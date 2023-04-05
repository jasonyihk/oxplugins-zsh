##########################################################
# Configuration File Utils
##########################################################

export PATH="${HOMEBREW_PREFIX}/opt/uutils-coreutils/libexec/uubin:$PATH"

test_oxpath() {
    if [[ -z $1 ]]; then
        echo "$1 does not exist, please define it in custom.sh"
    fi

    if [ ! -d $(dirname $1) ]; then
        mkdir -p $(dirname $1)
    fi
}

# export file
# $@=names
epf() {
    for file in $@; do
        local in_path=${OX_ELEMENT[$file]}
        local out_path=${OX_OXIDE[bk$file]}

        test_oxpath $out_path

        if [[ $file == *_ ]]; then
            rm -rf $out_path
            cp -R -v $in_path $out_path
        else
            cp -v $in_path $out_path
        fi

    done
}

# import file: reverse action of `epf`
# $@=names
ipf() {
    for file in $@; do
        local in_path=${OX_OXIDE[bk$file]}
        local out_path=${OX_ELEMENT[$file]}

        test_oxpath $out_path

        if [[ $file == *_ ]]; then
            rm -rf $out_path
            cp -R -v $in_path $out_path
        else
            cp -v $in_path $out_path
        fi
    done
}

# initialize file
# $@=names
iif() {
    for file in $@; do
        local in_path=${OX_OXYGEN[ox$file]}
        local out_path=${OX_ELEMENT[$file]}

        test_oxpath $out_path

        cp -v $in_path $out_path
    done
}

# duplicate file
# $@=names
dpf() {
    for file in $@; do
        local in_path=${OX_OXYGEN[ox$file]}
        local out_path=${OX_OXIDE[bk$file]}

        test_oxpath $out_path

        cp -v $in_path $out_path
    done
}

##########################################################
# Gerneral File Utils
##########################################################

# refresh file
# $@=names
frf() {
    if [[ -z $1 ]]; then
        . ${OX_ELEMENT[zs]}
    else
        . ${OX_ELEMENT[$1]}
    fi
}

# browse file
# $1=name
brf() {
    if [[ $1 == *_ ]]; then
        cmd="ls"
    else
        cmd="cat"
    fi
    case $1 in
    ox[a-z]*) $cmd ${OX_OXYGEN[$1]} ;;
    bk[a-z]*) $cmd ${OX_OXIDE[$1]} ;;
    *) $cmd ${OX_ELEMENT[$1]} ;;
    esac
}

# edit file by default editor
# $@=names
edf() {
    if [[ $2 == -t ]]; then
        cmd=$EDITOR_T
    else
        cmd=$EDITOR
    fi
    case $1 in
    ox[a-z]*) $cmd ${OX_OXYGEN[$1]} ;;
    bk[a-z]*) $cmd ${OX_OXIDE[$1]} ;;
    *) $cmd ${OX_ELEMENT[$1]} ;;
    esac
}

##########################################################
# Zip Files
##########################################################

zpf="ouch compress"
uzpf="ouch decompress"
lzpf="ouch list"

##########################################################
# Hash Files
##########################################################

alias md5="hashsum --md5"
alias sha1="hashsum --sha1"
alias sha2="hashsum --sha256"
alias sha5="hashsum --sha512"

##########################################################
# Proxy Utils
##########################################################

# px=proxy
px() {
    if [[ ${#1} < 3 ]]; then
        local port=${OX_PROXY[$1]}
    else
        local port=$1
    fi
    echo "using port $port"
    export https_proxy=http://127.0.0.1:$port
    export http_proxy=http://127.0.0.1:$port
    export all_proxy=socks5://127.0.0.1:$port
}

pxq() {
    echo 'unset all proxies'
    unset https_proxy
    unset http_proxy
    unset all_proxy
}

##########################################################
# Editor
##########################################################

che() {
    sd "EDITOR=\'.*\'" "EDITOR=\'$1\'" ${OX_ELEMENT[ox]}
    case ${SHELL} in
    *zsh)
        . ${OX_ELEMENT[zs]}
        ;;
    *bash)
        . ${OX_ELEMENT[bs]}
        ;;
    esac
}

##########################################################
# Zoxide
##########################################################

export _ZO_DATA_DIR=${HOME}/.config/zoxide

if [ ! -d $_ZO_DATA_DIR ]; then
    mkdir -p $_ZO_DATA_DIR
fi

OX_ELEMENT[z]=${_ZO_DATA_DIR}/db.zo
# backup files
OX_OXIDE[bkz]=${OX_BACKUP}/shell/db.zo

case ${SHELL} in
*zsh)
    eval "$(zoxide init zsh)"
    ;;
*bash)
    eval "$(zoxide init bash)"
    ;;
esac

alias zh="zoxide --help"
alias zii="zoxide init"
alias za="zoxide add"
alias zrm="zoxide remove"
alias zed="zoxide edit"
alias zsc="zoxide query"
