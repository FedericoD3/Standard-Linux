#!/bin/bash

alias vers='echo Version de Aliases de 2026-05-24 17:30'
# alias grep='grep --color=auto --invert-match "^$" '
alias fgrep='fgrep --color=auto --invert-match "^$" '
alias egrep='egrep --color=auto --invert-match "^$" '
alias ls='ls --color=auto'
alias ll='echo "--tree, --sort SORT_FIELD, --only-dirs, --only-files"  && ls -Al --time-style=long-iso --group-directories-first $1'
alias ping='ping -W 1 -c 4 $1'
alias which='echo type -a $1 && type -a $1'
alias rm='rip $@'

alias ips4='echo "ip -4 -color -brief address show" && ip -4 -color -brief address show'
alias ips6='echo "ip -6 -color -brief address show" && ip -6 -color -brief address show'
alias rutas4='echo "ip -4 -color route | column -t" && ip -4 -color route | column -t'
alias rutas6='echo "ip -6 -color route | column -t" && ip -6 -color route | column -t'

psg () (
  if [ "$1" == "" ];
  then
    ps -el | head -1; ps -el
  else
    ps -el | head -1; ps -el | grep  "$1"
  fi
)

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

alias actualizar='sudo apt-get update && sudo apt upgrade && sudo apt autoremove && echo "Si algo no se pudo actualizar, ejecutar sudo apt full-upgrade"'

alias ssaver='sudo setterm --blank 1 --powerdown 2'

alias carpetas='smbclient -L $(hostname) -U "$1" '
# alias puertos='sudo netstat -tulpn | grep LISTEN'
  alias puertosl='echo "sudo lsof -i -P -n | grep LISTEN"  && sudo lsof -i -P -n | grep LISTEN'
  alias puertoss='echo "sudo ss --listening | grep LISTEN" && sudo ss --listening | grep LISTEN'
  alias rered='echo -e "sudo nmcli general reload\nsudo systemctl restart NetworkManager" && sudo nmcli general reload && sudo systemctl restart NetworkManager '
alias mkdir="mkdir -pv"
alias hg='history | grep "$@"'
alias hn='history $1 '
alias servicios='echo "/etc/systemd/system/" && ls -Al /etc/systemd/system/ && echo "/lib/systemd/system/" && ls -Al /lib/systemd/system/'
# alias repos='ll /etc/apt/sources.list.d/*'
alias hostse='sudo nano /etc/hosts'
alias hostsl="cat /etc/hosts | less"

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

nginxe () {
  if type nginx > /dev/null 2>&1 then
    then
      sudo nano /etc/nginx/nginx.conf
      sudo nginx -t && service nginx restart
    else
      echo "En este equipo no esta instalado nginx"
  fi
  }

# Convertir ejecutable por cualquiera todos los .sh en el directorio especificado:
rexe () {
  DIR=$1
  if [ -z "$DIR" ]; then DIR="$(pwd)"; fi
  DIR="$DIR"/
  ll "$DIR"
  sudo chown FedericoD3 "$DIR"*
  sudo chgrp FedericoD3 "$DIR"*
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
      echo "Primero instala fastfetch:"
      echo "sudo apt install fastfetch"
  fi
  # Ejecutar cpufetch si existe:
  if which cpufetch
    then
      echo "cpufetch -s retro --logo-short --full-cpu-name --accurate-pp:"
            cpufetch -s retro --logo-short --full-cpu-name --accurate-pp
    else
      echo "Primero instala cpufetch:"
      echo "sudo apt install cpufetch"
  fi
  # Ejecutar sysbench si existe:
  if which sysbench
    then
      echo "sysbench cpu run | grep "events per second\|Prime" | grep -v -e '^$':"
            sysbench cpu run | grep "events per second\|Prime" | grep -v -e '^$'
      echo "************************************************************"
    else
      echo "Primero instala sysbench:"
      echo "sudo apt install sysbench"
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
  du --bytes --max-depth=1 $base/ | sort --numeric-sort
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

scan () {
  if [ "$1" == "" ];
    then
    # Ver el IP de la puerta de enlace, casi seguro que en la red principal:
    Red=$(ip route | grep default | cut -d " " -f 3)
    Red=${Red%.*}".0/24"
    else
    Red=$1
  fi
#  # Ver el IP de la puerta de enlace, casi seguro que en la red principal:
#  Red=$(ip route | grep default | cut -d " " -f 3)
#  Red=${Red%.*}".0/24"
  echo "  nmap -sP $Red | grep 'scan report for' "
  nmap -sP "$Red" | grep "scan report for"
  echo "  /usr/sbin/arp | grep ether"
  /usr/sbin/arp | grep ether
}

realias () {
  source /Discos/Local/bashStd/.bash_aliases
}
