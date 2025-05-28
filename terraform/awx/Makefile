AWX_ENV?=stage-01-us-centarl1-awx

init:
	terraform init -no-color
	terraform workspace select -or-create ${AWX_ENV}
plan: init
	terraform plan -var-file=../tf_state/workspace_vars/$(AWX_ENV).json -no-color
apply: init
	terraform apply -auto-approve -no-color -var-file=../tf_state/workspace_vars/$(AWX_ENV).json
destroy: init
	terraform destroy -var-file=../tf_state/workspace_vars/$(AWX_ENV).json -auto-approve -no-color