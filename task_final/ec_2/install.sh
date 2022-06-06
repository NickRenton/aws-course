#! /bin/bash
sudo su
yum update -y
yum install java-1.8.0-openjdk -y
java -version

aws s3 cp s3://kterletskyi-task-3-bucket-1/calc-2021-0.0.1-SNAPSHOT.jar /home/

java -jar /home/calc-2021-0.0.1-SNAPSHOT.jar