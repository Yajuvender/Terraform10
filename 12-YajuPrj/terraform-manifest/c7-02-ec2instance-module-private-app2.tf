
module "private-ec2-app2" {
  depends_on = [
    module.vpc
  ]
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  name          = "${local.name}-private-ec2-app2"
  for_each      = toset(["0", "1"])
  ami           = data.aws_ami.mylinuxami.id
  instance_type = var.instance_type
  key_name      = var.keyname

  vpc_security_group_ids = [module.alb-sg.security_group_id, module.private-sg.security_group_id]
  subnet_id              = element(module.vpc.private_subnets, tonumber(each.key))

  associate_public_ip_address = true

  user_data_base64 = base64encode(local.user_data_app2)

  tags = local.common_tags
}