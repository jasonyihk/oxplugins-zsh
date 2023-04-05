##########################################################
# config
##########################################################

# binaries
export OX_OPEN=nautilus

# system files
OX_ELEMENT[scs]="/etc/apt/sources.list"
# backup files
OX_OXIDE[bkscs]=${OX_BACKUP}/install/source.list

##########################################################
# main
##########################################################

update() {
    case $1 in
    -d) sudo apt dselect-upgrade ;;
    *) sudo apt dist-upgrade ;;
    esac
}

clean() {
    case $1 in
    cc)
        sudo rm -rfv /var/cache
        ;;
    zs)
        rm ${HOME}/.zsh_sessions/*.history*
        rm ${HOME}/.zsh_sessions/*_timestamp
        ;;
    log)
        echo "Emptying the system log files.\n"
        sudo rm -rfv /var/log/*
        ;;
    *)
        echo "Emptying trash.\n"
        rm -rfv ${HOME}/.local/share/Trash >/dev/null 2>&1
        ;;
    esac
}

sysinfo() {
    sysctl -a | rg $1
}

##########################################################
# apt
##########################################################

alias ah="apt help"
alias asc="apt-cache search"
alias aif="apt-cache show"
alias adp="apt-cache depends"
alias ardp="apt-cache rdepends"
alias als="apt list --installed"

alias ais="sudo apt install"
alias aus="sudo apt remove"
alias ausp="sudo apt remove --purge"
alias aups="sudo apt update"
alias aup="sudo apt upgrade"
alias acl="sudo apt autoremove && sudo apt clean && sudo apt autoclean"
alias aclp="sudo apt autoremove --purge && sudo apt clean && sudo apt autoclean"
alias ack="sudo apt check"

###########################################################
# apt extension
##########################################################

alias axa="sudo add-apt-repository"
alias axrm="sudo add-apt-repository --remove"
alias axls="grep ^[^#] /etc/apt/sources.list"

##########################################################
# wsl
##########################################################

# use host proxy
wpx() {
    host_ip=$(cat /etc/resolv.conf | grep "nameserver" | cut -f 2 -d " ")
    export ALL_PROXY="https://$host_ip:${OX_PROXY[$1]}"
}
