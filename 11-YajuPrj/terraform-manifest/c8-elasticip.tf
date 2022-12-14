resource "aws_eip" "bastion_eip" {
  depends_on = [module.bastion-ec2, module.vpc]
  instance   = module.bastion-ec2.id
  vpc        = true
  tags       = local.common_tags

  ## Local Exec Provisioner:  local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
  provisioner "local-exec" {
    command     = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when        = destroy
    #on_failure = continue
  }
}