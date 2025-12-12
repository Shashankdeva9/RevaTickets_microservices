# RevTickets Docker Deployment Guide

## Prerequisites
- Docker Desktop installed and running
- Docker Hub account (for pushing images)
- Maven installed (for building microservices)
- Git (for version control)

## Quick Start

### 1. Build and Push Images to Docker Hub

```bash
# Build all services and push to Docker Hub
.\build-and-push-docker.bat your-dockerhub-username

# Or run step by step:
docker login
.\build-and-push-docker.bat
```

### 2. Run Application with Docker Compose

```bash
# Start all services
.\start-docker.bat

# Or manually:
docker-compose -f docker-compose-full.yml up -d
```

### 3. Access the Application

- **Frontend**: http://localhost:4200
- **API Gateway**: http://localhost:9090
- **Eureka Dashboard**: http://localhost:8761
- **MySQL**: localhost:3306 (root/abc@123)
- **MongoDB**: localhost:27017

### 4. Stop Application

```bash
.\stop-docker.bat

# Or manually:
docker-compose -f docker-compose-full.yml down
```

## Docker Images

The application consists of 8 Docker images:

1. **revtickets-eureka** - Service Discovery (Port 8761)
2. **revtickets-gateway** - API Gateway (Port 9090)
3. **revtickets-user** - User Management (Port 8081)
4. **revtickets-movie** - Movie & Event Management (Port 8082)
5. **revtickets-venue** - Venue Management (Port 8083)
6. **revtickets-booking** - Booking & Show Management (Port 8084)
7. **revtickets-payment** - Payment Processing (Port 8085)
8. **revtickets-frontend** - Angular Frontend (Port 80 → mapped to 4200)

## Architecture

```
┌─────────────┐
│   Frontend  │ :4200
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ API Gateway │ :9090
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Eureka    │ :8761 (Service Registry)
└──────┬──────┘
       │
       ├──────┬──────┬──────┬──────┬──────┐
       ▼      ▼      ▼      ▼      ▼      ▼
    User   Movie  Venue  Booking Payment
    :8081  :8082  :8083  :8084   :8085
       │      │      │      │       │
       └──────┴──────┴──────┴───────┘
              │              │
              ▼              ▼
           MySQL          MongoDB
           :3306          :27017
```

## Jenkins Pipeline Deployment

### Setup Jenkins

1. **Install Jenkins Plugins**:
   - Docker Pipeline
   - Docker Commons
   - Git Plugin

2. **Configure Credentials in Jenkins**:
   - Docker Hub credentials (ID: `docker-hub-credentials`)
   - Git credentials (ID: `git-credentials`)

3. **Create Pipeline Job**:
   - New Item → Pipeline
   - Pipeline script from SCM
   - Repository: https://github.com/Shashankdeva9/RevaTickets_microservices.git
   - Script Path: `Jenkinsfile-Docker`

4. **Build the Pipeline**:
   - Click "Build Now"
   - Jenkins will:
     - Checkout code
     - Build all microservices with Maven
     - Create Docker images
     - Push images to Docker Hub
     - Deploy with docker-compose
     - Run health checks

## Manual Docker Commands

### Build Individual Images

```bash
# Eureka Server
cd microservices/eureka-server
mvn clean package -DskipTests
docker build -t your-username/revtickets-eureka:latest .

# API Gateway
cd microservices/api-gateway
mvn clean package -DskipTests
docker build -t your-username/revtickets-gateway:latest .

# Repeat for other services...
```

### Push Images

```bash
docker push your-username/revtickets-eureka:latest
docker push your-username/revtickets-gateway:latest
docker push your-username/revtickets-user:latest
docker push your-username/revtickets-movie:latest
docker push your-username/revtickets-venue:latest
docker push your-username/revtickets-booking:latest
docker push your-username/revtickets-payment:latest
docker push your-username/revtickets-frontend:latest
```

### View Logs

```bash
# All services
docker-compose -f docker-compose-full.yml logs -f

# Specific service
docker-compose -f docker-compose-full.yml logs -f api-gateway

# Individual container
docker logs revtickets-gateway -f
```

### Check Service Health

```bash
# Check running containers
docker ps

# Check service health
curl http://localhost:8761/actuator/health  # Eureka
curl http://localhost:9090/actuator/health  # Gateway
curl http://localhost:8081/actuator/health  # User Service
```

## Database Configuration

### MySQL Databases
- `revtickets_user_db` - User data
- `revtickets_movie_db` - Movies and events
- `revtickets_venue_db` - Venues and screens
- `revtickets_booking_db` - Bookings and shows
- `revtickets_payment_db` - Payment transactions

All databases are auto-created on startup via `init-db.sql`.

### MongoDB
- Database: `revtickets_reviews`
- Collection: Movie reviews

## Environment Variables

Services use environment variables for Docker networking:

```yaml
SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/database_name
SPRING_DATASOURCE_USERNAME: root
SPRING_DATASOURCE_PASSWORD: abc@123
SPRING_DATA_MONGODB_HOST: mongodb
EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://eureka-server:8761/eureka/
EUREKA_INSTANCE_PREFER_IP_ADDRESS: "true"
```

## Troubleshooting

### Services not registering with Eureka
```bash
# Check Eureka logs
docker logs revtickets-eureka -f

# Restart service
docker-compose -f docker-compose-full.yml restart api-gateway
```

### Database connection errors
```bash
# Check MySQL is healthy
docker exec revtickets-mysql mysqladmin ping -uroot -pabc@123

# Check databases exist
docker exec revtickets-mysql mysql -uroot -pabc@123 -e "SHOW DATABASES;"
```

### Frontend can't connect to backend
- Check API Gateway is running: `docker ps | grep gateway`
- Check CORS configuration in `api-gateway/application.yml`
- Verify frontend environment points to `http://localhost:9090/api`

### Container memory issues
```bash
# Increase Docker Desktop memory limit
# Settings → Resources → Memory → 8GB recommended
```

## Updating the Application

### Update and rebuild specific service
```bash
# Make code changes
cd microservices/user-service
mvn clean package -DskipTests
docker build -t your-username/revtickets-user:latest .
docker push your-username/revtickets-user:latest

# Restart just that service
docker-compose -f docker-compose-full.yml up -d --no-deps --build user-service
```

## Production Considerations

1. **Security**:
   - Change default MySQL password
   - Use secrets management for credentials
   - Enable HTTPS with SSL certificates

2. **Scaling**:
   - Use `docker-compose scale` for horizontal scaling
   - Configure load balancer in front of gateway

3. **Monitoring**:
   - Add Prometheus and Grafana
   - Configure centralized logging (ELK stack)
   - Set up alerts for service health

4. **Backup**:
   - Regular MySQL backups: `docker exec revtickets-mysql mysqldump -uroot -pabc@123 --all-databases > backup.sql`
   - MongoDB backups: `docker exec revtickets-mongodb mongodump`

## Clean Up

### Remove all containers and volumes
```bash
docker-compose -f docker-compose-full.yml down -v
```

### Remove all images
```bash
docker rmi $(docker images 'revtickets-*' -q)
```

### Full cleanup
```bash
docker system prune -a --volumes
```

## Support

For issues or questions:
- Check logs: `docker-compose -f docker-compose-full.yml logs`
- GitHub Issues: https://github.com/Shashankdeva9/RevaTickets_microservices/issues
