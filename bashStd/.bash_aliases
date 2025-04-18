alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls --color=auto'
alias ll='echo "-S size, -t time, -X extension" && ls -Al --time-style=long-iso'
alias ping='ping -c 4 $1'
alias ssaver='sudo setterm --blank 1 --powerdown 2'

alias carpetas='smbclient -L $(hostname) -U '$1
# alias puertos='sudo netstat -tulpn | grep LISTEN '
  alias puertos='sudo lsof -i -P -n | grep LISTEN '
alias mkdir="mkdir -pv"
alias hg='history | grep $@'
alias hn='history $1'
alias servicios='echo '/etc/systemd/system/' && ls -Al /etc/systemd/system/ && echo '/lib/systemd/system/' && ls -Al /lib/systemd/system/'
# alias repos='ll /etc/apt/sources.list.d/*'
alias hostse='sudo nano /etc/hosts'
alias hostsl='cat /etc/hosts | less'

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
  ll $DIR
  sudo chown nobody $DIR*
  sudo chgrp nogroup $DIR*
  sudo chmod 766 $DIR*
  sudo chmod 777  $DIR*.sh
  ll $DIR
}

fetch () {
  echo
  echo "********************** $(hostname -f) **********************"
  sudo dmidecode -t1 | grep -A 15 '^System Information'
  echo neofetch:
  neofetch
  echo "cpufetch -s retro --logo-short --full-cpu-name --accurate-pp:"
  cpufetch -s retro --logo-short --full-cpu-name --accurate-pp
  echo "sysbench cpu run | grep "events per second\|Prime" | grep -v -e '^$':"
  sysbench cpu run | grep "events per second\|Prime" | grep -v -e '^$'
  echo "************************************************************"
  echo
# x86:
# cpufetch -s retro --logo-short --full-cpu-name --accurate-pp
# sysbench cpu run | grep "events per second\|Prime" | grep -v -e '^$'
# Rpi:
# cpufetch -s retro --logo-short
# sysbench --test=cpu --cpu-max-prime=10000 run | grep "("
}

usuarios () {
  echo LINUX:
  cat /etc/passwd
  echo
  echo SAMBA:
  sudo pdbedit -Lv | grep "Unix username" | sed 's/Unix username://' | sort
}

websrv () {
  curl -s -I $1 | grep Server
}

denadie () {
  sudo chown -R nobody $1 &&
  sudo chgrp nogroup -R $1 &&
  sudo chmod 777 -R $1
}

solomio () {
   sudo chown -R $(whoami) $1 &&
   sudo chgrp nogroup -R $1 &&
   sudo chmod 744 -R $1
}

clave () {
  sudo echo -e "$2\n$2\n" | passwd $1
  sudo echo -e "$2\n$2\n" | smbpasswd $1
}

espacio () {
  lsblk
  echo
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
  ls -dAl $base/*/ | more
}

actualizar () {
  sudo apt-get update
  sudo apt-get dist-upgrade
  sudo apt-get upgrade
  sudo apt-get autoremove
}

realias () {
  source /Discos/Local/bashStd/.bash_aliases
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
  echo '  nmap -sP 10.35.0.0/24 | grep "scan report for"'
#  nmap -sP 10.0.0.0/24 | grep "scan report for"
  echo '  /usr/sbin/arp | grep ether'
  /usr/sbin/arp | grep ether
}
