#!/bin/bash

# RevTickets - Build and Push All Docker Images Script
# This script builds and pushes all microservices to Docker Hub

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker Hub username is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Docker Hub username is required${NC}"
    echo "Usage: ./build-and-push.sh <docker-hub-username>"
    exit 1
fi

DOCKER_USERNAME=$1
IMAGE_TAG=${2:-latest}

echo -e "${GREEN}=== Starting Docker Build and Push Process ===${NC}"
echo "Docker Hub Username: $DOCKER_USERNAME"
echo "Image Tag: $IMAGE_TAG"

# Login to Docker Hub
echo -e "${YELLOW}Logging into Docker Hub...${NC}"
docker login

# Array of services
declare -a services=(
    "eureka-server:8761"
    "api-gateway:9090"
    "user-service:8081"
    "movie-service:8082"
    "venue-service:8083"
    "booking-service:8084"
    "payment-service:8085"
)

# Build Maven services
echo -e "${GREEN}=== Building Maven Services ===${NC}"
for service_info in "${services[@]}"; do
    service=$(echo $service_info | cut -d':' -f1)
    echo -e "${YELLOW}Building $service...${NC}"
    cd microservices/$service
    mvn clean package -DskipTests
    cd ../..
done

# Build and push Docker images for microservices
echo -e "${GREEN}=== Building and Pushing Microservice Docker Images ===${NC}"
for service_info in "${services[@]}"; do
    service=$(echo $service_info | cut -d':' -f1)
    image_name="$DOCKER_USERNAME/revtickets-$(echo $service | sed 's/-server//;s/-service//;s/api-//')"
    
    echo -e "${YELLOW}Building and pushing $image_name...${NC}"
    cd microservices/$service
    docker build -t $image_name:$IMAGE_TAG .
    docker build -t $image_name:latest .
    docker push $image_name:$IMAGE_TAG
    docker push $image_name:latest
    cd ../..
    echo -e "${GREEN}✓ Successfully pushed $image_name${NC}"
done

# Build and push Frontend
echo -e "${GREEN}=== Building and Pushing Frontend ===${NC}"
echo -e "${YELLOW}Building frontend...${NC}"
cd frontend
docker build -t $DOCKER_USERNAME/revtickets-frontend:$IMAGE_TAG .
docker build -t $DOCKER_USERNAME/revtickets-frontend:latest .
docker push $DOCKER_USERNAME/revtickets-frontend:$IMAGE_TAG
docker push $DOCKER_USERNAME/revtickets-frontend:latest
cd ..
echo -e "${GREEN}✓ Successfully pushed frontend${NC}"

# Update docker-compose file
echo -e "${GREEN}=== Updating docker-compose-production.yml ===${NC}"
sed -i "s/\${DOCKER_HUB_USERNAME:-yourusername}/$DOCKER_USERNAME/g" docker-compose-production.yml
echo -e "${GREEN}✓ Updated docker-compose-production.yml${NC}"

echo -e "${GREEN}=== All Images Built and Pushed Successfully! ===${NC}"
echo -e "${YELLOW}To deploy, run:${NC}"
echo "docker-compose -f docker-compose-production.yml up -d"

# Cleanup
echo -e "${YELLOW}Cleaning up local images...${NC}"
docker system prune -f

echo -e "${GREEN}=== Process Complete! ===${NC}"
