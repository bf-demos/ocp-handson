data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Setup hello world script to be called by the cloud-config
  part {
    filename     = "ocp-handson"
    content_type = "text/cloud-config"
    content      = "${file("../ssh/ocp-handson")}"
  }
	part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.ocp_cloud_config.rendered}"
  }
}

data "template_file" "ocp_cloud_config" {
  template = <<EOF
#!/bin/bash
yum -y update
if grep -q CentOS /etc/redhat-release ; then
  yum -y install epel-release
  yum -y install wget jq docker git
	export CLOUD_USER="centos"
else
  yum -y  --enablerepo=* install wget jq docker git
	export CLOUD_USER="ec2-user"
fi
wget -qNP /tmp https://github.com$(curl -sL https://github.com/openshift/origin/releases/latest | grep openshift-origin-server | grep href | cut -d '<' -f 2- | cut -d '"' -f 2)
cd /opt
tar -zxf /tmp/openshift-origin-server-*-linux-64bit.tar.gz
ln -sf $(ls /opt/openshift-origin-server*/oc) /usr/local/bin/
ln -sf $(ls /opt/openshift-origin-server*/oc) /usr/local/sbin/
echo "INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'" >> /etc/sysconfig/docker
systemctl enable docker.service
systemctl start docker
echo "/usr/local/bin/oc cluster up --use-existing-config=true --host-data-dir=/var/lib/origin/openshift.local.data --public-hostname=\"\$(curl  -s http://169.254.169.254/latest/meta-data/public-hostname)\" --routing-suffix=\"\$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4).nip.io\"" > /usr/local/bin/cluster_up.sh
echo "/usr/local/bin/oc cluster down" > /usr/local/bin/cluster_down.sh
chmod u+x /usr/local/bin/cluster_*.sh

if grep -q CentOS /etc/redhat-release ; then
  cd /home/centos
  git clone https://github.com/bf-demos/ocp-handson
  chown -R 1000.1000 /home/centos
else
  test -d /home/ec2-user/.ssh && cp /usr/local/etc/deploykey /home/ec2-user/.ssh/id_rsa
  test -f /home/ec2-user/.ssh/id_rsa && chown 1000.1000 /home/ec2-user/.ssh/id_rsa
  cd /home/ec2-user
  git clone https://github.com/bf-demos/ocp-handson
  chown -R 1000.1000 /home/ec2-user
fi
EOF
}
