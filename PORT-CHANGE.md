# Port Change Summary - Jenkins Conflict Resolution

## ⚠️ Problem
Port 8080 was in use by Jenkins, causing conflicts with the API Gateway.

## ✅ Solution
Changed API Gateway from port **8080** to port **9090**

---

## 📝 Files Modified

### Backend Configuration
1. **`microservices/api-gateway/src/main/resources/application.yml`**
   - Changed: `server.port: 8080` → `server.port: 9090`

### Frontend Configuration
2. **`frontend/src/environments/environment.ts`**
   - Changed: `apiUrl: 'http://localhost:8080/api'` → `'http://localhost:9090/api'`
   - Changed: `wsUrl: 'ws://localhost:8080/ws'` → `'ws://localhost:9090/ws'`

3. **`frontend/src/environments/environment.prod.ts`**
   - Changed: `apiUrl: 'http://localhost:8080/api'` → `'http://localhost:9090/api'`
   - Changed: `wsUrl: 'ws://localhost:8080/ws'` → `'ws://localhost:9090/ws'`

### Scripts
4. **`START.bat`**
   - Window title: `Gateway-8080` → `Gateway-9090`
   - Display URL: Updated to show port 9090

5. **`STOP.bat`**
   - Kill process by window title: Updated to `Gateway-9090`
   - Kill by port: `8080` → `9090`

### Documentation
6. **`README.md`** - All references updated
7. **`SETUP.md`** - All references updated  
8. **`QUICK-REFERENCE.md`** - All references updated
9. **`CHANGES.md`** - All references updated

---

## 🌐 New Service Endpoints

### API Gateway
- **Old**: `http://localhost:8080`
- **New**: `http://localhost:9090`

### All API Endpoints (Examples)
- `http://localhost:9090/api/auth/login`
- `http://localhost:9090/api/movies`
- `http://localhost:9090/api/events`
- `http://localhost:9090/display/{filename}`
- `http://localhost:9090/banner/{filename}`

### WebSocket
- **Old**: `ws://localhost:8080/ws`
- **New**: `ws://localhost:9090/ws`

---

## 🔌 Updated Port Map

| Service | Port | URL |
|---------|------|-----|
| Eureka Server | 8761 | http://localhost:8761 |
| **API Gateway** | **9090** | **http://localhost:9090** |
| User Service | 8081 | http://localhost:8081 |
| Movie Service | 8082 | http://localhost:8082 |
| Venue Service | 8083 | http://localhost:8083 |
| Booking Service | 8084 | http://localhost:8084 |
| Payment Service | 8085 | http://localhost:8085 |
| Frontend | 4200 | http://localhost:4200 |

---

## ✅ Verification

After starting the application:

1. **API Gateway**: http://localhost:9090/actuator/health
2. **Frontend**: http://localhost:4200 (connects to port 9090)
3. **No conflict with Jenkins on port 8080**

---

## 🚀 No Changes Required for Users

The scripts handle everything:
- `START.bat` - Uses port 9090 automatically
- `STOP.bat` - Stops services on port 9090
- `RESTART.bat` - Restarts with new port

**Just run START.bat as usual!**

---

**Updated**: December 9, 2025
**Port Changed**: 8080 → 9090
**Reason**: Jenkins conflict resolution
