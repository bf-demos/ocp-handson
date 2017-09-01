# Hands-On with OpenShift

( Figure out how to load the key, and get an IP address )

ssh -i ssh/ocp-handson centos@<IP>
tail -f /var/log/cloud-init.loh
  
( Wait until you see "Cloud-Init finished, then CTRL-C )

cd ocp-handson
. cluster_up

( Open the URL starting with "https://ec2-" in your browser and login as developer/developer )

./wrapper dev.sh
./wrapper prod.sh
./wrapper cicd.sh
