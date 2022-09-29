

# EC2 Complete
output "ec2_complete_id" {
  description = "The ID of the instance"
  value       = module.bastion-ec2.id
}
output "ec2_complete_public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = module.bastion-ec2.public_dns
}

output "ec2_complete_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.bastion-ec2.public_ip
}


# # EC2 Complete
# output "ec2_complete_id-app1" {
#   description = "The ID of the instance"
#   value       = module.private-ec2-app1[0].id
# }
# output "ec2_complete_private_dns-app1" {
#   description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
#   value       = module.private-ec2-app1[0].private_dns
# }


 