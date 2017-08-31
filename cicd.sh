oc new-project cicd
oc import-image openshift/jenkins-2-centos7 --confirm
until oc get istag jenkins-2-centos7:latest 2>/dev/null | grep -q latest ; do echo '-- waiting for initial imagestream to sync from upstream...' ; sleep 10s ; done
oc new-app jenkins-ephemeral -p NAMESPACE=cicd -p JENKINS_IMAGE_STREAM_TAG=jenkins-2-centos7:latest -p MEMORY_LIMIT=2Gi
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n dev
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n prod
cat ocp_files/bc_cloudfarm_pipeline.yaml | oc create -f -
sleep 5s ; oc logs -f dc/jenkins
oc start-build cloudfarm-pipeline
