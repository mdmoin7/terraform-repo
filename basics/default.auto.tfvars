# terraform apply -var-file="default.tfvars" : input passed via tfvars file
# terraform apply -var-file="default.tfvars" -var-file="env/dev.tfvars" 
application_name = "demo1"
instance_enabled = false
instance_type    = "t2.micro"
region           = "us-east-1"
# by default reads *.auto.tfvars files or terraform.tfvars
