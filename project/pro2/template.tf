resource "aws_launch_template" "server1_temp" {
  name = "server1_temp"

  block_device_mappings {
    device_name = "/dev/sdh"

    ebs {
      volume_size = 10
    }
  }

  image_id      = data.aws_ami.amaz23.id
  instance_type = "t2.micro"

  default_version = 1

  instance_initiated_shutdown_behavior = "terminate"


  key_name = aws_key_pair.dopper.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    security_groups = [aws_security_group.WebSG.id]
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.Public_Subnet1.id
    delete_on_termination       = true 
}

  placement {
    availability_zone = "us-east-1a"
  }

  # vpc_security_group_ids = [aws_security_group.WebSG.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "server1a"
    }
  }

  # user_data = data.cloudinit_config.cloudinit-example1.rendered
  user_data = filebase64("${path.module}/script.sh")
}