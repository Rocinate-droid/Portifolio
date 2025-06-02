#!/bin/bash
terraform init
terraform apply --auto-approve
terraform output > ../updated-ids.txt
old_subnet_id=$(grep "subnet-id" ../terraform.tfvars)
old_security_group_id=$(grep "security-group-id" ../terraform.tfvars)
new_subnet_id=$(grep "subnet-id" ../updated-ids.txt)
new_security_group_id=$(grep "security-group-id" ../updated-ids.txt)
sed -i "s|$old_subnet_id|$new_subnet_id|" ../terraform.tfvars
sed -i "s|$old_security_group_id|$new_security_group_id|" ../terraform.tfvars
rm ../updated-ids.txt
