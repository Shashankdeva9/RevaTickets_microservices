# RevTickets Configuration Changes Summary

## Overview
This document summarizes all changes made to configure the RevTickets microservices application with MySQL database, integrated frontend/backend, consolidated media folders, and fresh admin user setup.

---

## 1. Database Configuration Changes

### MySQL Credentials Updated
**Changed from**: `root/test` → **To**: `root/abc@123`

### Files Modified (5 services):
1. `microservices/user-service/src/main/resources/application.properties`
2. `microservices/movie-service/src/main/resources/application.properties`
3. `microservices/venue-service/src/main/resources/application.properties`
4. `microservices/booking-service/src/main/resources/application.properties`
5. `microservices/payment-service/src/main/resources/application.properties`

**Change in each file:**
```properties
spring.datasource.username=root
spring.datasource.password=abc@123
```

### Database Schemas Created
Each microservice has its own dedicated schema:
- `revtickets_user_db` - User Service
- `revtickets_movie_db` - Movie Service
- `revtickets_venue_db` - Venue Service
- `revtickets_booking_db` - Booking Service
- `revtickets_payment_db` - Payment Service

**Schema Creation**: Auto-create enabled via `?createDatabaseIfNotExist=true` in JDBC URL

---

## 2. Frontend Integration

### Environment Configuration
**File**: `frontend/src/environments/environment.ts`

**Configuration**:
```typescript
apiUrl: 'http://localhost:9090/api'  // Via API Gateway
wsUrl: 'ws://localhost:9090/ws'      // WebSocket via Gateway
```

### API Gateway Routing
**File**: `microservices/api-gateway/src/main/resources/application.yml`

**Already configured** to route:
- All `/api/**` requests to appropriate microservices
- Image requests `/display/**` and `/banner/**` to movie-service
- WebSocket connections to `/ws`

**Port**: 9090 (API Gateway serves as single entry point)

---

## 3. Media Files Organization

### Image Storage Location
All banner and display images are centralized in the movie-service:

```
microservices/movie-service/public/
├── banner/
│   └── .gitkeep
└── display/
    └── .gitkeep
```

### Access Patterns
- **Via API Gateway**: `http://localhost:9090/display/{filename}`
- **Via API Gateway**: `http://localhost:9090/banner/{filename}`
- **Direct (movie-service)**: `http://localhost:8082/display/{filename}`

### Notes
- ✅ No duplicate folders found - already consolidated
- ✅ Movie service properly configured to serve static resources
- ✅ API Gateway routes image requests correctly

---

## 4. Admin User Setup

### DataSeeder Component Created
**File**: `microservices/user-service/src/main/java/com/revature/userservice/config/DataSeeder.java`

**Functionality**:
- Runs on application startup via `CommandLineRunner`
- Creates admin user if it doesn't exist
- Uses BCrypt password encoding

**Default Admin Credentials**:
```
Email: admin@revature.com
Password: admin@123
Role: ADMIN
Full Name: Admin
Phone: 1234567890
Status: Active
```

**Security**: Password is encrypted using Spring Security's PasswordEncoder

---

## 5. New Files Created

### Setup & Documentation Files

1. **`database-setup.sql`**
   - SQL script to create all 5 databases
   - Includes comments and verification queries
   - Character set: utf8mb4

2. **`setup-database.bat`**
   - Windows batch script to setup databases
   - Validates MySQL connection
   - Runs database-setup.sql
   - Verifies successful creation

3. **`verify-setup.bat`**
   - Comprehensive system verification
   - Checks 7 critical components:
     - MySQL connection
     - Database schemas
     - Application properties
     - Database credentials
     - Frontend configuration
     - Media folders
     - DataSeeder component
   - Provides pass/fail summary

4. **`start-complete-system.bat`**
   - Complete startup automation
   - Starts services in correct order:
     1. Eureka Server (wait 30s)
     2. User Service (wait 10s)
     3. Movie Service (wait 10s)
     4. Venue Service (wait 10s)
     5. Booking Service (wait 10s)
     6. Payment Service (wait 10s)
     7. API Gateway (wait 15s)
   - Opens Eureka Dashboard

5. **`fresh-start.bat`**
   - Database reset utility
   - Drops all RevTickets databases
   - Recreates fresh databases
   - Includes safety confirmation
   - Preserves code and configurations

6. **`SETUP.md`**
   - Comprehensive setup guide
   - Database configuration details
   - Service architecture documentation
   - API endpoint reference
   - Troubleshooting guide
   - Security notes

7. **`QUICK-REFERENCE.md`**
   - Quick reference card
   - Database credentials table
   - Admin user info
   - All service endpoints
   - Common operations
   - Troubleshooting tips

---

## 6. Architecture Overview

### Service Communication Flow
```
Frontend (Angular - Port 4200)
    ↓
API Gateway (Port 9090)
    ↓
├─→ User Service (Port 8081) → revtickets_user_db
├─→ Movie Service (Port 8082) → revtickets_movie_db
├─→ Venue Service (Port 8083) → revtickets_venue_db
├─→ Booking Service (Port 8084) → revtickets_booking_db
└─→ Payment Service (Port 8085) → revtickets_payment_db
    ↑
Eureka Server (Port 8761) - Service Discovery
```

### Database Schema Isolation
✅ Each microservice has its own database
✅ No cross-database dependencies
✅ Follows microservices best practices

---

## 7. What Was NOT Changed

