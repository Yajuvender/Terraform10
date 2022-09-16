locals {

  name = "${var.division}-${var.environment}-${var.projectname}"

  common_tags = {
    division    = "${var.division}"
    environment = "${var.environment}"
    projectname = "${var.projectname}"
  }

  user_data_app1 = file("${path.module}/app1-install.sh")
  user_data_app2 = file("${path.module}/app2-install.sh")
}