module "vpc" {
  source             = "git@github.com:basefarm/bf_aws_mod_vpc"
  name               = "${var.environment}"
  cidr               = "10.0.0.0/16"
  azs                = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  create_nat_gateway = "false"
  create_vgw         = "true"
  create_vpc_s3_endpoint = "true"
  tags {
    "CostCenter"     = "${var.costcenter}"
    "Environment"    = "${var.environment}"
    }
}

