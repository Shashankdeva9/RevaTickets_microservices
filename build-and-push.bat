@echo off
echo ====================================
echo Building and Pushing All Docker Images
echo ====================================

set DOCKER_REGISTRY=your-registry
set VERSION=latest

echo Building Eureka Server...
cd microservices\eureka-server
docker build -t %DOCKER_REGISTRY%/eureka-server:%VERSION% .
docker push %DOCKER_REGISTRY%/eureka-server:%VERSION%
cd ..\..

echo Building API Gateway...
cd microservices\api-gateway
docker build -t %DOCKER_REGISTRY%/api-gateway:%VERSION% .
docker push %DOCKER_REGISTRY%/api-gateway:%VERSION%
cd ..\..

echo Building User Service...
cd microservices\user-service
docker build -t %DOCKER_REGISTRY%/user-service:%VERSION% .
docker push %DOCKER_REGISTRY%/user-service:%VERSION%
cd ..\..

echo Building Movie Service...
cd microservices\movie-service
docker build -t %DOCKER_REGISTRY%/movie-service:%VERSION% .
docker push %DOCKER_REGISTRY%/movie-service:%VERSION%
cd ..\..

echo Building Venue Service...
cd microservices\venue-service
docker build -t %DOCKER_REGISTRY%/venue-service:%VERSION% .
docker push %DOCKER_REGISTRY%/venue-service:%VERSION%
cd ..\..

echo Building Booking Service...
cd microservices\booking-service
docker build -t %DOCKER_REGISTRY%/booking-service:%VERSION% .
docker push %DOCKER_REGISTRY%/booking-service:%VERSION%
cd ..\..

echo Building Payment Service...
cd microservices\payment-service
docker build -t %DOCKER_REGISTRY%/payment-service:%VERSION% .
docker push %DOCKER_REGISTRY%/payment-service:%VERSION%
cd ..\..

echo Building Frontend...
cd frontend
docker build -t %DOCKER_REGISTRY%/frontend:%VERSION% .
docker push %DOCKER_REGISTRY%/frontend:%VERSION%
cd ..

echo ====================================
echo All images built and pushed successfully!
echo ====================================
