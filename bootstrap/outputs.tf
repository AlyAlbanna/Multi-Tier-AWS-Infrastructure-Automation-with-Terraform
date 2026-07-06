output "state_bucket_name" {
  value = module.remote_backend.state_bucket_name
}

output "lock_table_name" {
  value = module.remote_backend.lock_table_name
}
