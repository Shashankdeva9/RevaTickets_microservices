@echo off
REM Quick Service Health Check

color 0E
title RevTickets - Service Health Check

echo ========================================
echo    RevTickets Service Health Check
echo ========================================
echo.

echo Checking service endpoints...
echo.

echo [*] Eureka Server (8761)...
curl -s http://localhost:8761/actuator/health >nul 2>&1
if errorlevel 1 (
    echo [X] Eureka Server NOT responding
) else (
    echo [✓] Eureka Server OK
)

echo [*] API Gateway (9090)...
curl -s http://localhost:9090/actuator/health >nul 2>&1
if errorlevel 1 (
    echo [X] API Gateway NOT responding
) else (
    echo [✓] API Gateway OK
)

echo [*] User Service (8081)...
curl -s http://localhost:8081/actuator/health >nul 2>&1
if errorlevel 1 (
    echo [X] User Service NOT responding
) else (
    echo [✓] User Service OK
)

echo [*] Movie Service (8082)...
curl -s http://localhost:8082/actuator/health >nul 2>&1
if errorlevel 1 (
    echo [X] Movie Service NOT responding
) else (
    echo [✓] Movie Service OK
)

echo [*] Venue Service (8083)...
curl -s http://localhost:8083/actuator/health >nul 2>&1
if errorlevel 1 (
    echo [X] Venue Service NOT responding
) else (
    echo [✓] Venue Service OK
)

echo [*] Booking Service (8084)...
curl -s http://localhost:8084/actuator/health >nul 2>&1
if errorlevel 1 (
    echo [X] Booking Service NOT responding
) else (
    echo [✓] Booking Service OK
)

echo [*] Payment Service (8085)...
curl -s http://localhost:8085/actuator/health >nul 2>&1
if errorlevel 1 (
    echo [X] Payment Service NOT responding
) else (
    echo [✓] Payment Service OK
)

echo [*] Frontend (4200)...
curl -s http://localhost:4200 >nul 2>&1
if errorlevel 1 (
    echo [X] Frontend NOT responding
) else (
    echo [✓] Frontend OK
)

echo.
echo ========================================
echo.
echo To view Eureka Dashboard: http://localhost:8761
echo To view Frontend: http://localhost:4200
echo.
pause
