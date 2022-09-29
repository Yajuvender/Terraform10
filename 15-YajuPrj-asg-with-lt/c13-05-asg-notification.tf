
// SNS Topic
// Try to keep the SNS Topic name unique always and for that only we declard "random_pet" in c1-version.tf file
// when we are creating multiple times and for different env, there is some reference left in subscription... so use unique names

resource "aws_sns_topic" "mysnstopic" {
  name = "${local.name}-snstopic-${random_pet.randomnumber.id}" //"user-updates-topic"
}



// SNS Subscrition

resource "aws_sns_topic_subscription" "snstopicsubscription" {
  topic_arn = aws_sns_topic.mysnstopic.arn
  protocol  = "email"
  endpoint  = "yajuvender2018@gmail.com"
}



// Autoscaling notification resource

resource "aws_autoscaling_notification" "asg_notifications" {
  group_names = [aws_autoscaling_group.myasg.id]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.mysnstopic.arn
}