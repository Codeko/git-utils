#!/bin/bash
# -*- ENCODING: UTF-8 -*-

#Stops script if any error
set -e

CURRENT_PATH=`pwd`

#Check if a .git folder exits
function check_git_dir(){
	if [ ! -d .git ]; then
            echo "Can't find git in the current path: $CURRENT_PATH"
            exit -1
        fi
}


function update_all_branchs(){
    BRANCH=$(git name-rev HEAD 2> /dev/null | awk "{ print \$2 }")
    echo "Updating all branchs from remote..."
    git remote update --prune

    #Pull from all remote branches
    for brname in `git branch -r  | grep -v HEAD `; do
        echo "Updating ${brname/\// }..."
        CBRANCH=`echo $brname | sed -e 's/.*\///g'`
        git checkout $CBRANCH
        git pull ${brname/\// } 
    done
    
    git checkout $BRANCH
}

