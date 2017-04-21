# git-utils
A set of Git scripts to help developing and deploying.

## Installation
Copy the bin folder to your home directory or the contents to any folder in PATH.
If don't work do the following edit the .bashrc file and check it has the line: 

    PATH=$PATH:$HOME/bin

## Dependencies
The scripts require the following packages:

    realpath 

You can install it with your system package manager. For example in Debian:

    sudo apt-get install realpath

realpath -> Linux package that is installed with the command apt-get install realpath

## Available commands
### diffarchive

#### Description
Generates a tar.gz with all changed files between current branch and destination branch. Before doing the file it updates all branches from origin.
Create configure file for Git -> git config - f fileName level1.level2.levelN value
Include configure file in local config of Git -> git config include.path filePath(if it is in the file path then filePath=../fileName)

#### Parameters

    git diffarchive [destination branch] [destination folder]
`[destination branch]` is the branch to diff from the current branch. `master` is used by default
`[destination folder]` is the folder where will write the file and the list of files included, by default is the parent folder.

#### Example

    $> git diffarchive master

#### Use 
The command must be executed in the root of the git repository. The file is generated in the parent directory with the name: 

[repository_name]-[destination_branch]-[origin_branch]-patch_[date].tar.gz

Another file with the list of changes is also generated with the name: 

[repository_name]-[destination_branch]-[origin_branch]-files_[date].txt

The command is usefull to gather all files needed to be uploaded to a remote server (production, development, etc) and upload it manually.

### updateall
#### Description
Fast forward every branch to be updated from their remote

#### Example

    $> git updateall

#### Use 
This command is usefull to update the entire local repository from the remote repositories

### pullall
#### Description
Pull all remote branches to the current one.

#### Example

    $> git pullall

#### Use 
This command is usefull when working with many developers in the same proyect with hight posibilities of collisions. A updated branch is very important in this cases.

This command is usefull to update your branch before a deploy using the `diffarchive` command.

### pushall
#### Description
Push current branch to designed branchs in all origins

#### Parameters

    git pushall [destination branch]
`[destination branch]` is the branch to push from the current branch. `dev master` is used by default

#### Example

    $> git pushall

Push the current branch to all origin's branchs with name `dev` or `master` (default values)


    $> git pushall my_branch my_other_branch

Push the current branch to all origin's branchs with name `my_branch` or `my_other_branch`

#### Use 
This command is usefull to push your changes to multiple origins or/and to multiple branches 

### changesarchive
#### Description
Create a tar file with all the files changed but not commited in the current branch or for a commit id.

#### Parameters

    git changesarchive [commit id]

[commit id] is the commit id used to generate the archive with the changed files. If not commit id is set all uncommited changes will be used.

#### Example

Generate a file with all uncommited changes

    $> git changesarchive

Generate a file with all files changed in a commit

    $> git changesarchive 4670ddc015

#### Use 
This command is usefull to get the current changed files or the files affected by a commit.



