# RevTickets - Quick Reference Card

## 🗄️ Database Configuration

| Setting | Value |
|---------|-------|
| Username | `root` |
| Password | `abc@123` |
| User DB | `revtickets_user_db` |
| Movie DB | `revtickets_movie_db` |
| Venue DB | `revtickets_venue_db` |
| Booking DB | `revtickets_booking_db` |
| Payment DB | `revtickets_payment_db` |

## 👤 Default Admin User

| Field | Value |
|-------|-------|
| Email | `admin@revature.com` |
| Password | `admin@123` |
| Role | ADMIN |
| Full Name | Admin |

## 🚀 Quick Start Commands

### Setup (First Time Only)
```bash
# 1. Setup databases
setup-database.bat

# 2. Verify everything is configured
verify-setup.bat

# 3. Start all services
start-complete-system.bat

# 4. Start frontend (in new terminal)
cd frontend
npm install
npm start
```

### Daily Development
```bash
# Start backend services
start-complete-system.bat

# Start frontend (separate terminal)
cd frontend
npm start
```

## 🌐 Service Endpoints

### Production URLs (via API Gateway - Port 9090)

**Public Endpoints:**
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login
- `GET /api/movies` - List movies
- `GET /api/events` - List events
- `GET /api/venues` - List venues
- `GET /display/{filename}` - View display images
- `GET /banner/{filename}` - View banner images

**Admin Endpoints (require admin login):**
- `GET /api/admin/dashboard/**` - Dashboard stats
- `GET /api/admin/users` - User management
- `POST /api/admin/users` - Create user
- `GET /api/admin/movies/**` - Movie management
- `GET /api/admin/events/**` - Event management
- `GET /api/admin/venues/**` - Venue management
- `GET /api/admin/bookings/**` - Booking management

**Customer Endpoints (require login):**
- `GET /api/bookings` - My bookings
- `POST /api/bookings` - Create booking
- `GET /api/shows` - Available shows
- `POST /api/payments` - Process payment
- `GET /api/auth/profile` - My profile

## 📁 Media File Locations

All images are stored in the movie-service:

| Type | Location |
|------|----------|
| Display Images | `microservices/movie-service/public/display/` |
| Banner Images | `microservices/movie-service/public/banner/` |

**Accessing Images:**
- Via Gateway: `http://localhost:9090/display/image.jpg`
- Via Gateway: `http://localhost:9090/banner/banner.jpg`
- Direct: `http://localhost:8082/display/image.jpg`

## 🔌 Service Ports

| Service | Port | Direct URL |
|---------|------|------------|
| Eureka Server | 8761 | http://localhost:8761 |
| API Gateway | 9090 | http://localhost:9090 |
| User Service | 8081 | http://localhost:8081 |
| Movie Service | 8082 | http://localhost:8082 |
| Venue Service | 8083 | http://localhost:8083 |
| Booking Service | 8084 | http://localhost:8084 |
| Payment Service | 8085 | http://localhost:8085 |
| Frontend | 4200 | http://localhost:4200 |

## 🔧 Common Operations

### Adding New Images
```bash
# Place files in these folders:
microservices/movie-service/public/display/
microservices/movie-service/public/banner/

# Access via:
http://localhost:9090/display/filename.jpg
http://localhost:9090/banner/filename.jpg
```

### Checking Service Health
```bash
# View Eureka Dashboard
http://localhost:8761

# All services should show as "UP"
```

### Reset Database
```bash
# Login to MySQL
mysql -u root -pabc@123

# Drop and recreate
DROP DATABASE revtickets_user_db;
DROP DATABASE revtickets_movie_db;
DROP DATABASE revtickets_venue_db;
DROP DATABASE revtickets_booking_db;
DROP DATABASE revtickets_payment_db;

# Run setup again
exit
setup-database.bat
```

### Creating Additional Admin Users
```sql
-- Login to MySQL
mysql -u root -pabc@123

-- Use user database
USE revtickets_user_db;

-- Insert new admin (password will be hashed by application)
-- Use the application's register endpoint and then update role:
UPDATE users SET role = 'ADMIN' WHERE email = 'newadmin@example.com';
```

## 🐛 Troubleshooting

### Services Won't Start
1. Check MySQL is running
2. Verify Eureka Server started first (wait 30 seconds)
3. Check no port conflicts (9090-8085, 8761)
4. Review service logs in terminal windows

### Database Connection Failed
```bash
# Test MySQL connection
mysql -u root -pabc@123

# If fails, reset password:
ALTER USER 'root'@'localhost' IDENTIFIED BY 'abc@123';
FLUSH PRIVILEGES;
```

### Frontend Can't Connect
1. Verify API Gateway is running (port 9090)
2. Check `frontend/src/environments/environment.ts`:
   ```typescript
   apiUrl: 'http://localhost:9090/api'
   ```
3. Clear browser cache
4. Check browser console for errors

### Images Not Loading
1. Verify files exist in `movie-service/public/display/` or `/banner/`
2. Check movie-service is running (port 8082)
3. Test direct access: `http://localhost:8082/display/filename.jpg`
4. Check API Gateway routing in `application.yml`

### Admin Login Not Working
1. Ensure user-service has started successfully
2. Check DataSeeder ran (look for log: "Admin user created")
3. Verify in database:
   ```sql
   USE revtickets_user_db;
   SELECT * FROM users WHERE role = 'ADMIN';
   ```

## 📊 Monitoring

### Check Service Registration
```
http://localhost:8761
```
All services should be listed under "Instances currently registered"

### Check Database Tables
```sql
mysql -u root -pabc@123

USE revtickets_user_db;
SHOW TABLES;

USE revtickets_movie_db;
SHOW TABLES;

-- etc...
```

### View Logs
- Each service runs in its own terminal window
- Logs are displayed in real-time
- Look for "Started [ServiceName]Application" message

## 🔐 Security Notes

**⚠️ For Development Only**

These credentials are for development. Before production:
- [ ] Change database password
- [ ] Update admin password
- [ ] Rotate JWT secret
- [ ] Enable HTTPS
- [ ] Configure CORS properly
- [ ] Update Stripe keys
- [ ] Set up proper authentication

## 📞 Support

For issues:
1. Check service logs in terminal windows
2. Verify Eureka Dashboard (http://localhost:8761)
3. Review `SETUP.md` for detailed setup
4. Check database connectivity
5. Ensure all ports are available

---

**Last Updated**: 2025
**Version**: 1.0
