#!/usr/bin/env bash
echo "*************************************************"
echo "*         View Terraform Configuration          *"
echo "*              Aleksey Ovchinnikov              *"
echo "*               ORBITA.TEAM @2018               *"
echo "*************************************************"

if [ -z "$1" ]; then
   echo "Must provide config file environment variable. Exiting...."
   exit 1
fi

if [ -f .sec/$1.tfvars ]
then

./terraform graph .config | dot -Tpng > ./graph.png

fi

echo "Config $1 not exists! Exiting...."

