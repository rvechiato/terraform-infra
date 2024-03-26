# terraform-infra


terraform-infra % terraform plan -var="access_key=$AWS_ACCESS_KEY_ID" -var="secret_key=$AWS_SECRET_ACCESS_KEY"  -var-file=./environments/hom/stage.tfvars

terraform-infra % terraform apply -var="access_key=$AWS_ACCESS_KEY_ID" -var="secret_key=$AWS_SECRET_ACCESS_KEY"  -var-file=./environments/hom/stage.tfvars

terraform-infra % terraform destroy -var="access_key=$AWS_ACCESS_KEY_ID" -var="secret_key=$AWS_SECRET_ACCESS_KEY"  -var-file=./environments/hom/stage.tfvars