# Docker & CI/CD Deployment Guide

## 📋 Quick Start with Docker

### Prerequisites
- Docker Desktop installed and running
- Docker Compose installed (included with Docker Desktop)
- Port availability: 4200, 8080, 8081-8085, 8761, 3306, 27017

### Start All Services with Docker Compose

```bash
# Navigate to project root
cd Rev-Tickets-Microservices

# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Check service status
docker-compose ps
```

### Access Services

| Service | URL | Purpose |
|---------|-----|---------|
| **Frontend** | http://localhost:4200 | Angular Web Application |
| **API Gateway** | http://localhost:8080 | REST API Gateway |
| **Eureka Dashboard** | http://localhost:8761 | Service Registry |
| **MySQL** | localhost:3306 | Database (root/abc@123) |
| **MongoDB** | localhost:27017 | NoSQL Database (root/abc@123) |

### Stop All Services

```bash
docker-compose down

# Remove volumes (reset databases)
docker-compose down -v

# View all running services
docker-compose ps
```

---

## 🐳 Docker Architecture

### Docker Compose Services

**Databases:**
- `mysql`: MySQL 8.0 with 4 pre-configured databases
- `mongodb`: MongoDB 7.0 with authentication

**Backend Services:**
- `eureka-server`: Service Registry on port 8761
- `api-gateway`: Spring Cloud Gateway on port 8080
- `user-service`: User Management on port 8081
- `movie-service`: Movie Management on port 8082
- `venue-service`: Venue Management on port 8083
- `booking-service`: Booking Management on port 8084
- `payment-service`: Payment Management on port 8085

**Frontend:**
- `frontend`: Angular application on port 4200 (nginx)

### Network Configuration

All services are connected via `revtickets-network` (bridge network) for inter-service communication using service names as hostnames.

Example: `http://mysql:3306`, `http://eureka-server:8761`

---

## 🔨 Building Docker Images

### Build All Images

```bash
docker-compose build
```

### Build Specific Service

```bash
# Build only API Gateway
docker-compose build api-gateway

# Build only Frontend
docker-compose build frontend
```

### Manual Docker Build

```bash
# Build individual service
docker build -t revtickets/user-service:1.0.0 microservices/user-service/

# Build frontend
docker build -t revtickets/frontend:1.0.0 frontend/

# Tag for registry
docker tag revtickets/user-service:1.0.0 docker.io/yourusername/revtickets/user-service:1.0.0
```

---

## 📦 Docker Image Details

### Multi-Stage Builds
All microservice Dockerfiles use multi-stage builds:
1. **Build Stage**: Maven builds the application
2. **Production Stage**: Minimal runtime image with just JRE

### Features
- ✅ Non-root user execution (UID 1000)
- ✅ Health checks for container orchestration
- ✅ Optimized JVM settings (G1GC)
- ✅ Alpine Linux for smaller images
- ✅ Proper signal handling

### Optimizations
- **Memory**: 256MB-512MB per service (configurable via JVM_OPTS)
- **Base Images**:
  - Backend: `eclipse-temurin:17-jre-alpine` (~170MB)
  - Frontend: `nginx:alpine` (~40MB)

---

## 🔄 CI/CD Pipeline with Jenkins

### Jenkinsfile Overview

The included `Jenkinsfile` provides:

**Pipeline Stages:**
1. **Checkout** - Clone repository
2. **Build Backend** - Parallel Maven builds for all 7 microservices
3. **Build Frontend** - Angular build with production optimization
4. **Run Tests** - Execute unit tests (main branch only)
5. **Code Quality** - SonarQube analysis (when configured)
6. **Build Docker Images** - Create Docker images for all services
7. **Push Images** - Push to Docker registry (main branch only)
8. **Deploy** - Docker Compose deployment
9. **Health Check** - Verify all services are operational

### Jenkins Setup

#### 1. Install Jenkins Plugins
Required plugins:
- Git plugin
- Docker plugin
- Pipeline plugin
- Credentials Binding plugin

#### 2. Create Credentials
In Jenkins, add credentials:

**Docker Hub Credentials:**
- ID: `docker-hub-credentials`
- Type: Username with password
- Username: Your Docker Hub username
- Password: Your Docker Hub token

**Git Credentials (if private repo):**
- SSH key or Personal Access Token

#### 3. Create Jenkins Job

```groovy
// Option 1: Create Pipeline job from SCM
Job Type: Pipeline
Definition: Pipeline script from SCM
SCM: Git
Repository URL: https://github.com/yourusername/Rev-Tickets-Microservices.git
Script Path: Jenkinsfile
```

