@echo off
REM RevTickets - Fresh Start Script
REM Cleans up databases and prepares for fresh installation

echo ========================================
echo RevTickets Fresh Start
echo ========================================
echo.
echo WARNING: This will DELETE all data!
echo.
echo This script will:
echo - Drop all RevTickets databases
echo - Recreate fresh databases
echo - Remove all users (admin will be recreated)
echo - Keep your code and configurations
echo.
set /p CONFIRM="Are you sure? Type YES to continue: "

if /i not "%CONFIRM%"=="YES" (
    echo.
    echo Operation cancelled.
    pause
    exit /b 0
)

echo.
echo Proceeding with fresh start...
echo.

REM Check MySQL connection
echo Checking MySQL connection...
mysql -u root -pabc@123 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ERROR: Cannot connect to MySQL!
    pause
    exit /b 1
)
echo ✓ MySQL connection successful
echo.

REM Drop existing databases
echo Dropping existing databases...
mysql -u root -pabc@123 -e "DROP DATABASE IF EXISTS revtickets_user_db;"
mysql -u root -pabc@123 -e "DROP DATABASE IF EXISTS revtickets_movie_db;"
mysql -u root -pabc@123 -e "DROP DATABASE IF EXISTS revtickets_venue_db;"
mysql -u root -pabc@123 -e "DROP DATABASE IF EXISTS revtickets_booking_db;"
mysql -u root -pabc@123 -e "DROP DATABASE IF EXISTS revtickets_payment_db;"
echo ✓ Old databases removed
echo.

REM Create fresh databases
echo Creating fresh databases...
mysql -u root -pabc@123 < database-setup.sql
if errorlevel 1 (
    echo ERROR: Failed to create databases!
    pause
    exit /b 1
)
echo ✓ Fresh databases created
echo.

REM Verify
echo Verifying new databases...
mysql -u root -pabc@123 -e "SHOW DATABASES LIKE 'revtickets_%%';"
echo.

echo ========================================
echo Fresh Start Complete!
echo ========================================
echo.
echo All databases have been reset to fresh state.
echo.
echo Next steps:
echo 1. Start services using start-complete-system.bat
echo 2. Admin user will be created automatically:
echo    Email: admin@revature.com
echo    Password: admin@123
echo 3. All data is fresh and empty
echo.
echo ========================================
echo.
pause
