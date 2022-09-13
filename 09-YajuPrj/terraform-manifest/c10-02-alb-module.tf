
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "7.0.0"
  # insert the 4 required variables here
    name = "${local.name}-alb"
    //name_prefix = "lb1-"
    subnets = module.vpc.public_subnets
    vpc_id = module.vpc.vpc_id
 
#   name = "complete-alb-${random_pet.this.id}"
  load_balancer_type = "application"  
  security_groups = [module.alb-sg.security_group_id] 
 

  #   # See notes in README (ref: https://github.com/terraform-providers/terraform-provider-aws/issues/7987)
  #   access_logs = {
  #     bucket = module.log_bucket.s3_bucket_id
  #   }

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      # action_type        = "forward"
    }  
  ]
  
  target_groups = [
    {
      name_prefix          = "lb1"
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
          target_id = module.private-ec2-instance[0].id
          port      = 80
        },
        my_ec2_again = {
          target_id = module.private-ec2-instance[1].id
          port      = 80
        }
      }
      tags = local.common_tags
    } 
  ]

  tags = local.common_tags

#   lb_tags = local.common_tags

#   target_group_tags = local.common_tags 

#   http_tcp_listeners_tags = local.common_tags
}