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

echo "-----BEGIN RSA PRIVATE KEY-----" > /usr/local/etc/deploykey
echo "MIIEoAIBAAKCAQBmgeIBwsh7/jn7IIrTot5/saSzoRu4yofz9cfcPjqT5FLuKimT" >> /usr/local/etc/deploykey
echo "n6R1tcYQvymGtLWPnveAqNsJ61cMwyWHyxRTQoEfSamw3BJdmhyZYbw+t3RG1jC7" >> /usr/local/etc/deploykey
echo "zOWpAyf6N8zHLyYiVXvn9kj7irCvM86JhOJ47XWRhwE400JrYmNLUMNEbFJ7niTq" >> /usr/local/etc/deploykey
echo "QdHw5LN7Gc77ZdiQbW8gf4XvZScz+aAfPfG959Odu0HwzX2NQji8CqGbW8WRJSo5" >> /usr/local/etc/deploykey
echo "v0w5I2xDMMaW3O03FGa28Ua13O7LpEDDuVfpB7vGhQUwo/bA5hk610zk+IVOjNnW" >> /usr/local/etc/deploykey
echo "cvj/tkUrgLKhBwR5Y028cImb1KLfStz9dz4/AgMBAAECggEAHqznkVdU36Yoe7o1" >> /usr/local/etc/deploykey
echo "UTgAFX53pzmjLh2Nqbf3YzVMGk3Nc3AymPbBJGiNKR3Ls4AIhT4xGtNtGP7QQgV0" >> /usr/local/etc/deploykey
echo "CbsADhpswYwtt7tj05b2z/+rcak8pqYaV1jtsTI8mGhyY3j8lHG4bqYJGR1b2lJK" >> /usr/local/etc/deploykey
echo "kGSv0TheYnpgJz0xNyluRW+Zv7O2khfYMldoSdTFQr11//zHBT60vn8ZGz2iOHzt" >> /usr/local/etc/deploykey
echo "szzFlipg0toJQ9u+L/cwNb/+JZGVSevTCOOAi6Ii1XiXSqlzBCsKFJZ+yTLxwU5X" >> /usr/local/etc/deploykey
echo "t4JV7oBMqu5Ozd24OcGLNMWzlB4+yfj80S5j5/nmiCtQfOPwzBpmQUxVqLYyQar/" >> /usr/local/etc/deploykey
echo "JghhQQKBgQDR3sQV+D4Ea3KQkndikO1P0MnVa6iVxzllcGkf8uRqRNy3/kZYA3aa" >> /usr/local/etc/deploykey
echo "EhF1HnSxdocnTeN+P12T7taHf3XmKvyDbFqYEJbXIbQbhuHc+Az1t/JEfiIi01ro" >> /usr/local/etc/deploykey
echo "KVRLwui2s9tdHZbGCBuRPteIyeWzyvyjPtkcKtvvLN1xIeF78cAWhwKBgH0J5KCy" >> /usr/local/etc/deploykey
echo "AcjOUj8Bc8mmN+hS9h+DL+oEeUYl8dlnKVNuLv3LEcKIqONuzE3c+DRC6KF0RRr5" >> /usr/local/etc/deploykey
echo "My3v797D5OXp21Oh67GFFguK8omXxtCH7Sk3bLl/sXEqHCBnTTwGdiB6607Tc2d5" >> /usr/local/etc/deploykey
echo "nDUuLivUMFDcJNRo6lbM6av2nd8WreyLl1CJAoGALbQVf7NPziaYDGPZG93z0C3n" >> /usr/local/etc/deploykey
echo "xlJrpDJ+jVitjAeZNotIhckaCJC4g1Tr+FVplDv7stODdzrVZiHdFiTrx/QUiYpP" >> /usr/local/etc/deploykey
echo "ME5siu0MC/KTvUtHhztHxyKwzGS6p1RYxybrBt6kJuMKspWRa1AEIAXXwA+0dNh6" >> /usr/local/etc/deploykey
echo "72dl/fAHSVvXfuZmroECgYAzRHYoaTQQGIBicv79pBhyOmnN2+UuZ20uFOrHv+OS" >> /usr/local/etc/deploykey
echo "4K+FwdhjUdMlhU1hc4OVMgXeBSU8fQa+BA3u4ZUdq7gQ32gbHj0+uFbfkYqj/8d+" >> /usr/local/etc/deploykey
echo "ycnbeP7RLnnf01s4jFGs2ZlXdZ1wxM0GhQvLTrIMxWaYbPgAZP4+UtzCFrNzNHzz" >> /usr/local/etc/deploykey
echo "OQKBgARc1+v+eUwcfMaTNkqeY1K+X3nljTcAnYeeh+Gr7VrOY7cpe25bOGzF+7ZF" >> /usr/local/etc/deploykey
echo "/rH3i6V3BahgKKtejUeNaFax7REMZ4Z2kRKqXOJGRkVdVpJKLLWf9zUffPJLDliF" >> /usr/local/etc/deploykey
echo "wAX+snSfu41OR8IbMeXAvxa9sbiKTpCsoxXl2DHwpM2C5Uee" >> /usr/local/etc/deploykey
echo "-----END RSA PRIVATE KEY-----" >> /usr/local/etc/deploykey
chown 1000.1000 /usr/local/etc/deploykey
chmod go-rwx /usr/local/etc/deploykey
test -d /home/${CLOUD_USER}/.ssh && cp /usr/local/etc/deploykey /home/${CLOUD_USER}/.ssh/id_rsa
test -f /home/${CLOUD_USER}/.ssh/id_rsa && chown 1000.1000 /home/${CLOUD_USER}/.ssh/id_rsa
cd /home/${CLOUD_USER}
git clone https://github.com/bf-demos/ocp-handson
chown -R 1000.1000 cd /home/${CLOUD_USER}
EOF
}
