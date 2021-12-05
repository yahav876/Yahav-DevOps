output "db-prod-id" {

  value = module.db-prod.db_instance_id
  depends_on = [
    module.db-prod
  ]
  
}

output "db-stage-id" {

  value = module.db-stage.db_instance_id
  depends_on = [
    module.db-stage
  ]
  
}

output "db-strapi-id" {

  value = module.strapi-database.db_instance_id
  depends_on = [
    module.strapi-database
  ]
  
}

output "db-strapi-prod-id" {

  value = module.strapi-database-prod.db_instance_id
  depends_on = [
    module.strapi-database-prod
  ]
}