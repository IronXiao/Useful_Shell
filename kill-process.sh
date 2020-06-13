#!/system/bin/sh
proclist=`ps |grep logcat |awk '{print $2}'`
array=(${proclist//\n/ })
for var in ${array[@]}
do  
  echo "var:${var}"
  kill ${var}
done

