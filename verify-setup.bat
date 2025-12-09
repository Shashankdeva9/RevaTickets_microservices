@echo off
REM RevTickets System Verification Script
REM Checks if all components are properly configured

setlocal enabledelayedexpansion
set ERROR_COUNT=0

echo ========================================
echo RevTickets System Verification
echo ========================================
echo.

REM Check 1: MySQL Connection
echo [1/7] Checking MySQL connection...
mysql -u root -pabc@123 -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ✗ FAILED: Cannot connect to MySQL with root/abc@123
    set /a ERROR_COUNT+=1
) else (
    echo ✓ PASSED: MySQL connection successful
)
echo.

REM Check 2: Database Schemas
echo [2/7] Checking database schemas...
set DB_COUNT=0
for %%D in (revtickets_user_db revtickets_movie_db revtickets_venue_db revtickets_booking_db revtickets_payment_db) do (
    mysql -u root -pabc@123 -e "USE %%D;" >nul 2>&1
    if not errorlevel 1 (
        set /a DB_COUNT+=1
    ) else (
        echo ✗ Missing database: %%D
        set /a ERROR_COUNT+=1
    )
)
if !DB_COUNT! EQU 5 (
    echo ✓ PASSED: All 5 databases exist
) else (
    echo ✗ FAILED: Only !DB_COUNT!/5 databases found
)
echo.

REM Check 3: Application Properties Files
echo [3/7] Checking application.properties files...
set PROPS_OK=1
for %%S in (user-service movie-service venue-service booking-service payment-service) do (
    if not exist "microservices\%%S\src\main\resources\application.properties" (
        echo ✗ Missing: %%S application.properties
        set PROPS_OK=0
        set /a ERROR_COUNT+=1
    )
)
if !PROPS_OK! EQU 1 (
    echo ✓ PASSED: All application.properties files exist
)
echo.

REM Check 4: Database Credentials in Properties
echo [4/7] Checking database credentials...
findstr /C:"password=abc@123" microservices\user-service\src\main\resources\application.properties >nul 2>&1
if errorlevel 1 (
    echo ✗ FAILED: Password not updated to abc@123
    set /a ERROR_COUNT+=1
) else (
    echo ✓ PASSED: Database credentials configured correctly
)
echo.

REM Check 5: Frontend Environment Configuration
echo [5/7] Checking frontend configuration...
if exist "frontend\src\environments\environment.ts" (
    findstr /C:"localhost:8080/api" frontend\src\environments\environment.ts >nul 2>&1
    if errorlevel 1 (
        echo ✗ FAILED: Frontend not configured to use API Gateway
        set /a ERROR_COUNT+=1
    ) else (
        echo ✓ PASSED: Frontend configured to use API Gateway
    )
) else (
    echo ✗ FAILED: Frontend environment file not found
    set /a ERROR_COUNT+=1
)
echo.

REM Check 6: Media Folders
echo [6/7] Checking media folders...
set MEDIA_OK=1
if not exist "microservices\movie-service\public\banner" (
    echo ✗ Missing: banner folder
    set MEDIA_OK=0
    set /a ERROR_COUNT+=1
)
if not exist "microservices\movie-service\public\display" (
    echo ✗ Missing: display folder
    set MEDIA_OK=0
    set /a ERROR_COUNT+=1
)
if !MEDIA_OK! EQU 1 (
    echo ✓ PASSED: Media folders exist
)
echo.

REM Check 7: DataSeeder Component
echo [7/7] Checking DataSeeder component...
if exist "microservices\user-service\src\main\java\com\revature\userservice\config\DataSeeder.java" (
    echo ✓ PASSED: DataSeeder component exists
) else (
    echo ✗ FAILED: DataSeeder component not found
    set /a ERROR_COUNT+=1
)
echo.

echo ========================================
echo Verification Summary
echo ========================================
if !ERROR_COUNT! EQU 0 (
    echo.
    echo ✓✓✓ ALL CHECKS PASSED! ✓✓✓
    echo.
    echo Your system is properly configured.
    echo.
    echo Next Steps:
    echo 1. Run setup-database.bat to initialize databases
    echo 2. Start services using start-all-services.bat
    echo 3. Access the app at http://localhost:4200
    echo 4. Login with admin@revature.com / admin@123
    echo.
) else (
    echo.
    echo ✗✗✗ FOUND !ERROR_COUNT! ERROR(S) ✗✗✗
    echo.
    echo Please fix the errors above before proceeding.
    echo Refer to SETUP.md for detailed instructions.
    echo.
)
echo ========================================
echo.
pause
