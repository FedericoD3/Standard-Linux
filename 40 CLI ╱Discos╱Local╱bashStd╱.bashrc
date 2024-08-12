# PS1 es el prompt de la sesion
#  Si no existe (es Null) no es sesion interactiva en pantalla,
#  no configurar mas nada de esta sesion
  [ -z "$PS1" ] && return

echo "######## EJECUTANDO /Discos/Local/bashStd/.bashrc"

# echo  $(TZ=":America/Caracas" date +'%Y-%m-%d_%H%M%S')" ${0}" > ~/Arranque_bash.log

# Para recargar ediciones a este archivo, ejecutar
# source /Discos/Local/bashStd/.bashrc
  echo "sleep 2 (para dar chance de hacer Ctrl+C si hay algún error fatal mas abajo)"
  sleep 2   # Para dar chance de hacer Ctrl+C si hay algún error fatal mas abajo.

run-parts /Discos/Local/bashStd/motd.d
export PATH=$PATH:~/.local/bin

echo "Configuracion del command history" >> ~/Arranque_bash.log
########## CONFIGURACION DEL HISTORY ##########
# Don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
  HISTCONTROL=ignoredups:erasedups
# append to the history file, don't overwrite it
  shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
  HISTSIZE=1000
  HISTFILESIZE=2000
# Time tag history
  export HISTTIMEFORMAT="%h%d %H:%M:%S "
# Ignore Specific Commands
  export HISTIGNORE="history:otrocomando:cualquierotro"
# Store multi-line commands in one history entry:
  shopt -s cmdhist
# append clear and reload the history after each command
# export PROMPT_COMMAND="history -a; history -c; history -r; curl wttr.in/Maracay?format=2; $PROMPT_COMMAND"
  export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
################################################

echo "Definición de aliases en /Discos/Local/bashStd/.bash_aliases" >> ~/Arranque_bash.log
########## DEFINICIONES DE ALIASES #############
# Es mas ordenado poner los aliases en otro archivo
#  Lo normal es ~/.bash_aliases, pero se puede poner en otro lado
#  por ejemplo un archivo de aliases comunes a todos los usuarios
# Ver /usr/share/doc/bash-doc/examples
# Incluir .bash_aliases sin ver si existe,
#  justamente para que de un error si no existe
. /Discos/Local/bashStd/.bash_aliases
################################################

# Para que no tenga indents enormes
  tabs 2

echo "Decoracion del prompt con FancyBash" >> ~/Arranque_bash.log
source /Discos/Local/bashStd/FancyBash.sh
return





# Definir los colores de ls
  . /Discos/Local/bashStd/colores.sh

# http://tldp.org/LDP/abs/html/comparison-ops.html
#       [ -z "$algo" ]     True si $algo es Null (string de longitud cero)
#       [ -n "$algo" ]     True si $algo es NO Null
#       [ -r /algun/arch ] True si /algun/arch es un archivo legible (readable)


# PS1 es el prompt de la sesion
#  Si no existe (es Null) no es sesion interactiva en pantalla,
#  no configurar mas nada de esta sesion
  [ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
  shopt -s checkwinsize

########## AGREGAR EL CHROOT AL PROMPT ##########
# Si este shell esta dentro de un chroot (directorio raiz a partir de un sub-dir)
#  y si ese directorio raiz tiene un archivo /etc/debian_chroot
#  y la variable debian_chroot esta vacia, tomarla del archivo
#  para mostrarla en el prompt
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
################################################

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
#    alias ls='ls --color=auto'
#    alias grep='grep --color=auto'
#    alias fgrep='fgrep --color=auto'
#    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

if [ -f "$HOME/.bash_ps1" ]; then
  . "$HOME/.bash_ps1"
fi

# Si es root, que el prompt sea rojo, si no que sea azul:
resetFormato="\e[0m"
if [ "`id -u`" -eq 0 ]; then
  colorUser="\[\e[7;38;5;9m\]"
  colorHost="\[\e[7;38;5;1m\]"
  colorPath="\[\e[0;38;5;1m\]"
  colorPrompt="\e[0m"
  else
  colorUser="\[\e[7;38;5;45m\]"
  colorHost="\[\e[7;38;5;31m\]"
  colorPath="\[\e[0;38;5;39m\]"
  colorPrompt="\e[0m"
fi
# PS1=$'\u25B6\u2192\u263f\u2605'
# PS1="$resetFormato$colorUser \u $colorHost $(printf "\u25B6") \h $colorPath \w $colorPrompt \n$"
  PS1="$resetFormato$colorUser \u $colorHost \h $colorPath \w $colorPrompt"
# Agregar la campanita para que avise al terminar comandos largos
PS1=$PS1$(printf "\007\a\n$ ")
