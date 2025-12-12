@echo off
REM Stop all RevTickets Docker containers
echo ========================================
echo   Stopping RevTickets Application
echo ========================================
echo.

docker-compose -f docker-compose-full.yml down

echo.
echo All containers stopped!
echo.
pause
