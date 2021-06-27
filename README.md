# app_grafana
Grafana deployment configuration leveraging a basic HA architecture (not application) strategy.  Go ahead -- delete a running EC2 and watch it spin up a new one!

## What is...
For simplicity, the default `app_env` value, if you use the deploy script below, is `dev` by default.  Any variables you set which require the `app_env` variable should use `dev` for this component.

## What you need to provide
With this configuration, you only need to provide a handful of variables (located in `variables.tf`) in order to deploy Grafana to an ELB:
|variable name  |desciption|
|---------------|----------|
|ami_id         |dev.<aws_region> = "<AMI_ID>"|
|app_subnets    |dev.<aws_region> = "<SUBNET_ID>"|
|owner_contact  |"your@email_address"|
|vpc_id         |dev.<aws_region> = "<VPC_ID>"|


## How to deploy
First, you must set your AWS environment; secrets/keys should NEVER (ever ever) be saved to repos or passed through anything that will store them (like `history` in terminal).

### Setting AWS access
If you have OAuth/MFA for AWS, you can skip all this -- the end-goal is to have credentials located at `~/.aws/credentials`.  If you're using access keys, make sure you have those available and:
1. In your terminal, enter `aws configure` (this assumes you have the AWS CLI installed)
2. Enter the information requested
3. Validate that you now have data in the `~/.aws/credentials` file (unless you specify a value, the name of this profile will be `default`)
4. Type `export AWS_PROFILE=default` if you didn't provide a profile name; use the name provided if you did
5. Any command you run that invokes AWS, from this point forward, will leverage these credentials under-the-covers

### Checking your Terraform
You need to install, and have available to your environment, Terraform (Google if you don't).  It's been about three years since I've done anything with Terraform and a lot's changed!  This code was written and validated in v1.0.1.  If you're on a v1.x release, you *should* be set to run the below to deploy, once you've made the `variables.tf` changes required above.  All steps are from the `app_grafana` directory:
1. `terraform init` - this will get Terraform going and it'll pull things together to make sure everything is set for next steps
2. `terraform apply --var app_env=dev --var aws_region=<enter your region> --var deployment_owner=<enter your email>` - this will actually deploy the application and the architecture in conjunction.  You will be prompted to *actually* deploy once all components are validated
3. `terraform destroy --var app_env=dev --var aws_region=<enter your region> --var deployment_owner=<enter your email>` - this will delete everything you've deployed; paying for stuff you're not using isn't fun!

### But I don't have Terraform 1.x
I didn't either; I got an emergency replacement laptop last week but my old one (sniff, sniff) had v0.11 and I was not able to run almost anything using the old syntax and format against the latest.  So I give you the Docker solution (also run from the `app_grafana` directory):
1. `docker run -it -v $(pwd):/workspace -w /workspace hashicorp/terraform:light init`
2. `docker run -it -v $HOME/.aws/credentials:/root/.aws/credentials:ro -v $(pwd):/workspace -w /workspace hashicorp/terraform:light apply --var app_env=dev --var aws_region=<enter your region> --var deployment_owner=<enter your email>`
Remember to `destroy` (run step 2 `s/apply/destroy/` when you're done AND delete any images)

## ...and what should be
If this was a completely HA strategy, the the minimum design would be:
- multiple Grafana instances running in each region (use containers/Fargate and never have to manage EC2s)
- RDS backend (replicated to another region) to ensure data retention and centralization amongst numerous running instances
- Route53 entrypoint with failover to alternate region (active/passive) or if you are more geographically diverse, active/active with geolocation routing
