provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
   key_name      = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y apache2
              echo "<h1>Hello from Terraform</h1>" > /var/www/html/index.html
              systemctl enable apache2
              systemctl start apache2
              EOF

  tags = {
    Name = "WebServer"
  }
}
