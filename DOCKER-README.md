# RevTickets Docker Images

## Available Images

All images are available on Docker Hub:

```
yourusername/revtickets-eureka:latest
yourusername/revtickets-gateway:latest
yourusername/revtickets-user:latest
yourusername/revtickets-movie:latest
yourusername/revtickets-venue:latest
yourusername/revtickets-booking:latest
yourusername/revtickets-payment:latest
yourusername/revtickets-frontend:latest
```

## Quick Start

### 1. Using Pre-built Images (Recommended)

```bash
# Update docker-compose-production.yml with your Docker Hub username
export DOCKER_HUB_USERNAME=yourusername

# Pull and start all services
docker-compose -f docker-compose-production.yml up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### 2. Build Images Locally

**Linux/Mac:**
```bash
chmod +x build-and-push.sh
./build-and-push.sh yourusername
```

**Windows:**
```cmd
build-and-push.bat yourusername
```

## Jenkins Pipeline

### Setup Steps:

1. **Add Docker Hub Credentials in Jenkins**
   - Navigate to: Manage Jenkins → Manage Credentials
   - Add Secret Text credentials:
     - ID: `docker-hub-username`
     - Secret: your-docker-hub-username
   - Add Secret Text credentials:
     - ID: `docker-hub-password`
     - Secret: your-docker-hub-password

2. **Create Jenkins Pipeline Job**
   - New Item → Pipeline
   - Pipeline script from SCM
   - Select Git
   - Repository URL: your-repo-url
   - Script Path: `Jenkinsfile`

3. **Run Pipeline**
   - Click "Build Now"
   - Monitor Console Output

### Pipeline Features:

✅ Parallel building of all microservices
✅ Automatic Docker image creation
✅ Push to Docker Hub with version tags
✅ Multi-stage Docker builds for smaller images
✅ Health checks for all services
✅ Automatic cleanup

## Docker Compose Profiles

### Development (Local)
```bash
docker-compose up -d
```

### Production (Docker Hub images)
```bash
docker-compose -f docker-compose-production.yml up -d
```

## Environment Configuration

### Default Ports:
- Frontend: 80
- API Gateway: 9090
- Eureka Server: 8761
- User Service: 8081
- Movie Service: 8082
- Venue Service: 8083
- Booking Service: 8084
- Payment Service: 8085
- MySQL: 3306
- MongoDB: 27017

### Database Credentials:
- MySQL: root / abc@123
- MongoDB: root / abc@123

⚠️ **Change these in production!**

## Service Dependencies

```
Frontend → API Gateway → Services → Databases
                ↓
          Eureka Server
```

All microservices register with Eureka Server for service discovery.

## Image Details

### Microservices
- Base: `eclipse-temurin:17-jre-alpine`
- Build: Multi-stage with Maven
- Size: ~200-300MB per service
- Memory: 256-512MB allocated

### Frontend
- Base: `nginx:alpine`
- Build: Multi-stage with Node.js
- Size: ~50MB
- Serves static Angular files

### Databases
- MySQL: Official MySQL 8.0
- MongoDB: Official MongoDB 7.0

## Dockerfile Features

All microservice Dockerfiles include:
- Multi-stage builds (Build + Runtime)
- JVM memory optimization (-Xmx512m -Xms256m)
- Alpine Linux for smaller images
- Non-root user execution
- Health check endpoints

## Monitoring

### Check Service Health:
```bash
# All services
docker-compose ps

# Specific service
docker-compose logs -f user-service

# Eureka dashboard
open http://localhost:8761
```

### Resource Usage:
```bash
docker stats
```

## Scaling

Scale services horizontally:
```bash
docker-compose up -d --scale user-service=3
docker-compose up -d --scale booking-service=2
```

## Troubleshooting

### Service won't start:
```bash
# Check logs
docker logs <container-name>

# Check network
docker network inspect revtickets-network

# Restart service
docker-compose restart <service-name>
```

### Database connection issues:
```bash
# Check MySQL
docker exec -it revtickets-mysql mysql -uroot -pabc@123

# Check MongoDB
docker exec -it revtickets-mongodb mongosh -u root -p abc@123
```

### Clean restart:
```bash
docker-compose down -v
docker-compose up -d
```

## Production Checklist

Before deploying to production:

- [ ] Change all default passwords
- [ ] Update CORS allowed origins
- [ ] Configure SSL/TLS certificates
- [ ] Set up log aggregation
- [ ] Configure monitoring (Prometheus/Grafana)
- [ ] Set resource limits
- [ ] Configure backup strategy
- [ ] Set up secrets management
- [ ] Review security settings
- [ ] Configure firewall rules

## Support

For issues:
1. Check logs: `docker-compose logs`
2. Verify configuration
3. Check service health endpoints
4. Review Jenkins console output

## License

All rights reserved - RevTickets
