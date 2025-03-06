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
# alias ll='echo "--tree, --sort SORT_FIELD, --only-dirs, --only-files"  && eza --icons=never --time-style=long-iso --absolute -BAl --total-size --level 2'
  alias ll='echo "--tree, --sort SORT_FIELD, --only-dirs, --only-files"  && ls -Al $1\"' 
alias ping='ping -c 4 $1'
alias ssaver='sudo setterm --blank 1 --powerdown 2'

alias carpetas='smbclient -L $(hostname) -U "$1" '
# alias puertos='sudo netstat -tulpn | grep LISTEN'
  alias puertos='sudo lsof -i -P -n | grep LISTEN'
alias mkdir="mkdir -pv"
alias hg='history | grep  "$@" '
alias hn='history $1 '
alias servicios='echo "/etc/systemd/system/" && ls -Al /etc/systemd/system/ && echo "/lib/systemd/system/" && ls -Al /lib/systemd/system/'
# alias repos='ll /etc/apt/sources.list.d/*'
alias hostse='sudo nano /etc/hosts'
alias hostsl="cat /etc/hosts | less"

# Aliases de conexión remota:
  # Alfica
    alias portos='echo ssh root@portos.alfica.red           && ssh root@portos.alfica.red'
    alias atos='echo ssh -p 41022 Admin@atos.alfica.red     && ssh -p 41022 Admin@atos.alfica.red'
    alias aramis='echo ssh -p 41032 Admin@aramis.alfica.red && ssh -p 41032 Admin@aramis.alfica.red'
    alias sistjefe='echo ssh Admin@sistjefe-pc.alfica.red   && ssh Admin@sistjefe-pc.alfica.red'
    alias sistaux='echo ssh Admin@sistaux-pc.alfica.red     && ssh Admin@sistaux-pc.alfica.red'
    alias hermes='echo ssh Admin@hermes.alfica.red          && ssh Admin@hermes.alfica.red'
    alias dvr0='echo ssh Admin@dvr0.alfica.red              && ssh Admin@dvr0.alfica.red'
  # UnimatrixZero
    alias ptb='echo ssh FedericoD3@ptbarnum.unimatrixzero.red      && ssh FedericoD3@ptbarnum.unimatrixzero.red'
    alias mcp='echo ssh FedericoD3@mcp.unimatrixzero.red           && ssh FedericoD3@mcp.unimatrixzero.red'
    alias pi01='echo ssh FedericoD3@pi-01.unimatrixzero.red        && ssh FedericoD3@pi-01.unimatrixzero.red'
    alias hedy='echo ssh root@hedylamarr.unimatrixzero.red         && ssh root@hedylamarr.unimatrixzero.red'
    alias mazinger='echo ssh FedericoD3@mazinger.unimatrixzero.red && ssh FedericoD3@mazinger.unimatrixzero.red'
  # ViejasDuran
    alias sdell='ssh    -p    22 FedericoD3@servidordell.viejasduran.red'
    alias pizw01='ssh   -p    22 FedericoD3@pizw-01.viejasduran.red'
    alias wifiDF1='ssh  -p    22 root@DF-AP1.viejasduran.red'

pingmon () {
  ping -D $1 | awk '{if(gsub(/\[|\]/, "", $1)) {$1= strftime("[%F %T]", $1); print} else print }'
}

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

Nuevou () {
  echo Crear el usuario $1 con clave $2 del grupo $3
  sudo useradd $1 --comment "($2)" --groups $3 --shell /bin/false --base-dir /Discos/Alfica/Usuarios --password $2
  sudo mkdir /Discos/Alfica/Usuarios/$1
  sudo chown -R nobody /Discos/Alfica/Usuarios/$1
  sudo chgrp nogroup -R /Discos/Alfica/Usuarios/$1
  sudo chmod 777 -R /Discos/Alfica/Usuarios/$1
  echo -e "$2\n$2\n" | sudo smbpasswd -a "$1"
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
