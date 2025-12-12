# RevTickets - Jenkins CI/CD Setup Guide

## Prerequisites

### 1. Install Jenkins
- Download and install Jenkins from https://www.jenkins.io/
- Start Jenkins and complete the initial setup

### 2. Install Required Jenkins Plugins
Go to **Manage Jenkins → Manage Plugins** and install:
- Docker Pipeline
- Docker Plugin
- Git Plugin
- Pipeline Plugin
- Credentials Plugin

### 3. Setup Docker Hub Credentials

#### In Jenkins:
1. Go to **Manage Jenkins → Manage Credentials**
2. Click on **(global)** domain
3. Click **Add Credentials**
4. Add two credentials:
   - **Docker Hub Username:**
     - Kind: Secret text
     - Secret: your-docker-hub-username
     - ID: `docker-hub-username`
   
   - **Docker Hub Password:**
     - Kind: Secret text
     - Secret: your-docker-hub-password
     - ID: `docker-hub-password`

### 4. Configure Jenkins Pipeline

1. Create a new Pipeline job:
   - Go to Jenkins Dashboard
   - Click **New Item**
   - Enter name: `RevTickets-Docker-Build`
   - Select **Pipeline**
   - Click **OK**

2. Configure Pipeline:
   - Under **Pipeline** section
   - Definition: **Pipeline script from SCM**
   - SCM: **Git**
   - Repository URL: Your GitHub repo URL
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`
   - Click **Save**

### 5. Update Docker Hub Username

Before running the pipeline, update your Docker Hub username:

1. In `docker-compose-production.yml`, replace `yourusername` with your Docker Hub username
2. Or set environment variable:
   ```bash
   export DOCKER_HUB_USERNAME=your-docker-hub-username
   ```

## Running the Pipeline

### Option 1: Through Jenkins UI
1. Go to your pipeline job
2. Click **Build Now**
3. Watch the build progress in Console Output

### Option 2: Through Git Push (with Webhook)
- Configure GitHub webhook to trigger builds on push
- Every push to main branch will trigger the pipeline

## Pipeline Stages

The pipeline will execute these stages:

1. **Checkout** - Clone the repository
2. **Build Maven Services** - Build all Spring Boot services in parallel
3. **Docker Login** - Login to Docker Hub
4. **Build and Push Docker Images** - Build and push all Docker images in parallel
5. **Cleanup** - Remove unused Docker images

## Deploy with Docker Compose

After successful pipeline execution:

```bash
# Pull images from Docker Hub
docker-compose -f docker-compose-production.yml pull

# Start all services
docker-compose -f docker-compose-production.yml up -d

# Check status
docker-compose -f docker-compose-production.yml ps

# View logs
docker-compose -f docker-compose-production.yml logs -f

# Stop all services
docker-compose -f docker-compose-production.yml down
```

## Service URLs

After deployment:
- Frontend: http://localhost
- API Gateway: http://localhost:9090
- Eureka Server: http://localhost:8761
- User Service: http://localhost:8081
- Movie Service: http://localhost:8082
- Venue Service: http://localhost:8083
- Booking Service: http://localhost:8084
- Payment Service: http://localhost:8085

## Troubleshooting

### Build Fails
- Check Jenkins Console Output for errors
- Verify Docker is installed and running
- Check Docker Hub credentials

### Services Don't Start
- Check Docker logs: `docker-compose logs <service-name>`
- Verify port availability
- Check database connections

### Images Not Found
- Verify Docker Hub username in docker-compose file
- Check if images were pushed successfully
- Try pulling manually: `docker pull username/revtickets-eureka:latest`

## Environment Variables

Update these in `docker-compose-production.yml` if needed:
- `MYSQL_ROOT_PASSWORD`
- `MONGO_INITDB_ROOT_PASSWORD`
- `SPRING_DATASOURCE_PASSWORD`

## Security Notes

⚠️ **Important:**
- Never commit Docker Hub credentials to Git
- Use Jenkins credentials manager
- Change default database passwords in production
- Use secrets management for sensitive data

## Monitoring

Check service health:
```bash
# Check all services
docker-compose ps

# Check specific service logs
docker-compose logs -f user-service

# Check database connection
docker exec -it revtickets-mysql mysql -uroot -pabc@123
```

## Scaling Services

Scale specific services:
```bash
docker-compose up -d --scale user-service=3
docker-compose up -d --scale booking-service=2
```

## Backup Database

```bash
# MySQL backup
docker exec revtickets-mysql mysqldump -uroot -pabc@123 --all-databases > backup.sql

# MongoDB backup
docker exec revtickets-mongodb mongodump --out /backup
```

## Clean Restart

```bash
# Stop and remove everything
docker-compose down -v

# Remove all images
docker-compose down --rmi all

# Fresh start
docker-compose up -d
```
