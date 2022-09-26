
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "7.0.0"
  # insert the 4 required variables here

  name               = "${local.name}-alb"
  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  security_groups = [module.alb-sg.security_group_id]
  subnets         = module.vpc.public_subnets

  #   # See notes in README (ref: https://github.com/terraform-providers/terraform-provider-aws/issues/7987)
  #   access_logs = {
  #     bucket = module.log_bucket.s3_bucket_id
  #   }

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port     = 80
      protocol = "HTTP"
      //target_group_index = 0
      # action_type        = "forward"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
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
    { // Rule 1
      https_listener_index = 0
      priority             = 1
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]

      conditions = [{
        path_patterns = ["/*"]
        # # host_headers = [var.app1_dns_name] //"app1.yajuenterprise.quest"
        # http_headers = [{
        #   http_header_name = "mycustom-header"
        #   values           = ["myapp1", "app1", "app-1"]
        # }]
      }]
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

      # targets = {
      #   my_ec2 = {
      #     target_id = module.private-ec2-app1[0].id
      #     port      = 80
      #   },
      #   my_ec2_again = {
      #     target_id = module.private-ec2-app1[1].id
      #     port      = 80
      #   }
      # }
      tags = local.common_tags
    } 
  ]

  tags = local.common_tags

}

