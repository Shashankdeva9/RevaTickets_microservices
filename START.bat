@echo off
REM RevTickets - Quick Start Script
REM Starts all microservices in order

color 0A
title RevTickets - Starting Services

echo ========================================
echo    RevTickets Microservices Startup
echo ========================================
echo.

REM Verify MySQL is running
echo [*] Checking MySQL connection...
mysql -u root -pabc@123 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo [X] ERROR: Cannot connect to MySQL!
    echo     Please ensure MySQL is running
    echo     Username: root
    echo     Password: abc@123
    echo.
    pause
    exit /b 1
)
echo [✓] MySQL connection verified
echo.

REM Check databases
echo [*] Verifying databases...
mysql -u root -pabc@123 -e "USE revtickets_user_db;" >nul 2>&1
if errorlevel 1 (
    echo [*] Creating databases...
    mysql -u root -pabc@123 < database-setup.sql
    if errorlevel 1 (
        echo [X] Failed to create databases
        pause
        exit /b 1
    )
    echo [✓] Databases created successfully
) else (
    echo [✓] Databases already exist
)
echo.

echo ========================================
echo    Starting Services...
echo ========================================
echo.

REM Start Eureka Server
echo [1/7] Starting Eureka Server (8761)...
cd microservices\eureka-server
start "Eureka Server - 8761" cmd /k "mvn spring-boot:run"
cd ..\..
echo       Waiting 30 seconds for Eureka...
timeout /t 30 /nobreak >nul
echo [✓] Eureka Server started
echo.

REM Start User Service
echo [2/7] Starting User Service (8081)...
cd microservices\user-service
start "User Service - 8081" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul
echo [✓] User Service started
echo.

REM Start Movie Service
echo [3/7] Starting Movie Service (8082)...
cd microservices\movie-service
start "Movie Service - 8082" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul
echo [✓] Movie Service started
echo.

REM Start Venue Service
echo [4/7] Starting Venue Service (8083)...
cd microservices\venue-service
start "Venue Service - 8083" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul
echo [✓] Venue Service started
echo.

REM Start Booking Service
echo [5/7] Starting Booking Service (8084)...
cd microservices\booking-service
start "Booking Service - 8084" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul
echo [✓] Booking Service started
echo.

REM Start Payment Service
echo [6/7] Starting Payment Service (8085)...
cd microservices\payment-service
start "Payment Service - 8085" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul
echo [✓] Payment Service started
echo.

REM Start API Gateway
echo [7/7] Starting API Gateway (9090)...
cd microservices\api-gateway
start "API Gateway - 9090" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 15 /nobreak >nul
echo [✓] API Gateway started
echo.

echo ========================================
echo    All Services Running!
echo ========================================
echo.
echo Service URLs:
echo   Eureka:    http://localhost:8761
echo   Gateway:   http://localhost:9090
echo   User:      http://localhost:8081
echo   Movie:     http://localhost:8082
echo   Venue:     http://localhost:8083
echo   Booking:   http://localhost:8084
echo   Payment:   http://localhost:8085
echo.
echo Admin Login:
echo   Email:     admin@revature.com
echo   Password:  admin@123
echo.
echo ========================================
echo.
echo To start frontend:
echo   cd frontend
echo   npm install
echo   npm start
echo.
echo Frontend will be at: http://localhost:4200
echo.
echo Press any key to open Eureka Dashboard...
pause >nul
start http://localhost:8761
