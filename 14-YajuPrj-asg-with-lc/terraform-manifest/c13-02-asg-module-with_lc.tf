module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.5.2"

  # Autoscaling group
  name            = "${local.name}-asg" //"complete-${local.name}"
  use_name_prefix = false
  instance_name   = "my-instance-name"

  ignore_desired_capacity_changes = true

  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets

  // This is an optional argument so we can either set it or comment it
  #   A service-linked role is a unique type of IAM role that is linked directly to an 
  #   AWS service. Service-linked roles are predefined by the service and include all the 
  #   permissions that the service requires to call other AWS services on your behalf. 
  service_linked_role_arn = aws_iam_service_linked_role.asgservicelinkrole.arn

  // Associate ASG with ALB
  target_group_arns = module.alb.target_group_arns

  // ASG Lifecycle hooks
  initial_lifecycle_hooks = [
    {
      name                 = "ExampleStartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 60
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                 = "ExampleTerminationLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 180
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  // ASG Instance Refresh
  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    // refresh the instances if there is any change to tags, desired_capacity, etc...
    triggers = ["tag", "desired_capacity"]
  }

  // ASG Launch Configuration

  launch_template_name        = "${local.name}-asg-lc"
  launch_template_description = "Complete launch Configuration example"
  update_default_version      = true

  image_id          = data.aws_ami.mylinuxami.id
  instance_type     = var.instance_type
  user_data         =  base64encode(file("${path.module}/app1-install.sh"))
  ebs_optimized     = true
  enable_monitoring = true

  #   create_iam_instance_profile = true
  #   iam_role_name               = "complete-${local.name}"
  #   iam_role_path               = "/ec2/"
  #   iam_role_description        = "Complete IAM role example"
  #   iam_role_tags = {
  #     CustomIamRole = "Yes"
  #   }
  #   iam_role_policies = {
  #     AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  #   }

  # # Security group is set on the ENIs below
  # security_groups          = [module.asg_sg.security_group_id]
  security_groups             = [module.private-sg.security_group_id]

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
      }
    }
  ]

  #   capacity_reservation_specification = {
  #     capacity_reservation_preference = "open"
  #   }

  #   cpu_options = {
  #     core_count       = 1
  #     threads_per_core = 1
  #   }

  #   credit_specification = {
  #     cpu_credits = "standard"
  #   }

  # enclave_options = {
  #   enabled = true # Cannot enable hibernation and nitro enclaves on same instance nor on T3 instance type
  # }

  # hibernation_options = {
  #   configured = true # Root volume must be encrypted & not spot to enable hibernation
  # }

  #   instance_market_options = {
  #     market_type = "spot"
  #   }

  #   license_specifications = {
  #     license_configuration_arn = aws_licensemanager_license_configuration.test.arn
  #   }

  #   maintenance_options = {
  #     auto_recovery = "default"
  #   }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "optional" // at production, we can make this as required.
    http_put_response_hop_limit = 32
    instance_metadata_tags      = "enabled"
  }

  #   network_interfaces = [
  #     {
  #       delete_on_termination = true
  #       description           = "eth0"
  #       device_index          = 0
  #       security_groups       = [module.asg_sg.security_group_id]
  #     },
  #     {
  #       delete_on_termination = true
  #       description           = "eth1"
  #       device_index          = 1
  #       security_groups       = [module.asg_sg.security_group_id]
  #     }
  #   ]

  #   placement = {
  #     availability_zone = "${local.region}b"
  #   }

  #   tag_specifications = [
  #     {
  #       resource_type = "instance"
  #       tags          = { WhatAmI = "Instance" }
  #     },
  #     {
  #       resource_type = "volume"
  #       tags          = merge({ WhatAmI = "Volume" })
  #     },
  #     {
  #       resource_type = "spot-instances-request"
  #       tags          = merge({ WhatAmI = "SpotInstanceRequest" })
  #     }
  #   ]

  tags = local.common_tags

  # Autoscaling Schedule
  #   schedules = {
  #     night = {
  #       min_size         = 0
  #       max_size         = 0
  #       desired_capacity = 0
  #       recurrence       = "0 18 * * 1-5" # Mon-Fri in the evening
  #       time_zone        = "Europe/Rome"
  #     }

  #     morning = {
  #       min_size         = 0
  #       max_size         = 1
  #       desired_capacity = 1
  #       recurrence       = "0 7 * * 1-5" # Mon-Fri in the morning
  #     }

  #     go-offline-to-celebrate-new-year = {
  #       min_size         = 0
  #       max_size         = 0
  #       desired_capacity = 0
  #       start_time       = "2031-12-31T10:00:00Z" # Should be in the future
  #       end_time         = "2032-01-01T16:00:00Z"
  #     }
  #   }
  #   # Target scaling policy schedule based on average CPU load
  #   scaling_policies = {
  #     avg-cpu-policy-greater-than-50 = {
  #       policy_type               = "TargetTrackingScaling"
  #       estimated_instance_warmup = 1200
  #       target_tracking_configuration = {
  #         predefined_metric_specification = {
  #           predefined_metric_type = "ASGAverageCPUUtilization"
  #         }
  #         target_value = 50.0
  #       }
  #     },
  #     predictive-scaling = {
  #       policy_type = "PredictiveScaling"
  #       predictive_scaling_configuration = {
  #         mode                         = "ForecastAndScale"
  #         scheduling_buffer_time       = 10
  #         max_capacity_breach_behavior = "IncreaseMaxCapacity"
  #         max_capacity_buffer          = 10
  #         metric_specification = {
  #           target_value = 32
  #           predefined_scaling_metric_specification = {
  #             predefined_metric_type = "ASGAverageCPUUtilization"
  #             resource_label         = "testLabel"
  #           }
  #           predefined_load_metric_specification = {
  #             predefined_metric_type = "ASGTotalCPUUtilization"
  #             resource_label         = "testLabel"
  #           }
  #         }
  #       }
  #     }
  #     request-count-per-target = {
  #       policy_type               = "TargetTrackingScaling"
  #       estimated_instance_warmup = 120
  #       target_tracking_configuration = {
  #         predefined_metric_specification = {
  #           predefined_metric_type = "ALBRequestCountPerTarget"
  #           resource_label         = "${module.alb.lb_arn_suffix}/${module.alb.target_group_arn_suffixes[0]}"
  #         }
  #         target_value = 800
  #       }
  #     }
  #   }
}
