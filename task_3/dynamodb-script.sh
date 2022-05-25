aws dynamodb list-tables --region us-west-2

echo "Write -> August Burns Red band"
aws dynamodb put-item --table-name "Music" --item '{"Band": {"S":"August Burns Red"}, "Song": {"S":"Redemption"}, "Year": {"N": "2007"}}' --region us-west-2
echo "Write -> If I were You band"
aws dynamodb put-item --table-name "Music" --item '{"Band": {"S":"If I were You"}, "Song": {"S":"At Days End"}, "Year": {"N": "2013"}}' --region us-west-2
echo "Write -> Betraying the Martyrs"
aws dynamodb put-item --table-name "Music" --item '{"Band": {"S":"Betraying the Martyrs"}, "Song": {"S":"Lighthouse"}, "Year": {"N": "2014"}}' --region us-west-2

echo "Read -> August Burns Red band"
aws dynamodb get-item --consistent-read --table-name Music --key '{"Band": {"S": "August Burns Red"}, "Song": {"S":"Redemption"}}' --region us-west-2
echo "Read -> If I were You band"
aws dynamodb get-item --consistent-read --table-name Music --key '{"Band": {"S": "If I were You"}, "Song": {"S":"At Days End"}}' --region us-west-2
echo "Read -> Betraying the Martyrs band"
aws dynamodb get-item --consistent-read --table-name Music --key '{"Band": {"S": "Betraying the Martyrs"}, "Song": {"S":"Lighthouse"}}' --region us-west-2
