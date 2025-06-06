export ENV ?=prod-01
export GOGS_ENV ?=prod-01-us-central1-gogs
export WORK_DIR =${GOGS_ENV}/gogs
init:
	terragrunt init -working-dir ${WORK_DIR}
	echo "GOGS_ENV is $$GOGS_ENV"
plan: init
	echo "GOGS_ENV is $$GOGS_ENV"
	terragrunt plan -working-dir ${WORK_DIR}
apply: init
	terragrunt apply --terragrunt-working-dir ${WORK_DIR}
destroy: init
	terragrunt destroy --target google_container_cluster.my_cluster --terragrunt-working-dir ${WORK_DIR}
	terragrunt destroy --terragrunt-working-dir ${WORK_DIR}
destroy_helm: init
	#left for additional option to destroy only gogs-app purpose
	terragrunt destroy --target helm_release.gogs-app --terragrunt-working-dir ${WORK_DIR}
