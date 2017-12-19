#!/bin/sh
if [ 1 -gt $# ]; then
    echo "Usage ./sign.sh apk_name"
    exit 1
fi
APK=$1
PEM=platform.x509.pem
PK8=platform.pk8
SIGNAPK=signapk.jar
java -Xmx2048m -jar $SIGNAPK -w $PEM $PK8 $APK ${APK%.*}_signed.${APK##*.}
