@echo off
REM Run RevTickets application using Docker Compose
echo ========================================
echo   Starting RevTickets Application
echo ========================================
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running! Please start Docker Desktop.
    pause
    exit /b 1
)

echo [*] Stopping any existing containers...
docker-compose -f docker-compose-full.yml down
echo.

echo [*] Starting all services...
docker-compose -f docker-compose-full.yml up -d
echo.

echo [*] Waiting for services to start...
timeout /t 60 /nobreak
echo.

echo ========================================
echo   Application Started!
echo ========================================
echo.
echo Services are available at:
echo   - Frontend:        http://localhost:4200
echo   - API Gateway:     http://localhost:9090
echo   - Eureka Dashboard: http://localhost:8761
echo   - MySQL:           localhost:3306
echo   - MongoDB:         localhost:27017
echo.
echo To view logs:
echo   docker-compose -f docker-compose-full.yml logs -f
echo.
echo To stop all services:
echo   docker-compose -f docker-compose-full.yml down
echo.
pause
