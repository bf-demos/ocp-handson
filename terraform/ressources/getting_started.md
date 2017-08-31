ssh ec2-user@<IP>
tail -f /var/log/cloud-init.log
# WAIT FOR "Cloud-init v. 0.7.6 finished", then CTRL-C
sudo /usr/local/bin/cluster_up.sh
# USE the URL shown in your browser
oc login localhost:8443 --username=developer --password=developer --insecure-skip-tls-verify=true
git clone --quiet git@github.com:basefarm/bf-ocp-demos.git
cd bf-ocp-demos/cloudfarm/
export PROJECT_PREFIX=cf
./create.sh
./destroy.sh
