@echo off
REM RevTickets - Single Click Stop
REM Stops all backend services and frontend

title RevTickets - Stopping...

echo.
echo ========================================
echo    RevTickets - Stopping System
echo ========================================
echo.

echo Stopping all services...
echo.

REM Kill all Java processes (Spring Boot services)
echo [1/2] Stopping backend services...
taskkill /F /FI "WINDOWTITLE eq Eureka-8761*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq User-8081*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Movie-8082*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Venue-8083*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Booking-8084*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Payment-8085*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Gateway-9090*" >nul 2>&1

REM Also kill by port if windows are renamed
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8761') do taskkill /F /PID %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :9090') do taskkill /F /PID %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8081') do taskkill /F /PID %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8082') do taskkill /F /PID %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8083') do taskkill /F /PID %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8084') do taskkill /F /PID %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8085') do taskkill /F /PID %%a >nul 2>&1

echo [OK] Backend services stopped
echo.

REM Kill frontend (Node.js)
echo [2/2] Stopping frontend...
taskkill /F /FI "WINDOWTITLE eq Frontend-4200*" >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :4200') do taskkill /F /PID %%a >nul 2>&1
echo [OK] Frontend stopped
echo.

echo ========================================
echo    All Services Stopped!
echo ========================================
echo.
echo All RevTickets services have been stopped.
echo Use START.bat to restart the system.
echo.
pause
