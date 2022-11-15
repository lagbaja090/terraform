output "aws_instance" {
    value = aws_instance.dev-instance.public_ip
}

output "aws_instance_subnet" {
    value = aws_instance.dev-instance.subnet_id
}

output "aws_instance_ami" {
    value = aws_instance.dev-instance.ami 
}

output "aws_instance_availability_zone" {
    value = aws_instance.dev-instance.availability_zone
}

output "aws_instance_instance_type" {
    value = aws_instance.dev-instance.instance_type
}