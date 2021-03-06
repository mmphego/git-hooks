#!/bin/bash
# Force everyone to comply and use git-hooks!!!!
# Author: Mpho Mphego <mmphego@ska.ac.za>

# set -i

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

gprint (){
    echo "${GREEN}$1${NORMAL}";
}

rprint (){
    echo "${RED}$1${NORMAL}";
}

sudo git config --system init.templatedir "${PWD}";
COMMIT_TEMPLATE="${PWD}/templates/git-commit-template.txt"
if [ -f "${COMMIT_TEMPLATE}" ]; then
    sudo git config --system commit.template "${COMMIT_TEMPLATE}";
fi

delete_hooks() {
    find /home -name ".git" -type d -prune -exec dirname {} \; | while read -r DIR; do
        gprint "Deleting git hooks: ${DIR}";
        sudo rm -vrf -- "${DIR}/.git/hooks/"*;
    done
}

install_hooks() {
    find /home -name ".git" -type d -prune -exec dirname {} \; | while read -r DIR;
        do git init -q "${DIR}";
        if [ ! -f "${DIR}/.git/hooks/pre-commit" ]; then
            rprint "${DIR}: Failed to create a hook" ;
        else
            gprint "Hook installed: ${DIR}";
            if ! cmp --silent "${DIR}/.git/hooks/pre-commit" "$(dirname "${BASH_SOURCE[0]}")/hooks/pre-commit"; then
                rprint "Failed to update Hooks."
                rprint "    run sudo $0 delete_hooks"
               fi
        fi
    done
    [ $? -eq 0 ] && gprint "####################### DONE #######################"
}

# Check if the function exists (bash specific)
if declare -f "$1" > /dev/null; then
    # call arguments verbatim
    "$@"
else
    # Show a helpful error
    if [ "$1" == '' ]; then
        rprint "'$1' is not a known function name" >&2
    fi
    gprint "Available functions: delete_hooks and install_hooks";
    gprint "Usage: sudo $0 delete_hooks or $0 install_hooks"
    exit 1;
fi
