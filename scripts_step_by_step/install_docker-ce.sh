sudo yum update -y
# sudo amazon-linux-extras install docker -y #deprecado 
sudo yum install  docker -y
systemctl enable --now docker
# systemctl start docker
#//amazon linux 2023