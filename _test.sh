#!/usr/bin/env bash
echo "*************************************************"
echo "*         Test Terraform Configuration          *"
echo "*              Aleksey Ovchinnikov              *"
echo "*               ORBITA.TEAM @2018               *"
echo "*************************************************"
if [ -z "$1" ]; then
   echo "Must provide config file environment variable. Exiting...."
   exit 1
fi

if [ -f .sec/$1.tfvars ]
then

./terraform plan -var-file=.sec/$1.tfvars  .config

fi

echo "Config $1 not exists! Exiting...."

