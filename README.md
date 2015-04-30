# git-utils
A set of Git scripts to help developing and deploying.

## Installation
Copy the bin folder to your home directory or the contents to any folder in PATH.
If don't work do the following edit the .bashrc file and check it has the line: 

    PATH=$PATH:$HOME/bin

## Available commands
### uploadfile

#### Description
Generates a tar.gz with all changed files between current branch and destination branch. Before doing the file it updates all branches from origin.

#### Parameters

    git uploadfile [destination branch]
`[destination branch]` is the branch to diff from the current branch. `master` is used by default

#### Example

    $> git uploadfile master

#### Use 
The command must be executed in the root of the git repository. The file is generated in the parent directory with the name: 

[repository_name]-[destination_branch]-[origin_branch]-patch_[date].tar.gz

Another file with the list of changes is also generated with the name: 

[repository_name]-[destination_branch]-[origin_branch]-files_[date].txt

The command is usefull to gather all files needed to be uploaded to a remote server (production, development, etc) and upload it manually.

### pullall
#### Description
Pull all remote branches to the current one.

#### Example

    $> git pullall

#### Use 
This command is usefull when working with many developers in the same proyect with hight posibilities of collisions. A updated branch is very important in this cases.

This command is usefull to update your branch before a deploy using the `uploadfile` command.


