/*
Buildtime variables are @ the bottom; the only things I'm overriding or initially setting are below
*/
variable "ami_id" {
    description = "The AMI ID you'll use for your EC2 (if you're using one).  We don't use 'latest' since that doesn't stay the same, and we potentially haven't validated that it works with our stack"
    default = {
        #"dev.us-east-1"     = "ami-0747bdcabd34c712a" # Ubuntu16.04
        "dev.us-east-1"     = "ami-0aeeebd8d2ab47354" # AmazonLinux2
    }
}

variable "app_name" {
    description = "Your app name is used to identify deployed components easier"
    default = "grafana"
}

variable "app_port" {
    description = "Port your application runs on"
    default = 3000
}

variable "app_subnets" {
    description = "Subnet(s) for the ELB to leverage"
    default = {
        "dev.us-east-1"     = "subnet-01234567890123456"
    }
}

variable "hc_target" {
    description = "ELB health check -- target"
    default = "TCP:3000"
}

variable "listener_port" {
    default = 3000
}

variable "listener_protocol" {
    default = "http"
}

variable "owner_contact" {
    description = "Email address/idnetifier of the TEAM responsible for this app"
    default = "your@email.com"
}

variable "vpc_id" {
    description = "VPC your subnets and security groups are contained in"
    default = {
        "dev.us-east-1"     = "vpc-01234567890123456"
    }
}

# Variables you'll pass at buildtime
variable "app_env" {
    description = "Denotes dev/qa/prod regions (or whatever values you use); needed for map variables"
}

variable "aws_region" {
    description = "The AWS region you're deploying to.  For example, us-east-1"
}

variable "deployment_owner" {
    description = "Email address/identifier of the PERSON deploying this app"
}
