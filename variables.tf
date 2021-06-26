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
        "dev.us-east-1"     = "subnet-0ea9e47983f203578, subnet-021f28cc2574fc87e"
    }
}

variable "ami_id" {
    description = "The AMI ID you'll use for your EC2 (if you're using one).  We don't use 'latest' since that doesn't stay the same, and we potentially haven't validated that it works with our stack"
    default = {
        "dev.us-east-1"     = "ami-0aeeebd8d2ab47354"
    }
}

variable "hc_target" {
    description = "ELB health check -- target"
    default = "HTTP:3000/"
}

variable "listeners" {
    description = "Ingress port configurations for load balancer"
    default = [
        {
            instance_port     = 3000
            instance_protocol = "http"
            lb_port           = 3000
            lb_protocol       = "http"
        }
    ]
}

variable "s3_bucket_name" {
    description = "We save statefiles to S3 so that they're in a centralized location that's not your laptop. Remember to create buckets PER REGION or you may not have access to your statefiles in the event of a regional outage"
    default = {
        "dev.us-east-1"     = "cribl-test-jlq818"
    }
}

variable "owner_contact" {
    description = "Email address/idnetifier of the TEAM responsible for this app"
    default = "sfellin@sfproductions.net"
}

# Variables you'll pass at run time -- you can leave these blank unless they're region agnostic
variable "app_env" {
    description = "Denotes dev/qa/prod regions (or whatever values you use); needed for map variables"
}

variable "aws_region" {
    description = "The AWS region you're deploying to.  For example, us-east-1"
}

variable "deployment_owner" {
    description = "Email address/identifier of the PERSON deploying this app"
}
