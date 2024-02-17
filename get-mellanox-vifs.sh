#!/bin/bash
PORTS="06:00.0 06:00.1"
source env.sh
PODS=$(kubectl get pods -o wide |grep ubuntu-login |grep Running | awk '{print $7 ":" $1 ":" $6}' )

for POD in $PODS; do
  pod=$(echo $POD | cut -d: -f2)  
  node=$(echo $POD | cut -d: -f1)
  ip=$(echo $POD | cut -d: -f3) 
  echo "$node $pod ($ip) ... "
  for port in $PORTS; do
    echo -n "$node $port "
    kubectl exec $pod -- bash -c "mstconfig -d $port query|grep VFS"
  done
  echo ""
done
