# app_grafana
Grafana deployment configuration leveraging a basic HA architecture (not application) strategy.  Go ahead -- delete a running EC2 and watch it spin up a new one!

The design here is based off my experience working with 26 teams deploying 100+ APIs, most of which were public-facing.  This model enabled us, the platform team, to design, manage, and update architecture without substantial impacts or creating work for the application teams, while enforcing structure and standards (like encrypting all those EBS volumes) which is critical at-scale.

Because we work for a bank (and also because I don't think they were available yet when we started), we created our own modules to ensure granular control over all our architecture.

This is actually my first ELB deployment (ALB was our norm); wouldn't recommend it.

## What is...
- For simplicity, the default `app_env` value, if you use the deploy scripts below, is `dev` by default.  Any variables you set which require the `app_env` variable (such as `variable "AMI"`) should use `dev` for this component.
- My resources have a Rick and Morty theme going.  Season 5 just came out and I like to remind people that instances are cattle (not pets) and that they are 100% disposable (and should be).

## What you need to provide
With this configuration, you only need to provide a handful of variables (located in `variables.tf`) in order to deploy Grafana to an ELB:
|variable name  |desciption|
|---------------|----------|
|ami_id         |dev.<aws_region> = "<AMI_ID>"|
|app_subnets    |dev.<aws_region> = "<SUBNET_ID>"|
|owner_contact  |"your@email_address"|
|vpc_id         |dev.<aws_region> = "<VPC_ID>"|

In addition to these variables, the `configs/user_data.sh` file may need to be updated to accommodate your distro of choice; it comes with RPM and Ubuntu/Debian-based install steps but with other distros (or when yum/apt are retired) you'll need to provide what works for your use-case.

## How to deploy
First, you must set your AWS environment; secrets/keys should NEVER (ever ever) be saved to repos or passed through anything that will store them (like `history` in terminal).

### Setting AWS access
If you have OAuth/MFA for AWS, you can skip all this -- the end-goal is to have credentials located at `~/.aws/credentials`.  If you're using access keys, make sure you have those available and:
1. In your terminal, enter `aws configure` (this assumes you have the AWS CLI installed)
2. Enter the information requested
3. Validate that you now have data in the `~/.aws/credentials` file (unless you specify a value, the name of this profile will be `default`)
4. Type `export AWS_PROFILE=default` if you didn't provide a profile name; use the name provided if you did
5. Any command you run that invokes AWS, from this point forward, will leverage these credentials under-the-covers

### Get the code
Maybe you found this repo in the wild and don't know this part?
1. Clone this repo to your local environment (`git clone https://github.com/sfell77/app_grafana`)
2. `cd app_grafana`

### Checking your Terraform
You need to install, and have available to your environment, Terraform (Google if you don't).  It's been about three years since I've done anything with Terraform and a lot's changed!  This code was written and validated in v1.0.1.  If you're on a v1.x release, you *should* be set to run the below to deploy, once you've made the `variables.tf` changes required above.  All steps are from the `app_grafana` directory:
1. `terraform init` - this will get Terraform going and it'll pull things together to make sure everything is set for next steps
2. `terraform apply --var app_env=dev --var aws_region=<enter your region> --var deployment_owner=<enter your email>` - this will deploy the application and the architecture in conjunction.  You will be prompted to *actually* deploy once all components are validated
3. `terraform destroy --var app_env=dev --var aws_region=<enter your region> --var deployment_owner=<enter your email>` - this will delete everything you've deployed; paying for stuff you're not using isn't fun!

### But I don't have Terraform 1.x
I didn't either; I got an emergency replacement laptop last week but my old one (sniff, sniff) had v0.11 and I was not able to run almost anything using the old syntax and format against the latest.  So I give you the Docker solution (also run from the `app_grafana` directory):
1. `docker run -it -v $(pwd):/workspace -w /workspace hashicorp/terraform:light init`
2. `docker run -it -v $HOME/.aws/credentials:/root/.aws/credentials:ro -v $(pwd):/workspace -w /workspace hashicorp/terraform:light apply --var app_env=dev --var aws_region=<enter your region> --var deployment_owner=<enter your email>`

Remember to `destroy` (run step 2 `s/apply/destroy/` when you're done AND delete any images)

### Cool -- how do I see my stuff?
I didn't add a Route53 endpoint -- I've gone a lot farther down the rabbit hole than I think you were anticipating and omitted a bunch of stuff because for a test app, it's just over-kill.  You'll have to track down the ELB you generated in AWS console, copy/paste the DNS entry into a browser, and throw `:3000` at the end of it.

Grafana says that the default credentials are `[admin:admin]` and those worked for me.

## ...and what should be
If this was a completely HA strategy, the the minimum design would be:
- Split `app_port` variable into two; set inbound ELB port to 80 -- I'm sorry; it didn't make it off the to-do list
- Multiple Grafana instances running in each region (use containers/Fargate and never have to manage EC2s)
- RDS backend (replicated to another region) to ensure data retention and centralization amongst numerous running instances
- Route53 entrypoint with failover to alternate region (active/passive) or if you are more geographically diverse, active/active with geolocation routing
- Alerts all over the place for ELB, EC2s, and Route53 health checks hooked to SNS topics
- ELB log collection and S3 backend since `statefiles` shouldn't be stored locally unless you want to have a *really* bad time later
