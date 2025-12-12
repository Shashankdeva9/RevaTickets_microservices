@echo off
echo ========================================
echo   Jenkins Pipeline Fix Script
echo ========================================
echo.

echo [*] This script will help fix your Jenkins pipeline issues
echo.

echo Issues identified:
echo 1. Jenkinsfile uses 'sh' commands (Linux) instead of 'bat' (Windows)
echo 2. Docker registry placeholder needs your Docker Hub username
echo 3. Missing Docker Hub credentials in Jenkins
echo.

echo Solutions provided:
echo 1. Created Jenkinsfile-Windows (Windows-compatible)
echo 2. Created Jenkinsfile-Simple-Windows (simplified version)
echo 3. Updated Docker registry to 'shashankdeva9'
echo.

echo Next steps:
echo 1. In Jenkins, update your pipeline to use 'Jenkinsfile-Windows'
echo 2. Add Docker Hub credentials in Jenkins:
echo    - Go to Manage Jenkins > Credentials
echo    - Add Username/Password credential
echo    - ID: docker-hub-credentials
echo    - Username: your Docker Hub username
echo    - Password: your Docker Hub password
echo.
echo 3. Test locally first with: build-and-push-docker.bat
echo.

echo [*] Testing local Docker build capability...
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running! Start Docker Desktop first.
) else (
    echo [OK] Docker is running
)

echo.
echo [*] Testing Maven availability...
mvn --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Maven not found in PATH
) else (
    echo [OK] Maven is available
)

echo.
echo [*] Checking if JAR files exist...
if exist "microservices\eureka-server\target\*.jar" (
    echo [OK] Eureka Server JAR exists
) else (
    echo [WARN] Eureka Server JAR missing - run Maven build first
)

if exist "microservices\api-gateway\target\*.jar" (
    echo [OK] API Gateway JAR exists
) else (
    echo [WARN] API Gateway JAR missing - run Maven build first
)

echo.
echo ========================================
echo   Quick Test Commands
echo ========================================
echo.
echo To test locally before Jenkins:
echo 1. build-and-push-docker.bat [your-docker-username]
echo 2. docker-compose -f docker-compose-full.yml up -d
echo.
echo To use in Jenkins:
echo 1. Use 'Jenkinsfile-Windows' or 'Jenkinsfile-Simple-Windows'
echo 2. Update DOCKER_REGISTRY to your Docker Hub username
echo 3. Add docker-hub-credentials in Jenkins
echo.

pause