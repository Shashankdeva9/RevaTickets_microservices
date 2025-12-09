# Jenkins Pipeline - Quick Start Guide

## 🚀 Quick Setup (5 Minutes)

### Step 1: Configure Jenkins Credentials
```
Jenkins → Manage Jenkins → Manage Credentials → Add Credentials
```

**Add Docker Registry URL:**
- Kind: Secret text
- ID: `docker-registry-url`
- Secret: `docker.io/yourusername` (for Docker Hub)

**Add Docker Credentials:**
- Kind: Username with password
- ID: `docker-credentials-id`
- Username: Your Docker Hub username
- Password: Your Docker Hub token

### Step 2: Create Jenkins Job
```
New Item → Enter name → Pipeline → OK
```

**Configure Pipeline:**
- Definition: Pipeline script from SCM
- SCM: Git
- Repository URL: Your repo URL
- Script Path: `Jenkinsfile-parallel` (faster) or `Jenkinsfile` (sequential)

### Step 3: Run Pipeline
Click "Build Now" and watch it build all services!

---

## 📋 What Gets Built

✅ **Microservices:**
- eureka-server (Service Discovery)
- api-gateway (API Gateway)
- user-service
- movie-service
- venue-service
- booking-service
- payment-service

✅ **Frontend:**
- Angular frontend with Nginx

✅ **Databases:**
- MySQL 8.0
- MongoDB

---

## 🔧 Registry Options

### Docker Hub (Easiest)
```groovy
DOCKER_REGISTRY = 'docker.io/yourusername'
```

### AWS ECR
```groovy
DOCKER_REGISTRY = '123456789.dkr.ecr.us-east-1.amazonaws.com'
```
Install "Amazon ECR" plugin and use AWS credentials

### Azure Container Registry
```groovy
DOCKER_REGISTRY = 'yourregistry.azurecr.io'
```

### Google Container Registry
```groovy
DOCKER_REGISTRY = 'gcr.io/your-project-id'
```

---

## 🎯 Deploy After Build

### Option 1: Docker Compose (Recommended)
```bash
# Set your registry
export DOCKER_REGISTRY=docker.io/yourusername

# Pull and run all services
docker-compose -f docker-compose-microservices.yml up -d
```

### Option 2: Manual Docker Run
```bash
docker pull yourusername/eureka-server:latest
docker run -d -p 8761:8761 yourusername/eureka-server:latest
```

---

## 📊 Service Ports

| Service | Port |
|---------|------|
| Eureka Server | 8761 |
| API Gateway | 8080 |
| User Service | 8081 |
| Movie Service | 8082 |
| Venue Service | 8083 |
| Booking Service | 8084 |
| Payment Service | 8085 |
| Frontend | 80 |
| MySQL | 3307 |
| MongoDB | 27017 |

---

## ⚡ Pipeline Comparison

### Jenkinsfile (Sequential)
- ⏱️ Build time: ~20-30 minutes
- 💾 Memory: Low (1-2 GB)
- 🎯 Best for: Limited resources

### Jenkinsfile-parallel (Parallel)
- ⏱️ Build time: ~8-12 minutes
- 💾 Memory: High (4-8 GB)
- 🎯 Best for: Production CI/CD

---

## 🐛 Common Issues

### "Docker not found"
```bash
# Add jenkins user to docker group
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### "Permission denied"
```bash
# Fix Docker socket permissions
sudo chmod 666 /var/run/docker.sock
```

### "Registry authentication failed"
- Verify credentials in Jenkins
- Test: `docker login docker.io`

### "Out of memory"
- Use `Jenkinsfile` instead of `Jenkinsfile-parallel`
- Increase Jenkins heap size

---

## 🔄 Automated Triggers

### GitHub Webhook
1. GitHub Repo → Settings → Webhooks → Add webhook
2. Payload URL: `http://your-jenkins:8080/github-webhook/`
3. Content type: application/json
4. Events: Just the push event

### GitLab Webhook
1. GitLab Repo → Settings → Webhooks
2. URL: `http://your-jenkins:8080/project/YOUR_JOB_NAME`
3. Trigger: Push events

---

## 📦 Manual Build (Without Jenkins)

### Windows
```cmd
set DOCKER_REGISTRY=docker.io/yourusername
build-and-push.bat
```

### Linux/Mac
```bash
export DOCKER_REGISTRY=docker.io/yourusername
chmod +x build-and-push.sh
./build-and-push.sh
```

---

## ✅ Verify Deployment

```bash
# Check Eureka Dashboard
http://localhost:8761

# Check API Gateway
http://localhost:8080/actuator/health

# Check Frontend
http://localhost
```

---

## 🎓 Next Steps

1. ✅ Set up automated testing
2. ✅ Add deployment to Kubernetes
3. ✅ Implement blue-green deployment
4. ✅ Add monitoring (Prometheus/Grafana)
5. ✅ Set up logging (ELK Stack)

---

## 📞 Need Help?

Check `JENKINS-SETUP.md` for detailed documentation.
