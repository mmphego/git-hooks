#!/bin/bash
# Force everyone to comply and use git-hooks!!!!
# Author: Mpho Mphego <mmphego@ska.ac.za>

set -i

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

cd /;
function delete_hooks() {
    for i in $(find / -type d -name '.git'); do
        echo "Deleting ${i} hooks" 1>&2;
        chattr -i $i/hooks/*;
        rm -vrf $i/hooks/*;
    done
}

function install_hooks(){
    for i in $(find / -type d -name '.git'); do
        cd $i && cd ..;
        git init;
        chattr +i $i/hooks/*;
        echo "$i: Hook installed" 1>&2;
        head -2 $i/hooks/pre-commit;
    done
}

# Check if the function exists (bash specific)
if declare -f "$1" > /dev/null; then
    # call arguments verbatim
    "$@"
else
    # Show a helpful error
    if [ "$1" == '' ]; then
        echo "'$1' is not a known function name" >&2
    fi
    echo "Available functions: delete_hooks and install_hooks";
    echo "Usage: sudo $0 delete_hooks or $0 install_hooks"
    exit 1
fi
