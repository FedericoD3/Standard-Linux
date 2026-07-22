#!/bin/bash

Log=0

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
  # clear
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
#  export PATH=$PATH:~/.local/bin
  export PATH=$PATH:/Discos/Local/Scripts
  export PATH=$PATH:/usr/sbin
# Agregar a los directorios confiables:
  export XDG_DATA_DIRS="~/.local/share/applications:$XDG_DATA_DIRS"
# export PATH=$PATH:CualquierOtroPathQueSeUse
  if [ $Log -eq 1 ]; then echo "Path asignado" >> ~/Arranque_bash.log; fi

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

# check the window size after each command and, 
# if necessary, update the values of LINES and COLUMNS.
  shopt -s checkwinsize
  if [ $Log -eq 1 ]; then echo "Activada actualización de \$COLUMNS y \$LINES" >> ~/Arranque_bash.log; fi

# Decorar el prompt:
  source /Discos/Local/bashStd/FancyBash.sh
  if [ $Log -eq 1 ]; then echo "Prompt decorado" >> ~/Arranque_bash.log; fi

# Modificar el título de la ventana con el usuario y host
  PS1=$PS1'\[\e]2;\u @ \H\a\]'
  if [ $Log -eq 1 ]; then echo "Titulo de la ventana actualizado" >> ~/Arranque_bash.log; fi

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

# Pasar al fin al terminal
  return
