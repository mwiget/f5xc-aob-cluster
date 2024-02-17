#!/bin/bash
filter=$1
source env.sh
PODS=$(kubectl get pods -o wide |grep ubuntu-login |grep Running | awk '{print $7 ":" $1 ":" $6}' )
#echo $PODS
for pod in $PODS; do
  if grep -q "$filter" <<< "$pod"; then
    #echo "found it in $pod"
    pod=$(echo $pod | cut -d: -f2)
    node=$(echo $pod | cut -d: -f1)
    ip=$(echo $pod | cut -d: -f3)
    break
  fi
done
echo "Logging into $node $pod ($ip) ..."
kubectl exec -ti $pod -- /bin/bash -li 
exit
