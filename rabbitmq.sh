#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=172.31.45.86

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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "Downloading erlang script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE

VALIDATE  $? "Downloading  rabbitmq script"

dnf install rabbitmq-server -y  &>>$LOGFILE 

VALIDATE  $? "Installing rabbitmq server"

systemctl enable rabbitmq-server  &>>$LOGFILE

VALIDATE $? "enabling rabbitmq server"

systemctl start rabbitmq-server &>>$LOGFILE

VALIDATE $? "starting rabbit mq server"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE

VALIDATE $? "creating user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE

VALIDATE $? "setting permission"