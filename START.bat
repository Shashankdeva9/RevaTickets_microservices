@echo off
REM RevTickets - Single Click Start
REM Starts all backend services and frontend

title RevTickets - Starting...

echo.
echo ========================================
echo    RevTickets - Starting System
echo ========================================
echo.

REM Check MySQL
echo Checking MySQL...
mysql -u root -pabc@123 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] MySQL not accessible!
    echo Please ensure MySQL is running with credentials: root/abc@123
    pause
    exit /b 1
)
echo [OK] MySQL connection verified
echo.

REM Check and create databases if needed
mysql -u root -pabc@123 -e "USE revtickets_user_db;" >nul 2>&1
if errorlevel 1 (
    echo Creating databases...
    mysql -u root -pabc@123 < database-setup.sql
    echo [OK] Databases created
) else (
    echo [OK] Databases exist
)
echo.

echo Starting services...
echo.

REM Start Eureka Server
echo [1/8] Starting Eureka Server...
cd microservices\eureka-server
start /MIN "Eureka-8761" cmd /c "mvn spring-boot:run"
cd ..\..
timeout /t 30 /nobreak >nul

REM Start User Service
echo [2/8] Starting User Service...
cd microservices\user-service
start /MIN "User-8081" cmd /c "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul

REM Start Movie Service
echo [3/8] Starting Movie Service...
cd microservices\movie-service
start /MIN "Movie-8082" cmd /c "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul

REM Start Venue Service
echo [4/8] Starting Venue Service...
cd microservices\venue-service
start /MIN "Venue-8083" cmd /c "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul

REM Start Booking Service
echo [5/8] Starting Booking Service...
cd microservices\booking-service
start /MIN "Booking-8084" cmd /c "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul

REM Start Payment Service
echo [6/8] Starting Payment Service...
cd microservices\payment-service
start /MIN "Payment-8085" cmd /c "mvn spring-boot:run"
cd ..\..
timeout /t 10 /nobreak >nul

REM Start API Gateway
echo [7/8] Starting API Gateway...
cd microservices\api-gateway
start /MIN "Gateway-9090" cmd /c "mvn spring-boot:run"
cd ..\..
timeout /t 15 /nobreak >nul

REM Start Frontend
echo [8/8] Starting Frontend...
cd frontend
start /MIN "Frontend-4200" cmd /c "npm install && npm start"
cd ..

echo.
echo ========================================
echo    All Services Started!
echo ========================================
echo.
echo Services running:
echo   - Eureka Server:  http://localhost:8761
echo   - API Gateway:    http://localhost:9090
echo   - Frontend:       http://localhost:4200
echo.
echo Admin Login:
echo   Email:    admin@revature.com
echo   Password: admin@123
echo.
echo Opening application in browser...
timeout /t 10 /nobreak >nul
start http://localhost:4200
echo.
echo Use STOP.bat to shut down all services.
echo.
pause
