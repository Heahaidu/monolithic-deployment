#!/bin/bash
set -e

AWS_REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
PROJECT_NAME="monolithic-deployment"
IMAGE_NAME="${ECR_REGISTRY}/${PROJECT_NAME}/frontend:latest"
CONTAINER_NAME="frontend"
APP_PORT=80

yum update -y
yum install -y docker aws-cli
systemctl enable docker
systemctl start docker

aws ecr get-login-password --region ${AWS_REGION} | \
  docker login --username AWS --password-stdin ${ECR_REGISTRY}

docker pull ${IMAGE_NAME}

docker run -d \
  --name ${CONTAINER_NAME} \
  --restart always \
  -p ${APP_PORT}:80 \
  ${IMAGE_NAME}

cat > /etc/systemd/system/frontend.service <<EOF
[Unit]
Description=Frontend Container
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStartPre=-/usr/bin/docker stop ${CONTAINER_NAME}
ExecStartPre=-/usr/bin/docker rm ${CONTAINER_NAME}
ExecStartPre=/bin/bash -c 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}'
ExecStart=/usr/bin/docker run \
  --name ${CONTAINER_NAME} \
  --rm \
  -p ${APP_PORT}:80 \
  ${IMAGE_NAME}
ExecStop=/usr/bin/docker stop ${CONTAINER_NAME}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable frontend