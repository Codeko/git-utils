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

function load_gitconfig(){
  git config include.path ../.gitconfig
}
function load_route(){
	echo $(git config --get $1.ruta)
}
function update_branchs(){
   if [ "$1" = "pullall" ] || [ "updateall" ]; then
      for brname in `git branch -r  | grep -v HEAD `; do
	  CBRANCH=`echo $brname | sed -e 's/.*\///g'`
    	  brname=$(echo $brname|cut -d "/" -f1)
	  for i in "$@"; do
		if [ "$CBRANCH" = "$i" ]; then
            	     echo "Pulling from ${brname/\// }..."
	    	     git checkout $i
	    	     git pull $brname $i
		fi
    	  done
      done
    elif [ "$1" = "pushall" ]; then
        for brname in `git branch -r  | grep -v HEAD `; do
            CBRANCH=`echo $brname | sed -e 's/.*\///g'`
	    brname=$(echo $brname|cut -d "/" -f1)
            for i in $@; do
                if [ "$CBRANCH" = "$i" ]; then
                    echo "Push to ${brname/\// }..."
	    	    git checkout $i
		    git merge $i
        	    git push $brname $i	
     	        fi
	    done
	done
     fi
}

function load_white_list(){
  branchs=""
  if [ $(git config --get $1.lista.blanca)!="" ]; then
    branchs=$(git config --get $1.lista.blanca)
  fi
  echo $branchs

}

function load_black_list(){
  branchs=""
  if [ $(git config --get $1.lista.negra)!="" ]; then
    branchs=$(git config --get $1.lista.negra)
  fi
  echo $branchs

}
function create_array(){
	declare -a list
	b=1
	condition=$(echo $1| cut -d "," -f$b)
	while [ "$condition" != "" ]; do
	    list[$b]=$condition
	    ((b++))
	    condition=$(echo $1| cut -d "," -f$b)
	done
	echo ${list[@]}

}
function option_default(){
 declare -a list_def
 declare -a white
 declare -a black
   if [ -z $(git config  --get $1.default) ];then
       white_list=($(load_white_list $1))
       black_list=($(load_black_list $1))
       if [ "$white_list" = "" ] && [ "$black_list" = "" ]; then
	   update_all_branchs
	   exit 1
       elif [ "$white_list" != "" ] && [ "$black_list" != "" ]; then
	    white=($(create_array $white_list))
	    black=($(create_array $black_list))
	    d=1
	    for w in "${white[@]}"; do
		found=0
		for b in "${black[@]}"; do
			if [ "$w" = "$b" ]; then
				found=1
				break
			fi
	    	done
		if [ $found -eq 0 ]; then
			list_def[$d]=$w
			((d++))		
		fi
	    done
       elif [ "$white_list" != "" ] && [ "$black_list" = "" ]; then
	    white=$(create_array $white_list)
       elif [ "$black_list" != "" ] && [ "$white_list" = "" ]; then
	     j=1
	     for branch in `git branch -r  | grep -v HEAD|cut -d "/" -f2`; do
		     i=1
		     found=0
		     final=$(echo $black_list | cut -d "," -f$i)
		     while [ "$final" != "" ]; do
			   if [ "$final" = "$branch" ]; then
			       found=1
			       break
			   fi
			   ((i++))
			   final=$(echo $black_list| cut -d "," -f$i)
		     done
		     if [ $found -eq 0 ]; then
		     	 list_def[$j]=$branch
			 ((j++))		
		     fi
	     done

	fi
	update_branchs $1 ${list_def[@]}
	exit 1
   else
        option_default=($(git config  --get $1.default))
	update_branchs $1 ${option_default[@]}
	exit 1
   fi
}



includePathGitconfig=$(git config include.path)

if [ "$includePathGitconfig" = "" ]; then
    load_configure_file
fi

