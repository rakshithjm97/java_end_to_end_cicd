resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "allow_user_to_connect" {
    name = "cicd"
    description = "allow juser to connect"
    vpc_id = aws_default_vpc.default.id
    ingress{
        description = "port 22 alow"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        

    }
    egress{
        description = "allow outgoing traffice"
        from_port = 0
        to_port = 0
        protocol = "-1"
        

    }
    ingress{
        description = "allow outgoing traffice"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        

    }
    ingress{
        description = "port 443 allow"
        from_port = 443
        to_port = 443
        protocol = "tcp"

    }
    tags = {
        Name = "security"
    }

}

resource "aws_instance" "testinstance" {
    ami = var.ami_id
    instance_type = var.instance_type
    security_groups = [aws_security_group.allow_user_to_connect.name]
    tags = {
        Name = "automate"
    }
    root_block_device{
        volume_size = 30 
        volume_type = "gp3"

    }
  
}






