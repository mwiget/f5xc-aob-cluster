#!/bin/bash
filter=$1
source env.sh
PODS=$(kubectl get pods -o wide |grep ubuntu-login |grep Running | awk '{print $7 ":" $1 ":" $6}' )
#echo $PODS
for POD in $PODS; do
  if grep -q "$filter" <<< "$POD"; then
    #echo "found it in $ALPINE"
    pod=$(echo $POD | cut -d: -f2)
    node=$(echo $POD | cut -d: -f1)
    ip=$(echo $POD | cut -d: -f3)
    break
  fi
done
echo "Logging into $node $pod ($ip) ..."
kubectl exec -ti $pod -- chroot /host /bin/bash -li 
exit
