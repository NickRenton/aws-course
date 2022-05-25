aws s3 mb s3://kterletskyi-task-3-bucket-1
echo 'S3 bucket is created'
aws s3api put-bucket-versioning --bucket kterletskyi-task-3-bucket-1  --versioning-configuration Status=Enabled
echo 'Versioning is enabled to the bucket'
aws s3api put-object --bucket kterletskyi-task-3-bucket-1 --key rds-script.sql --body rds-script.sql
aws s3api put-object --bucket kterletskyi-task-3-bucket-1 --key dynamodb-script.sh --body dynamodb-script.sh
echo 'The files are successfully uploaded to the bucket'
