module "networking" {
  source                 = "./networking"
  vpc_cidr_block         = var.vpc_cidr_block
  vpc_name               = var.vpc_name
  pub_subnet_cidr_blocks = var.pub_subnet_cidr_blocks
  availability_zones     = var.availability_zones
}

module "security_groups" {
  source = "./security-groups"
  vpc_id = module.networking.vpc_id
}

module "jenkins" {
  source                = "./jenkins"
  jenkins_subnet_id     = module.networking.public_subnet_id
  jenkins_instance_type = var.jenkins_instance_type
  ami                   = var.ami_id
  jenkins_sg_id         = module.security_groups.jenkins_ec2_sg
  key_name              = var.sshkey
}

module "tomcat" {
  source               = "./tomcat"
  ami                  = var.ami_id
  tomcat_instance_type = var.instance_type
  tomcat_subnet_id     = module.networking.public_subnet_id
  key_name             = var.sshkey
  tomcat_sg_id         = module.security_groups.tomcat_sg_id
}

module "nexus" {
  source              = "./nexus"
  ami                 = var.ami_id
  nexus_subnet_id     = module.networking.public_subnet_id
  nexus_instance_type = var.nexus_instance_type
  nexus_sg_id         = module.security_groups.nexus_sg_id
  key_name            = var.sshkey
}

module "maven" {
  source              = "./maven"
  maven_instance_type = var.jenkins_instance_type
  ami                 = var.ami_id
  maven_sg_id         = module.security_groups.maven_sg_id
  maven_subnet_id     = module.networking.public_subnet_id
  key_name            = var.sshkey
}


module "route53" {
  source             = "./route53"
  jenkins_ip_address = module.jenkins.jenkins_ip_address
  nexus_ip_address   = module.nexus.nexus_ip_address
  tomcat_ip_address  = module.tomcat.tomcat_ip_address
  maven_ip_address   = module.maven.maven_ip_address
  domain_name        = var.domain_name
}
