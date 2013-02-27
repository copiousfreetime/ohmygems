export ORIG_GEM_PATH=${GEM_PATH:-}
export ORIG_GEM_HOME=${GEM_HOME:-}
export ORIG_PATH=${PATH}

ohmygems() {
    name=${1:-}

    if [ -z "$name" ]; then
        echo "usage: ohmygems <name or reset>"
        echo
        echo "  Switches gem home to a (potentially new) named repo."
        echo "  Your previous gems are still visible,"
        echo "  but new gem installs will install into ~/.gems/repos/<name>."
        echo "  Use 'reset' to go back to normal."
        echo
        echo "Available repos:"
        echo
        ls ~/.gem/repos | pr -o2 -l1 | sed "s/^  ${OHMYGEMS}$/* ${OHMYGEMS}/g"
        echo
        return
    elif [ $name = "reset" ]; then
        echo Resetting repo

        if [ -z "$ORIG_GEM_HOME" ]; then
            unset GEM_HOME
        else
            GEM_HOME=${ORIG_GEM_HOME}
        fi

        GEM_PATH=${ORIG_GEM_PATH}
        PATH=$ORIG_PATH
        unset OHMYGEMS_REPO
    else
        echo Switching to $name

        export GEM_HOME=~/.gem/repos/${name}
        export GEM_PATH=${ORIG_GEM_HOME}:${ORIG_GEM_PATH}
        export PATH=${ORIG_PATH}:${GEM_HOME}/bin
        export OHMYGEMS=$name
    fi

    echo
    echo GEM_PATH=${GEM_PATH:-not set}
    echo GEM_HOME=${GEM_HOME:-not set}
    echo PATH=$PATH
    echo OHMYGEMS=${OHMYGEMS}
}
