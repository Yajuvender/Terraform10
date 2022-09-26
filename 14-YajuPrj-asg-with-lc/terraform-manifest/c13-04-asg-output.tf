# Launch configuration Outputs
output "launch_configuration_id" {
  description = "The ID of the launch configuration"
  value       = module.autoscaling.launch_template_id
}

