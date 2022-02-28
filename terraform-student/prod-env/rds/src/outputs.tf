output "db-id" {

  value = module.db.cluster_instances
  depends_on = [
    module.db
  ]
}

output "db-strapi-id" {

  value = module.strapi-database.cluster_instances
  depends_on = [
    module.strapi-database
  ]
}


output "snap-db" {
  value = data.aws_db_cluster_snapshot.latest_db_snapshot.id
}

output "snap-starpi" {
  value = data.aws_db_cluster_snapshot.latest_strapi_snapshot.id
}

