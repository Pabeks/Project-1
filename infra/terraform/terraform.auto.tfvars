region = "us-east-1"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

# enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

environment = "dev"

ami-web = "ami-05614b8f595b9aa9f"

ami-bastion = "ami-000e18f7398e298c2"

ami-nginx = "ami-096f4dfdf88a77832"

ami-sonar = "ami-061249cf6c7714618"

keypair = "packer"

master-password = "Sa4la2xa###"

master-username = "paje"

account_no = "654654210154"

tags = {
  Owner-Email     = "pabeks11@gmail.com"
  Managed-By      = "Terraform"
  Billing-Account = "654654210154"
}
