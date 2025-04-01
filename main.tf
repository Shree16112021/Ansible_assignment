resource "aws_key_pair" "Tester" {   
    key_name = "mykey"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiu3pzjZ9kLD5AxWIPN4TcXe1tvZwN5VYw7OnVfm4p5c78Sp+OS71yGXgIbgNwc8zNm0muBiElXVzQDSM0WXfqdOkaAMvbESCRllzo1JsHFvZRYyARNFsPy4LdTShRSfEHJOQMCqD5PDsFQQYqTUMYKzOcxi/FPAkh/R89i8VmQ7070VkeBMlJ+8c507SCu7IOCysL7m3Z5fiXI0ppKuWUDMmK6cT8vD+PzZsOfFGnHnZFAnWfBSshn2idrFJJ6HpiKhhSHM4KzZH/0sHtIpOsWGA+8m0iSl991Rupr0bSMFn9yVdOd7RGvXNIwb5weDJzwUq2vTl+N3j7wQzwJvbyZagGRdVB7mO/SISTP9qrXa3rlBeLN5H1ucM8tizGTGszhjomYUKrSZzxg7Dn0IyYW1eFNGHbTujIKzgcSOCIxJxFMnHK6+A2v9gzLfJy6FQ6FgkY+ghOJxNTzuujJ1mjojs5tN3n8jGrQLDMDFqjngUHUlZDd3S4SS9ndFT8h8U= ADMIN@DESKTOP-1HNN1HA"

  
}
resource "aws_instance" "myec2" {
  ami = "ami-0efc43a4067fe9a3e"
  instance_type = "t2.micro"
  key_name = aws_key_pair.Tester.key_name
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y 
              sudo yum install -y java-17*
              sudo wget -O /etc/yum.repos.d/jenkins.repo \https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
              sudo yum install -y jenkins
              sudo systemctl start jenkins
              sudo systemctl enable jenkins

              sudo useradd -m -s /bin/bash jenkins
              echo "jenkins_user:Redhat@123" | sudo chpasswd
              sudo usermod -aG wheel jenkins
                EOF
   tags = {
    Name = "Testing-server"
   }
}


# Capture Private IP
resource "null_resource" "capture_private_ip" {
  depends_on = [aws_instance.myec2]

  provisioner "local-exec" {
    command ="echo Private_IP=${aws_instance.myec2.private_ip} > private_ip.txt"
       
  }
}