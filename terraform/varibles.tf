variable "aws_region"{
   description = "aws region where it is provisined"
   default = "ap-south-1"
}

variable "ami_id"{
    description = "AMI ID oe ec2 instance"
    default = "ami-051a31ab2f4d498f5"
}

variable "instance_type" {
    description = "type of instance"
    default = "t3.micro"
  
}
