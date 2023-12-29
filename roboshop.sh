#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-013e4f22ecfb53901
INSTANCES=("mongodb" "redis" "mysql" rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${ Instances[@]}"
do    
   if [ $i == "mongodb" ] || [ $i ==  "mysql"] || [ $i== "shipping" ]
   then
      INSTANCE_TYPE="t3.small"
   else
      INSTANCE_TYPE="t2.micro"
    fi

    aws  ec2 run-instances --image-id ami-03265a0778a880afb --instance-type  t2.micro  --se curity-group-ids sg-013e4f22ecfb53901 

done
