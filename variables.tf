/*
These variables will need to be adjusted for any architecture blueprints you plan on using; some sections will be used regardless of design where others will need to be added/removed based on what's being built.  If a variable is defined but not used, you can either delete it or ignore it.
*/

# Tell us about your app
var "app_name" {
    description = "Your app name is used to identify deployed components easier"
    default = "grafana"
}

var "tag_owner_contact" {
    description = "Email address/idnetifier of the TEAM responsible for this app"
    default = "sfellin@sfproductions.net"
}

var "asg_max_size" {
    default = 1
}

var "asg_min_size" {
    default = 1
}

var "asg_desired_size" {
    default = 1
}

var "instance_type" {
    default = ""
}

var "ebs_volume_type" {
    default = "gp2"
}

var "ebs_volume_size" {
    default = 20
}

var "s3_bucket_name" {
    description = "We save statefiles to S3 so that they're in a centralized location that's not your laptop. Remember to create buckets PER REGION or you may not have access to your statefiles in the event of a regional outage"
    default = {
        "dev.us-east-1"     = ""
        "qa.us-east-1"      = ""
        "dev.us-west-2"     = ""
        "qa.us-west-2"      = ""
    }


# Variables you'll pass at run time -- you can leave these blank unless they're region agnostic
var "ami_id" {
    description = "The AMI ID you'll use for your EC2 (if you're using one).  We don't use 'latest' since that doesn't stay the same, and we potentially haven't validated that it works with our stack"
}

var "aws_region" {
    description = "The AWS region you're deploying to.  For example, us-east-1"
}

var "deploy_env" {
    description = "Denotes dev/qa/prod regions (or whatever values you use); needed for map variables"
}

var "tag_deployment_owner" {
    description = "Email address/identifier of the PERSON deploying this app"
}
