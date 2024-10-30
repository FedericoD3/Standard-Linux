#!/bin/bash

alias vers='echo Version de Aliases de 2024-09-30 20.00'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls --color=auto'
# alias ll='echo "-S size, -t time, -X extension" && ls -Al --time-style=long-iso'  

# --sort SORT_FIELD
# --only-dirs
# --only-files
alias ll='echo "--tree, --sort SORT_FIELD, --only-dirs, --only-files"  && eza --icons=never --time-style=long-iso --absolute -BAl --total-size'
alias ping='ping -c 4 $1'
alias ssaver='sudo setterm --blank 1 --powerdown 2'

alias carpetas='smbclient -L $(hostname) -U "$1" '
# alias puertos='sudo netstat -tulpn | grep LISTEN'
  alias puertos='sudo lsof -i -P -n | grep LISTEN'
alias mkdir="mkdir -pv"
alias hg='history | grep  "$@" '
alias hn='history "$1" '
alias servicios='echo "/etc/systemd/system/" && ls -Al /etc/systemd/system/ && echo "/lib/systemd/system/" && ls -Al /lib/systemd/system/'
# alias repos='ll /etc/apt/sources.list.d/*'
alias hostse='sudo nano /etc/hosts'
alias hostsl="cat /etc/hosts | less"

# Aliases de conexión remota:
  # Alfica
    alias portos='ssh   -p 41012 root@portos.alfica.red'
    alias atos='ssh     -p 41022 Admin@atos.alfica.red'
    alias aramis='ssh   -p 41032 Admin@aramis.alfica.red'
    alias sistjefe='ssh -p 41112 Admin@sistjefe-pc.alfica.red'
    alias sistaux='ssh  -p 22    Admin@sistaux-pc.alfica.red'
    alias hermes='ssh   -p 42502 Admin@hermes.alfica.red'
  # UnimatrixZero
    alias ptb='ssh      -p 40012 federico@ptbarnum.unimatrixzero.red'
    alias pi01='ssh     -p 40062 federico@pi-01.unimatrixzero.red'
    alias hermes='ssh   -p 40102 federico@hermes.unimatrixzero.red'
    alias mazinger='ssh -p 41012 FedericoD3@mazinger.unimatrixzero.red'
  # ViejasDuran
    alias sdell='ssh    -p    22 FedericoD3@servidordell.viejasduran.red'
    alias pizw01='ssh   -p    22 FedericoD3@pizw-01.viejasduran.red'

fuentes () {
  echo "/etc/apt/sources.list:"
  cat /etc/apt/sources.list | grep -v "^#" | grep -v "^$"
  echo ""
  ls -Al /etc/apt/sources.list.d/*.list
}
 
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
  lsblk
  echo
  df -k "$1"
# df -h "$1"
# du -d 1 -h "$1"
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

actualizar () {
  sudo apt-get update
  sudo apt-get dist-upgrade
  sudo apt-get upgrade
  sudo apt-get autoremove
}

repi () {
  sudo systemctl restart unbound
  sleep 1s
  sudo service pihole-FTL reload
  sleep 1s
  sudo pihole restartdns
  sleep 1s
  sudo systemctl status unbound
  pihole status
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
