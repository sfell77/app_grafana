terraform {
  required_providers {
    aws = "~> 3.37"
  }
}

module "arch_ec2_asg_elb" {
    source                  = "git::https://github.com/sfell77/arch_ec2_asg_elb"
    ami_id                  = lookup(var.ami_id, format("%s.%s", var.app_env, var.aws_region))
    app_env                 = var.app_env
    app_name                = var.app_name
    app_port                = var.app_port
    aws_region              = var.aws_region
    hc_target               = var.hc_target
    s3_bucket_name          = lookup(var.s3_bucket_name, format("%s.%s", var.app_env, var.aws_region))
    subnets                 = lookup(var.app_subnets, format("%s.%s", var.app_env, var.aws_region))
    tag_deployment_owner    = var.tag_deployment_owner
    tag_owner_contact       = var.tag_owner_contact
    user_data               = "${file("config/user_data.sh")}"
}

# I tend to use variables for EVERYTHING instead of just the things that can't be static-defined (app_name, for example, will always be "Grafana" for Grafana) because this puts ALL the variables into one location (variables.tf) instead of having to bounce around between main and variables.
