##############
# Standalone
##############

data "aws_ami" "RHEL" {
    most_recent = true

    filter {
        name = "name"
        values = ["RHEL-9.3.0_HVM-*-x86_64*"]
    }

    owners = ["309956199498"]
}

resource "aws_instance" "POC-Standalone" {
    ami = data.aws_ami.RHEL.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.POC-Subnet-2.id

    tags = {
        Name = "POC-Standalone"
    }
    root_block_device {
        volume_size = 20
        volume_type = "gp3"
    }
    
    security_groups = [aws_security_group.standalone.id]
    key_name = "Newbie"
    associate_public_ip_address = true
    iam_instance_profile = aws_iam_instance_profile.POCallowSSM-Profile.name
}

################
# ASG resources
################

resource "aws_launch_template" "POC-ASG-Template" {
    name = "POC-ASG-Template"

    block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
    }

    instance_type = "t2.micro"
    iam_instance_profile {
        name = aws_iam_instance_profile.POC-ALB-Allow-Profile.name
    }
    image_id = "ami-0fe630eb857a6ec83"
    user_data = base64encode(file("userData.sh"))

}

resource "aws_autoscaling_group" "POC-ASG" {
    name = "POC-ASG"
    max_size = 6
    min_size = 2
    launch_template {
        id = aws_launch_template.POC-ASG-Template.id
        version = "$Latest"
    }
    target_group_arns = [aws_lb_target_group.POC-ALB-TG.arn]
    vpc_zone_identifier = [aws_subnet.POC-Subnet-3.id, aws_subnet.POC-Subnet-4.id]
}