#/bin/bash

while :
do
  emptyKey="None"
  originalAcl1=""
  originalAcl2=""

  echo "`date`: New iteration"

  s3key1=$(aws s3api list-objects --bucket elasticbeanstalk-us-west-2-957862771990 --prefix "resources/environments/e-qxacvw7vpn/_runtime/_versions/Tomcat8Apache" --query 'Contents[0].Key' --output text)
  s3key2=$(aws s3api list-objects --bucket elasticbeanstalk-us-west-2-957862771990 --prefix "resources/environments/e-qxacvw7vpn/_runtime/_versions/Tomcat8Apache" --query 'Contents[1].Key' --output text)

  #echo $s3key1
  #echo $s3key2
  #if "$s3key1" -ne "None"; then
  #  originalAcl1=$(aws s3api get-object-acl --bucket elasticbeanstalk-us-west-2-957862771990 --key "${s3key1}")
  #fi
  originalAcl1=$(aws s3api get-object-acl --bucket elasticbeanstalk-us-west-2-957862771990 --key "${s3key1}")
  if [ $s3key2 != $emptyKey ]; then
    originalAcl2=$(aws s3api get-object-acl --bucket elasticbeanstalk-us-west-2-957862771990 --key "${s3key2}")
  fi

  if grep aws-mac+prod-us-west-2-cstore <<< $originalAcl1 > /dev/null 2>&1; then
    echo "`date`: found aws-mac+prod-us-west-2-cstore in s3key1"

    putObjectAclResponse=$(aws s3api put-object-acl --acl bucket-owner-full-control --bucket elasticbeanstalk-us-west-2-957862771990 --key "${s3key1}")
    newAcl=$(aws s3api get-object-acl --bucket elasticbeanstalk-us-west-2-957862771990 --key "${s3key1}")

    echo "`date`: NewAcl1:"
    echo $newAcl
  elif grep aws-mac+prod-us-west-2-cstore <<< $originalAcl2 > /dev/null 2>&1; then
    echo "`date`: found aws-mac+prod-us-west-2-cstore in s3key2"

    putObjectAclResponse=$(aws s3api put-object-acl --acl bucket-owner-full-control --bucket elasticbeanstalk-us-west-2-957862771990 --key "${s3key2}")
    newAcl=$(aws s3api get-object-acl --bucket elasticbeanstalk-us-west-2-957862771990 --key "${s3key2}")

    echo "`date`: NewAcl2:"
    echo $newAcl
  else
    echo "`date`: not found, continuing..."
  fi

  sleep 1
  #echo "S3 Key"
  #echo $s3key
  #echo "Original Acl"
  #echo $originalAcl
  #echo "PutObjectAcl Response"
  #echo $putObjectAclResponse
  #echo "New Acl"
  #echo $newAcl

done
