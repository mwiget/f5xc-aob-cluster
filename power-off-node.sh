#!/bin/bash
 # ${self.input.node} ${self.input.ipmi_ip} ${self.input.ipmi_user} ${self.input.ipmi_password}

set -e

node=$1
ipmi_ip=$2
ipmi_user=$3
ipmi_password=$4

if [ -z "$ipmi_password" ]; then
  echo "$0 <node> <ipmi_ip> <ipmi_user> <ipmi_password>"
  exit 1
fi

echo "checking ipmitool version ..."
ipmitool -V

echo "power reset node $node ..."
ipmitool -I lanplus -H $ipmi_ip -U $ipmi_user -P $ipmi_password chassis power off
