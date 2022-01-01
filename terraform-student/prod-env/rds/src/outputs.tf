# output "db-prod-id" {

#   value = module.db-prod.db_instance_id
#   depends_on = [
#     module.db-prod
#   ]
  
# }

output "db-id" {

  value = module.db.db_instance_id
  depends_on = [
    module.db
  ]
}

output "db-strapi-id" {

  value = module.strapi.db_instance_id
  depends_on = [
    module.strapi
  ]
  
}

# output "db-strapi-prod-id" {

#   value = module.strapi-prod.db_instance_id
#   depends_on = [
#     module.strapi-prod
#   ]
# }

# output "strapi_snap" {
#   value = data.aws_db_snapshot.strapi
# }

