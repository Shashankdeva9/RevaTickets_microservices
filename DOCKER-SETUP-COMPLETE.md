# RevTickets Docker & Jenkins Deployment - Complete Setup

## 📦 What's Been Created

### Core Files
✅ **docker-compose-full.yml** - Complete stack with build configuration
✅ **docker-compose-hub.yml** - Pull images from Docker Hub
✅ **init-db.sql** - Auto-initialize 5 MySQL databases
✅ **Jenkinsfile-Docker** - Full CI/CD pipeline
✅ **DOCKER-DEPLOYMENT.md** - Comprehensive documentation
✅ **DOCKER-QUICK-START.md** - Quick reference guide

### Build & Run Scripts
✅ **build-and-push-docker.bat** - Build all images and push to Docker Hub
✅ **start-docker.bat** - Start entire application
✅ **stop-docker.bat** - Stop all containers

### Configuration Updates
✅ Created **application-docker.properties** for all 5 microservices
✅ Updated **frontend/Dockerfile** for production build
✅ Created **environment.docker.ts** for frontend

## 🚀 How to Use

### Option 1: Quick Test Locally

```bash
# Start everything (builds images locally)
docker-compose -f docker-compose-full.yml up -d

# Access at:
# - Frontend: http://localhost:4200
# - API Gateway: http://localhost:9090
# - Eureka: http://localhost:8761
```

### Option 2: Build and Push to Docker Hub

```bash
# Login to Docker Hub
docker login

# Build all services and push
.\build-and-push-docker.bat your-dockerhub-username

# This will:
# 1. Build all 7 microservices with Maven
# 2. Create 8 Docker images
# 3. Push to your Docker Hub
```

### Option 3: Use Jenkins Pipeline

**Setup Steps:**

1. **Install Jenkins Plugins:**
   - Docker Pipeline
   - Docker Commons
   - Git Plugin

2. **Add Credentials:**
   - Docker Hub (ID: `docker-hub-credentials`)
   - Git (ID: `git-credentials`)

3. **Create Pipeline Job:**
   - New Item → Pipeline
   - Repository: https://github.com/Shashankdeva9/RevaTickets_microservices.git
   - Script Path: `Jenkinsfile-Docker`
   - **Important**: Update `DOCKER_REGISTRY` in Jenkinsfile-Docker with your Docker Hub username

4. **Run Pipeline:**
   - Click "Build Now"
   - Jenkins will automatically:
     ✅ Checkout code
     ✅ Build all microservices (parallel)
     ✅ Create Docker images
     ✅ Push to Docker Hub
     ✅ Deploy with docker-compose
     ✅ Run health checks

## 🏗️ Architecture

```
Docker Containers:
┌────────────────────────────────────────────┐
│  revtickets-mysql (3306)                   │ MySQL 8.0
│  - 5 databases auto-created                │
└────────────────────────────────────────────┘
┌────────────────────────────────────────────┐
│  revtickets-mongodb (27017)                │ MongoDB
│  - revtickets_reviews database             │
└────────────────────────────────────────────┘
┌────────────────────────────────────────────┐
│  revtickets-eureka (8761)                  │ Service Discovery
└────────────────────────────────────────────┘
┌────────────────────────────────────────────┐
│  revtickets-gateway (9090)                 │ API Gateway + CORS
└────────────────────────────────────────────┘
┌────────────────────────────────────────────┐
│  revtickets-user (8081)                    │ User Service
│  revtickets-movie (8082)                   │ Movie/Event Service
│  revtickets-venue (8083)                   │ Venue Service
│  revtickets-booking (8084)                 │ Booking/Show Service
│  revtickets-payment (8085)                 │ Payment Service
└────────────────────────────────────────────┘
┌────────────────────────────────────────────┐
│  revtickets-frontend (4200)                │ Angular Frontend
└────────────────────────────────────────────┘
```

## 📋 Docker Images

Your Docker Hub will have 8 images:
1. `your-username/revtickets-eureka:latest`
2. `your-username/revtickets-gateway:latest`
3. `your-username/revtickets-user:latest`
4. `your-username/revtickets-movie:latest`
5. `your-username/revtickets-venue:latest`
6. `your-username/revtickets-booking:latest`
7. `your-username/revtickets-payment:latest`
8. `your-username/revtickets-frontend:latest`

## 🔧 Configuration Details

### Database Connections (Docker)
All services automatically connect to Docker network hostnames:
- MySQL: `mysql:3306`
- MongoDB: `mongodb:27017`
- Eureka: `eureka-server:8761`

