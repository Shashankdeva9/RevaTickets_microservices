@echo off
REM ╔════════════════════════════════════════════════════════════╗
REM ║  RevTickets - Start All Services (Local Mode)             ║
REM ║  Starts: 7 Microservices + Frontend                       ║
REM ╚════════════════════════════════════════════════════════════╝

setlocal enabledelayedexpansion

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  Starting RevTickets Services...                           ║
echo ║  Eureka + API Gateway + 5 Services + Frontend             ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Kill any existing Java and Node processes
echo [*] Cleaning up existing processes...
taskkill /F /IM java.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1
timeout /t 2 /nobreak >nul

REM Verify databases are running
echo [*] Checking databases...
netstat -ano | findstr :3306 >nul 2>&1
if errorlevel 1 (
    echo [ERROR] MySQL is not running on port 3306!
    echo Please start MySQL before running this script.
    pause
    exit /b 1
)
echo [✓] MySQL running

netstat -ano | findstr :27017 >nul 2>&1
if errorlevel 1 (
    echo [ERROR] MongoDB is not running on port 27017!
    echo Please start MongoDB before running this script.
    pause
    exit /b 1
)
echo [✓] MongoDB running
echo.

REM Change to project root directory
cd /d "%~dp0"

REM Start Eureka Server
echo [1/8] Starting Eureka Server (8761)...
start "Eureka Server" cmd /k "cd /d %cd%\microservices\eureka-server && java -jar target\eureka-server-1.0.0.jar"
timeout /t 5 /nobreak >nul

REM Start API Gateway
echo [2/8] Starting API Gateway (8080)...
start "API Gateway" cmd /k "cd /d %cd%\microservices\api-gateway && java -jar target\api-gateway-1.0.0.jar"
timeout /t 5 /nobreak >nul

REM Start User Service
echo [3/8] Starting User Service (8081)...
start "User Service" cmd /k "cd /d %cd%\microservices\user-service && java -jar target\user-service-1.0.0.jar"
timeout /t 3 /nobreak >nul

REM Start Movie Service
echo [4/8] Starting Movie Service (8082)...
start "Movie Service" cmd /k "cd /d %cd%\microservices\movie-service && java -jar target\movie-service-1.0.0.jar"
timeout /t 3 /nobreak >nul

REM Start Venue Service
echo [5/8] Starting Venue Service (8083)...
start "Venue Service" cmd /k "cd /d %cd%\microservices\venue-service && java -jar target\venue-service-1.0.0.jar"
timeout /t 3 /nobreak >nul

REM Start Booking Service
echo [6/8] Starting Booking Service (8084)...
start "Booking Service" cmd /k "cd /d %cd%\microservices\booking-service && java -jar target\booking-service-1.0.0.jar"
timeout /t 3 /nobreak >nul

REM Start Payment Service
echo [7/8] Starting Payment Service (8085)...
start "Payment Service" cmd /k "cd /d %cd%\microservices\payment-service && java -jar target\payment-service-1.0.0.jar"
timeout /t 3 /nobreak >nul

REM Start Frontend
echo [8/8] Starting Angular Frontend (4200)...
start "Angular Frontend" cmd /k "cd /d %cd%\frontend && npm install && ng serve --host 0.0.0.0 --port 4200"

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  All services starting in separate windows...             ║
echo ║                                                            ║
echo ║  Eureka:    http://localhost:8761                         ║
echo ║  API Gateway: http://localhost:8080                       ║
echo ║  Frontend:  http://localhost:4200                         ║
echo ║                                                            ║
echo ║  Close any window to stop that service                    ║
echo ║  Run STOP.bat to stop all services at once               ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
pause
