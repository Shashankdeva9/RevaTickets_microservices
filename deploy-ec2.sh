#!/bin/bash

# Complete EC2 Deployment Script for Rev-Tickets

set -e  # Exit on any error

echo "Starting Rev-Tickets complete deployment on EC2..."

# Get EC2 public IP
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "EC2 Public IP: $PUBLIC_IP"

# Stop any existing containers
echo "Stopping existing containers..."
docker-compose down || true

# Clean up old images
echo "Cleaning up old Docker images..."
docker system prune -f

# Build all microservices
echo "Building all microservices..."
cd microservices

# Build each service
for service in eureka-server api-gateway user-service movie-service venue-service booking-service payment-service; do
    if [ -d "$service" ]; then
        echo "Building $service..."
        cd "$service"
        mvn clean package -DskipTests -q
        cd ..
    fi
done

cd ..

# Build frontend
echo "Building frontend..."
cd frontend
npm install
npm run build
cd ..

# Build all Docker containers
echo "Building Docker containers..."
docker-compose build --no-cache

# Start database first
echo "Starting MySQL database..."
docker-compose up -d mysql
echo "Waiting for database to initialize..."
sleep 30

# Start Eureka server
echo "Starting Eureka server..."
docker-compose up -d eureka-server
echo "Waiting for Eureka to start..."
sleep 20

# Start all microservices
echo "Starting microservices..."
docker-compose up -d user-service movie-service venue-service booking-service payment-service
echo "Waiting for microservices to register..."
sleep 30

# Start API Gateway
echo "Starting API Gateway..."
docker-compose up -d api-gateway
echo "Waiting for API Gateway..."
sleep 15

# Start frontend
echo "Starting frontend..."
docker-compose up -d frontend
echo "Waiting for frontend..."
sleep 10

# Check all services
echo "Checking all services..."
docker-compose ps

# Test endpoints
echo "Testing endpoints..."
echo "Eureka: http://$PUBLIC_IP:8080"
echo "API Gateway Health: http://$PUBLIC_IP:9090/actuator/health"
echo "Frontend: http://$PUBLIC_IP"

# Show logs for any failed services
echo "Checking for failed services..."
FAILED_SERVICES=$(docker-compose ps --services --filter "status=exited")
if [ ! -z "$FAILED_SERVICES" ]; then
    echo "Failed services detected: $FAILED_SERVICES"
    for service in $FAILED_SERVICES; do
        echo "Logs for $service:"
        docker-compose logs --tail=20 $service
    done
else
    echo "All services are running successfully!"
fi

echo "\n=== DEPLOYMENT COMPLETE ==="
echo "Access your application at: http://$PUBLIC_IP"
echo "API Gateway: http://$PUBLIC_IP:9090"
echo "Eureka Dashboard: http://$PUBLIC_IP:8080"
echo "\nTo monitor logs: docker-compose logs -f"
echo "To restart: docker-compose restart"
echo "To stop: docker-compose down"