### Environment Variables
Services use these environment variables in Docker:
```yaml
SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/database_name
SPRING_DATASOURCE_USERNAME: root
SPRING_DATASOURCE_PASSWORD: abc@123
SPRING_DATA_MONGODB_HOST: mongodb
EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://eureka-server:8761/eureka/
EUREKA_INSTANCE_PREFER_IP_ADDRESS: "true"
```

### Local Development
Your existing application.properties still work for local development:
- Localhost connections preserved
- Docker profiles use environment variables
- No changes needed to existing local setup

## 🎯 Jenkins Pipeline Stages

1. **Checkout** - Pull latest code from Git
2. **Build Microservices** (Parallel) - Maven builds all 7 services
3. **Build Docker Images** - Create 8 Docker images
4. **Push Docker Images** - Upload to Docker Hub
5. **Deploy** - Start with docker-compose
6. **Health Check** - Verify all services are running

## ✅ Testing the Deployment

### Check Containers
```bash
docker ps
# Should show 10 containers running
```

### Check Service Health
```bash
curl http://localhost:8761  # Eureka Dashboard
curl http://localhost:9090/actuator/health  # Gateway
curl http://localhost:4200  # Frontend
```

### View Logs
```bash
# All services
docker-compose -f docker-compose-full.yml logs -f

# Specific service
docker logs revtickets-gateway -f
```

## 🐛 Troubleshooting

### Services not starting
```bash
# Check Docker is running
docker info

# Increase Docker memory (Settings → Resources → 8GB)

# Check logs
docker-compose -f docker-compose-full.yml logs
```

### Database connection errors
```bash
# Verify MySQL is healthy
docker exec revtickets-mysql mysqladmin ping -uroot -pabc@123

# Check databases created
docker exec revtickets-mysql mysql -uroot -pabc@123 -e "SHOW DATABASES;"
```

### Services not registering with Eureka
```bash
# Wait 30 seconds after startup
# Check Eureka dashboard: http://localhost:8761

# Restart service
docker-compose -f docker-compose-full.yml restart user-service
```

## 📝 Important Notes

### Before Pushing to Docker Hub
1. Update `DOCKER_REGISTRY` in:
   - `Jenkinsfile-Docker` (line 6)
   - `docker-compose-hub.yml` (use environment variable)

2. Login to Docker Hub:
   ```bash
   docker login
   ```

### Database Data Persistence
- MySQL data: Stored in Docker volume `mysql-data`
- MongoDB data: Stored in Docker volume `mongodb-data`
- Data persists even after `docker-compose down`
- To remove data: `docker-compose down -v`

### Port Mappings
| Service | Container Port | Host Port |
|---------|----------------|-----------|
| MySQL | 3306 | 3306 |
| MongoDB | 27017 | 27017 |
| Eureka | 8761 | 8761 |
| Gateway | 9090 | 9090 |
| User | 8081 | 8081 |
| Movie | 8082 | 8082 |
| Venue | 8083 | 8083 |
| Booking | 8084 | 8084 |
| Payment | 8085 | 8085 |
| Frontend | 80 | 4200 |

## 🚀 Deployment Workflow

### For Development
```bash
# Make code changes
# Test locally
.\START.bat

# When ready, build Docker images
.\build-and-push-docker.bat your-username
```

### For Production (Jenkins)
```bash
# Push code to Git
git add .
git commit -m "Your changes"
git push origin main

# Jenkins automatically:
# 1. Detects commit
# 2. Builds everything
# 3. Creates images
# 4. Pushes to Docker Hub
# 5. Deploys application
```

## 📚 Documentation Files

- **DOCKER-DEPLOYMENT.md** - Full deployment guide with all details
- **DOCKER-QUICK-START.md** - Quick commands reference
- This file - Complete setup summary

## ✨ What Works Now

✅ Complete Docker containerization
✅ MySQL with 5 auto-created databases
✅ MongoDB for reviews
✅ Service discovery with Eureka
✅ API Gateway with CORS
✅ All 5 microservices containerized
✅ Angular frontend containerized
✅ Jenkins CI/CD pipeline
✅ Health checks for all services
✅ Data persistence with volumes
✅ Docker Compose orchestration
✅ Push to Docker Hub
✅ Pull from Docker Hub
✅ Local development unchanged

## 🎉 Ready to Deploy!

Your application is now fully containerized and ready for:
- Local Docker testing
- CI/CD with Jenkins
- Cloud deployment (AWS, Azure, GCP)
- Kubernetes orchestration (future)

**Next Steps:**
1. Test locally: `.\start-docker.bat`
2. Push to Docker Hub: `.\build-and-push-docker.bat your-username`
3. Setup Jenkins pipeline
4. Deploy to production!
