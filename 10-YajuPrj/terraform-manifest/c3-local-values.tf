

locals {

  name   = "${var.business_division}-${var.environment}"
  region = var.aws_region
  common_tags = {

    division    = "${var.business_division}"
    environment = "${var.environment}"
    project     = "${var.projectname}"
  }

  # user_data = file("${path.module}/app1-install.sh")

}