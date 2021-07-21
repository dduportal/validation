data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }


  filter {
    name = "virtualization-type"

    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "production" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.awesome_sg.name]
}

resource "aws_security_group" "awesome_sg" {
  name        = "awesome_sg"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "awesome_key" {
  key_name   = "awesome_key"
  public_key = file("~/.ssh/id_awesome.pub")
}

output "production" {
  value = aws_instance.production.public_dns
}
