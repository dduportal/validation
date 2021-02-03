data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "server" {
  count           = length(var.configuration)
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.awesome_sg.name]

  tags = {
    Name        = keys(var.configuration)[count.index]
    Description = var.configuration[keys(var.configuration)[count.index]]
  }
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "awesome_sg"
  }
}

resource "aws_key_pair" "awesome_key" {
  key_name   = "awesome_key"
  public_key = file("~/.ssh/id_awesome.pub")
}
