terraform {
    required_providers {
        aws = "~> 3.37"
    }
}

provider "aws" {
    region = var.aws_region
}

module "arch_ec2_asg_elb" {
    source                  = "git::https://github.com/sfell77/arch_ec2_asg_elb"
    ami_id                  = lookup(var.ami_id, format("%s.%s", var.app_env, var.aws_region))
    app_env                 = var.app_env
    app_name                = var.app_name
    app_port                = var.app_port
    aws_region              = var.aws_region
    deployment_owner        = var.deployment_owner
    hc_target               = var.hc_target
    listener_port           = var.listener_port
    listener_protocol       = var.listener_protocol
    owner_contact           = var.owner_contact
    s3_bucket_name          = lookup(var.s3_bucket_name, format("%s.%s", var.app_env, var.aws_region))
    subnets                 = lookup(var.app_subnets, format("%s.%s", var.app_env, var.aws_region))
    user_data               = "${file("configs/user_data.sh")}"
    vpc_id                  = lookup(var.vpc_id, format("%s.%s", var.app_env, var.aws_region))
}

# I tend to use variables for EVERYTHING instead of just the things that can't be static-defined (app_name, for example, will always be "Grafana" for Grafana) because this puts ALL the variables into one location (variables.tf) instead of having to bounce around between main and variables.
