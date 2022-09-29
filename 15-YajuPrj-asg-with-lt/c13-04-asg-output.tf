//LT outputs

# launch template id
output "launch_template_id" {
  value = aws_launch_template.myasg_launch_template.id
}
# launch template latest version
output "launch_template_version" {
  value = aws_launch_template.myasg_launch_template.latest_version
}
// ASG Outputs

# asg group ID
output "asg_group_id" {
  value = aws_autoscaling_group.myasg.id
}
# asg group name
output "asg_group_name" {
  value = aws_autoscaling_group.myasg.name
}
# asg group arn
output "asg_group_arn" {
  value = aws_autoscaling_group.myasg.arn
}
