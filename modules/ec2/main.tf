resource "aws_instance" "web" {
  ami = "ami-053a45fff0a704a47" # Amazon Linux 2023 AMI
  instance_type = "t2.micro"
  key_name = "accesskeyforterraformdeploy" # Keypair name
  user_data = file("${path.module}/../../user_data.sh")

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer"
  }
}

resource "aws_security_group" "web_sg" {
  name = "web-security-group"
  description = "Allow HTTP and SSH"

  // Inbound Rules
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Outbound Rules (Allow all outbound traffic)
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1" // This means all traffic
    cidr_blocks = ["0.0.0.0/0"] // Allows traffic to any destination
  }
}
