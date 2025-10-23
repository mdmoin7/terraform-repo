Infrastructure as a service

X -> A, B, C

documentation

single
multiple

Terraform : platform agnostic
Infrastructure as a code

1. provisioning infrastructure
2. multi cloud deployments
3. infrastructure lifecycle management
   - create, update, destroy : micro=>small
4. reusable infrastructure modules : dev:1 micro, prod:5 small, staging: 1 small
5. integrates with ci/cd pipelines
6. security & compliance

Key concepts

1. Idempotence
   the end result shall remain the same regardless of how many times we perform it

2. immutability
   versioning : capturing snapshot of the current state, such that when we are introducing a new feature & if anything goes wrong we can rollback to the previous state

3. cohesion
   it measures how well the parts of a module work together towards one specific purpose

file handler : create, write, delete

utility : read from file, triggers an email

4. declarative v/s imperative
   terraform is declarative

Terraform key concepts
Provider : plugins that interact with a cloud or a service

Resource : fundamental building block : represents a single piece of infrastructure that terraform manages

Variables : input parameters

State file : keeps track of real world infrastructure & your config

Output : values you want terraform to print or share after deployment

Modules : reusable group of resources

Idemptonce : running the same terraform code multiple times gives the same result,
it only changes what's different

Terraform workflowx
write => initialize => plan => apply => destroy

terraform init : initializes the working directory and download the provider plugins
terraform plan : shows what terraform will do before applying the changes
terraform apply : build or update the infrastructure
terraform destroy : removes all infrastructure being managed by terraform

project

- main.tf : core infrastructure
- variables.tf : input variables
- outputs.tf : output variables
- terraform.tfvars/\*.auto.tfvars : actual variable values
- provider.tf : provider configuration

modules : reusability

project : root

- main.tf
- outputs.tf
  modules
  random_string - main.tf - variables.tf - outputs.tf

Module

- parameterize everything : avoid hardcoding values - use variables
- expose only needed outputs
- use defaults wisely : provide default values for optional inputs
- version control : put custom modules in git for reusability
- document

az --version
az login

terraform workspace list
terraform workspace new dev
terraform workspace new prod
terraform workspace new stage

terraform workspace select dev
terraform apply

terraform workspace select prod
terraform apply -var-file="./env/prod.tfvars"

terraform workspace select stage
terraform destroy

az provider register --namespace Microsoft.Storage
terraform init -reconfigure
terraform plan

---

terraform workspace new dev

terraform init -backend-config="resource_group_name=tfstate-rg" -backend-config="storage_account_name=tfstatebackend0010" -backend-config="container_name=tfstate" -backend-config="key=${TF_WORKSPACE}.tfstate"

## terraform apply

---

terraform workspace new prod

terraform init -backend-config="resource_group_name=tfstate-rg" -backend-config="storage_account_name=tfstatebackend0010" -backend-config="container_name=tfstate" -backend-config="key=${TF_WORKSPACE}.tfstate"

## terraform apply

ssh-keygen -t rsa -b 4096 -C "crimsonmoin@hotmail.com" -f ~/.ssh/id_rsa_azure
