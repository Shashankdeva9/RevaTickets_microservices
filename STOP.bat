@echo off
REM RevTickets - Stop All Services Script
REM Terminates all running microservices

color 0C
title RevTickets - Stopping Services

echo ========================================
echo    RevTickets - Stop All Services
echo ========================================
echo.
echo This will stop all running microservices
echo.
pause

echo.
echo [*] Stopping all Java processes (Spring Boot services)...
echo.

REM Kill all Java processes (Spring Boot applications)
taskkill /F /IM java.exe >nul 2>&1
if errorlevel 1 (
    echo [!] No Java processes found running
) else (
    echo [✓] All Java processes stopped
)

echo.
echo [*] Stopping Node.js processes (Angular frontend)...
echo.

REM Kill Node.js processes (Angular dev server)
taskkill /F /IM node.exe >nul 2>&1
if errorlevel 1 (
    echo [!] No Node.js processes found running
) else (
    echo [✓] All Node.js processes stopped
)

echo.
echo ========================================
echo    All Services Stopped
echo ========================================
echo.
echo The following have been terminated:
echo   [X] Eureka Server (8761)
echo   [X] API Gateway (9090)
echo   [X] User Service (8081)
echo   [X] Movie Service (8082)
echo   [X] Venue Service (8083)
echo   [X] Booking Service (8084)
echo   [X] Payment Service (8085)
echo   [X] Angular Frontend (4200)
echo.
echo All service windows have been closed.
echo.
echo To restart services, run: START.bat
echo.
pause
