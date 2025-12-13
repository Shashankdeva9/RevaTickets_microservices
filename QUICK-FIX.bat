@echo off
REM Quick Fix for Eureka Connection Issues
color 0C
title RevTickets - Quick Fix

echo ========================================
echo    RevTickets Quick Fix
echo ========================================
echo.
echo This will:
echo 1. Kill any existing Java processes
echo 2. Start Eureka Server first
echo 3. Wait for proper startup
echo 4. Start other services in sequence
echo.
pause

echo [*] Killing existing Java processes...
taskkill /f /im java.exe >nul 2>&1
timeout /t 3 /nobreak >nul

echo [*] Starting Eureka Server...
cd microservices\eureka-server
start "Eureka Server - 8761" cmd /k "mvn spring-boot:run"
cd ..\..

echo [*] Waiting 45 seconds for Eureka to fully start...
timeout /t 45 /nobreak >nul

echo [*] Testing Eureka connection...
curl -s http://localhost:8761 >nul 2>&1
if errorlevel 1 (
    echo [X] Eureka still not responding. Please check manually.
    echo     Open: http://localhost:8761
    pause
    exit /b 1
)

echo [✓] Eureka is running! Starting other services...
echo.

REM Start other services with delays
echo [*] Starting User Service...
cd microservices\user-service
start "User Service - 8081" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 15 /nobreak >nul

echo [*] Starting Movie Service...
cd microservices\movie-service
start "Movie Service - 8082" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 15 /nobreak >nul

echo [*] Starting Venue Service...
cd microservices\venue-service
start "Venue Service - 8083" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 15 /nobreak >nul

echo [*] Starting Booking Service...
cd microservices\booking-service
start "Booking Service - 8084" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 15 /nobreak >nul

echo [*] Starting Payment Service...
cd microservices\payment-service
start "Payment Service - 8085" cmd /k "mvn spring-boot:run"
cd ..\..
timeout /t 15 /nobreak >nul

echo [*] Starting API Gateway...
cd microservices\api-gateway
start "API Gateway - 9090" cmd /k "mvn spring-boot:run"
cd ..\..

echo.
echo ========================================
echo    Services Starting...
echo ========================================
echo.
echo Wait 2-3 minutes for all services to register.
echo Then check Eureka Dashboard: http://localhost:8761
echo.
echo All services should appear as registered.
echo Frontend will be available at: http://localhost:4200
echo.
pause