#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-013e4f22ecfb53901 #replace with your SG ID
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
ZONE_ID=Z104317737D96UJVA7NEF # replace your zone ID
DOMAIN_NAME="daws76s.online"

for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb  --instance-type $INSTANCE_TYPE --security-group-ids sg-013e4f22ecfb53901 )
    echo "$i: $IP_ADDRESS"

    