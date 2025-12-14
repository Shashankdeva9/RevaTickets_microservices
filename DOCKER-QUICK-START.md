# 🐳 Quick Docker Startup Guide

## ⚡ Get Started in 30 Seconds

### Option 1: Windows (PowerShell)

```powershell
cd "Rev-Tickets-Microservices"
docker-compose up -d
Start-Sleep -Seconds 30
docker-compose ps
```

### Option 2: Mac/Linux (Terminal)

```bash
cd Rev-Tickets-Microservices
docker-compose up -d
sleep 30
docker-compose ps
```

### Option 3: Windows (CMD)

```cmd
cd Rev-Tickets-Microservices
docker-compose up -d
timeout /t 30
docker-compose ps
```

---

## ✅ Verify Everything is Running

### Check All Services

```bash
docker-compose ps
```

Expected output:
```
NAME                   STATUS
revtickets-mysql       Up (healthy)
revtickets-mongodb     Up (healthy)
revtickets-eureka      Up (healthy)
revtickets-gateway     Up (healthy)
revtickets-user-service     Up
revtickets-movie-service    Up
revtickets-venue-service    Up
revtickets-booking-service  Up
revtickets-payment-service  Up
revtickets-frontend    Up (healthy)
```

### Access Applications

| Service | URL |
|---------|-----|
| **Frontend** | http://localhost:4200 |
| **API Gateway** | http://localhost:8080 |
| **Eureka Dashboard** | http://localhost:8761 |

---

## 🛑 Stop All Services

```bash
docker-compose down
```

**To also delete databases:**
```bash
docker-compose down -v
```

---

## 📊 View Service Logs

```bash
# View all logs (follow mode)
docker-compose logs -f

# View specific service logs
docker-compose logs -f user-service

# View last 50 lines
docker-compose logs --tail=50 api-gateway
```

---

## 🔧 Rebuild and Restart

```bash
# Rebuild all images
docker-compose build

# Rebuild specific service
docker-compose build user-service

# Restart services
docker-compose restart
```

---

## 📦 Docker Images Built

✅ All images created with:
- Multi-stage builds (smaller images)
- Non-root users (security)
- Health checks (orchestration ready)
- Optimized JVM settings
- Alpine Linux base (minimal)

---

## 🚀 Next Steps

1. ✅ Run: `docker-compose up -d`
2. ✅ Verify: `docker-compose ps`
3. ✅ Open: http://localhost:4200
4. ✅ Test APIs: Use RevTickets_Postman_Collection.json
5. ✅ Check logs: `docker-compose logs -f`

---

## 📖 For More Information

- **DOCKER-DEPLOYMENT.md** - Comprehensive Docker guide
- **JENKINS-SETUP.md** - CI/CD pipeline setup
- **README.md** - System architecture
- **RUN-LOCALLY.md** - Local development setup

**Happy Deploying! 🎉**
