# RevTickets Docker Setup - Quick Reference

## Files Created

### Docker Compose Files
1. **docker-compose-full.yml** - Build images locally and run
2. **docker-compose-hub.yml** - Pull pre-built images from Docker Hub
3. **init-db.sql** - Initialize MySQL databases

### Jenkins Pipeline
- **Jenkinsfile-Docker** - Automated CI/CD pipeline

### Build Scripts
- **build-and-push-docker.bat** - Build all images and push to Docker Hub
- **start-docker.bat** - Start application with Docker Compose
- **stop-docker.bat** - Stop all Docker containers

### Configuration Files
- **application-docker.properties** - Created for each microservice (5 files)
- **environment.docker.ts** - Frontend Docker environment

## Quick Commands

### Local Build and Run
```bash
# Build and push to Docker Hub
.\build-and-push-docker.bat your-dockerhub-username

# Start application
.\start-docker.bat

# Stop application
.\stop-docker.bat
```

### Using Pre-built Images
```bash
# Set your Docker Hub username
set DOCKER_REGISTRY=your-username

# Pull and run
docker-compose -f docker-compose-hub.yml up -d

# Stop
docker-compose -f docker-compose-hub.yml down
```

### Jenkins Pipeline
1. Configure credentials in Jenkins
2. Create pipeline job pointing to Jenkinsfile-Docker
3. Run build - Jenkins will build, push, and deploy automatically

## Access Points
- Frontend: http://localhost:4200
- API Gateway: http://localhost:9090
- Eureka: http://localhost:8761
- MySQL: localhost:3306 (root/abc@123)
- MongoDB: localhost:27017

## Before You Start
1. Update `DOCKER_REGISTRY` in Jenkinsfile-Docker with your Docker Hub username
2. Update docker-compose-hub.yml if pulling from your registry
3. Ensure Docker Desktop is running
4. Login to Docker Hub: `docker login`

## Next Steps
1. Test locally: `.\start-docker.bat`
2. Push to Docker Hub: `.\build-and-push-docker.bat your-username`
3. Setup Jenkins pipeline for CI/CD
4. Deploy to production server

See DOCKER-DEPLOYMENT.md for detailed documentation.
