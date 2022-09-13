
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "7.0.0"
  # insert the 4 required variables here
  name = "${local.name}-alb"
  //name_prefix = "lb1-"
  subnets = module.vpc.public_subnets
  vpc_id  = module.vpc.vpc_id

  #   name = "complete-alb-${random_pet.this.id}"
  load_balancer_type = "application"
  security_groups    = [module.alb-sg.security_group_id]


  #   # See notes in README (ref: https://github.com/terraform-providers/terraform-provider-aws/issues/7987)
  #   access_logs = {
  #     bucket = module.log_bucket.s3_bucket_id
  #   }

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port     = 80
      protocol = "HTTP"

      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  target_groups = [
    {
      name_prefix          = "app1-"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id = module.private-ec2-instance-app1[0].id
          port      = 80
        },
        my_ec2_again = {
          target_id = module.private-ec2-instance-app1[1].id
          port      = 80
        }
      }
      tags = local.common_tags
    },
    {
      name_prefix          = "app2-"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app2/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2_app2 = {
          target_id = module.private-ec2-instance-app2[0].id
          port      = 80
        },
        my_ec2_again_app2 = {
          target_id = module.private-ec2-instance-app2[1].id
          port      = 80
        }
      }
      tags = local.common_tags
    }
  ]

  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.acm_certificate_arn

      action_type = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "This is Fixed static message which will come for root context. i.e when path is URL/*"
        status_code  = "200"
      }

    }
  ]


  https_listener_rules = [
    {
      //Rule 1 /app1* should go to App1 EC2 instances
      https_listener_index = 0

      actions = [
        {
          type               = "forward"
          target_group_index = 0 // this is the target group where it has to send... so app1 is 0
        }
      ]

      conditions = [{
        path_patterns = ["/app1*"]
      }]
    },
    {
      //Rule 2 /app2* should go to App2 EC2 instances
      https_listener_index = 0

      actions = [
        {
          type               = "forward"
          target_group_index = 1 // this is the target group where it has to send... so app2 is 0
        }
      ]

      conditions = [{
        path_patterns = ["/app2*"]
      }]
    }
  ]


  tags = local.common_tags

  #   lb_tags = local.common_tags

  #   target_group_tags = local.common_tags 

  #   http_tcp_listeners_tags = local.common_tags
}