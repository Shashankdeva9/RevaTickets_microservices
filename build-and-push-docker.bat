@echo off
REM Build and Push all Docker images to Docker Hub
REM Usage: build-and-push-docker.bat [your-dockerhub-username]

setlocal enabledelayedexpansion

echo ========================================
echo   RevTickets Docker Build and Push
echo ========================================
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running! Please start Docker Desktop.
    pause
    exit /b 1
)

REM Get Docker Hub username
set DOCKER_REGISTRY=%1
if "%DOCKER_REGISTRY%"=="" (
    set /p DOCKER_REGISTRY="Enter your Docker Hub username: "
)

echo [*] Using Docker registry: %DOCKER_REGISTRY%
echo.

REM Login to Docker Hub
echo [*] Logging in to Docker Hub...
docker login
if errorlevel 1 (
    echo [ERROR] Docker login failed!
    pause
    exit /b 1
)
echo.

REM Build all microservices first
echo ========================================
echo   Building Microservices with Maven
echo ========================================
echo.

cd microservices

echo [1/7] Building Eureka Server...
cd eureka-server
call mvn clean package -DskipTests
if errorlevel 1 (
    echo [ERROR] Failed to build Eureka Server
    pause
    exit /b 1
)
cd ..

echo [2/7] Building API Gateway...
cd api-gateway
call mvn clean package -DskipTests
if errorlevel 1 (
    echo [ERROR] Failed to build API Gateway
    pause
    exit /b 1
)
cd ..

echo [3/7] Building User Service...
cd user-service
call mvn clean package -DskipTests
if errorlevel 1 (
    echo [ERROR] Failed to build User Service
    pause
    exit /b 1
)
cd ..

echo [4/7] Building Movie Service...
cd movie-service
call mvn clean package -DskipTests
if errorlevel 1 (
    echo [ERROR] Failed to build Movie Service
    pause
    exit /b 1
)
cd ..

echo [5/7] Building Venue Service...
cd venue-service
call mvn clean package -DskipTests
if errorlevel 1 (
    echo [ERROR] Failed to build Venue Service
    pause
    exit /b 1
)
cd ..

echo [6/7] Building Booking Service...
cd booking-service
call mvn clean package -DskipTests
if errorlevel 1 (
    echo [ERROR] Failed to build Booking Service
    pause
    exit /b 1
)
cd ..

echo [7/7] Building Payment Service...
cd payment-service
call mvn clean package -DskipTests
if errorlevel 1 (
    echo [ERROR] Failed to build Payment Service
    pause
    exit /b 1
)
cd ..

cd ..

echo.
echo ========================================
echo   Building Docker Images
echo ========================================
echo.

echo [1/8] Building Eureka Server image...
docker build -t %DOCKER_REGISTRY%/revtickets-eureka:latest ./microservices/eureka-server
if errorlevel 1 goto :error

echo [2/8] Building API Gateway image...
docker build -t %DOCKER_REGISTRY%/revtickets-gateway:latest ./microservices/api-gateway
if errorlevel 1 goto :error

echo [3/8] Building User Service image...
docker build -t %DOCKER_REGISTRY%/revtickets-user:latest ./microservices/user-service
if errorlevel 1 goto :error

echo [4/8] Building Movie Service image...
docker build -t %DOCKER_REGISTRY%/revtickets-movie:latest ./microservices/movie-service
if errorlevel 1 goto :error

echo [5/8] Building Venue Service image...
docker build -t %DOCKER_REGISTRY%/revtickets-venue:latest ./microservices/venue-service
if errorlevel 1 goto :error

echo [6/8] Building Booking Service image...
docker build -t %DOCKER_REGISTRY%/revtickets-booking:latest ./microservices/booking-service
if errorlevel 1 goto :error

echo [7/8] Building Payment Service image...
docker build -t %DOCKER_REGISTRY%/revtickets-payment:latest ./microservices/payment-service
if errorlevel 1 goto :error

echo [8/8] Building Frontend image...
docker build -t %DOCKER_REGISTRY%/revtickets-frontend:latest ./frontend
if errorlevel 1 goto :error

echo.
echo ========================================
echo   Pushing Docker Images
echo ========================================
echo.

echo [1/8] Pushing Eureka Server...
docker push %DOCKER_REGISTRY%/revtickets-eureka:latest
if errorlevel 1 goto :error

echo [2/8] Pushing API Gateway...
docker push %DOCKER_REGISTRY%/revtickets-gateway:latest
if errorlevel 1 goto :error

echo [3/8] Pushing User Service...
docker push %DOCKER_REGISTRY%/revtickets-user:latest
if errorlevel 1 goto :error

echo [4/8] Pushing Movie Service...
docker push %DOCKER_REGISTRY%/revtickets-movie:latest
if errorlevel 1 goto :error

echo [5/8] Pushing Venue Service...
docker push %DOCKER_REGISTRY%/revtickets-venue:latest
if errorlevel 1 goto :error

echo [6/8] Pushing Booking Service...
docker push %DOCKER_REGISTRY%/revtickets-booking:latest
if errorlevel 1 goto :error

echo [7/8] Pushing Payment Service...
docker push %DOCKER_REGISTRY%/revtickets-payment:latest
if errorlevel 1 goto :error

echo [8/8] Pushing Frontend...
docker push %DOCKER_REGISTRY%/revtickets-frontend:latest
if errorlevel 1 goto :error

echo.
echo ========================================
echo   SUCCESS!
echo ========================================
echo.
echo All images have been built and pushed successfully!
echo.
echo Docker Images:
echo   - %DOCKER_REGISTRY%/revtickets-eureka:latest
echo   - %DOCKER_REGISTRY%/revtickets-gateway:latest
echo   - %DOCKER_REGISTRY%/revtickets-user:latest
echo   - %DOCKER_REGISTRY%/revtickets-movie:latest
echo   - %DOCKER_REGISTRY%/revtickets-venue:latest
echo   - %DOCKER_REGISTRY%/revtickets-booking:latest
echo   - %DOCKER_REGISTRY%/revtickets-payment:latest
echo   - %DOCKER_REGISTRY%/revtickets-frontend:latest
echo.
echo To run the application:
echo   docker-compose -f docker-compose-full.yml up -d
echo.
pause
exit /b 0

:error
echo.
echo ========================================
echo   ERROR!
echo ========================================
echo.
echo Build or push failed! Check the error message above.
echo.
pause
exit /b 1
