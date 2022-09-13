
module "bastion-ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  name = "${local.name}-bastion-ec2-instance"

  ami           = data.aws_ami.mylinuxami.id
  instance_type = var.instance_type

  # availability_zone           = [var.availability_zone[0]] //element(module.vpc.azs, 0)
  subnet_id              = module.vpc.public_subnets[0] // element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.bastion-sg.security_group_id]
  key_name               = var.instance_keypair
  user_data              = file("${path.module}/app1-install.sh") //local.user_data
  tags                   = local.common_tags
}