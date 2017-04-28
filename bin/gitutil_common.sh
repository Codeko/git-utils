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
	echo $(git config --get $1.route)
}
function load_white_list_remotes(){
     remotes=""
     if [ $(git config --get remotes.list.white)!="" ]; then
    	remotes=$(git config --get remotes.list.white)
     fi
     echo $remotes
}
function load_black_list_remotes(){
     remotes=""
     if [ $(git config --get remotes.list.black)!="" ]; then
    	remotes=$(git config --get remotes.list.black)
     fi
     echo $remotes
}
function load_all_remotes(){
    declare -a remotes_def
    j=1
    for remote in `git remote`; do
	
	      remotes_def[$j]=$remote
	      ((j++))
    done
    echo ${remotes_def[@]}
}
function load_all_branchs(){
    declare -a branchs
    j=1
    for branch in `git branch -r  | grep -v "HEAD"|grep "origin"|cut -d "/" -f2`; do
	      branchs[$j]=$branch
	      ((j++))
    done
    echo ${branchs[@]}
}
function load_remotes(){
       declare -a white_list_remotes
       declare -a black_list_remotes
       declare -a remotes_def
       white_list_remotes=($(load_white_list_remotes))
       black_list_remotes=($(load_black_list_remotes))	
       if [ "$white_list_remotes" = "" ] && [ "$black_list_remotes" = "" ]; then
	   remotes_def=($(load_all_remotes))
       elif [ "$white_list_remotes" != "" ] && [ "$black_list_remotes" != "" ]; then
	    white=($(create_array $white_list_remotes))
	    black=($(create_array $black_list_remotes))
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
			remotes_def[$d]=$w
			((d++))		
		fi
	    done
       elif [ "$white_list_remotes" != "" ] && [ "$black_list_remotes" = "" ]; then
	    white=$(create_array $white_list_remotes)
	    remotes_def=($white)
       elif [ "$black_list_remotes" != "" ] && [ "$white_list_remotes" = "" ]; then
	     j=1
	     final=$(echo $black_list_remotes | cut -d "," -f1)
	     final_next=$(echo $black_list_remotes | cut -d "," -f2)
	     if [ "$final" != "$final_next" ]; then
		     for branch in `git remote`; do
		 	i=1
			found=0
 			final=$(echo $black_list_remotes | cut -d "," -f1)
			while [ "$final" != "" ]; do
			      if [ "$final" = "$branch" ]; then
				  found=1
				  break
			      fi
			      ((i++))
			      final=$(echo $black_list_remotes| cut -d "," -f$i)
			done
			      if [ $found -eq 0 ]; then
				  remotes_def[$j]=$branch
				  ((j++))		
			      fi
		      done
	     else
		     remotes_def=($(load_all_remotes)) 
	     fi
	fi
   	echo ${remotes_def[@]}
}
function create_array(){
	declare -a list
	b=1
	condition=$(echo $1| cut -d "," -f$b)
	condition_next=$(echo $1| cut -d "," -f2)
	if [ "$condition" != "$condition_next" ]; then
		while [ "$condition" != "" ]; do
		    list[$b]=$condition
		    ((b++))
		    condition=$(echo $1| cut -d "," -f$b)
		done
	else
		list[$b]=$1
	fi
	echo ${list[@]}

}
function update_branchs(){
	remotes_def=($(load_remotes))
	if [ "$1" = "pullall" ] || [ "updateall" ]; then
	      for brname in `git branch -r  | grep -v HEAD `; do
		  CBRANCH=`echo $brname | sed -e 's/.*\///g'`
	    	  brname=$(echo $brname|cut -d "/" -f1)
		  for r in "${remotes_def[@]}"; do
			if [ "$brname" = "$r" ]; then
			  for i in "$@"; do
				if [ "$CBRANCH" = "$i" ]; then
			    	     echo "Pulling from ${brname/\// }..."
			    	     git checkout $i
			    	     git pull $brname $i
				fi
		    	  done
			fi
		  done
	      done
    	elif [ "$1" = "pushall" ]; then
		for brname in `git branch -r  | grep -v HEAD `; do
		    CBRANCH=`echo $brname | sed -e 's/.*\///g'`
		    brname=$(echo $brname|cut -d "/" -f1)
		    for r in "${remotes_def[@]}"; do
			if [ "$brname" = "$r" ]; then
		    	   for i in $@; do
		        	 if [ "$CBRANCH" = "$i" ]; then
		            	      echo "Push to ${brname/\// }..."
		    	    	      git checkout $i
			    	      git merge $i
			    	     git push $brname $i	
	     	        	 fi
			   done
			fi
		    done
		done
     	fi
	exit 0
}

function load_white_list(){
  branchs=""
  if [ $(git config --get $1.list.white)!="" ]; then
    branchs=$(git config --get $1.list.white)
  fi
  echo $branchs

}

function load_black_list(){
  branchs=""
  if [ $(git config --get $1.list.black)!="" ]; then
    branchs=$(git config --get $1.list.black)
  fi
  echo $branchs

}
function option_default(){
 declare -a list_def
 declare -a white
 declare -a black
 declare -a white_remotes
   if [ -z $(git config  --get $1.default) ];then
       white_list=($(load_white_list $1))
       black_list=($(load_black_list $1))
       if [ "$white_list" = "" ] && [ "$black_list" = "" ]; then
	   list_def=($(load_all_branchs))
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
	    list_def=($white)
       elif [ "$black_list" != "" ] && [ "$white_list" = "" ]; then
	     j=1
	     for branch in `git branch -r  | grep -v HEAD|grep "origin"|cut -d "/" -f2`; do
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
	exit 0
   else
        option_default=$(git config  --get $1.default)
	update_branchs $1 ${option_default[@]}
	exit 0
   fi
}



includePathGitconfig=$(git config include.path)

if [ "$includePathGitconfig" = "" ]; then
    load_configure_file
fi

