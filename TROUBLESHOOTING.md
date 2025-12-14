# 🔧 Troubleshooting - Services Not Running

## Quick Fix Checklist

### Step 1: Prerequisites Check
```
✓ MySQL running on port 3306
✓ MongoDB running on port 27017
✓ Java 17+ installed
✓ Node.js 16+ installed
```

**Run:** `DIAGNOSE.bat` to verify all prerequisites

### Step 2: Test Single Service First
```
Run: TEST-EUREKA.bat
Wait: 30-60 seconds
Access: http://localhost:8761
```

If Eureka works, all services should work!

---

## Common Issues & Solutions

### Issue 1: "MySQL is not running"
**Error:** `MySQL is not running on port 3306!`

**Solution:**
1. Open Windows Services (services.msc)
2. Find "MySQL80" or similar
3. Click "Start" if it's stopped
4. Or start MySQL manually from Command Prompt:
   ```cmd
   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe"
   ```

### Issue 2: "MongoDB is not running"
**Error:** `MongoDB is not running on port 27017!`

**Solution:**
1. Open Windows Services (services.msc)
2. Find "MongoDB" service
3. Click "Start" if it's stopped
4. Or start MongoDB manually:
   ```cmd
   mongod --dbpath "C:\data\db"
   ```

### Issue 3: Java Not Found
**Error:** `'java' is not recognized`

**Solution:**
1. Install Java 17 LTS from: https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html
2. Add to PATH:
   - Right-click "This PC" > Properties
   - Advanced system settings > Environment Variables
   - Add Java bin folder to PATH
3. Restart Command Prompt and try again

### Issue 4: Node.js Not Found
**Error:** `'node' is not recognized`

**Solution:**
1. Install Node.js from: https://nodejs.org/ (LTS version)
2. Restart Command Prompt
3. Verify: `node -v` and `npm -v`

### Issue 5: Ports Already in Use
**Error:** `Address already in use` or `Port is being used by another application`

**Solution - Option A: Kill existing processes**
```cmd
taskkill /F /IM java.exe
taskkill /F /IM node.exe
```

**Solution - Option B: Change ports**
Edit `microservices/*/src/main/resources/application.yml` and change ports.

### Issue 6: JAR Files Not Found
**Error:** `Cannot find file: target\eureka-server-1.0.0.jar`

**Solution:**
Build all services with Maven:
```cmd
cd microservices\eureka-server
mvn clean package -DskipTests
cd ..\api-gateway
mvn clean package -DskipTests
REM ... repeat for all services
```

Or use Maven from project root:
```cmd
mvn clean package -DskipTests -DdontSkipTests
```

### Issue 7: Services Start but Exit Immediately
**Error:** Service windows close right away

**Solution:**
1. Run `TEST-EUREKA.bat` to see actual error messages
2. Check if databases are running
3. Check if all required properties are set in `application.yml`
4. Common causes:
   - MySQL/MongoDB not running
   - Database connection strings wrong
   - Port already in use
   - Insufficient disk space

### Issue 8: Service Starts but Shows Connection Errors
**Error:** `Connection refused` or `Cannot connect to database`

**Solution:**
1. Verify MySQL is running: `mysql -u root -pabc@123`
2. Verify MongoDB is running: `mongosh`
3. Check database credentials in `application.yml`:
   ```yaml
   spring:
     datasource:
       username: root
       password: abc@123
       url: jdbc:mysql://localhost:3306/revtickets_user_db
   ```

### Issue 9: Frontend (npm) Takes Too Long
**Error:** `npm install` takes forever

**Solution:**
The first run takes 5-10 minutes. Wait for it to complete:
1. Leave npm window open
2. Wait until you see `Application bundle generation complete`
3. Then access http://localhost:4200

### Issue 10: Angular Shows Blank Page
**Error:** `http://localhost:4200` shows nothing

**Solution:**
1. Wait for `npm install` and Angular build to finish
2. Check frontend window for build errors
3. Verify API Gateway is running on port 8080
4. Check browser console (F12) for errors

