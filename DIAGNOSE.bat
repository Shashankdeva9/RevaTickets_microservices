@echo off
REM ╔════════════════════════════════════════════════════════════╗
REM ║  RevTickets - Diagnostic Check                             ║
REM ║  Run this before START.bat to verify everything is OK      ║
REM ╚════════════════════════════════════════════════════════════╝

setlocal enabledelayedexpansion

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  RevTickets - Diagnostic Check                             ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

set "all_ok=1"

REM Check Java
echo [1/6] Checking Java Installation...
java -version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Java not found!
    echo Please install Java 17 or higher
    set "all_ok=0"
) else (
    java -version 2>&1 | findstr /R "version" | head -1
    echo [✓] Java OK
)
echo.

REM Check Node.js
echo [2/6] Checking Node.js Installation...
node -v >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js not found!
    echo Please install Node.js 16 or higher
    set "all_ok=0"
) else (
    node -v
    echo [✓] Node.js OK
)
echo.

REM Check MySQL
echo [3/6] Checking MySQL (port 3306)...
netstat -ano | findstr :3306 >nul 2>&1
if errorlevel 1 (
    echo [ERROR] MySQL is not running!
    echo Please start MySQL before running START.bat
    echo Windows: Services ^> MySQL80 ^> Start
    set "all_ok=0"
) else (
    echo [✓] MySQL running on port 3306
)
echo.

REM Check MongoDB
echo [4/6] Checking MongoDB (port 27017)...
netstat -ano | findstr :27017 >nul 2>&1
if errorlevel 1 (
    echo [ERROR] MongoDB is not running!
    echo Please start MongoDB before running START.bat
    echo Windows: Services ^> MongoDB ^> Start
    set "all_ok=0"
) else (
    echo [✓] MongoDB running on port 27017
)
echo.

REM Check JAR files
echo [5/6] Checking JAR files...
set "jar_ok=1"
for %%S in (eureka-server api-gateway user-service movie-service venue-service booking-service payment-service) do (
    if not exist "microservices\%%S\target\%%S-1.0.0.jar" (
        echo [ERROR] %%S-1.0.0.jar not found!
        set "jar_ok=0"
        set "all_ok=0"
    )
)
if !jar_ok! equ 1 (
    echo [✓] All 7 microservice JARs found
) else (
    echo [ACTION] Run Maven build: mvn clean package -DskipTests
)
echo.

REM Check Frontend
echo [6/6] Checking Frontend...
if not exist "frontend\package.json" (
    echo [ERROR] Frontend package.json not found!
    set "all_ok=0"
) else (
    echo [✓] Frontend package.json found
)
echo.

REM Summary
echo ╔════════════════════════════════════════════════════════════╗
if !all_ok! equ 1 (
    echo ║  [✓] ALL CHECKS PASSED - Ready to run START.bat        ║
) else (
    echo ║  [ERROR] Some checks failed - See above for details    ║
)
echo ╚════════════════════════════════════════════════════════════╝
echo.
pause
