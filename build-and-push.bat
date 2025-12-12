@echo off
REM RevTickets - Build and Push All Docker Images Script (Windows)
REM This script builds and pushes all microservices to Docker Hub

setlocal EnableDelayedExpansion

REM Check if Docker Hub username is provided
if "%~1"=="" (
    echo Error: Docker Hub username is required
    echo Usage: build-and-push.bat ^<docker-hub-username^>
    exit /b 1
)

set DOCKER_USERNAME=%1
set IMAGE_TAG=%2
if "%IMAGE_TAG%"=="" set IMAGE_TAG=latest

echo === Starting Docker Build and Push Process ===
echo Docker Hub Username: %DOCKER_USERNAME%
echo Image Tag: %IMAGE_TAG%

REM Login to Docker Hub
echo Logging into Docker Hub...
docker login
if errorlevel 1 (
    echo Failed to login to Docker Hub
    exit /b 1
)

REM Build Maven services
echo === Building Maven Services ===
for %%s in (eureka-server api-gateway user-service movie-service venue-service booking-service payment-service) do (
    echo Building %%s...
    cd microservices\%%s
    call mvn clean package -DskipTests
    if errorlevel 1 (
        echo Failed to build %%s
        exit /b 1
    )
    cd ..\..
)

REM Build and push Docker images for microservices
echo === Building and Pushing Microservice Docker Images ===
for %%s in (eureka-server api-gateway user-service movie-service venue-service booking-service payment-service) do (
    set SERVICE_NAME=%%s
    set IMAGE_NAME=%DOCKER_USERNAME%/revtickets-!SERVICE_NAME:-server=!
    set IMAGE_NAME=!IMAGE_NAME:-service=!
    set IMAGE_NAME=!IMAGE_NAME:api-=!
    
    echo Building and pushing !IMAGE_NAME!...
    cd microservices\%%s
    docker build -t !IMAGE_NAME!:%IMAGE_TAG% .
    docker build -t !IMAGE_NAME!:latest .
    docker push !IMAGE_NAME!:%IMAGE_TAG%
    docker push !IMAGE_NAME!:latest
    cd ..\..
    echo Successfully pushed !IMAGE_NAME!
)

REM Build and push Frontend
echo === Building and Pushing Frontend ===
echo Building frontend...
cd frontend
docker build -t %DOCKER_USERNAME%/revtickets-frontend:%IMAGE_TAG% .
docker build -t %DOCKER_USERNAME%/revtickets-frontend:latest .
docker push %DOCKER_USERNAME%/revtickets-frontend:%IMAGE_TAG%
docker push %DOCKER_USERNAME%/revtickets-frontend:latest
cd ..
echo Successfully pushed frontend

REM Update docker-compose file
echo === Updating docker-compose-production.yml ===
powershell -Command "(Get-Content docker-compose-production.yml) -replace '\${DOCKER_HUB_USERNAME:-yourusername}', '%DOCKER_USERNAME%' | Set-Content docker-compose-production.yml"
echo Updated docker-compose-production.yml

echo === All Images Built and Pushed Successfully! ===
echo To deploy, run:
echo docker-compose -f docker-compose-production.yml up -d

REM Cleanup
echo Cleaning up local images...
docker system prune -f

echo === Process Complete! ===
endlocal
