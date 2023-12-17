#!/bin/bash
set -e

iso_url="https://vesio.blob.core.windows.net/releases/rhel/9/x86_64/images/latest"
http_folder=$(grep local_http_folder terraform.tfvars | cut -d\" -f2)
tftp_folder=$(grep local_tftp_folder terraform.tfvars | cut -d\" -f2)

# echo iso_url=$iso_url http=$http_folder tftp=$tftp_folder ...

echo "quering $iso_url ..."
URL=$(curl -s $iso_url)
VER=$(echo $URL | cut -d - -f2)
IMAGE=$(basename $URL)

if ! test -f $IMAGE; then
  echo downloading $URL ...
  curl -o $IMAGE $URL
else
  echo using local image $IMAGE ...
fi 

echo "checking if the local target folders $http_folder and $tftp_folder exist ..."
if [ ! -d $http_folder ]; then
  echo "please create folder $http_folder"
  exit 1
fi
if [ ! -d $tftp_folder ]; then
  echo "please create folder $tftp_folder"
  exit 1
fi

echo "mounting iso ..."
if [ "$(uname)" == "Darwin" ]; then
  # Load the kext module (required if mount fails on Big Sur)
  # sudo kmutil load -p /System/Library/Extensions/cd9660.kext
  DISK=$(hdiutil attach -nomount $IMAGE | grep FDisk | cut -d' ' -f1)
  echo $DISK
  mount -t cd9660 -r -o noowners $DISK ./iso
else
  sudo mount -o loop,ro -t iso9660 $IMAGE ./iso
fi

echo "copying files to tftp folder $tftp_folder/ ..."
cp -rp iso/EFI $tftp_folder/
mkdir -p $tftp_folder/images
cp -rp iso/images/pxeboot $tftp_folder/images/
chmod -R +r $tftp_folder/

echo "copying files to http folder $http_folder/ ..."
mkdir -p $http_folder/images
cp -p iso/images/install.img $http_folder/images/
chmod -R +r $http_folder/

if [ "$(uname)" == "Darwin" ]; then
umount $DISK
hdiutil detach $DISK
else
  sudo umount ./iso
fi
