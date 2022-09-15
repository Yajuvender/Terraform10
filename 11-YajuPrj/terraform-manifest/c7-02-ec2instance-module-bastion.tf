
module "bastion-ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  name = "${local.name}-bastion-ec2"

  ami           = data.aws_ami.mylinuxami.id
  instance_type = var.instance_type
  key_name      = var.keyname

  availability_zone = var.availability_zones[1]

  vpc_security_group_ids = [module.bastion-sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[1]

  associate_public_ip_address = true

  user_data_base64 = base64encode(local.user_data_app1)

  tags = local.common_tags
}