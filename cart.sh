#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=172.31.45.86

TIMESTAMP=$(date +%F-%H-%m-%s)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
exec &>$LOGFILE

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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current nodejs" 

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "enabling  nodejs:18" 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "installing  nodejs:18"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else 
    echo -e "roboshop user already exit $Y SKIPPING $N"
fi    

mkdir -p /app

VALIDATE $? "creating app directory" 

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip

VALIDATE $? "Downloading cart application"

cd /app 

unzip -o /tmp/cart.zip &>> $LOGFILE


VALIDATE $? "unzipping the cart" 

npm install &>> $LOGFILE
 
VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

VALIDATE $? "Copying cart service file" 

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "cart daemon reload" 

systemctl enable cart &>> $LOGFILE

VALIDATE $? "Enabling cart" 

systemctl start cart &>> $LOGFILE

VALIDATE $? "starting cart" 
