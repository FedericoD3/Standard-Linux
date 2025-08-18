#!/bin/bash

alias vers='echo Version de Aliases de 2025-08-18 17:30'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls --color=auto'
alias ll='echo "--tree, --sort SORT_FIELD, --only-dirs, --only-files"  && ls -Al --time-style=long-iso --group-directories-first $1' 
alias ping='ping -c 4 $1'

alias ssaver='sudo setterm --blank 1 --powerdown 2'

alias carpetas='smbclient -L $(hostname) -U "$1" '
# alias puertos='sudo netstat -tulpn | grep LISTEN'
  alias puertos='echo "sudo lsof -i -P -n | grep LISTEN" && sudo lsof -i -P -n | grep LISTEN'
alias mkdir="mkdir -pv"
alias hg='history | grep  "$@" '
alias hn='history $1 '
alias servicios='echo "/etc/systemd/system/" && ls -Al /etc/systemd/system/ && echo "/lib/systemd/system/" && ls -Al /lib/systemd/system/'
# alias repos='ll /etc/apt/sources.list.d/*'
alias hostse='sudo nano /etc/hosts'
alias hostsl="cat /etc/hosts | less"

# Aliases de conexión remota:
  # Alfica
    alias portos='echo ssh root@portos.alfica.red          && ssh root@portos.alfica.red'
    alias atos='echo ssh -p 41022 root@atos.alfica.red     && ssh -p 41022 root@atos.alfica.red'
    alias aramis='echo ssh -p 41032 root@aramis.alfica.red && ssh -p 41032 root@aramis.alfica.red'
    alias sistjefe='echo ssh root@sistjefe-pc.alfica.red   && ssh root@sistjefe-pc.alfica.red'
    alias hermes='echo ssh root@hermes.alfica.red          && ssh root@hermes.alfica.red'
    alias dvr0='echo ssh root@dvr0.alfica.red              && ssh root@dvr0.alfica.red'
  # UnimatrixZero
    alias ptb='echo ssh FedericoD3@ptbarnum.unimatrixzero.red       && ssh FedericoD3@ptbarnum.unimatrixzero.red'
    alias mcp='echo ssh FedericoD3@mcp.unimatrixzero.red            && ssh FedericoD3@mcp.unimatrixzero.red'
    alias pi01='echo ssh FedericoD3@pi01.unimatrixzero.red          && ssh FedericoD3@pi01.unimatrixzero.red'
    alias hedy='echo -p 42502 ssh root@hedylamarr.unimatrixzero.red && ssh -p 42502 root@hedylamarr.unimatrixzero.red'
    alias mazinger='echo ssh FedericoD3@mazinger.unimatrixzero.red  && ssh FedericoD3@mazinger.unimatrixzero.red'
  # ViejasDuran
    alias sdell='echo ssh FedericoD3@servidordell.viejasduran.red && ssh FedericoD3@servidordell.viejasduran.red'
    alias pizw01='echo ssh FedericoD3@pizw01.viejasduran.red      && ssh FedericoD3@pizw01.viejasduran.red'
    alias wifiDF1='echo ssh root@DF-AP1.viejasduran.red           && ssh root@DF-AP1.viejasduran.red'

pingmon () {
  ping -D $1 | awk '{if(gsub(/\[|\]/, "", $1)) {$1= strftime("[%F %T]", $1); print} else print }'
}

fuentes () {
  echo "/etc/apt/sources.list:"
  cat /etc/apt/sources.list | grep -v "^#" | grep -v "^$"
  echo ""
  ls -Al /etc/apt/sources.list.d/*.list
}

alias listapaq='dpkg --list --no-pager'

# Convertir ejecutable por cualquiera todos los .sh en el directorio especificado:
rexe () {
  DIR=$1
  if [ -z "$DIR" ]; then DIR="$(pwd)"; fi
  DIR="$DIR"/
  ll "$DIR"
  sudo chown nobody "$DIR"*
  sudo chgrp nogroup "$DIR"*
  sudo chmod 766 "$DIR"*
  sudo chmod 777  "$DIR"*.sh
  ll "$DIR"
}

fetch () {
  echo
  echo "***************** $(hostname -f) $(date +%Y-%m-%d) *****************"
  sudo dmidecode -t1 | grep -A 15 '^System Information'
  # Ejecutar fastfetch si existe:
  if which fastfetch
    then
      echo fastfetch
      fastfetch
    else
    # Ejecutar neofetch si existe:
    if which neofetch
      then
        echo neofetch
        neofetch
      else echo "No esta instalado ni neofetch ni fastfetch"
      fi
  fi
  # Ejecutar cpufetch si existe:
  if which cpufetch
    then
      echo "cpufetch -s retro --logo-short --full-cpu-name --accurate-pp:"
            cpufetch -s retro --logo-short --full-cpu-name --accurate-pp
  fi
  # Ejecutar sysbench si existe:
  if which sysbench
    then
    echo "sysbench cpu run | grep "events per second\|Prime" | grep -v -e '^$':"
          sysbench cpu run | grep "events per second\|Prime" | grep -v -e '^$'
    echo "************************************************************"
  fi
}

usuarios () {
  echo LINUX:
  cat /etc/passwd
  echo
  echo SAMBA:
  sudo pdbedit -Lv | grep "Unix username" | sed "s/Unix username://" | sort
}

websrv () {
  curl -s -I "$1" | grep Server
}

denadie () {
  sudo chown -R nobody "$1" &&
  sudo chgrp nogroup -R "$1" &&
  sudo chmod 777 -R "$1"
}

solomio () {
   sudo chown -R "$(whoami)" "$1" &&
   sudo chgrp nogroup -R "$1" &&
   sudo chmod 744 -R "$1"
}

clave () {
  sudo echo -e "$2\n$2\n" | passwd "$1"
  sudo echo -e "$2\n$2\n" | smbpasswd "$1"
}

espacio () {
  echo "lsblk"
  lsblk 
  echo
  echo "df -k "$1
  df -k $1
# df -h $1
# du -d 1 -h $1
}

tamdir () {
  if [ "$1" == "" ];
    then
    base=$(pwd)
    else
    base=$1
  fi
  du -hs $base/
}

dirs () {
  if [ "$1" == "" ]; 
  then 
    base=$(pwd)
  else
    base=$1
  fi
  find "$base"/ -type d -maxdepth 1 | less
}

donde () {
   echo "Aun no programo nada para 'find'"
}

actualizar () {
  sudo apt-get update
  sudo apt-get dist-upgrade
  sudo apt-get upgrade
  sudo apt-get autoremove
}

red () {
  # Ver el IP de la puerta de enlace, casi seguro que en la red principal:
  Red=$(ip route | grep default | cut -d " " -f 3)
  Red=${Red%.*}".0/24"
  echo "  nmap -sP $Red | grep 'scan report for' " 
  nmap -sP "$Red" | grep "scan report for"
  echo "  /usr/sbin/arp | grep ether"
  /usr/sbin/arp | grep ether
}

realias () {
  source /Discos/Local/bashStd/.bash_aliases
}

