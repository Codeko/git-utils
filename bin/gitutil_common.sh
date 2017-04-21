#!/bin/bash
# -*- ENCODING: UTF-8 -*-

#Stops script if any error
set -e

CURRENT_PATH=`pwd`
#Current branch
BRANCH=`git rev-parse --abbrev-ref HEAD 2> /dev/null`

#Check if a .git folder exits
function check_git_dir(){
	if [ ! -d .git ]; then
            echo "Can't find git in the current path: $CURRENT_PATH"
            exit -1
        fi
}


function update_all_branchs(){
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

function load_configure_file(){
  git config include.path ../.gitconfig
}

exitInclude=$(grep -e 'path = ../.gitconfig' .git/config|wc -l)

if [ $exitInclude -eq 0 ]; then
    load_configure_file
fi
