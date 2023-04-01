##########################################################
# config
##########################################################

export JULIA_DEPOT_PATH=${JULIA_DEPOT_PATH:-"${HOME}/.julia"}

# default files
OX_OXYGEN[jl]=${OXIDIZER}/defaults/startup.jl
# system files
OX_ELEMENT[jl]=${JULIA_DEPOT_PATH}/config/startup.jl
OX_ELEMENT[jlp]=$(fd 'Project' ${JULIA_DEPOT_PATH}/environments)
OX_ELEMENT[jlm]=$(fd 'Manifest' ${JULIA_DEPOT_PATH}/environments)
# backup files
OX_OXIDE[bkjl]=${OX_BACKUP}/julia/startup.jl
OX_OXIDE[bkjlx]=${OX_BACKUP}/julia/julia-pkgs.txt

up_julia() {
    echo "Update Julia by ${OX_OXIDE[bkjlx]}"
    local pkgs=[\"$(cat ${OX_OXIDE[bkjlx]} | sd '\n' '", "')\"]
    local pkgs_vec=$(echo $pkgs | sd ', ""' '')
    local cmd=$(echo 'using Pkg; Pkg.add(,,)' | sd ',,' "$pkgs_vec")
    julia --eval "$cmd"
}

back_julia() {
    echo "Backup Julia to ${OX_OXIDE[bkjlx]}"
    cat ${OX_ELEMENT[jlp]} | rg --only-matching "\w.*=" | sd "[= ]" "" >${OX_OXIDE[bkjlx]}
}

##########################################################
# packages
##########################################################

alias jl="julia --quiet"
alias jlh="julia --help"
alias jlr="julia --eval"
alias jlcl="julia --eval 'using Pkg; Pkg.gc()'"
alias jlst="julia --eval 'using Pkg; Pkg.status()'"

# install packages
jlis() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.add([,,])' | sd ',,' "$pkgs")
    # echo "$cmd"
    julia --eval "$cmd"
}

# uninstall packages
jlus() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.rm([,,])' | sd ',,' "$pkgs")
    # echo "$cmd"
    julia --eval "$cmd"
}

# update packages
jlup() {
    if [[ -z $1 ]]; then
        julia --eval "using Pkg; Pkg.update()"
    else
        local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
        local cmd=$(echo 'using Pkg; Pkg.update([,,])' | sd ',,' "$pkgs")
        # echo "$cmd"
        julia --eval "$cmd"
    fi
}

# list leave packages
jllv() {
    cat ${OX_ELEMENT[jlp]} | rg --only-matching "\w+ =" | sd " =" " "
}

# list packages
jlls() {
    cat ${OX_ELEMENT[jlm]} | rg --only-matching "deps\.\w+" | sd "deps\." ""
}

# dependencies of package
jldp() {
    local cmd=$(echo "using PkgDependency; PkgDependency.tree(\"$1\") |> println")
    # echo "$cmd"
    julia --eval "$cmd"
}

jlrdp() {
    local cmd=$(echo "using PkgDependency; PkgDependency.tree(\"$1\"; reverse=true) |> println")
    # echo "$cmd"
    julia --eval "$cmd"
}

jlpn() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.pin([,,])' | sd ',,' "$pkgs")
    # echo "$cmd"
    julia --eval "$cmd"
}

jlupn() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.free([,,])' | sd ',,' "$pkgs")
    # echo "$cmd"
    julia --eval "$cmd"
}

# calculate mature rate
jlmt() {
    local num_total=$(cat ${OX_ELEMENT[jlm]} | rg "version =" | wc -l)
    echo "total: $num_total"
    local num_immature=$(cat ${OX_ELEMENT[jlm]} | rg '"0\.' | wc -l)
    local mature_rate=$((100 - num_immature * 100 / num_total))
    echo "mature rate: $mature_rate %"
}

##########################################################
# project
##########################################################

# build project
jlb() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.build([,,])' | sd ',,' "$pkgs")
    # echo "$cmd"
    julia --eval "$cmd"
}

# test project
jlts() {
    local pkgs=$(echo \"$@\" | sd ' ' '\", \"')
    local cmd=$(echo 'using Pkg; Pkg.test([,,])' | sd ',,' "$pkgs")
    # echo "$cmd"
    julia --eval "$cmd"
}
