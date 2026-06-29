#!/bin/bash
set -e
exec > /var/log/user_data.log 2>&1

# sudo yum update -y
# sudo yum install -y docker
# sudo systemctl start docker
# sudo systemctl enable docker

sudo dnf install -y java-17-amazon-corretto
sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "Jenkins setup done!"
