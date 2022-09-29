
// Create schedule action 1: Increase capacity during business hours
resource "aws_autoscaling_schedule" "increase_capacity_9am_schedule_action" {
  scheduled_action_name = "increase_schedule_action"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 4
  // note that its UTC time
  start_time = "2030-12-11T09:00:00Z" //for testing purpose we gave 2030 as we dont want to create.. 
  # end_time               = "2016-12-12T06:00:00Z"  // we dont have to give end date because another action will trigger in evening
  recurrence             = "00 09 * * *" // which means that everyday at 9am it will start 
  autoscaling_group_name = aws_autoscaling_group.myasg.id
}


// Create schedule action 2: Decrease capacity during non-business hours

resource "aws_autoscaling_schedule" "decrease_capacity_9pm_schedule_action" {
  scheduled_action_name = "decrease_schedule_action"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  // note that its UTC time
  start_time = "2030-12-11T21:00:00Z" //for testing purpose we gave 2030 as we dont want to create.. 
  # end_time               = "2016-12-12T06:00:00Z"  // we dont have to give end date because another action will trigger in evening
  recurrence             = "00 09 * * *" // which means that everyday at 9am it will start 
  autoscaling_group_name = aws_autoscaling_group.myasg.id
}

