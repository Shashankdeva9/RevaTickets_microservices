# 🎬 RevTickets - Complete Setup Guide

## 📋 System Requirements

### Required Software

| Software | Version | Purpose | Download Link |
|----------|---------|---------|---------------|
| **MySQL** | 8.0+ | Main database for all services | [Download](https://dev.mysql.com/downloads/installer/) |
| **MongoDB** | 5.0+ | Reviews database (movie-service) | [Download](https://www.mongodb.com/try/download/community) |
| **JDK** | 17+ | Java runtime for microservices | [Download](https://adoptium.net/) |
| **Maven** | 3.6+ | Build tool for Java projects | [Download](https://maven.apache.org/download.cgi) |
| **Node.js** | 18+ | JavaScript runtime for frontend | [Download](https://nodejs.org/) |

---

## 🚀 Quick Start (3 Commands)

```bash
# 1. Verify all prerequisites are installed
VERIFY-SYSTEM.bat

# 2. Start all backend services
START.bat

# 3. In a NEW terminal, start the frontend
cd frontend
npm install
npm start
```

**Access Application**: http://localhost:4200

**Default Admin Login**:
- Email: `admin@revature.com`
- Password: `admin@123`

---

## 🔧 Detailed Setup Instructions

### Step 1: Install MySQL

1. Download MySQL Installer from the link above
2. Run installer and choose "Developer Default"
3. Set root password to: `abc@123`
4. Complete installation
5. Verify installation:
   ```bash
   mysql --version
   mysql -u root -pabc@123 -e "SELECT 1;"
   ```

### Step 2: Install MongoDB

1. Download MongoDB Community Server
2. Install with default settings
3. MongoDB will run automatically as a Windows service
4. Verify installation:
   ```bash
   mongod --version
   sc query MongoDB
   ```

### Step 3: Install JDK and Maven

**JDK 17:**
1. Download from Adoptium (Eclipse Temurin)
2. Install and note installation path
3. Add to PATH if not automatic
4. Verify: `java -version`

**Maven:**
1. Download binary zip from Maven website
2. Extract to `C:\Program Files\apache-maven-x.x.x`
3. Add `bin` folder to system PATH
4. Verify: `mvn -version`

### Step 4: Install Node.js

1. Download Node.js LTS version
2. Run installer (includes npm)
3. Verify:
   ```bash
   node --version
   npm --version
   ```

---

## 🗄️ Database Configuration

### MySQL Databases Created

The system uses **5 separate MySQL databases** (one per microservice):

| Database | Service | Purpose |
|----------|---------|---------|
| `revtickets_user_db` | user-service | Users, authentication, admin |
| `revtickets_movie_db` | movie-service | Movies, events, shows |
| `revtickets_venue_db` | venue-service | Venues, locations, halls |
| `revtickets_booking_db` | booking-service | Bookings, seats, tickets |
| `revtickets_payment_db` | payment-service | Payments, transactions |

### MongoDB Database

| Database | Service | Purpose |
|----------|---------|---------|
| `revtickets_reviews` | movie-service | Movie/event reviews and ratings |

### Connection Details

**MySQL:**
- Host: `localhost:3306`
- Username: `root`
- Password: `abc@123`

**MongoDB:**
- URI: `mongodb://localhost:27017/revtickets_reviews`

---

## 🏗️ Architecture Overview

### Microservices (Port Configuration)

| Service | Port | Purpose |
|---------|------|---------|
| **Eureka Server** | 8761 | Service discovery and registration |
| **API Gateway** | 9090 | Single entry point for all APIs |
| **User Service** | 8081 | Authentication, users, admin |
| **Movie Service** | 8082 | Movies, events, reviews |
| **Venue Service** | 8083 | Venues, halls, locations |
| **Booking Service** | 8084 | Bookings, seats, shows |
| **Payment Service** | 8085 | Payment processing |
| **Angular Frontend** | 4200 | User interface |

### Service Communication Flow

```
Frontend (4200)
    ↓
API Gateway (9090)
    ↓
[Eureka Server (8761)]
    ↓
Microservices (8081-8085)
    ↓
Databases (MySQL + MongoDB)
```

---

## 🎯 Starting the Application

### Backend Services

**Option 1: Use START.bat (Recommended)**
```bash
START.bat
```

This will:
1. ✅ Verify MySQL connection
2. ✅ Create databases if needed
3. ✅ Start Eureka Server (8761)
4. ✅ Start all 5 microservices (8081-8085)
5. ✅ Start API Gateway (9090)
6. ✅ Wait with proper delays for service registration

**Option 2: Manual Start**
```bash
# Terminal 1 - Eureka Server
cd microservices\eureka-server
mvn spring-boot:run

# Terminal 2 - User Service
cd microservices\user-service
mvn spring-boot:run

# Terminal 3 - Movie Service
cd microservices\movie-service
mvn spring-boot:run

# ... and so on for venue, booking, payment services

# Terminal 7 - API Gateway
cd microservices\api-gateway
mvn spring-boot:run
```

### Frontend

**In a NEW terminal:**
```bash
cd frontend
npm install           # First time only
npm start
```

The frontend will be available at: http://localhost:4200

---

## 🛑 Stopping the Application

**Stop All Services:**
```bash
STOP.bat
```

This will terminate:
- ✅ All Java processes (microservices)
- ✅ Node.js processes (frontend)

**Manual Stop:**
- Close each terminal window
- Or press `Ctrl+C` in each terminal

---

## 🔌 API Endpoints

All API calls go through the API Gateway at `http://localhost:9090`

### Authentication APIs
```
POST   /api/auth/register          - Register new user
POST   /api/auth/login             - User login
GET    /api/auth/profile           - Get user profile
```

### Movie APIs
```
GET    /api/movies                 - Get all movies
GET    /api/movies/{id}            - Get movie by ID
POST   /api/admin/movies           - Create movie (Admin)
PUT    /api/admin/movies/{id}      - Update movie (Admin)
DELETE /api/admin/movies/{id}      - Delete movie (Admin)
```

### Event APIs
```
GET    /api/events                 - Get all events
GET    /api/events/{id}            - Get event by ID
POST   /api/admin/events           - Create event (Admin)
```

### Venue APIs
```
GET    /api/venues                 - Get all venues
GET    /api/venues/{id}            - Get venue by ID
POST   /api/admin/venues           - Create venue (Admin)
```

### Booking APIs
```
GET    /api/bookings               - Get user bookings
POST   /api/bookings               - Create booking
GET    /api/shows/{id}             - Get show details
GET    /api/seats/{showId}         - Get available seats
```

### Payment APIs
```
POST   /api/payments/create        - Create payment
POST   /api/payments/verify        - Verify payment
GET    /api/payments/{id}          - Get payment details
```

### Admin APIs
```
GET    /api/admin/dashboard/stats  - Dashboard statistics
GET    /api/admin/users            - Get all users
PUT    /api/admin/users/{id}       - Update user
DELETE /api/admin/users/{id}       - Delete user
```

---

## 🔐 CORS Configuration

All microservices are configured to accept requests from:
- ✅ `http://localhost:4200` (Frontend)
- ✅ `http://localhost:9090` (API Gateway)

CORS settings:
- Allowed Methods: `GET`, `POST`, `PUT`, `DELETE`, `OPTIONS`, `PATCH`
- Allowed Headers: `*`
- Allow Credentials: `true`
- Max Age: `3600 seconds`

---

## 📊 Monitoring & Health Checks

### Eureka Dashboard
**URL**: http://localhost:8761

View all registered microservices and their status.

### Service Health Endpoints
```
http://localhost:8081/actuator/health   - User Service
http://localhost:8082/actuator/health   - Movie Service
http://localhost:8083/actuator/health   - Venue Service
http://localhost:8084/actuator/health   - Booking Service
http://localhost:8085/actuator/health   - Payment Service
```

---

## 🧪 Testing the System

### Using Postman

1. Import the collection: `RevTickets_Postman_Collection.json`
2. Test authentication endpoints
3. Get JWT token from login response
4. Use token in Authorization header for protected routes

### Manual Testing

1. **Access Frontend**: http://localhost:4200
2. **Login as Admin**: 
   - Email: `admin@revature.com`
   - Password: `admin@123`
3. **Test Features**:
   - Browse movies/events
   - Create bookings
   - Make payments
   - Admin dashboard

---

## ⚠️ Troubleshooting

### Port Already in Use

**Error**: "Port 8080 in use" or similar

**Solution**: 
- This project uses port 9090 for API Gateway (not 8080)
- Stop any other Java/Node processes
- Run `STOP.bat` to clean up

### MySQL Connection Failed

**Error**: "Cannot connect to MySQL"

**Solutions**:
1. Verify MySQL is running: `sc query MySQL80`
2. Start MySQL: `net start MySQL80`
3. Check password is `abc@123`
4. Test connection: `mysql -u root -pabc@123`

### MongoDB Not Running

**Error**: "Failed to connect to MongoDB"

**Solutions**:
1. Check MongoDB service: `sc query MongoDB`
2. Start MongoDB: `net start MongoDB`
3. If not installed, download from MongoDB website

### Eureka Service Not Registering

**Error**: Services not showing in Eureka Dashboard

**Solutions**:
1. Wait 30-60 seconds for registration
2. Check Eureka is running: http://localhost:8761
3. Verify `application.properties` has correct Eureka URL:
   ```
   eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
   ```

### Frontend Cannot Connect to Backend

**Error**: "Failed to fetch" or CORS errors

**Solutions**:
1. Verify API Gateway is running on port 9090
2. Check frontend `environment.ts`:
   ```typescript
   apiUrl: 'http://localhost:9090/api'
   ```
3. Clear browser cache
4. Check browser console for errors

### Maven Build Fails

**Error**: Build failure during `mvn spring-boot:run`

**Solutions**:
1. Clean build: `mvn clean install`
2. Update dependencies: `mvn dependency:resolve`
3. Check JDK version: `java -version` (should be 17+)
4. Delete `target` folder and rebuild

---

## 📂 Project Structure

```
Rev-Tickets-Microservices/
├── microservices/
│   ├── eureka-server/          # Service discovery
│   ├── api-gateway/            # API Gateway (9090)
│   ├── user-service/           # Authentication & Users (8081)
│   ├── movie-service/          # Movies & Events (8082)
│   ├── venue-service/          # Venues (8083)
│   ├── booking-service/        # Bookings (8084)
│   └── payment-service/        # Payments (8085)
├── frontend/
│   └── src/
│       ├── app/
│       │   ├── features/       # Feature modules
│       │   ├── core/           # Services, guards
│       │   └── shared/         # Shared components
│       └── environments/       # Environment configs
├── database-setup.sql          # MySQL database schema
├── START.bat                   # Start all services
├── STOP.bat                    # Stop all services
├── VERIFY-SYSTEM.bat           # Verify prerequisites
└── README.md                   # This file
```

---

## 🎓 Default Users

### Admin User
- **Email**: `admin@revature.com`
- **Password**: `admin@123`
- **Role**: ADMIN
- **Permissions**: Full system access

### Test User
- **Email**: `user@test.com`
- **Password**: `test@123`
- **Role**: USER
- **Permissions**: Browse, book, payment

---

## 🚀 Production Deployment Notes

Before deploying to production:

1. ✅ Change all default passwords
2. ✅ Update JWT secret key
3. ✅ Enable HTTPS
4. ✅ Configure production database URLs
5. ✅ Update CORS to allow production domains only
6. ✅ Enable Spring Security
7. ✅ Set `spring.jpa.hibernate.ddl-auto=validate`
8. ✅ Configure external configuration server
9. ✅ Set up monitoring and logging
10. ✅ Configure load balancers

---

## 📞 Support & Documentation

- **Eureka Dashboard**: http://localhost:8761
- **API Gateway**: http://localhost:9090
- **Frontend**: http://localhost:4200
- **Postman Collection**: `RevTickets_Postman_Collection.json`

---

## ✅ System Checklist

- [ ] MySQL installed and running
- [ ] MongoDB installed and running
- [ ] JDK 17+ installed
- [ ] Maven installed
- [ ] Node.js 18+ installed
- [ ] npm installed
- [ ] All databases created
- [ ] Backend services started (START.bat)
- [ ] Frontend dependencies installed (npm install)
- [ ] Frontend running (npm start)
- [ ] Can access http://localhost:4200
- [ ] Can login with admin credentials
- [ ] All services registered in Eureka

**Run `VERIFY-SYSTEM.bat` to automatically check all prerequisites!**
