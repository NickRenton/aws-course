echo "AWS learning test file." > kterletskyi_aws_2022.txt
echo "File is created"
aws s3 mb s3://kterletskyi-task-3-bucket-1
echo 'S3 bucket is created'
aws s3api put-bucket-versioning --bucket kterletskyi-task-3-bucket-1  --versioning-configuration Status=Enabled
echo 'Versioning is enabled to the bucket'
aws s3api put-object --bucket kterletskyi-task-3-bucket-1 --key kterletskyi_aws_2022.txt --body kterletskyi_aws_2022.txt
echo 'The file is successfully uploaded to the bucket'