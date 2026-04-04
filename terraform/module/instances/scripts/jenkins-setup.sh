#!/bin/bash
set -e
exec > /var/log/user_data.log 2>&1

# sudo yum update -y
# sudo yum install -y docker
# sudo systemctl start docker
# sudo systemctl enable docker

sudo docker run --name jenkins-master -d --restart=on-failure \
  -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins_home:/var/jenkins_home --user root jenkins/jenkins:lts-alpine

sudo docker exec jenkins-master apk add --no-cache curl unzip docker-cli aws-cli jq

sudo docker exec jenkins-master jenkins-plugin-cli --plugins "json-path-api blueocean docker-workflow aws-credentials pipeline-aws"

sudo docker restart jenkins-master

echo "Jenkins setup done!"