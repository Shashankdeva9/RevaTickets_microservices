# RevTickets - Run Project LOCALLY (No Docker)

This guide explains how to run the entire RevTickets project **directly on your local machine** without Docker.

## Prerequisites ✓

All prerequisites are already installed on your machine:
- ✅ Java 17 (installed)
- ✅ Maven 3.9 (installed)
- ✅ Node.js & npm (installed)
- ✅ MySQL 8.0 (running on port 3306)
- ✅ MongoDB (running on port 27017)
- ✅ Angular CLI (installed)

## Quick Start (3 Steps)

### 1. **Build All Services** (First time only)
```
Run: BUILD-AND-START.bat
```
This will:
- ✅ Build all 7 microservices
- ✅ Build the Angular frontend
- ✅ Start all services automatically

### 2. **Start Services** (Every time after that)
```
Run: START.bat
```
This will:
- ✅ Start Eureka Server (8761)
- ✅ Start API Gateway (8080)
- ✅ Start User Service (8081)
- ✅ Start Movie Service (8082)
- ✅ Start Venue Service (8083)
- ✅ Start Booking Service (8084)
- ✅ Start Payment Service (8085)
- ✅ Start Angular Frontend (4200)

Each service opens in its own Command Prompt window so you can see logs.

### 3. **Stop Services**
```
Run: STOP.bat
```
This will:
- ✅ Stop all 7 Java microservices
- ✅ Stop Angular frontend
- ✅ Keep databases running (MySQL & MongoDB)

## Access Your Application

| Component | URL | Port |
|-----------|-----|------|
| **Frontend** | http://localhost:4200 | 4200 |
| **API Gateway** | http://localhost:8080/api | 8080 |
| **Eureka Dashboard** | http://localhost:8761 | 8761 |

## Database Access

| Database | Connection | Credentials |
|----------|-----------|-------------|
| **MySQL** | localhost:3306 | root / abc@123 |
| **MongoDB** | localhost:27017 | root / abc@123 |

## Service Ports

| Service | Port | Type |
|---------|------|------|
| Eureka Server | 8761 | Java (Discovery) |
| API Gateway | 8080 | Java (Gateway) |
| User Service | 8081 | Java (Microservice) |
| Movie Service | 8082 | Java (Microservice) |
| Venue Service | 8083 | Java (Microservice) |
| Booking Service | 8084 | Java (Microservice) |
| Payment Service | 8085 | Java (Microservice) |
| Frontend | 4200 | Angular (Node.js) |

## Common Tasks

### Verify Services Are Running
```powershell
netstat -ano | findstr :4200    # Frontend
netstat -ano | findstr :8080    # API Gateway
netstat -ano | findstr :8761    # Eureka
```

### View Logs for a Service
Each service window shows logs in real-time. Don't close the windows while services are running!

### Quick Rebuild of a Single Service
```
cd microservices\user-service
mvn clean install
java -jar target/user-service-1.0.0.jar
```

### Rebuild Frontend Only
```
cd frontend
ng build
ng serve
```

## What's Different From Docker?

| Aspect | Docker | Local (This Setup) |
|--------|--------|-------------------|
| **Execution** | Containers | Native processes on machine |
| **Frontend Port** | 80 (nginx) | 4200 (ng serve) |
| **API Port** | 9090 | 8080 |
| **Service Windows** | All hidden in containers | 8 visible Command Prompt windows |
| **Logs** | `docker-compose logs` | Real-time in service windows |
| **Startup Time** | ~2-3 minutes | ~30-45 seconds |
| **Database Access** | Through containers | Direct to local instances |

## Troubleshooting

### "Port Already in Use" Error
```powershell
# Find what's using the port (example: 8080)
netstat -ano | findstr :8080

# Get the PID from output, then kill it
taskkill /PID <PID> /F
```

### Service Fails to Start
1. Check Java is installed: `java -version`
2. Check Maven is installed: `mvn -version`
3. Check port is free: `netstat -ano | findstr :PORT_NUMBER`
4. Check logs in the service window

### Frontend Can't Connect to API
- ✅ Already fixed! Frontend points to http://localhost:8080/api
- Check API Gateway is running on port 8080
- Check browser console for CORS errors

### Database Connection Issues
- ✅ MySQL should be running: `netstat -ano | findstr :3306`
- ✅ MongoDB should be running: `netstat -ano | findstr :27017`
- Check credentials: root/abc@123

## Files Overview

- **START.bat** - Start all services (uses pre-built JAR files)
- **STOP.bat** - Stop all services (kills local processes)
- **BUILD-AND-START.bat** - Rebuild and start everything (from scratch)
- **DIAGNOSTIC.bat** - Check which services are running
- This file: **RUN-LOCALLY.md** - You are here!

## Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│         Angular Frontend (Port 4200)            │
│        Running on Node.js with ng serve         │
└────────────────┬────────────────────────────────┘
                 │
                 │ HTTP/WebSocket
                 ▼
┌─────────────────────────────────────────────────┐
│    API Gateway (Port 8080)                      │
│   Spring Cloud Gateway + Spring Boot 3.2        │
│   Routes requests to microservices              │
└──────────┬──────────────┬──────────────┬────────┘
           │              │              │
    ┌──────▼──┐    ┌──────▼──┐    ┌─────▼───┐
    │  User   │    │  Movie  │    │  Venue  │
    │ Service │    │ Service │    │ Service │
    │ (8081)  │    │ (8082)  │    │ (8083)  │
    └──────┬──┘    └──────┬──┘    └─────┬───┘
           │              │              │
    ┌──────▼────────────────▼──────────────▼───┐
    │     Eureka Server (Port 8761)             │
    │  Service Discovery & Registration        │
    └──────────────────────────────────────────┘
           │              │              │
    ┌──────▼──┐    ┌──────▼──┐    ┌─────▼───┐
    │ Booking │    │ Payment │    │ MySQL   │
    │ Service │    │ Service │    │ Database│
    │ (8084)  │    │ (8085)  │    │ (3306)  │
    └─────────┘    └────────┬┘    └─────────┘
                           │
                   ┌───────▼────────┐
                   │    MongoDB     │
                   │   (27017)      │
                   └────────────────┘
```

## Next Steps

1. ✅ **Prerequisites verified** (Java, Maven, Node.js installed)
2. ✅ **Databases running** (MySQL 3306, MongoDB 27017)
3. ✅ **API endpoint fixed** (Frontend → localhost:8080/api)
4. 🔄 **Ready to go!** Run `START.bat` now

---

**Questions?** Check the other guide files:
- **START-HERE.md** - Quick reference
- **COMPLETE-STARTUP-GUIDE.md** - Detailed startup steps
- **PROJECT-STRUCTURE.md** - File organization

**Good luck! 🚀**
