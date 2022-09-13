
module "private-ec2-instance" {
  depends_on = [
    module.vpc
  ]
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"


  for_each = toset(["0", "1"])
  name = "${local.name}-private-ec2-instance-${each.key}"

  ami                         = data.aws_ami.mylinuxami.id
  instance_type               = var.instance_type

  # availability_zone           = [var.availability_zone[0]] //element(module.vpc.azs, 0)
  # subnet_id                   = module.vpc.private_subnets[0]//, module.vpc.private_subnets[1]] // element(module.vpc.private_subnets, 0)
// There is a change in latest version of ec2-instance.. so use this link while practicing
  //https://github.com/stacksimplify/terraform-on-aws-ec2/tree/main/07-AWS-EC2Instance-and-SecurityGroups/terraform-manifests-ec2private-module-version330
  
  subnet_id =  element(module.vpc.private_subnets, tonumber(each.key))
  vpc_security_group_ids      = [module.private-sg.security_group_id]
  key_name = var.instance_keypair
  user_data = local.user_data
  tags = local.common_tags
} 

