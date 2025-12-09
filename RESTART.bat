@echo off
REM RevTickets - Single Click Restart
REM Stops all services and starts them again

title RevTickets - Restarting...

echo.
echo ========================================
echo    RevTickets - Restarting System
echo ========================================
echo.

echo Stopping all services...
call STOP.bat

echo.
echo Waiting 5 seconds...
timeout /t 5 /nobreak >nul

echo.
echo Starting all services...
call START.bat
