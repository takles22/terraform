resource "aws_placement_group" "test" {
  name     = "test"
  strategy = "spread"
}

#------------------------------------------------#

resource "aws_launch_configuration" "as_conf" {
  name          = "web_config"
  image_id      = data.aws_ami.amaz23.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.dopper.key_name
}

#------------------------------------------------#

resource "aws_autoscaling_group" "ASG1" {
  name                      = "ASG1"
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 100
  target_group_arns = [aws_lb_target_group.WebTG.arn]
  health_check_type         = "ELB"
  force_delete    = true
  placement_group = aws_placement_group.test.id
  # launch_configuration      = aws_launch_configuration.as_conf.name
  availability_zones = ["us-east-1a"]
  launch_template {
    id = aws_launch_template.server1_temp.id
    version = "$Latest"
  }

  tag {
    key                 = "ASG1"
    value               = "MA"
    propagate_at_launch = true
  }
}

#------------------------------------------------#

resource "aws_autoscaling_policy" "bat1" {
  name                   = "foobar3-terraform-test1"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.ASG1.name
  policy_type            = "SimpleScaling"
}

#------------------------------------------------#

# resource "aws_autoscaling_group" "ASG2" {
#   name                      = "ASG2"
#   max_size                  = 4
#   min_size                  = 1
#   health_check_grace_period = 100
#   health_check_type         = "ELB"
#   desired_capacity          = 2
#   force_delete              = true
#   placement_group           = aws_placement_group.test.id
#   # launch_configuration      = aws_launch_configuration.as_conf.name
#   availability_zones = ["us-east-1b"]
#   launch_template {
#     id      = aws_launch_template.server1_temp.id
#     # version = "$Latest"
#   }

#   tag {
#     key                 = "ASG2"
#     value               = "MA"
#     propagate_at_launch = true
#   }
# }

#------------------------------------------------#

# resource "aws_autoscaling_policy" "bat2" {
#   name                   = "foobar3-terraform-test2"
#   scaling_adjustment     = 4
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 60
#   autoscaling_group_name = aws_autoscaling_group.ASG2.name
#   policy_type =  "SimpleScaling"
# }

#------------------------------------------------#

# Create a new ALB1 Target Group attachment
resource "aws_autoscaling_attachment" "auto_attc1" {
  autoscaling_group_name = aws_autoscaling_group.ASG1.id
  lb_target_group_arn    = aws_lb_target_group.WebTG.arn
}

#------------------------------------------------#

# Create a new ALB2 Target Group attachment
# resource "aws_autoscaling_attachment" "auto_attc2" {
#   autoscaling_group_name = aws_autoscaling_group.ASG2.id
#   lb_target_group_arn    = aws_lb_target_group.WebTG.arn
# }

#------------------------------------------------#