# Demo of Dynamic Provisioning using EBS CSI driver

 k apply -f sc.yaml
 k get sc

 k apply -f pvc.yaml
 k get pvc
 NOTE: it's not bound, because "WaitForFirstConsumer"
 k get pvc


 k apply -f pod.yaml
 (NOTE: Will take 5-6 seconds...Gotta DYNAMICALLY provision an EBS Volume)
 k get pv,pvc

 k exec -it po/app-pod -- /bin/sh
 df -h
 ls -lha /data
 exit
 
 k delete -f pod.yaml
 k get pv,pvc 
 (Observe pv and pvc still exist)

 k delete -f pvc.yaml
 k get pv,pvc
 (Observe now they are gone)