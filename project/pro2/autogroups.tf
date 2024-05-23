resource "aws_placement_group" "test" {
  name     = "test"
  strategy = "cluster"
}

#------------------------------------------------#

resource "aws_launch_configuration" "as_conf" {
  name          = "web_config"
  image_id      = data.aws_ami.amaz23.id
  instance_type = "t2.micro"
  key_name =  "memo"
}

#------------------------------------------------#

resource "aws_autoscaling_group" "ASG" {
  name                      = "ASG"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ALB"
  desired_capacity          = 2
  force_delete              = true
  placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = [aws_subnet.Public_Subnet1.id, aws_subnet.Public_Subnet2.id]


  tag {
    key                 = "ASG"
    value               = "MA"
    propagate_at_launch = true
  }
}

#------------------------------------------------#

resource "aws_autoscaling_policy" "bat" {
  name                   = "foobar3-terraform-test"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.ASG.name
  policy_type =  "SimpleScaling"
}