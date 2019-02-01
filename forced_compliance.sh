#!/bin/bash
# Force everyone to comply and use git-hooks!!!!
# Author: Mpho Mphego <mmphego@ska.ac.za>

# set -i

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

function gprint (){
    echo "${GREEN}$1${NORMAL}";
}

function rprint (){
    echo "${RED}$1${NORMAL}";
}

cd / || exit 1;

function delete_hooks() {
    while IFS= read -r -d '' file; do
        gprint "Deleting ${file} hooks";
        # Read more about chattr https://linoxide.com/how-tos/change-attributes-of-file/
        # chattr -RVf -i "${file}/hooks";
        rm -vrf -- "${file}/hooks/"*;
    done < <(find / -type d -name '.git' -print0)
}

function install_hooks(){
    while IFS= read -r -d '' file; do
        cd "${file}" && cd ..;
        git init -q;
        # chattr -R +i "${file}/hooks/";
        gprint "${file}: Hook installed";
        if [ -f "${file}/hooks/pre-commit" ]; then
            gprint "Hook created!!!"
        else
            rprint "Failed to create a hook"
        fi
    done < <(find / -type d -name '.git' -print0)
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
