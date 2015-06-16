#!/bin/bash
#set -x
# Define logs dirctory
#LOG_DIR_ROOT="/logs"
LOG_DIR_ROOT="/work/logs"
LOG_DIR=`ls  -F  $LOG_DIR_ROOT|grep '/$'`
# define  your ERROR logs dirctory
ERROR_LOG_ROOT="/work/errors"
########################################################################
ADDRESS=`ifconfig eth0 |sed '3,$d'|grep inet|awk '{ print $2 }'| awk -F ":" '{ print $2 }'`
echo $ADDRESS

###################################
if [ ! -d $ERROR_LOG_ROOT ]; then
    mkdir -p $ERROR_LOG_ROOT
else
    rm -rf $ERROR_LOG_ROOT/*
fi

for DIR in $LOG_DIR 
do
    if [ ! -d $ERROR_LOG_ROOT/$DIR ]; then
        mkdir -p $ERROR_LOG_ROOT/$DIR
    fi
    sleep 2
    for list in `ls $DIR`
    do
        sed -n '/ERROR/,/INFO/p' $LOG_DIR_ROOT/$DIR/$list > $ERROR_LOG_ROOT/$DIR/${list}.err
        if [ `du  $ERROR_LOG_ROOT/$DIR/${list}.err|awk '{ print $1 }'` -eq 0 ]; then
            sleep 2
            rm -f $ERROR_LOG_ROOT/$DIR/${list}.err
        fi
    done
done


sendEmail -o tls=no -f smurf@chinasmurf.com -t jinyafeng@mychebao.com -s smtp.mxhichina.com -xu smurf@chinasmurf.com -xp Jyf900913 -u "运维报告" -m "test mail" 

