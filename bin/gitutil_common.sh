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

