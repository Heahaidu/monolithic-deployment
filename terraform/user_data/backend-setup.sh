#!/bin/bash
set -e

AWS_REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
PROJECT_NAME="monolithic-deployment"
IMAGE_NAME="${ECR_REGISTRY}/${PROJECT_NAME}/backend:latest"
CONTAINER_NAME="backend"
APP_PORT=5000

DB_HOST=$(aws ssm get-parameter \
  --name "/${PROJECT_NAME}/db/host" \
  --query "Parameter.Value" --output text --region ${AWS_REGION})
DB_NAME=$(aws ssm get-parameter \
  --name "/${PROJECT_NAME}/db/name" \
  --query "Parameter.Value" --output text --region ${AWS_REGION})
DB_USER=$(aws ssm get-parameter \
  --name "/${PROJECT_NAME}/db/username" \
  --query "Parameter.Value" --output text --region ${AWS_REGION})
DB_PASS=$(aws ssm get-parameter \
  --name "/${PROJECT_NAME}/db/password" \
  --with-decryption \
  --query "Parameter.Value" --output text --region ${AWS_REGION})

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
  -p ${APP_PORT}:5000 \
  -e DB_HOST="${DB_HOST}" \
  -e DB_NAME="${DB_NAME}" \
  -e DB_USER="${DB_USER}" \
  -e DB_PASS="${DB_PASS}" \
  -e NODE_ENV="production" \
  ${IMAGE_NAME}

cat > /etc/systemd/system/backend.service <<EOF
[Unit]
Description=Backend Container
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
  -p ${APP_PORT}:5000 \
  -e DB_HOST="${DB_HOST}" \
  -e DB_NAME="${DB_NAME}" \
  -e DB_USER="${DB_USER}" \
  -e DB_PASS="${DB_PASS}" \
  -e NODE_ENV="production" \
  ${IMAGE_NAME}
ExecStop=/usr/bin/docker stop ${CONTAINER_NAME}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable backend