#!/bin/bash
mkdir -p $HOME/git-utils
mkdir -p $HOME/git-utils/bin
echo "chmod 777 /usr/local/lib/node_modules/git-utils"
echo "source ~/git-utils/bin/git-changesarchive" >>~/git-utils/bin/git-changesarchive
echo "source ~/git-utils/bin/git-diffarchive" >>~/git-utils/bin/git-diffarchive
echo "source ~/git-utils/bin/git-pullall" >>~/git-utils/bin/git-pullall
echo "source ~/git-utils//bin/git-pushall" >>~/git-utils/bin/git-pushall
echo "source ~/git-utils/bin/git-updateall" >>~/git-utils/bin/git-updateall
echo "source ~/git-utils/bin/gitutil_common.sh" >>~/git-utils/bin/gitutil_common.sh
echo "chmod 777 ~/git-utils/bin/*"
