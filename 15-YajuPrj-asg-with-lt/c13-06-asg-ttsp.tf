// TTSP - Target Tracking Scaling Policies
// i.e. when our auto scaling should scale out/in.. based on CPU utilization

// Policy 1 - Based on CPU Utilization of EC2 instance
resource "aws_autoscaling_policy" "asg-ttsp-avg-cpu-greated-than-50" {
  name                      = "asg-ttsp-avg-cpu-greated-than-50"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.myasg.id
  estimated_instance_warmup = 180

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }

}


// Policy 2 - Based on ALB Target requests


resource "aws_autoscaling_policy" "asg-ttsp-alb-target-request-greated-than-10" {
  name                      = "asg-ttsp-alb-target-request-greated-than-10"
  policy_type               = "TargetTrackingScaling" # Important Note: The policy type, either "SimpleScaling", "StepScaling" or "TargetTrackingScaling". If this value isn't provided, AWS will default to "SimpleScaling."    
  autoscaling_group_name    = aws_autoscaling_group.myasg.id
  estimated_instance_warmup = 120 # defaults to ASG default cooldown 300 seconds if not set  
  # Number of requests > 10 completed per target in an Application Load Balancer target group.
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${module.alb.lb_arn_suffix}/${module.alb.target_group_arn_suffixes[0]}"
    }
    target_value = 10.0
  }
}



