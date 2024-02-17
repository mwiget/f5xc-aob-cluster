#!/bin/bash
PORTS="06:00.0 06:00.1"
NUM_OF_VFS=64

source env.sh
PODS=$(kubectl get pods -o wide |grep ubuntu-login |grep Running | awk '{print $7 ":" $1 ":" $6}' )

for POD in $PODS; do
  pod=$(echo $POD | cut -d: -f2)  
  node=$(echo $POD | cut -d: -f1)
  ip=$(echo $POD | cut -d: -f3) 
  echo -n "$node $pod ($ip) ... "
  for port in $PORTS; do
    kubectl exec $pod -- bash -c "mstconfig -d $port -y set NUM_OF_VFS=$NUM_OF_VFS"
  done
  echo ""
done
