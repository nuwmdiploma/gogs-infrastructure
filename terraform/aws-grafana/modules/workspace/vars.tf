data "aws_ssoadmin_instances" "current" {}
data "aws_identitystore_user" "selected_user" {
    identity_store_id = tolist(data.aws_ssoadmin_instances.current.identity_store_ids)[0]
    alternate_identifier {
      unique_attribute { 
       attribute_path  = "userName"
       attribute_value =  "grafana-admin"
      }
    }
}