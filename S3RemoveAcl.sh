#/bin/bash

while :
do
  s3key=$(aws s3api list-objects --bucket elasticbeanstalk-us-west-2-957862771990 --prefix "resources/environments/e-qxacvw7vpn/_runtime/_versions/Tomcat8Apache" --query 'Contents[0].Key' --output text)
  originalAcl=$(aws s3api get-object-acl --bucket elasticbeanstalk-us-west-2-957862771990 --key "${s3key}")

  if grep aws-mac+prod-us-west-2-cstore <<< $originalAcl > /dev/null 2>&1; then
    echo "`date`:found aws-mac+prod-us-west-2-cstore, changing Acl"

    putObjectAclResponse=$(aws s3api put-object-acl --acl bucket-owner-full-control --bucket elasticbeanstalk-us-west-2-957862771990 --key "${s3key}")
    newAcl=$(aws s3api get-object-acl --bucket elasticbeanstalk-us-west-2-957862771990 --key "${s3key}")

    echo "`date`:NewAcl:"
    echo $newAcl
  else
    echo "`date`:not found, continuing..."
  fi

  #echo "S3 Key"
  #echo $s3key
  #echo "Original Acl"
  #echo $originalAcl
  #echo "PutObjectAcl Response"
  #echo $putObjectAclResponse
  #echo "New Acl"
  #echo $newAcl

done
