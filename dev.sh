oc new-project dev
oc secrets new-sshauth  cloudfarm --ssh-privatekey=../ssh/ocp-handson
oc secrets link builder cloudfarm --for=pull
oc import-image dotnet --from=registry.access.redhat.com/dotnet/dotnetcore-11-rhel7 --confirm
until oc get istag dotnet:latest 2>/dev/null | grep -q latest ; do echo '-- waiting for initial imagestream to sync from upstream...' ; sleep 10s ; done
cat ocp_files/is_cloudfarm.yaml | oc create -f -
cat ocp_files/bc_cloudfarm.yaml | oc create -f -
sleep 2s && oc logs -f bc/cloudfarm
cat ocp_files/dc_cloudfarm.yaml | oc create -f -
oc expose dc cloudfarm -l app=cloudfarm
oc expose service cloudfarm -l app=cloudfarm
oc get routes/cloudfarm
oc tag dev/cloudfarm:latest dev/cloudfarm:readyforprod -n dev
