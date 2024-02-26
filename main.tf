data "aws_ami" "amazon-linux-2" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "kubeadm"
  cidr = "10.0.0.0/24"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.0.0/28", "10.0.0.16/28"]
  private_subnets = ["10.0.0.32/28", "10.0.0.48/28"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "sg_bastion" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "bastion"
  description         = "bastion"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]

}


module "ec2_bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "bastion"
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = "t2.micro"
  key_name                    = "kubeadm"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_bastion.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  depends_on = [
    module.vpc
  ]

}


module "sg_cluster" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "cluster_kubeadm"
  description         = "cluster kubeadm"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["10.0.0.0/24"]
  ingress_rules       = ["all-icmp", "all-tcp"]

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]

}


module "ec2_kubemaster" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "kubemaster"

  instance_type               = "t2.micro"
  ami                         = data.aws_ami.amazon-linux-2.id
  key_name                    = "kubeadm"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_cluster.security_group_id]
  subnet_id                   = module.vpc.private_subnets[0]
  private_ip                  = "10.0.0.37"
  user_data                   = templatefile("${path.module}/configurations_master_hostname.tftpl", { kubemaster_ip = "10.0.0.37", node_01_ip = "10.0.0.55" })
  user_data_replace_on_change = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  depends_on = [
    module.vpc
  ]

}

module "ec2_node" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "node01"

  instance_type               = "t2.micro"
  ami                         = data.aws_ami.amazon-linux-2.id
  key_name                    = "kubeadm"
  monitoring                  = false
  vpc_security_group_ids      = [module.sg_cluster.security_group_id]
  subnet_id                   = module.vpc.private_subnets[1]
  private_ip                  = "10.0.0.55"
  user_data                   = templatefile("${path.module}/configurations_node_hostname.tftpl", { kubemaster_ip = "10.0.0.37", node_01_ip = "10.0.0.55" })
  user_data_replace_on_change = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  depends_on = [
    module.vpc
  ]
}
