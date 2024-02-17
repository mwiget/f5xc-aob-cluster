#!/bin/bash
source env.sh
ALPINES=$(kubectl get pods |grep Running |grep alpine | cut -f1 -d' ')
echo $ALPINES

for pod in $ALPINES; do
  kubectl exec $pod -- ash -c "hostname && lshw -c network -businfo"
  echo ""
done
