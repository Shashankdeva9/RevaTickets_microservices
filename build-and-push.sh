#!/bin/bash
echo "===================================="
echo "Building and Pushing All Docker Images"
echo "===================================="

DOCKER_REGISTRY=${DOCKER_REGISTRY:-your-registry}
VERSION=${VERSION:-latest}

services=("eureka-server" "api-gateway" "user-service" "movie-service" "venue-service" "booking-service" "payment-service")

for service in "${services[@]}"; do
    echo "Building $service..."
    cd microservices/$service
    docker build -t $DOCKER_REGISTRY/$service:$VERSION .
    docker push $DOCKER_REGISTRY/$service:$VERSION
    cd ../..
done

echo "Building Frontend..."
cd frontend
docker build -t $DOCKER_REGISTRY/frontend:$VERSION .
docker push $DOCKER_REGISTRY/frontend:$VERSION
cd ..

echo "===================================="
echo "All images built and pushed successfully!"
echo "===================================="
