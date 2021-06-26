provider = "aws" {
    version = "~> 3.37"
}

module "arch_ec2_asg_elb" {
    source                  = "git::https://github.com/sfell77/arch_ec2_asg_elb"
    app_name                = var.app_name
    app_port                = var.app_port
    aws_region              = var.aws_region
    ami_id                  = lookup(var.ami_id, format("%s.%s", var.app_env, var.aws_region))
    deploy_env              = var.deploy_env
    asg_max_size            = var.asg_max_size
    asg_min_size            = var.asg_min_size
    asg_desired_size        = var.asg_desired_size
    instance_type           = var.instance_type
    volume_type             = var.ebs_volume_type
    volume_size             = var.ebs_volume_size
    s3_bucket_name          = lookup(var.s3_bucket_name, format("%s.%s", var.app_env, var.aws_region))
    subnets                 = lookup(var.subnets, format("%s.%s", var.app_env, var.aws_region))
    tag_owner_contact       = var.tag_owner_contact
    tag_deployment_owner    = var.tag_deployment_owner
    user_data               = var.user_data
}

# I use variables for EVERYTHING instead of just the things that can't be static-defined (app_port, for example, will always be 3000 for Grafana) because this puts ALL the variables into one location (variables.tf) instead of having to bounce around between main and variables.
