@echo off
REM ╔════════════════════════════════════════════════════════════╗
REM ║  RevTickets - Stop All Services                            ║
REM ║  Stops: 7 Microservices + Frontend                         ║
REM ╚════════════════════════════════════════════════════════════╝

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  Stopping All RevTickets Services...                      ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Kill all Java processes
echo [*] Stopping Java services...
taskkill /F /IM java.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] Java services stopped
) else (
    echo [*] No Java services running
)

REM Kill all Node processes
echo [*] Stopping Node services...
taskkill /F /IM node.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] Node services stopped
) else (
    echo [*] No Node services running
)

REM Close command windows
echo [*] Closing service windows...
taskkill /F /FI "WINDOWTITLE eq Eureka*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq API*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq User*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Movie*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Venue*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Booking*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Payment*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Angular*" >nul 2>&1

timeout /t 2 /nobreak >nul

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  All RevTickets services stopped successfully!            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
pause
