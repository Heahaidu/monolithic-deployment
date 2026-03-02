#!/bin/bash
set -e
exec > /var/log/user_data.log 2>&1

yum update -y
yum install -y docker git
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

REPO_URL="https://github.com/Heahaidu/monolithic-deployment.git"
DEST="/opt/jenkins"

git clone "$REPO_URL" "$DEST"
cd "$DEST"
cd "jenkins"

docker compose up -d --build

echo "Jenkins setup done!"