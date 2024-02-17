#!/bin/bash
filter=$1
source env.sh
ALPINES=$(kubectl get pods -o wide |grep alpine-login |grep Running | awk '{print $7 ":" $1 ":" $6}' )
#echo $ALPINES
for ALPINE in $ALPINES; do
  if grep -q "$filter" <<< "$ALPINE"; then
    #echo "found it in $ALPINE"
    pod=$(echo $ALPINE | cut -d: -f2)
    node=$(echo $ALPINE | cut -d: -f1)
    ip=$(echo $ALPINE | cut -d: -f3)
    break
  fi
done
echo "Logging into $node $pod ($ip) ..."
kubectl exec -ti $pod -- /bin/ash -li 
exit
