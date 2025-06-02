ENV?=prod-01
GOGS_ENV?=prod-01-europe-west4-gogs
WORK_DIR=${GOGS_ENV}/gogs 
init:
	terragrunt init -working-dir ${WORK_DIR}
plan: init
	terragrunt plan -working-dir ${WORK_DIR}
apply: init
	terragrunt apply --terragrunt-working-dir ${WORK_DIR}
destroy: init
	terragrunt destroy --target google_container_cluster.my_cluster --terragrunt-working-dir ${WORK_DIR}
	terragrunt destroy --terragrunt-working-dir ${WORK_DIR}
destroy_helm: init
	#left for additional option to destroy only gogs-app purpose
	terragrunt destroy --target helm_release.gogs-app --terragrunt-working-dir ${WORK_DIR}
