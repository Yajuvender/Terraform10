output "security_group_id" {
  description = "The ID of the security group"
  value       = module.bastion-sg.security_group_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = module.bastion-sg.security_group_name
}

 