---

## Step-by-Step Debugging

### Step 1: Run Diagnostic
```cmd
DIAGNOSE.bat
```
Check all items are marked ✓

### Step 2: Test Eureka
```cmd
TEST-EUREKA.bat
```
Wait 30 seconds, access http://localhost:8761

### Step 3: Check Logs
Look at the command windows - they show real-time logs:
- Errors appear in red
- Info appears in white
- Take note of error messages

### Step 4: Manual Service Start
```cmd
cd microservices\eureka-server
java -jar target\eureka-server-1.0.0.jar
```
This shows all output directly

### Step 5: Check Ports
```cmd
netstat -ano | findstr :8761
netstat -ano | findstr :8080
netstat -ano | findstr :4200
```
If ports are in use, something is already running

---

## Database Configuration Verification

### MySQL
```cmd
REM Login to MySQL
mysql -u root -pabc@123

REM Check databases exist
SHOW DATABASES;

REM You should see:
revtickets_user_db
revtickets_booking_db
revtickets_venue_db
revtickets_payment_db
```

### MongoDB
```cmd
REM Start MongoDB shell
mongosh -u root -p abc@123

REM Check databases
show dbs

REM You should see:
revtickets_movie_db
```

---

## System Requirements Verification

### Minimum Requirements
- **RAM:** 4GB (6-8GB recommended)
- **Disk:** 5GB free space
- **Ports:** 4200, 8080, 8081-8085, 8761, 3306, 27017

### Check Available Resources
```cmd
REM Check RAM usage
Get-Process | Measure-Object -Property WorkingSet -Sum

REM Check disk space
Get-Volume

REM Check used ports
netstat -ano
```

---

## Emergency Reset

If everything is stuck, run this to reset:

```cmd
REM Kill all Java and Node processes
taskkill /F /IM java.exe
taskkill /F /IM node.exe

REM Wait 10 seconds
timeout /t 10

REM Clear port conflicts (if needed)
netstat -ano | findstr :8080

REM Restart MySQL and MongoDB services
net stop MySQL80
timeout /t 5
net start MySQL80

net stop MongoDB
timeout /t 5
net start MongoDB

REM Then run START.bat again
START.bat
```

---

## Getting Help

### Provide This Information
1. Full error message from the service window
2. Output of `DIAGNOSE.bat`
3. Which service failed to start
4. Whether databases are running
5. Java and Node.js versions

### Useful Commands for Debugging
```cmd
REM Check Java version
java -version

REM Check Node version
node -v

REM Check npm version
npm -v

REM List all Java processes
tasklist | findstr java

REM Kill specific process
taskkill /PID <process-id> /F

REM Check port status
netstat -ano | findstr :<port>

REM Get detailed process info
tasklist /V | findstr java
```

---

## Still Not Working?

### Option 1: Use Docker Instead
```cmd
REM Run everything in Docker (easier)
docker-compose up -d

REM Check status
docker-compose ps

REM View logs
docker-compose logs -f
```

### Option 2: Manual Microservice Run
```cmd
REM Run each service manually in separate Command Prompts

REM Window 1: Eureka
cd microservices\eureka-server
java -jar target\eureka-server-1.0.0.jar

REM Window 2: API Gateway
cd microservices\api-gateway
java -jar target\api-gateway-1.0.0.jar

REM Window 3: User Service
cd microservices\user-service
java -jar target\user-service-1.0.0.jar

REM Window 4: Frontend
cd frontend
npm install
ng serve --host 0.0.0.0 --port 4200
```

### Option 3: Check Configuration
Review these files for issues:
- `microservices/api-gateway/src/main/resources/application.yml`
- `microservices/user-service/src/main/resources/application.yml`
- `frontend/src/environments/environment.ts`

Look for:
- Correct database URLs
- Correct Eureka server URL
- Correct API gateway URL

---

**Last Updated:** December 14, 2025
**Status:** Troubleshooting Guide Complete
