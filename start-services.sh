#!/bin/bash

echo "Starting RevTickets Microservices..."

# Start Eureka Server
echo "Starting Eureka Server..."
java -jar eureka-server.jar &
sleep 30

# Start other services
echo "Starting User Service..."
java -jar user-service.jar &
sleep 10

echo "Starting Movie Service..."
java -jar movie-service.jar &
sleep 10

echo "Starting Venue Service..."
java -jar venue-service.jar &
sleep 10

echo "Starting Booking Service..."
java -jar booking-service.jar &
sleep 10

echo "Starting Payment Service..."
java -jar payment-service.jar &
sleep 10

echo "Starting API Gateway..."
java -jar api-gateway.jar &

echo "All services started!"

# Keep container running
wait