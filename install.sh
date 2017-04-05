#!/bin/bash
echo "chmod 777 /usr/local/lib/node_modules/git-utils"
cp $HOME/.npm/git-utils/1.0.0/package.tgz .
tar -xvzf package.tgz
echo "chmod 777 ~/git-utils/bin/*"
