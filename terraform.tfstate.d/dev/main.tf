provider "aws" {
  region = "us-east-1"
}


module "proxy_instances" {
  source            = "../modules/ec2"
  instance_type     = "proxy"
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_ids = [module.security_groups.proxy_sg_id]
  key_name          = "my-ec2-key"
  private_key_path  = "../my-ec2-key.pem"
}

module "backend_instances" {
  source            = "../modules/ec2"
  instance_type     = "backend"
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_ids = [module.security_groups.backend_sg_id]
  key_name          = "my-ec2-key"
  private_key_path  = "../my-ec2-key.pem"
}


resource "aws_security_group" "allow_ssh_http" {
  vpc_id = module.vpc.vpc_id  

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  tags = {
    Name = "allow-ssh-http"
  }
}

module "vpc" {
  source = "../modules/vpc"
}

module "security_groups" {
  source = "../modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "load_balancers" {
  source             = "../modules/load_balancers"
  alb_sg_id          = module.security_groups.alb_sg_id
  internal_alb_sg_id = module.security_groups.internal_alb_sg_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}


module "target_groups" {
  source           = "../modules/target_groups"
  vpc_id           = module.vpc.vpc_id
  public_alb_arn   = module.load_balancers.public_alb_arn
  internal_alb_arn = module.load_balancers.internal_alb_arn
}

