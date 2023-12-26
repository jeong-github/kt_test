#!bin/bash

echo -n "Enter the user Access KeyID:"
read Key_ID
echo -n "Enter the user Secret Key:"
read Key_Secret

cat << EOF >> credentials-velero
[default]
aws_access_key_id =${Key_ID}
aws_secret_access_key =${Key_Secret}
EOF



Version=$(velero version | grep Version | cut -c 14,15)
echo "your velero version : v1.${Version}.x"


  case "$Version" in
    "13")
      echo "your plubing version 1.9.x"
      echo "please another vlero version"
      exit
      ;;
    "12")
      echo "your plubing version 1.8.x"
      docker pull velero/velero-plugin-for-aws:v1.8.1
			Pnum1=$(docker image list | grep 1.8 | awk  '{print $1}')
			Pnum2=$(docker image list | grep 1.8 | awk  '{print $2}')
      ;;
    "11")
      echo "your plubing version 1.7.x"
      docker pull velero/velero-plugin-for-aws:v1.7.1
			Pnum1=$(docker image list | grep 1.7 | awk  '{print $1}')
			Pnum2=$(docker image list | grep 1.7 | awk  '{print $2}')
      ;;
    "10")
      echo "your plubing version 1.6.x"
      docker pull velero/velero-plugin-for-aws:v1.6.1
      Pnum1=$(docker image list | grep 1.6 | awk  '{print $1}')
      Pnum2=$(docker image list | grep 1.6 | awk  '{print $2}')
      ;;
  esac

echo "################################################"
echo "               velero install                   "
echo "################################################"

echo -n "Enter the user bucket: "
read Bucket
echo -n "Enter the user minioip{port}: "
read MinioIp

velero install \
    --provider aws \
    --plugins $Pnum1:$Pnum2 \
    --bucket $Bucket \
    --secret-file ./credentials-velero \
    --use-volume-snapshots=false \
    --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=$MinioIp