### Preserved Configurations
- ✅ Eureka Server configuration (Port 8761)
- ✅ Service port assignments (9090-8085)
- ✅ JWT secret in user-service
- ✅ Stripe configuration
- ✅ JPA/Hibernate settings (ddl-auto=update)
- ✅ CORS configurations
- ✅ API Gateway routing rules
- ✅ WebSocket configurations

### Existing Features Maintained
- ✅ Service discovery via Eureka
- ✅ Load balancing
- ✅ API Gateway routing
- ✅ Static resource serving
- ✅ User authentication
- ✅ Role-based access control

---

## 8. Step-by-Step Usage Guide

### First Time Setup
```bash
# Step 1: Verify configuration
verify-setup.bat

# Step 2: Setup databases
setup-database.bat

# Step 3: Start all backend services
start-complete-system.bat

# Step 4: Start frontend (in new terminal)
cd frontend
npm install
npm start

# Step 5: Access application
# Browser: http://localhost:4200
# Login: admin@revature.com / admin@123
```

### Daily Development Workflow
```bash
# Terminal 1: Backend
start-complete-system.bat

# Terminal 2: Frontend
cd frontend
npm start
```

### Reset Everything (if needed)
```bash
# Reset databases to fresh state
fresh-start.bat

# Restart services
start-complete-system.bat
```

---

## 9. Testing Checklist

### Database Verification
- [ ] MySQL accessible with `root/abc@123`
- [ ] All 5 databases created
- [ ] Tables created automatically on first run

### Service Verification
- [ ] Eureka Server showing all services
- [ ] API Gateway responding on port 9090
- [ ] All microservices registered with Eureka

### Admin User Verification
- [ ] User-service logs show "Admin user created"
- [ ] Can login with admin@revature.com
- [ ] Admin role permissions working
- [ ] Can access admin dashboard

### Frontend Integration
- [ ] Frontend connects to API Gateway
- [ ] Login/Register working
- [ ] Movie/Event listings displaying
- [ ] Images loading correctly
- [ ] Admin panel accessible

### Media Files
- [ ] Display images accessible via gateway
- [ ] Banner images accessible via gateway
- [ ] No 404 errors for images
- [ ] Direct movie-service access working

---

## 10. Security Considerations

### Development vs Production

**Current (Development) Configuration**:
- Database password: `abc@123`
- Admin password: `admin@123`
- JWT secret: Hardcoded in properties
- SSL/HTTPS: Disabled
- CORS: Permissive

**⚠️ Before Production Deployment**:
1. Change database password
2. Rotate JWT secret
3. Update admin password
4. Enable HTTPS/SSL
5. Configure strict CORS
6. Use environment variables for secrets
7. Implement rate limiting
8. Add input validation
9. Enable SQL injection protection
10. Set up proper authentication

---

## 11. Maintenance & Operations

### Backup Strategy
```sql
-- Backup all databases
mysqldump -u root -pabc@123 --databases \
  revtickets_user_db \
  revtickets_movie_db \
  revtickets_venue_db \
  revtickets_booking_db \
  revtickets_payment_db \
  > backup.sql
```

### Log Monitoring
- Each service runs in separate terminal window
- Real-time log viewing
- Check for "Started [Service]Application" messages

### Performance Monitoring
- Eureka Dashboard: Service health
- Database: Monitor connection pool
- API Gateway: Request throughput

---

## 12. Troubleshooting Guide

### Common Issues & Solutions

**Issue**: Database connection failed
```bash
# Solution 1: Verify MySQL running
mysql -u root -pabc@123

# Solution 2: Reset password
ALTER USER 'root'@'localhost' IDENTIFIED BY 'abc@123';
FLUSH PRIVILEGES;
```

**Issue**: Services not registering with Eureka
```bash
# Solution: Ensure Eureka started first
# Wait 30 seconds after Eureka starts
# Check http://localhost:8761
```

**Issue**: Admin user not created
```bash
# Check logs for DataSeeder execution
# Verify user-service started successfully
# Check database:
mysql -u root -pabc@123
USE revtickets_user_db;
SELECT * FROM users WHERE role='ADMIN';
```

**Issue**: Images not loading
```bash
# Verify files exist
ls microservices/movie-service/public/display/
ls microservices/movie-service/public/banner/

# Test direct access
http://localhost:8082/display/filename.jpg

# Check API Gateway routing
http://localhost:9090/display/filename.jpg
```

---

## Summary of Changes

### Modified Files: 6
1. `microservices/user-service/src/main/resources/application.properties` ✏️
2. `microservices/movie-service/src/main/resources/application.properties` ✏️
3. `microservices/venue-service/src/main/resources/application.properties` ✏️
4. `microservices/booking-service/src/main/resources/application.properties` ✏️
5. `microservices/payment-service/src/main/resources/application.properties` ✏️
6. `frontend/src/environments/environment.ts` ✏️

### New Files Created: 8
1. `database-setup.sql` ✨
2. `setup-database.bat` ✨
3. `verify-setup.bat` ✨
4. `start-complete-system.bat` ✨
5. `fresh-start.bat` ✨
6. `microservices/user-service/src/main/java/com/revature/userservice/config/DataSeeder.java` ✨
7. `SETUP.md` ✨
8. `QUICK-REFERENCE.md` ✨

### Configuration Summary
- ✅ MySQL: `root/abc@123`
- ✅ 5 separate database schemas
- ✅ Frontend integrated via API Gateway
- ✅ Media folders consolidated (already done)
- ✅ Fresh admin user auto-creation
- ✅ Complete automation scripts
- ✅ Comprehensive documentation

---

**Configuration Date**: December 9, 2025
**System Status**: ✅ Ready for Development
**Next Step**: Run `verify-setup.bat` then `start-complete-system.bat`
