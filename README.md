# Hands-On with OpenShift

( Figure out how to load the key, and get an IP address )

ssh -i ssh/ocp-handson centos@<IP>
cd ocp-handson
. cluster_up

( Open the URL in your browser and login as developer/developer )

./wrapper dev.sh
./wrapper prod.sh
./wrapper cicd.sh
