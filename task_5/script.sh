aws configure

aws sns publish --topic arn:aws:sns:us-west-2:127811157688:task5_sns --message 'hello from EC2 task 5' --region us-west-2

aws sqs send-message --queue-url https://sqs.us-west-2.amazonaws.com/127811157688/task5_sqs --message-body 'TASK 5 EC2 to SQS' --region us-west-2

aws sqs receive-message --queue-url https://sqs.us-west-2.amazonaws.com/127811157688/task5_sqs --region us-west-2