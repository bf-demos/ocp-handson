oc new-project prod
oc policy add-role-to-user system:image-puller system:serviceaccount:prod:default -n dev
oc tag dev/cloudfarm:readyforprod prod/cloudfarm:latest -n prod
cat ocp_files/dc_cloudfarm.yaml | oc create -f -
oc expose dc cloudfarm -l app=cloudfarm
oc expose service cloudfarm -l app=cloudfarm
oc get routes/cloudfarm
