// This is ASG Resource

resource "aws_autoscaling_group" "myasg" {
  name             = "myasg"
  max_size         = 10
  min_size         = 2
  desired_capacity = 2
  # health_check_grace_period = 300
  health_check_type = "EC2"

  // wList of subnet IDs to launch resources in. Subnets automatically determine 
  // which availability zones the group will reside.
  vpc_zone_identifier = module.vpc.private_subnets
  //Set of aws_alb_target_group ARNs, for use with Application or Network Load Balancing
  target_group_arns = module.alb.target_group_arns

  launch_template {
    id      = aws_launch_template.myasg_launch_template.id
    version = aws_launch_template.myasg_launch_template.latest_version
  }

  // Instance Refresh

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["desired_capacity"] // you can add any argument from ASG and if those changes then instance will refresh
  }


  tag {
    key                 = "myasg-tag"
    value               = "myasg-value"
    propagate_at_launch = true
  }

}