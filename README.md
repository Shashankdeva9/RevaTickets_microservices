# RevTickets - Microservices Movie Booking Platform

A complete **local execution** microservices architecture with 7 Spring Boot services + Angular frontend.

## 🚀 Quick Start (3 Steps)

### 1. **Check Prerequisites** ✓
- Java 17 (installed)
- Maven 3.9+ (installed)
- Node.js & npm (installed)
- MySQL 3306 running
- MongoDB 27017 running

### 2. **Start All Services**
```batch
START.bat
```
This will:
- Start Eureka Server (8761) - Service Discovery
- Start API Gateway (8080) - Routes requests
- Start 5 Microservices (8081-8085)
- Start Angular Frontend (4200)
- Each service opens in its own window showing logs

### 3. **Stop Everything**
```batch
STOP.bat
```

---

## 🌐 Access Your Application

| Component | URL | Port |
|-----------|-----|------|
| **Frontend** | http://localhost:4200 | 4200 |
| **API Gateway** | http://localhost:8080/api | 8080 |
| **Eureka Dashboard** | http://localhost:8761 | 8761 |

---

## 📊 System Architecture

```
┌─────────────────────────────────────┐
│    Angular Frontend (4200)          │
└────────────┬────────────────────────┘
             │ HTTP/WebSocket
             ▼
┌─────────────────────────────────────┐
│ API Gateway (8080) - Spring Boot    │
│ CORS: localhost:4200 ✓              │
└────────┬────────┬────────┬──────────┘
         │        │        │
     ┌───▼──┐ ┌──▼──┐ ┌───▼──┐
     │User  │ │Movie│ │Venue │
     │8081  │ │8082 │ │8083  │
     └──┬───┘ └──┬──┘ └───┬──┘
        │        │        │
     ┌──▼────────▼────────▼───┐
     │ Eureka (8761)          │
     │ Service Discovery      │
     └──┬────────┬────────────┘
        │        │
     ┌──▼──┐ ┌───▼──┐
     │Book │ │Payment
     │8084 │ │8085
     └─────┘ └──────┘
        │       │
     ┌──▼───────▼──────┐
     │ Databases       │
     │ MySQL & MongoDB │
     └─────────────────┘
```

---

## 🔧 Microservices (7 Total)

| Service | Port | Database | Purpose |
|---------|------|----------|---------|
| **Eureka** | 8761 | - | Service registry |
| **API Gateway** | 8080 | - | Request routing |
| **User Service** | 8081 | MySQL | Auth & admin |
| **Movie Service** | 8082 | MongoDB | Movies & events |
| **Venue Service** | 8083 | MySQL | Venues & cities |
| **Booking Service** | 8084 | MySQL | Bookings & seats |
| **Payment Service** | 8085 | MySQL | Payments |

---

## 🗄️ Database Configuration

### MySQL (localhost:3306)
```
Credentials: root / abc@123
Databases:
- revtickets_user_db
- revtickets_venue_db
- revtickets_booking_db
- revtickets_payment_db
```

### MongoDB (localhost:27017)
```
Credentials: root / abc@123
Database: revtickets_movie_db
```

---

## 📡 API Endpoints

### Authentication
```
POST   /api/auth/register
POST   /api/auth/login
```

### Movies
```
GET    /api/movies
GET    /api/movies/{id}
GET    /api/movies/search
GET    /api/events
GET    /api/reviews/movie/{id}
POST   /api/reviews
```

### Venues
```
GET    /api/venues
GET    /api/venues/{id}
GET    /api/venues/city/{city}
```

### Bookings
```
GET    /api/bookings
GET    /api/seats/show/{showId}
GET    /api/seats/available/show/{showId}
```

### Payments
```
GET    /api/payments/{id}
POST   /api/payments/create-order
```

### Admin
```
GET    /api/admin/users
GET    /api/admin/users/{id}
GET    /api/admin/dashboard/stats
GET    /api/admin/bookings
GET    /api/admin/shows
```

---

## ✅ System Status

| Component | Status | Details |
|-----------|--------|---------|
| **HTTP Methods** | ✓ Working | GET, POST, PUT, DELETE, PATCH |
| **CORS** | ✓ Enabled | Frontend to API Gateway |
| **Databases** | ✓ Connected | MySQL & MongoDB |
| **Endpoints** | ✓ Configured | All services integrated |
| **API Gateway** | ✓ Routing | Central request handler |
| **Eureka** | ✓ Discovery | Service registration |

---

## 🔍 Monitoring & Verification

### Check Services
```powershell
netstat -ano | findstr :4200     # Frontend
netstat -ano | findstr :8080     # API Gateway
netstat -ano | findstr :8761     # Eureka
netstat -ano | findstr :8081     # User
netstat -ano | findstr :8082     # Movie
netstat -ano | findstr :8083     # Venue
netstat -ano | findstr :8084     # Booking
netstat -ano | findstr :8085     # Payment
```

### View Service Logs
Each service window shows **real-time logs**. Don't close windows while running!

### Eureka Dashboard
```
http://localhost:8761
```
Shows registered services (6 services + API Gateway = 7 total)

---

## 🛠️ Troubleshooting

### Services Won't Start
1. Check Java: `java -version`
2. Check Maven: `mvn -version`
3. Kill existing: `taskkill /F /IM java.exe`

### Port Already in Use
```powershell
netstat -ano | findstr :PORT
taskkill /PID <PID> /F
```

### Frontend Can't Connect
- ✓ Already configured to use localhost:8080
- Verify API Gateway is running

### Database Error
- Check MySQL: `netstat -ano | findstr :3306`
- Check MongoDB: `netstat -ano | findstr :27017`
- Verify credentials: root/abc@123

---

## 📂 Project Structure

```
Rev-Tickets-Microservices/
├── START.bat                  ← Start all
├── STOP.bat                   ← Stop all
├── README.md                  ← This file
├── RUN-LOCALLY.md             ← Detailed guide
├── AUDIT-REPORT.md            ← Full audit
├── RevTickets_Postman_Collection.json ← API tests
├── frontend/                  ← Angular (4200)
│   ├── src/
│   │   └── environments/
│   │       └── environment.ts (API: localhost:8080)
│   └── package.json
└── microservices/
    ├── eureka-server/         ← 8761
    ├── api-gateway/           ← 8080
    │   └── application.yml
    ├── user-service/          ← 8081
    ├── movie-service/         ← 8082
    ├── venue-service/         ← 8083
    ├── booking-service/       ← 8084
    └── payment-service/       ← 8085
```

---

## 📋 Documentation

- **START.bat** - Starts all services in local mode
- **STOP.bat** - Stops all services gracefully
- **RUN-LOCALLY.md** - Complete step-by-step guide
- **AUDIT-REPORT.md** - Full system audit results
- **RevTickets_Postman_Collection.json** - Test all APIs

---

## ✨ Key Features

✅ All HTTP methods working  
✅ CORS properly configured  
✅ Databases fully integrated  
✅ Service discovery enabled  
✅ API gateway routing active  
✅ No Docker required  
✅ Local execution only  
✅ Production ready  

---

## 🎯 Next Steps

1. Run: `START.bat`
2. Open: http://localhost:4200
3. Test APIs with Postman Collection
4. View service logs in terminal windows
5. Check Eureka: http://localhost:8761

---

**Status:** ✅ **READY TO RUN**

For detailed information, see RUN-LOCALLY.md
