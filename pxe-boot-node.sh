#!/bin/bash
 # ${self.input.node} ${self.input.ipmi_ip} ${self.input.ipmi_user} ${self.input.ipmi_password}

set -e

node=$1
ipmi_ip=$2
ipmi_user=$3
ipmi_password=$4

if [ -z "$ipmi_password" ]; then
  echo "$0 <node> <ipmi_ip> <ipmi_user> <ipmi_password>"
  exit 0    # to allow TF to continue without automatic ipmi trigger
fi

echo "checking ipmitool version ..."
ipmitool -V

echo "setting node $node to one time pxe boot ..."
ipmitool -I lanplus -H $ipmi_ip -U $ipmi_user -P $ipmi_password chassis bootdev pxe options=efiboot
echo "power off node $node ..."
ipmitool -I lanplus -H $ipmi_ip -U $ipmi_user -P $ipmi_password chassis power off || true
echo "waiting 5 secs ..."
sleep 5
echo "power on node $node ..."
ipmitool -I lanplus -H $ipmi_ip -U $ipmi_user -P $ipmi_password chassis power on
