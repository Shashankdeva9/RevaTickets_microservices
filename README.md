# 🎬 RevTickets Microservices Platform

A complete microservices-based movie and event ticketing system built with Spring Boot, Angular, MySQL, and MongoDB.

---

## 🚀 Quick Start (3 Commands)

```bash
# 1. Verify all prerequisites (MySQL, MongoDB, JDK, Maven, Node.js)
VERIFY-SYSTEM.bat

# 2. Start all backend services
START.bat

# 3. In a NEW terminal, start the frontend
cd frontend
npm install
npm start
```

**Access**: http://localhost:4200  
**Admin Login**: admin@revature.com / admin@123

**📘 Full Setup Guide**: See [COMPLETE-SETUP-GUIDE.md](COMPLETE-SETUP-GUIDE.md) for detailed instructions

---

## 📋 Table of Contents

- [System Requirements](#system-requirements)
- [Database Configuration](#database-configuration)
- [Architecture](#architecture)
- [Service Endpoints](#service-endpoints)
- [Quick Commands](#quick-commands)
- [Documentation](#documentation)
- [Troubleshooting](#troubleshooting)

---

## 💻 System Requirements

- **JDK**: 17 or higher
- **Maven**: 3.6+
- **Node.js**: 18+ (for Angular frontend)
- **MySQL**: 8.0+
- **Git**: For version control

---

## 🗄️ Database Configuration

### Credentials
```
Username: root
Password: abc@123
```

### Schemas (Auto-created)
- `revtickets_user_db`
- `revtickets_movie_db`
- `revtickets_venue_db`
- `revtickets_booking_db`
- `revtickets_payment_db`

### Setup
```bash
# Run the setup script
setup-database.bat

# Or manually
mysql -u root -pabc@123 < database-setup.sql
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend (Angular)                       │
│                   http://localhost:4200                     │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ↓
┌─────────────────────────────────────────────────────────────┐
│                  API Gateway (Port 9090)                    │
│              Single Entry Point for All APIs                │
└────┬────────┬─────────┬─────────┬─────────┬────────────────┘
     │        │         │         │         │
     ↓        ↓         ↓         ↓         ↓
┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
│ User   │ │ Movie  │ │ Venue  │ │Booking │ │Payment │
│ :8081  │ │ :8082  │ │ :8083  │ │ :8084  │ │ :8085  │
└───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘
    │          │          │          │          │
    ↓          ↓          ↓          ↓          ↓
┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐
│User DB│  │MovieDB│  │VenueDB│  │BookDB │  │PayDB  │
└───────┘  └───────┘  └───────┘  └───────┘  └───────┘
                         ↑
                         │
                ┌────────────────┐
                │ Eureka Server  │
                │     :8761      │
                │Service Discovery│
                └────────────────┘
```

---

## 🌐 Service Endpoints

### Via API Gateway (http://localhost:9090)

#### Public Endpoints
```
POST   /api/auth/register          Register new user
POST   /api/auth/login             User login
GET    /api/movies                 List all movies
GET    /api/events                 List all events
GET    /api/venues                 List all venues
GET    /display/{filename}         Display images
GET    /banner/{filename}          Banner images
```

#### Admin Endpoints (Requires Admin Role)
```
GET    /api/admin/dashboard        Dashboard statistics
GET    /api/admin/users            Manage users
GET    /api/admin/movies           Manage movies
GET    /api/admin/events           Manage events
GET    /api/admin/venues           Manage venues
GET    /api/admin/bookings         Manage bookings
```

#### Customer Endpoints (Requires Authentication)
```
GET    /api/auth/profile           User profile
GET    /api/bookings               My bookings
POST   /api/bookings               Create booking
GET    /api/shows                  Available shows
POST   /api/payments               Process payment
```

---

## ⚡ Quick Commands

### Setup & Verification
```bash
verify-setup.bat          # Verify all configurations
setup-database.bat        # Create databases
fresh-start.bat           # Reset everything
```

### Starting Services
```bash
start-complete-system.bat # Start all backend services
cd frontend && npm start  # Start frontend
```

### Monitoring
```
Eureka Dashboard:   http://localhost:8761
API Gateway:        http://localhost:9090
Frontend:           http://localhost:4200
```

---

## 📚 Documentation

- **[SETUP.md](SETUP.md)** - Detailed setup instructions
- **[QUICK-REFERENCE.md](QUICK-REFERENCE.md)** - Quick reference guide
- **[CHANGES.md](CHANGES.md)** - Configuration changes summary

---

## 👤 Default Users

### Admin User (Created Automatically)
```
Email:    admin@revature.com
Password: admin@123
Role:     ADMIN
```

This user is created automatically by the DataSeeder component when the user-service starts for the first time.

---

## 📁 Project Structure

```
Rev-Tickets-Microservices/
├── frontend/                    # Angular frontend
│   ├── src/
│   │   ├── app/
│   │   │   ├── features/       # Feature modules
│   │   │   ├── core/           # Core services
│   │   │   └── shared/         # Shared components
│   │   └── environments/       # Environment configs
│   └── package.json
│
├── microservices/
│   ├── eureka-server/          # Service discovery
│   ├── api-gateway/            # API Gateway
│   ├── user-service/           # User management
│   ├── movie-service/          # Movies & events
│   │   └── public/             # Media files
│   │       ├── display/        # Display images
│   │       └── banner/         # Banner images
│   ├── venue-service/          # Venue management
│   ├── booking-service/        # Booking management
│   └── payment-service/        # Payment processing
│
├── database-setup.sql          # Database initialization
├── setup-database.bat          # Database setup script
├── verify-setup.bat            # Configuration verification
├── start-complete-system.bat   # Start all services
├── fresh-start.bat             # Reset databases
├── SETUP.md                    # Setup guide
├── QUICK-REFERENCE.md          # Quick reference
└── CHANGES.md                  # Changes summary
```

---

## 🎯 Features

### For Customers
- ✅ Browse movies and events
- ✅ View show timings
- ✅ Book tickets
- ✅ Select seats
- ✅ Process payments
- ✅ View booking history
- ✅ User profile management

### For Admins
- ✅ Dashboard with statistics
- ✅ User management
- ✅ Movie & event management
- ✅ Venue management
- ✅ Booking management
- ✅ View all bookings
- ✅ System monitoring

### Technical Features
- ✅ Microservices architecture
- ✅ Service discovery (Eureka)
- ✅ API Gateway pattern
- ✅ JWT authentication
- ✅ Role-based access control
- ✅ Database per service
- ✅ Static resource serving
- ✅ WebSocket support

---

## 🔧 Troubleshooting

### Can't connect to MySQL
```bash
# Test connection
mysql -u root -pabc@123

# If fails, reset password
mysql -u root
ALTER USER 'root'@'localhost' IDENTIFIED BY 'abc@123';
FLUSH PRIVILEGES;
```

### Services not starting
1. Check MySQL is running
2. Ensure Eureka Server starts first
3. Wait 30 seconds between services
4. Check port availability (9090-8085, 8761)

### Frontend can't connect
1. Verify API Gateway is running (port 9090)
2. Check `frontend/src/environments/environment.ts`
3. Clear browser cache
4. Check browser console for errors

### Admin login not working
```sql
-- Check admin user exists
mysql -u root -pabc@123
USE revtickets_user_db;
SELECT * FROM users WHERE role='ADMIN';
```

### Images not loading
1. Check files exist in `microservices/movie-service/public/`
2. Verify movie-service is running
3. Test direct access: `http://localhost:8082/display/filename.jpg`
4. Test gateway access: `http://localhost:9090/display/filename.jpg`

---

## 🔐 Security Notes

⚠️ **Development Configuration** - Change before production:

- [ ] Database password
- [ ] Admin password
- [ ] JWT secret
- [ ] Enable HTTPS
- [ ] Configure CORS properly
- [ ] Update Stripe keys
- [ ] Environment variables for secrets
- [ ] Rate limiting
- [ ] Input validation

---

## 🛠️ Development Workflow

### Daily Development
```bash
# Terminal 1: Backend Services
start-complete-system.bat

# Terminal 2: Frontend
cd frontend
npm start

# Access
http://localhost:4200
```

### Making Changes
```bash
# After code changes, restart specific service
cd microservices/[service-name]
mvn spring-boot:run

# Frontend hot-reload is automatic
```

### Adding Images
```bash
# Place files in
microservices/movie-service/public/display/
microservices/movie-service/public/banner/

# Access via
http://localhost:9090/display/your-image.jpg
http://localhost:9090/banner/your-banner.jpg
```

---

## 📊 Monitoring & Health Checks

### Service Discovery
```
http://localhost:8761
```
All services should appear as "UP"

### API Gateway
```
http://localhost:9090/actuator/health
```

### Individual Services
```
http://localhost:8081/actuator/health  # User Service
http://localhost:8082/actuator/health  # Movie Service
http://localhost:8083/actuator/health  # Venue Service
http://localhost:8084/actuator/health  # Booking Service
http://localhost:8085/actuator/health  # Payment Service
```

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

---

## 📝 License

This project is licensed for educational purposes.

---

## 📞 Support

For issues or questions:
1. Check the troubleshooting section
2. Review documentation files
3. Check service logs in terminal windows
4. Verify Eureka Dashboard
5. Test database connectivity

---

## 🎓 Learning Resources

- **Spring Boot**: https://spring.io/projects/spring-boot
- **Angular**: https://angular.io
- **Microservices**: https://microservices.io
- **MySQL**: https://dev.mysql.com/doc/

---

**Version**: 1.0  
**Last Updated**: December 9, 2025  
**Status**: ✅ Ready for Development

---

## ✨ What's Configured

✅ MySQL credentials: root/abc@123  
✅ 5 separate database schemas  
✅ Frontend integrated via API Gateway  
✅ Media folders consolidated  
✅ Fresh admin user auto-creation  
✅ Complete automation scripts  
✅ Comprehensive documentation  

**Ready to start?** Run `verify-setup.bat` and then `start-complete-system.bat`!