#### 4. Configure Webhook (Optional)

GitHub Settings → Webhooks:
```
Payload URL: http://jenkins-server:8080/github-webhook/
Events: Push events
Content type: application/json
```

### Jenkins Execution

```bash
# Trigger pipeline from command line
curl -X POST http://jenkins-server:8080/job/RevTickets/build \
  -H "Authorization: Bearer YOUR_API_TOKEN"
```

---

## 🚀 Docker Registry Integration

### Docker Hub

```bash
# Login
docker login -u your-username -p your-password

# Tag image
docker tag revtickets/user-service:latest your-username/revtickets/user-service:latest

# Push to registry
docker push your-username/revtickets/user-service:latest

# Pull from registry
docker pull your-username/revtickets/user-service:latest
```

### Private Registry (Harbor, Artifactory, etc.)

```bash
# Login to private registry
docker login registry.example.com

# Tag for private registry
docker tag revtickets/user-service registry.example.com/revtickets/user-service:1.0.0

# Push to private registry
docker push registry.example.com/revtickets/user-service:1.0.0
```

---

## 📊 Monitoring & Debugging

### View Container Logs

```bash
# View specific service logs
docker-compose logs -f user-service

# View last 100 lines
docker-compose logs --tail=100 api-gateway

# View logs for all services
docker-compose logs -f
```

### Execute Commands in Container

```bash
# Access MySQL
docker exec -it revtickets-mysql mysql -u root -pabc@123

# Access MongoDB
docker exec -it revtickets-mongodb mongosh -u root -p abc@123

# Execute shell in Java service
docker exec -it revtickets-user-service /bin/sh
```

### Performance Monitoring

```bash
# CPU and Memory usage
docker stats

# Inspect container
docker inspect revtickets-user-service

# Check container logs for errors
docker logs revtickets-api-gateway | grep ERROR
```

---

## 🔧 Production Deployment

### Kubernetes Deployment

Generate Kubernetes manifests:

```bash
# Convert docker-compose to Kubernetes (using Kompose)
kompose convert -f docker-compose.yml -o k8s/

# Deploy to Kubernetes
kubectl apply -f k8s/
```

### Docker Swarm Deployment

```bash
# Initialize Swarm (on manager node)
docker swarm init

# Deploy stack
docker stack deploy -c docker-compose.yml revtickets

# View stack services
docker stack services revtickets

# Remove stack
docker stack rm revtickets
```

### Environment-Specific Configuration

Create separate docker-compose files:

```bash
docker-compose -f docker-compose.yml \
              -f docker-compose.prod.yml \
              up -d
```

---

## 🐛 Troubleshooting

### Container Won't Start

```bash
# Check logs
docker logs revtickets-user-service

# Inspect exit code
docker inspect revtickets-user-service | grep -A 5 "State"

# Check resource limits
docker stats --no-stream
```

### Database Connection Issues

```bash
# Test MySQL connection
docker exec -it revtickets-mysql mysql -h mysql -u root -pabc@123 -e "SELECT 1"

# Test MongoDB connection
docker exec -it revtickets-mongodb mongosh -u root -p abc@123 --eval "db.adminCommand('ping')"
```

### Network Issues

```bash
# Inspect network
docker network inspect revtickets-network

# Test DNS resolution
docker exec revtickets-api-gateway nslookup eureka-server

# Test port connectivity
docker exec revtickets-api-gateway curl -v http://eureka-server:8761
```

### Rebuild and Restart

```bash
# Full clean rebuild
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d

# Rebuild specific service
docker-compose build --no-cache user-service
docker-compose up -d user-service
```

---

## 📝 Docker Best Practices Used

✅ **Multi-Stage Builds** - Smaller production images
✅ **Non-Root Users** - Enhanced security
✅ **Health Checks** - Container orchestration ready
✅ **Optimized JVM** - G1GC for better performance
✅ **Alpine Linux** - Minimal attack surface
✅ **Environment Variables** - Configuration flexibility
✅ **.dockerignore** - Faster builds
✅ **Explicit Port Mapping** - Clear service discovery

---

## 📞 Support

For issues or questions:
1. Check logs: `docker-compose logs [service]`
2. Review [README.md](README.md) for system overview
3. Check [RUN-LOCALLY.md](RUN-LOCALLY.md) for local setup
4. Review [AUDIT-REPORT.md](AUDIT-REPORT.md) for verification status

---

**Last Updated:** December 14, 2025
**Docker Version Required:** 20.10+
**Docker Compose Version Required:** 2.0+
