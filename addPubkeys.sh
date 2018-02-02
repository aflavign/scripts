#!/bin/bash

if [ -z $1 ]; then
  echo "Missing parameter: s3 bucket name"
  exit 1
fi

S3BUCKET=$1
DIR=/tmp/somekeys

rm -rf ${DIR}

echo "Downloading keys"
aws s3 cp s3://${S3BUCKET} ${DIR} --recursive >/dev/null 2>&1

echo "Processing keys"
for somekeys in $(find ${DIR} -type f)
do
   #Is file a valid public key
   ssh-keygen -l -f ${somekeys} >/dev/null 2>&1
   if [ $? == 0 ] ;then
      cat ${somekeys} >> ~/.ssh/authorized_keys
      echo "Adding $(basename ${somekeys}) to authorized keys"
   fi
done

#Add uniq key only
sort ~/.ssh/authorized_keys | uniq > ~/.ssh/authorized_keys.uniq
mv ~/.ssh/authorized_keys{.uniq,}
