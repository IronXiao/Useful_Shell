#!/bin/bash
MSG=$1
if [ 1 -gt $# ]; then
    echo "Usage ./find_commit.sh commit_msg"
    exit 1
fi
LOCAL_DIR=$(pwd)
COMMIT_DIR=$LOCAL_DIR/find_out_${MSG#*\#}
if [ -d $COMMIT_DIR ]; then
   rm -rf $COMMIT_DIR
fi
REPOS=$(repo forall -c pwd)
for path in $REPOS
do
	pushd $path > /dev/null
        COMMITS=($(git log --pretty=format:"%H" --grep=$MSG))
        j=${#COMMITS[@]}
        if [ $j -gt 0 ]; then
	let i=n=$j-1
        k=0
	echo -e "Found "$j" commit(s) in "${path#*$LOCAL_DIR\/}
        COMMIT_OUT_PATCH=$COMMIT_DIR/patch
        if [ ! -d $COMMIT_OUT_PATCH ]; then
           mkdir -p $COMMIT_OUT_PATCH
        fi
        while [ $i -ge 0 ]
	do
		      commit=${COMMITS[$i]}
                      COMMIT_OUT_SOURCE=$COMMIT_DIR/source_code/${path#*$LOCAL_DIR}/commit_$k
                      if [ ! -d $COMMIT_OUT_SOURCE ]; then
                            mkdir -p $COMMIT_OUT_SOURCE
                      fi
		      PATCH_NAME_TMP=${path#*$LOCAL_DIR/}
		      PATCH_NAME=${PATCH_NAME_TMP//\//_}_$k.patch
		        if [ $i -eq $n ]; then
                           echo $PATCH_NAME_TMP: >> $COMMIT_DIR/commits.txt
                        fi
		      echo -e '\t'$commit >> $COMMIT_DIR/commits.txt
                        if [ $k -eq $n ]; then
                           echo -e '\n' >> $COMMIT_DIR/commits.txt
                        fi
		      mv $(git format-patch -1 $commit --no-commit-id) $COMMIT_OUT_PATCH/$PATCH_NAME
	              FILES=$(git diff-tree -r --no-commit-id --name-only $commit)
		            for file in $FILES
				do
				cp --parents $file $COMMIT_OUT_SOURCE
                                done
		     let i--
                     let k++
          done
          fi
	popd > /dev/null
done
echo -e "\n"
if [ -f $COMMIT_DIR/commits.txt ]; then
   echo "All patch and source code generated in dictory "${COMMIT_DIR#*$LOCAL_DIR\/}
else
   echo "No commit found that match commit_msg: "$MSG
fi
