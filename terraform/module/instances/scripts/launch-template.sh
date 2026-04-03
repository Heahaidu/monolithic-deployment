#! /bin/bash

sudo echo "ECS_CLUSTER=${ecs_cluster_name}" >> /etc/ecs/ecs.config
sudo systemctl start ecs