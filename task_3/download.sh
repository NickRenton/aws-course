#! /bin/bash
aws s3 cp s3://kterletskyi-task-3-bucket-1/rds-script.sql /home/
aws s3 cp s3://kterletskyi-task-3-bucket-1/dynamodb-script.sh /home/

echo 'Installing PostgreSQL client'
sudo amazon-linux-extras install postgresql10

echo 'Make the file executable'
sudo chmod +x /home/dynamodb-script.sh
