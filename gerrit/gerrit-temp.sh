#!/bin/bash
exit
git clone ssh://artem.radchenko@gerrit-ua.globallogic.com:29418/renesas/device/renesas/salvator/common
git checkout r-ncar
gitdir=$(git rev-parse --git-dir); scp -p -P 29418 artem.radchenko@gerrit-ua.globallogic.com:hooks/commit-msg ${gitdir}/hooks/
git add [changes]
git commit -s #-s for signed by
git push origin HEAD:refs/for/r-ncar

ssh -p 29418 review.example.com gerrit ls-projects
scp -p -P 29418 john.doe@review.example.com:bin/gerrit-cherry-pick ~/bin/


###########


