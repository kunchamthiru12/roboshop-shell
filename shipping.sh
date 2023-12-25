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

dnf install maven -y
id roboshop 
if [ $? -ne 0]
then
     useradd roboshop
     VALIDATE $? "roboshopuser creation"
else
    echo -e "roboshop user  already exist $Y SKIPPING $N"       
fi


mkdir /app

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

cd /appunzip /tmp/shipping.zip

mvn clean package

VALIDATE $? "Installing dependencies"

mv target/shipping-1.0.jar shipping.jar

VALIDATE $? "renaming jar file"

cp /hom/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

VALIDATE $? "copying shipping service" 

systemctl daemon-reload

VALIDATE $? "roboshop user creation"

systemctl enable shipping 

VALIDATE $? "enabling shipping"

systemctl start shipping

VALIDATE $? "starting shipping"

dnf install mysql -y

VALIDATE $? "Install MySQL client"

mysql -h 172.31.37.236 -uroot -pRoboShop@1 < /app/schema/shipping.sql 

VALIDATE $? loading shipping data"

systemctl restart shipping

VALIDATE $? "restart shipping"
