@echo off
echo ========================================
echo   COMMITTING DOCKER FIXES TO GIT
echo ========================================
echo.

echo [*] Adding all changed files...
git add .

echo [*] Committing changes...
git commit -m "Fix Docker base images - use eclipse-temurin instead of deprecated openjdk"

echo [*] Pushing to GitHub...
git push origin main

echo.
echo ========================================
echo   COMMIT COMPLETED
echo ========================================
echo.
echo Changes pushed to GitHub:
echo   ✅ All 7 Dockerfiles updated
echo   ✅ FROM openjdk:17-jdk-slim → eclipse-temurin:17-jdk-slim
echo.
echo Next: Run Jenkins pipeline again
echo.
pause