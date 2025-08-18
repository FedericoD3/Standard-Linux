  GNU nano 7.2                                                                /Discos/Local/bashStd/.bashrc                                                                         
#!/bin/bash

Log=1

# Si no es sesión interactiva, no hacer nada y salir
  case $- in
    *i*) ;;
    *) return;;
  esac
# Si es sesión interactiva, cargar la configuracion standard

if [ $Log -eq 1 ]; then echo -e "\nEjecutando /Discos/Local/bashStd" $(TZ=":America/Caracas" date +'%Y-%m-%d_%H%M%S') >> ~/Arranque_bash.log; fi

if [ "$(ps -o comm= $PPID)" != "su" ]; then 
  # Si es la sesión directa, dar chance a evitar error de configuracion
  echo "sleep 1 (para dar chance de hacer Ctrl+C si hay algún error fatal mas abajo)"
  sleep 1   # Para dar chance de hacer Ctrl+C si hay algún error fatal mas abajo.
  clear
  if [ $Log -eq 1 ]; then echo "Terminado retardo de seguridad" >> ~/Arranque_bash.log; fi
  else
  # Si es substitute user, refrescar los aliases para el usuario sustituto
  source /Discos/Local/bashStd/.bash_aliases
  # y re-colorear el prompt
  source /Discos/Local/bashStd/FancyBash.sh
  if [ $Log -eq 1 ]; then echo "Prompt redecorado y aliases recargados para $(whoami)" >> ~/Arranque_bash.log; fi
  return
fi

# Mensajes iniciales:
  run-parts /Discos/Local/bashStd/motd.d
  if [ $Log -eq 1 ]; then echo "Mostrados mensajes del dia" >> ~/Arranque_bash.log; fi

  export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games  # Path de usuario standard
  if [ $(id -u) -eq 0 ]; then export PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH; fi
#  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  export PATH=$PATH:~/.local/bin
  export PATH=$PATH:/Discos/Local/Scripts
# export PATH=$PATH:CualquierOtroPathQueSeUse
  if [ $Log -eq 1 ]; then echo "Path asignado" >> ~/Arranque_bash.log; fi

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
  export HISTIGNORE="history:hg:hn:otrocomando:cualquierotro"
# Store multi-line commands in one history entry:
  shopt -s cmdhist
# append clear and reload the history after each command
  export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
################################################
  if [ $Log -eq 1 ]; then echo "Configurado historico de comandos" >> ~/Arranque_bash.log; fi

########## DEFINICIONES DE ALIASES #############
# Es mas ordenado poner los aliases en otro archivo
#  Lo normal es ~/.bash_aliases, pero se puede poner en otro lado
#  por ejemplo un archivo de aliases comunes a todos los usuarios
# Ver /usr/share/doc/bash-doc/examples
# Incluir .bash_aliases sin ver si existe,
#  justamente para que de un error si no existe
. /Discos/Local/bashStd/.bash_aliases
################################################
  if [ $Log -eq 1 ]; then echo "Aliases asignados" >> ~/Arranque_bash.log; fi

# Para que no tenga indents enormes
  tabs 3
  if [ $Log -eq 1 ]; then echo "Tabs en 3" >> ~/Arranque_bash.log; fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
  shopt -s checkwinsize
  if [ $Log -eq 1 ]; then echo "Activada actualización de \$COLUMNS y \$LINES" >> ~/Arranque_bash.log; fi

# Decorar el prompt:
  source /Discos/Local/bashStd/FancyBash.sh
  if [ $Log -eq 1 ]; then echo "Prompt decorado" >> ~/Arranque_bash.log; fi
# Agregar la campanita para que avise al terminar comandos largos
  xset b 25 1760 # Bell de 25mS y de 1760Hz
  PS1=$PS1$(printf "\007\a\n")
  if [ $Log -eq 1 ]; then echo "Agregada la campanita al prompt" >> ~/Arranque_bash.log; fi

# Modificar el título de la ventana con el usuario y host
  PS1=$PS1'\[\e]2;\u @ \H\a\]'
  if [ $Log -eq 1 ]; then echo "Titulo de la ventana actualizado" >> ~/Arranque_bash.log; fi

# Pasar al fin al terminal 
  return



<<PorBorrar
# Colores que usa eza para el listado de archivos: 
  EZA="reset"                  # Resetear
  EZA=$EZA":da=32"             # Directorios en azul
  EZA=$EZA":*.txt=38;5;223"    # Archivos de texto en beige
  EZA=$EZA":nb=2;3"            # Tamaño menor de 1KB = gris cursiva
  EZA=$EZA":nk=2;3"            # Tamaño entre 1 KB/KiB y 1 MB/MiB = gris cursiva
  EZA=$EZA":nm=2;3"            # Tamaño entre 1 MB/MiB y 1 GB/GiB = gris cursiva
  EZA=$EZA":ng=2;3"            # Tamaño entre 1 GB/GiB y 1 TB/TiB = gris cursiva
  EZA=$EZA":nt=2;3"            # Tamaño mayor a 1 TB/TiB = gris cursiva
  export EZA_COLORS=$EZA

# http://tldp.org/LDP/abs/html/comparison-ops.html
#       [ -z "$algo" ]     True si $algo es Null (string de longitud cero)
#       [ -n "$algo" ]     True si $algo es NO Null
#       [ -r /algun/arch ] True si /algun/arch es un archivo legible (readable)

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

PorBorrar
