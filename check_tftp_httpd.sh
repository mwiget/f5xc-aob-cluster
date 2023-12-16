#!/bin/bash
set -e
echo ""
echo "getting redhat/EFI/BOOT/BOOTX64.EFI via tftp ..."
echo "get redhat/EFI/BOOT/BOOTX64.EFI /dev/null" | tftp localhost
echo ""
echo "getting redhat/EFI/BOOT/grub.cfg via tftp ..."
echo "get redhat/EFI/BOOT/grub.cfg /dev/null" | tftp localhost
echo ""
echo "getting kickstart files via http $base_url ..."
base_url=$(grep base_url terraform.tfvars | cut -d\" -f2)
curl -s $base_url/kickstart/ | grep -o 'href=".*">' | sed 's/href="//;s/\/">//' | cut -d\" -f1 | grep -v Parent\ Directory | grep -v ^\? | cut -d/ -f2

