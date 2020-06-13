#!/bin/bash
ECHO_CMD='echo 1 > /sys/class/unifykeys/attach'
ECHO_MAC='echo "mac" > /sys/class/unifykeys/name'
ECHO_SN='echo "usid" > /sys/class/unifykeys/name'
WRITE=' > /sys/class/unifykeys/write'
MACS=(
00:11:22:33:44:55
)

SNS=(
123456781234567812345678
)

length=${#MACS[@]}

j=1
for (( i = 0 ; i < $length ; i++ ))
do
	 echo $j "start "
   mac=${MACS[$i]}
   sn=${SNS[$i]}
   echo $ECHO_CMD
   echo $ECHO_MAC
   echo 'echo '\"$mac\"$WRITE
   echo $ECHO_SN
   echo 'echo '\"$sn\"$WRITE
   echo ""
   let j++
   
done


