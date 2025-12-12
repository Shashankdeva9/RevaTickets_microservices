@echo off
REM Frontend Setup and Start Script

color 0D
title RevTickets - Frontend Setup

echo ========================================
echo    RevTickets Frontend Setup
echo ========================================
echo.

REM Check if Node.js is installed
echo [*] Checking Node.js installation...
node --version >nul 2>&1
if errorlevel 1 (
    echo [X] Node.js is NOT installed!
    echo.
    echo Please install Node.js 18+ from:
    echo https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo [✓] Node.js installed:
node --version

echo [*] Checking npm...
npm --version >nul 2>&1
if errorlevel 1 (
    echo [X] npm is NOT installed!
    pause
    exit /b 1
)

echo [✓] npm installed:
npm --version
echo.

REM Navigate to frontend directory
if not exist "frontend" (
    echo [X] Frontend directory not found!
    echo     Make sure you're running this from the project root
    pause
    exit /b 1
)

cd frontend

REM Check if node_modules exists
if exist "node_modules" (
    echo [*] Dependencies already installed
    echo.
    choice /C YN /M "Reinstall dependencies (Y/N)"
    if errorlevel 2 goto skip_install
    if errorlevel 1 goto do_install
) else (
    goto do_install
)

:do_install
echo.
echo ========================================
echo    Installing Dependencies...
echo ========================================
echo.
echo This may take a few minutes...
echo.

npm install

if errorlevel 1 (
    echo.
    echo [X] Installation failed!
    echo     Check your internet connection
    echo     or try: npm cache clean --force
    pause
    exit /b 1
)

echo.
echo [✓] Dependencies installed successfully!
echo.

:skip_install

REM Check if backend is running
echo ========================================
echo    Checking Backend Services...
echo ========================================
echo.

echo [*] Checking API Gateway (9090)...
curl -s http://localhost:9090/actuator/health >nul 2>&1
if errorlevel 1 (
    echo [!] API Gateway is NOT running!
    echo.
    echo IMPORTANT: Start backend services first!
    echo Run: START.bat (in project root)
    echo.
    choice /C YN /M "Continue anyway (Y/N)"
    if errorlevel 2 (
        echo.
        echo Exiting... Start backend first with START.bat
        pause
        exit /b 1
    )
) else (
    echo [✓] API Gateway is running
)
echo.

REM Start the development server
echo ========================================
echo    Starting Frontend Server...
echo ========================================
echo.
echo The frontend will start on: http://localhost:4200
echo.
echo Default login credentials:
echo   Email:    admin@revature.com
echo   Password: admin@123
echo.
echo Press Ctrl+C to stop the server
echo.
pause

npm start
