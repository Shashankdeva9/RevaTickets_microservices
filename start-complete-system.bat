@echo off
REM RevTickets - Complete Startup Script
REM Starts all services in the correct order with proper delays

echo ========================================
echo RevTickets Complete Startup
echo ========================================
echo.
echo This script will start:
echo 1. Eureka Server (Service Discovery)
echo 2. All Microservices
echo 3. API Gateway
echo.
echo Make sure MySQL is running with:
echo - Username: root
echo - Password: abc@123
echo.
echo ========================================
echo.

REM Verify MySQL connection
echo Checking MySQL connection...
mysql -u root -pabc@123 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ERROR: Cannot connect to MySQL!
    echo Please ensure MySQL is running and password is abc@123
    pause
    exit /b 1
)
echo ✓ MySQL connection verified
echo.

REM Check if databases exist
echo Checking databases...
set DB_EXISTS=0
mysql -u root -pabc@123 -e "USE revtickets_user_db;" >nul 2>&1
if not errorlevel 1 set DB_EXISTS=1

if !DB_EXISTS! EQU 0 (
    echo Databases not found. Creating them now...
    mysql -u root -pabc@123 < database-setup.sql
    echo ✓ Databases created
) else (
    echo ✓ Databases already exist
)
echo.

echo ========================================
echo Starting Services...
echo ========================================
echo.

REM Step 1: Start Eureka Server
echo [1/7] Starting Eureka Server on port 8761...
cd microservices\eureka-server
start "Eureka Server" cmd /k "mvn spring-boot:run"
cd ..\..
echo Waiting for Eureka Server to start (30 seconds)...
timeout /t 30 /nobreak >nul
echo ✓ Eureka Server started
echo.

REM Step 2: Start User Service
echo [2/7] Starting User Service on port 8081...
cd microservices\user-service
start "User Service" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul
echo ✓ User Service started
echo.

REM Step 3: Start Movie Service
echo [3/7] Starting Movie Service on port 8082...
cd microservices\movie-service
start "Movie Service" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul
echo ✓ Movie Service started
echo.

REM Step 4: Start Venue Service
echo [4/7] Starting Venue Service on port 8083...
cd microservices\venue-service
start "Venue Service" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul
echo ✓ Venue Service started
echo.

REM Step 5: Start Booking Service
echo [5/7] Starting Booking Service on port 8084...
cd microservices\booking-service
start "Booking Service" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul
echo ✓ Booking Service started
echo.

REM Step 6: Start Payment Service
echo [6/7] Starting Payment Service on port 8085...
cd microservices\payment-service
start "Payment Service" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul
echo ✓ Payment Service started
echo.

REM Step 7: Start API Gateway
echo [7/7] Starting API Gateway on port 8080...
cd microservices\api-gateway
start "API Gateway" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 15 /nobreak >nul
echo ✓ API Gateway started
echo.

echo ========================================
echo All Services Started!
echo ========================================
echo.
echo Service URLs:
echo - Eureka Dashboard: http://localhost:8761
echo - API Gateway: http://localhost:8080
echo - User Service: http://localhost:8081
echo - Movie Service: http://localhost:8082
echo - Venue Service: http://localhost:8083
echo - Booking Service: http://localhost:8084
echo - Payment Service: http://localhost:8085
echo.
echo Default Admin Credentials:
echo - Email: admin@revature.com
echo - Password: admin@123
echo.
echo To start the frontend:
echo   cd frontend
echo   npm install
echo   npm start
echo.
echo Then access: http://localhost:4200
echo.
echo ========================================
echo.
echo Press any key to open Eureka Dashboard...
pause >nul
start http://localhost:8761
