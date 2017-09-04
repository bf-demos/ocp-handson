resource "aws_instance" "ocp" {
  count                  = "${var.instancecount}"
  ami                    = "ami-061b1560"
  instance_type          = "m4.xlarge"
  subnet_id              = "${element(module.vpc.public_subnets ,0)}"
  key_name               = "ocp-handson"
  vpc_security_group_ids = ["${aws_security_group.ocp_inbound.id}", "${aws_security_group.ocp_outbound.id}"]
  user_data              = "${data.template_cloudinit_config.config.rendered}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }

  tags {
    "CostCenter" = "${var.costcenter}"
    "Name"       = "${var.environment}_ocp_${count.index}"
  }
}

resource "aws_eip" "ocp" {
  count = "${var.instancecount}"
  vpc   = true
}

resource "aws_eip_association" "ocp" {
  count         = "${var.instancecount}"
  instance_id   = "${element(aws_instance.ocp.*.id, count.index)}"
  allocation_id = "${element(aws_eip.ocp.*.id, count.index)}"
}

resource "aws_key_pair" "ocp-handson" {
  key_name   = "ocp-handson"
  public_key = "${file("../ssh/ocp-handson.pub")}"
}

resource "aws_security_group" "ocp_inbound" {
  name        = "ocp_inbound"
  description = "Allow inbound SSH/HTTP/HTTPS to OCP instances"
  vpc_id      = "${module.vpc.vpc_id}"

  tags {
    CostCenter = "${var.costcenter}"
    Name       = "${var.environment}_ocp_inbound"
  }
}

resource "aws_security_group_rule" "ocp_inbound_01" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.access}"]
  security_group_id = "${aws_security_group.ocp_inbound.id}"
}

resource "aws_security_group_rule" "ocp_inbound_02" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["${var.access}"]
  security_group_id = "${aws_security_group.ocp_inbound.id}"
}

resource "aws_security_group_rule" "ocp_inbound_03" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["${var.access}"]
  security_group_id = "${aws_security_group.ocp_inbound.id}"
}

resource "aws_security_group_rule" "ocp_inbound_04" {
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = ["${var.access}"]
  security_group_id = "${aws_security_group.ocp_inbound.id}"
}

resource "aws_security_group_rule" "ocp_inbound_05" {
  type                     = "ingress"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.ocp_inbound.id}"
  security_group_id        = "${aws_security_group.ocp_inbound.id}"
}

resource "aws_security_group" "ocp_outbound" {
  name        = "ocp_outbound"
  description = "Allow egress from OCP instances"
  vpc_id      = "${module.vpc.vpc_id}"

  tags {
    CostCenter = "${var.costcenter}"
    Name       = "${var.environment}_ocp_outbound"
  }
}

resource "aws_security_group_rule" "ocp_outbound_01" {
  type              = "egress"
  from_port         = 1
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ocp_outbound.id}"
}

output "ocp_public_ips" {
  value = ["${aws_eip.ocp.*.public_ip}"]
}
