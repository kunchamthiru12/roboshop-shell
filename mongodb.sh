#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%m-%s)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>>$LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
         echo -e "$2 ... $R Failed $N"
    else
         echo -e "$2 ... $G success $N"
    fi          
}


if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: please run the script with root access $N"
    exit 1
else
    echo "you are root user"
fi # fi means revers of if ,indicating condition end

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied MongoDB Repo"

dnf install mongodb-org -y  &>> $LOGFILE

VALIDATe $? "installating  MongoDB"

systemctl enable mongod &>> $LOGFILE

VALIDATe $? "Enabling  MongoDB"

systemctl  start mongod &>> $LOGFILE

VALIDATe $? "starting  MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
 
 VALIDATE $? "Remote access to MongoDB"

systemctl restart mongod  &>> $LOGFILE

VALIDATe $? "restarting  MongoDB"

