terraform {
  required_providers {
    aws = "~> 3.37"
  }
}

module "arch_ec2_asg_elb" {
    source                  = "git::https://github.com/sfell77/arch_ec2_asg_elb"
    ami_id                  = lookup(var.ami_id, format("%s.%s", var.app_env, var.aws_region))
    app_name                = var.app_name
    app_port                = var.app_port
    asg_desired_size        = var.asg_desired_size
    asg_max_size            = var.asg_max_size
    asg_min_size            = var.asg_min_size
    aws_region              = var.aws_region
    deploy_env              = var.deploy_env
    instance_type           = var.instance_type
    s3_bucket_name          = lookup(var.s3_bucket_name, format("%s.%s", var.app_env, var.aws_region))
    subnets                 = lookup(var.app_subnets, format("%s.%s", var.app_env, var.aws_region))
    tag_deployment_owner    = var.tag_deployment_owner
    tag_owner_contact       = var.tag_owner_contact
    volume_size             = var.ebs_volume_size
    volume_type             = var.ebs_volume_type
    user_data               = "${file("config/user_data.sh")}"
}

# I tend to use variables for EVERYTHING instead of just the things that can't be static-defined (app_name, for example, will always be "Grafana" for Grafana) because this puts ALL the variables into one location (variables.tf) instead of having to bounce around between main and variables.
