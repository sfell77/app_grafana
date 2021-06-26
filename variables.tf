var "app_name" {
    description = "Your app name is used to identify deployed components easier"
    default = "grafana"
}

variable "app_port" {
    description = "Port your application runs on"
    default = 3000
}

var "ami_id" {
    description = "The AMI ID you'll use for your EC2 (if you're using one).  We don't use 'latest' since that doesn't stay the same, and we potentially haven't validated that it works with our stack"
    default = {
        "dev.us-east-1"     = ""
    }
}

var "listeners" {
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

var "s3_bucket_name" {
    description = "We save statefiles to S3 so that they're in a centralized location that's not your laptop. Remember to create buckets PER REGION or you may not have access to your statefiles in the event of a regional outage"
    default = {
        "dev.us-east-1"     = ""
    }
}

var "subnets" {
    description = "Subnet(s) for the ELB to leverage"
    default = {
        "dev.us-east-1"     = ""
    }
}

var "tag_owner_contact" {
    description = "Email address/idnetifier of the TEAM responsible for this app"
    default = "sfellin@sfproductions.net"
}

var "user_data" {
    description = "What to run inside each EC2 during instantiation"
    default = "
        # Because I have no idea what your favorite distro is...
        if [ -n "$(command -v yum)" ]; then
        yum install docker -y
        elif [ -n "$(command -v apt-get)" ]; then
        apt-get install docker -y

        # Install Grafana via constainer (controlled version, of course)
        docker run -d -p 3000:3000 --name grafana grafana/grafana:6.5.0"
}


# Variables you'll pass at run time -- you can leave these blank unless they're region agnostic
var "aws_region" {
    description = "The AWS region you're deploying to.  For example, us-east-1"
}

var "deploy_env" {
    description = "Denotes dev/qa/prod regions (or whatever values you use); needed for map variables"
}

var "tag_deployment_owner" {
    description = "Email address/identifier of the PERSON deploying this app"
}
