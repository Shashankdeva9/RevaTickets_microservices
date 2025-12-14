@echo off
REM ╔════════════════════════════════════════════════════════════╗
REM ║  RevTickets - Test Single Service                          ║
REM ║  Use this to verify one service works before starting all  ║
REM ╚════════════════════════════════════════════════════════════╝

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  Testing Eureka Server (8761)                             ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Kill any existing Java processes
echo [*] Cleaning up existing Java processes...
taskkill /F /IM java.exe >nul 2>&1
timeout /t 2 /nobreak >nul

REM Check if databases are running
echo [*] Checking databases...
netstat -ano | findstr :3306 >nul 2>&1
if errorlevel 1 (
    echo [ERROR] MySQL is not running on port 3306!
    pause
    exit /b 1
)
echo [✓] MySQL running

netstat -ano | findstr :27017 >nul 2>&1
if errorlevel 1 (
    echo [ERROR] MongoDB is not running on port 27017!
    pause
    exit /b 1
)
echo [✓] MongoDB running
echo.

REM Test Eureka
echo [*] Starting Eureka Server (8761)...
echo [*] This will run in a new window - keep it open to test
echo.
pause
echo Starting...

cd /d "%~dp0"
start "Eureka Test" cmd /k "cd /d %cd%\microservices\eureka-server && echo Starting Eureka... && java -jar target\eureka-server-1.0.0.jar"

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  Eureka Server starting...                                ║
echo ║  Check the new window for logs                            ║
echo ║  Wait 30 seconds then access: http://localhost:8761      ║
echo ║                                                            ║
echo ║  If it works, all services should work!                   ║
echo ║  Then you can run START.bat to start everything          ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
pause
