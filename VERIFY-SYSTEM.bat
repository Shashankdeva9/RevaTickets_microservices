@echo off
REM RevTickets - Complete System Setup Script
REM Verifies all prerequisites and configurations

color 0B
title RevTickets - System Setup & Verification

echo ========================================
echo    RevTickets System Setup
echo ========================================
echo.
echo This script will verify:
echo   [1] MySQL Installation and Connection
echo   [2] MongoDB Installation (for Reviews)
echo   [3] Database Creation
echo   [4] JDK and Maven Installation
echo   [5] Node.js and npm Installation
echo.
pause
echo.

REM ===================================
REM Check MySQL
REM ===================================
echo [1/5] Checking MySQL...
mysql --version >nul 2>&1
if errorlevel 1 (
    echo [X] MySQL not found in PATH
    echo     Please install MySQL 8.0+ and add to PATH
    echo     Download: https://dev.mysql.com/downloads/installer/
    set MYSQL_OK=0
) else (
    echo [✓] MySQL found
    echo [*] Testing connection...
    mysql -u root -pabc@123 -e "SELECT 1;" >nul 2>&1
    if errorlevel 1 (
        echo [X] Cannot connect to MySQL
        echo     Please ensure MySQL is running
        echo     Username: root
        echo     Password: abc@123
        set MYSQL_OK=0
    ) else (
        echo [✓] MySQL connection successful
        set MYSQL_OK=1
    )
)
echo.

REM ===================================
REM Check MongoDB
REM ===================================
echo [2/5] Checking MongoDB...
mongod --version >nul 2>&1
if errorlevel 1 (
    echo [!] MongoDB not found
    echo     MongoDB is REQUIRED for movie reviews feature
    echo     Download: https://www.mongodb.com/try/download/community
    echo.
    echo     Quick Install:
    echo     1. Download MongoDB Community Server
    echo     2. Install with default settings
    echo     3. MongoDB runs automatically as a service
    set MONGO_OK=0
) else (
    echo [✓] MongoDB found
    echo [*] Checking MongoDB service...
    sc query MongoDB >nul 2>&1
    if errorlevel 1 (
        echo [!] MongoDB service not running
        echo     Start it with: net start MongoDB
        set MONGO_OK=0
    ) else (
        echo [✓] MongoDB service is running
        set MONGO_OK=1
    )
)
echo.

REM ===================================
REM Create/Verify Databases
REM ===================================
if "%MYSQL_OK%"=="1" (
    echo [3/5] Setting up MySQL databases...
    mysql -u root -pabc@123 -e "USE revtickets_user_db;" >nul 2>&1
    if errorlevel 1 (
        echo [*] Creating databases...
        mysql -u root -pabc@123 < database-setup.sql
        if errorlevel 1 (
            echo [X] Failed to create databases
        ) else (
            echo [✓] All databases created successfully
        )
    ) else (
        echo [✓] Databases already exist
    )
) else (
    echo [3/5] Skipping database setup - MySQL not available
)
echo.

REM ===================================
REM Check JDK
REM ===================================
echo [4/5] Checking Java Development Kit...
java -version >nul 2>&1
if errorlevel 1 (
    echo [X] JDK not found
    echo     Install JDK 17 or higher
    echo     Download: https://adoptium.net/
    set JDK_OK=0
) else (
    java -version 2>&1 | findstr /i "version" 
    echo [✓] JDK found
    set JDK_OK=1
)
echo.
echo [*] Checking Maven...
mvn -version >nul 2>&1
if errorlevel 1 (
    echo [X] Maven not found
    echo     Install Maven 3.6+
    echo     Download: https://maven.apache.org/download.cgi
    set MAVEN_OK=0
) else (
    mvn -version | findstr /i "Maven"
    echo [✓] Maven found
    set MAVEN_OK=1
)
echo.

REM ===================================
REM Check Node.js
REM ===================================
echo [5/5] Checking Node.js and npm...
node --version >nul 2>&1
if errorlevel 1 (
    echo [X] Node.js not found
    echo     Install Node.js 18+
    echo     Download: https://nodejs.org/
    set NODE_OK=0
) else (
    node --version
    echo [✓] Node.js found
    set NODE_OK=1
)
echo.
npm --version >nul 2>&1
if errorlevel 1 (
    echo [X] npm not found
    set NPM_OK=0
) else (
    echo [✓] npm version:
    npm --version
    set NPM_OK=1
)
echo.

REM ===================================
REM Summary
REM ===================================
echo ========================================
echo    Setup Summary
echo ========================================
echo.
if "%MYSQL_OK%"=="1" (echo [✓] MySQL Ready) else (echo [X] MySQL NOT Ready)
if "%MONGO_OK%"=="1" (echo [✓] MongoDB Ready) else (echo [X] MongoDB NOT Ready)
if "%JDK_OK%"=="1" (echo [✓] JDK Ready) else (echo [X] JDK NOT Ready)
if "%MAVEN_OK%"=="1" (echo [✓] Maven Ready) else (echo [X] Maven NOT Ready)
if "%NODE_OK%"=="1" (echo [✓] Node.js Ready) else (echo [X] Node.js NOT Ready)
if "%NPM_OK%"=="1" (echo [✓] npm Ready) else (echo [X] npm NOT Ready)
echo.

if "%MYSQL_OK%%MONGO_OK%%JDK_OK%%MAVEN_OK%%NODE_OK%%NPM_OK%"=="111111" (
    echo ========================================
    echo    ✓ ALL SYSTEMS READY!
    echo ========================================
    echo.
    echo You can now start the application:
    echo   1. Run: START.bat
    echo   2. Wait for all services to start
    echo   3. Open new terminal and run:
    echo      cd frontend
    echo      npm install
    echo      npm start
    echo   4. Access: http://localhost:4200
    echo.
) else (
    echo ========================================
    echo    ⚠ SETUP INCOMPLETE
    echo ========================================
    echo.
    echo Please install the missing components above
    echo Then run this script again to verify
    echo.
)

pause
