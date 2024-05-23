# Create ALB target group
resource "aws_lb_target_group" "WebTG" {
    name     = "WebTG"
    vpc_id = aws_vpc.custom_VPC.id
    port     = 80
    target_type = "instance"
    protocol = "HTTP"
    health_check {
       port = 80
        healthy_threshold = 6
        unhealthy_threshold = 2
        timeout = 2
        interval = 5
    }
}

#------------------------------------------------#

# Create ALB
resource "aws_lb" "WebALB" {
    name               = "ALB"
    internal           = false
    load_balancer_type = "application"
    enable_cross_zone_load_balancing = "true"
    security_groups    = [aws_security_group.ALBSG.id]
    subnets            = [aws_subnet.Public_Subnet1, aws_subnet.Public_Subnet2]
}

#------------------------------------------------#
# register targets to target_group
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.WebTG.arn
  target_id = aws_instance.ebs.id
  port             = 80
}
#------------------------------------------------#

# Add lislener to ALB
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WebTG.arn
  }
}


#------------------------------------------------#
output "Display_DNS" {
  value = aws_lb.WebALB.dns_name
}

#------------------------------------------------#
