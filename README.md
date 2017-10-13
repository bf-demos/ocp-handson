# Hands-On with OpenShift

Figure out how to load the key from this repo into your SSH key agent. And get an IP address for a testserver. The list of IP's can be obtained with the `show_ips.sh` script in the `terraform` subfolder.

    ssh -i ssh/ocp-handson centos@<IP>  

    cd ocp-handson  
    ./cluster_up

Open the URL starting with "https://ec2-" in your browser and login as developer/developer

    ./wrapper dev.sh  

Step through the script, pressing ENTER to execute each line. Swap back and forth between the CLI and the GUI to see what happens in each step  

    ./wrapper prod.sh  

Notice how we don't re-build the container, but simply tag and deploy.

    ./wrapper cicd.sh  

Open Jenkins and login as developer/developer. Compare the pipeline in OpenShift (found under Builds, Pipelines) with the BlueOcean view in Jenkins.

## Fast version for the impatient

    cd ocp-handson ; ./cluster_up ; . dev.sh ; . prod.sh ; . cicd.sh
