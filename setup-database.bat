@echo off
REM RevTickets Database Setup Script
REM This script sets up all required MySQL databases

echo ========================================
echo RevTickets Database Setup
echo ========================================
echo.
echo MySQL Credentials:
echo Username: root
echo Password: abc@123
echo.
echo This will create the following databases:
echo - revtickets_user_db
echo - revtickets_movie_db
echo - revtickets_venue_db
echo - revtickets_booking_db
echo - revtickets_payment_db
echo.
echo ========================================
echo.

REM Check if MySQL is accessible
echo Checking MySQL connection...
mysql -u root -pabc@123 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ERROR: Cannot connect to MySQL!
    echo Please ensure:
    echo 1. MySQL is running
    echo 2. Username is 'root'
    echo 3. Password is 'abc@123'
    echo.
    pause
    exit /b 1
)

echo ✓ MySQL connection successful!
echo.

REM Run the database setup script
echo Creating databases...
mysql -u root -pabc@123 < database-setup.sql

if errorlevel 1 (
    echo ERROR: Failed to create databases!
    pause
    exit /b 1
)

echo ✓ Databases created successfully!
echo.

REM Verify databases
echo Verifying databases...
mysql -u root -pabc@123 -e "SHOW DATABASES LIKE 'revtickets_%%';"

echo.
echo ========================================
echo Database Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Start Eureka Server
echo 2. Start all microservices using start-all-services.bat
echo 3. Admin user will be created automatically on first run
echo    Email: admin@revature.com
echo    Password: admin@123
echo.
pause
