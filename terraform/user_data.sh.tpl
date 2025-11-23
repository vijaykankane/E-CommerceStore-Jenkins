#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1

# Update & install prerequisites
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Allow ubuntu user to run docker
usermod -aG docker ubuntu || true

# Wait for docker service
systemctl enable docker
systemctl start docker

# Pull images from DockerHub (replace template variable)
DOCKERHUB_USER="${DOCKERHUB_USER}"

# container names & ports
docker pull ${DOCKERHUB_USER}/user-service:latest || true
docker pull ${DOCKERHUB_USER}/products-service:latest || true
docker pull ${DOCKERHUB_USER}/orders-service:latest || true
docker pull ${DOCKERHUB_USER}/cart-service:latest || true
docker pull ${DOCKERHUB_USER}/frontend:latest || true

# Stop & remove existing containers if any
for c in frontend user products orders cart; do
  docker rm -f ecom-$c 2>/dev/null || true
done

# Start backend services (bind to localhost ports - internal)
docker run -d --name ecom-user --restart unless-stopped -p 127.0.0.1:3001:3001 ${DOCKERHUB_USER}/user-service:latest
docker run -d --name ecom-products --restart unless-stopped -p 127.0.0.1:3002:3002 ${DOCKERHUB_USER}/product-service:latest
docker run -d --name ecom-orders --restart unless-stopped -p 127.0.0.1:3003:3003 ${DOCKERHUB_USER}/order-service:latest
docker run -d --name ecom-cart --restart unless-stopped -p 127.0.0.1:3004:3004 ${DOCKERHUB_USER}/cart-service:latest

# Start frontend and map container port 3000 to host port 80 for public access
docker run -d --name ecom-frontend --restart unless-stopped -p 80:80 ${DOCKERHUB_USER}/frontend-service:latest

# Simple health log
echo "$(date) - Containers started:" > /var/log/ecom-containers.log
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" >> /var/log/ecom-containers.log
