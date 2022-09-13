# EC2 Complete
output "ec2_complete_id" {
  description = "The ID of the instance"
  value       = module.bastion-ec2-instance.id
}
output "ec2_complete_public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = module.bastion-ec2-instance.public_dns
}

output "ec2_complete_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.bastion-ec2-instance.public_ip
}


# Private EC2 Instances for App1
## ec2_private_instance_ids 

output "app1-ec2_private_instance_ids" {
  description = "List of App1 IDs of instances"
  #value       = [module.ec2_private.id]
  value = [for ec2private in module.private-ec2-instance-app1 : ec2private.id]
}

## ec2_private_ip
output "app1-ec2_private_ip" {
  description = "List of App1 private IP addresses assigned to the instances"
  #value       = [module.ec2_private.private_ip]
  value = [for ec2private in module.private-ec2-instance-app1 : ec2private.private_ip]
}

# Private EC2 Instances for App2
## ec2_private_instance_ids 

output "app2-ec2_private_instance_ids" {
  description = "List of App2 IDs of instances"
  #value       = [module.ec2_private.id]
  value = [for ec2private in module.private-ec2-instance-app2 : ec2private.id]
}

## ec2_private_ip
output "app2-ec2_private_ip" {
  description = "List of App2 private IP addresses assigned to the instances"
  #value       = [module.ec2_private.private_ip]
  value = [for ec2private in module.private-ec2-instance-app2 : ec2private.private_ip]
}