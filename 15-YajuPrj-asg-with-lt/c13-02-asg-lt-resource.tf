// This is Launch Template resource

resource "aws_launch_template" "myasg_launch_template" {
  name          = "myasg_launch_template"
  description   = "Yaju asg launch template"
  image_id      = data.aws_ami.mylinuxami.id
  instance_type = var.instance_type
  # default_version = 1.0
  update_default_version = true
  key_name               = var.keyname

  vpc_security_group_ids = [module.private-sg.security_group_id]
  # user_data              = base64encode(file("${path.module}/app1-install.sh"))
    user_data = filebase64("${path.module}/app1-install.sh")
  ebs_optimized          = true

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 10
      delete_on_termination = true
      volume_type           = "gp2"
    }
  }

  monitoring {
    enabled = true
  }

  # tags = local.common_tags

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "myasg-with-lt"
    }
  }

}