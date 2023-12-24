#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=mongodb.padimalayamuna.xyz

TIMESTAMP=$(date +%F-%H-%m-%s)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>>$LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ... $R Failed $N"
        exit1
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

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading catalogue application"

cd /app 

unzip -o /tmp/catalogue.zip &>> $LOGFILE


VALIDATE $? "unzipping the catalogue" 

npm install &>> $LOGFILE
 
VALIDATE $? "Installing dependencies"

#use absolute path.because catalogue.service exists there
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "Copying catalogue service file" 

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "catalogue daemon reload" 

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enabling catalogue" 

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "starting catalogue" 

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? " copying mongodb repo" 

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? " Installing MongoDB client" 

mongo --host $MONGODB_HOST </app/schema/catalogue.js &>> $LOGFILE 

VALIDATE $? " Loading catalogue data into MongoDB" 



