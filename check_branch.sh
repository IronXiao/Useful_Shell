#!/bin/bash
################################
#my company use a certain branch to track a certain bug
#so all releated changes can be checkout by a certain branch name
#just use this shell in your repo project to checkout these branches just one-time
###############################
BRANCH=$1
if [ 1 -gt $# ]; then
    echo "Usage "$0" branch_name"
    exit 1
fi

REPOS=$(repo forall -c pwd)
for path in $REPOS
do
	pushd $path > /dev/null
        RESULT=$(git branch -a|grep $BRANCH)
        if [ -n "$RESULT" ]; then
#          echo "find branch in "$path
          FILE=$(git status --porcelain|awk '/\ M/ { print $2; }')
          if [ -n "$FILE" ]; then
          	git diff $FILE > $(date "+%Y%m%d").patch
          	git stash -q
          fi
          git checkout -q $BRANCH
          CHECK_BRANCH=$(git branch | awk '/\*/ { print $2; }')
#          echo "branch after is "$CHECK_BRANCH
          if [ "$CHECK_BRANCH" != "$BRANCH" ]; then
          	echo "failed to checkout branch in "$path", please check it !"
          exit
          fi
        fi      
	popd > /dev/null
done
echo "checkout branch to releated git folder to "$BRANCH" success !"

