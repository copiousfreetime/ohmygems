# Variables to store the current state of affairs
export OMG_ORIG_GEM_PATH=${GEM_PATH:-}
export OMG_ORIG_GEM_HOME=${GEM_HOME:-}
export OMG_ORIG_PATH=${PATH:-}

# items we use to set everything up
export OMG_RUBY=$(ruby_version)
export OMG_GEMSET=
export OMG_REPO_ROOT=${OMG_REPO_ROOT:-${HOME}/.gem/repos}

ohmygems() {
    local name=${1:-}
    export OMG_RUBY=$(ruby_version)

    local rv_repo=${OMG_REPO_ROOT}/${OMG_RUBY}
    local gem_dir=


    if [ -z "$name" ]; then
        echo "usage: ohmygems <name or reset>"
        echo
        echo "  Switches gem home to a (potentially new) named repo."
        echo "  Your previous gems are still visible,"
        echo "  but new gem installs will install into ${rv_repo}/<name>."
        echo "  Use 'reset' to go back to normal."
        echo
        echo "Available repos for ${OMG_RUBY}:"
        echo
        ls ${rv_repo} | pr -o2 -l1 | sed "s/^  ${OMG_GEMSET}$/* ${OMG_GEMSET}/g"
        echo
        return
    elif [ $name = "reset" ]; then
        echo Resetting repo

        if [ -z "${OMG_ORIG_GEM_HOME}" ]; then
            unset GEM_HOME
        else
            export GEM_HOME=${OMG_ORIG_GEM_HOME}
        fi

        if [ -z "${OMG_ORIG_GEM_PATH}" ]; then
          unset GEM_PATH
        else
          export GEM_PATH=${OMG_ORIG_GEM_PATH}
        fi

        export PATH=${OMG_ORIG_PATH}
        unset OMG_GEMSET
        export OMG_GEMSET=
    else
        echo Switching to ${name}
        gem_dir=${rv_repo}/${name}

        export GEM_HOME=${gem_dir}
        export GEM_PATH=${gem_dir}:${GEM_PATH}
        export PATH=${gem_dir}/bin:${PATH}
        export OMG_GEMSET=${name}
    fi

    echo
    echo GEM_PATH=${GEM_PATH:-not set}
    echo GEM_HOME=${GEM_HOME:-not set}
    echo PATH=$PATH
}

alias omg=ohmygems
