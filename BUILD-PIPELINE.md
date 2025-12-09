# 🚀 Jenkins Pipeline - Complete Guide

## 📋 Prerequisites
- Jenkins installed and running
- Docker installed on Jenkins server
- Docker Hub account

---

## ⚡ Quick Setup (10 Minutes)

### 1️⃣ Add Docker Hub Credentials

```
Jenkins Dashboard
  └─ Manage Jenkins
      └─ Manage Credentials
          └─ (global)
              └─ Add Credentials
```

**Fill in:**
```
Kind: Username with password
ID: docker-hub-credentials
Username: [your-dockerhub-username]
Password: [your-dockerhub-password]
```

### 2️⃣ Create Pipeline Job

```
Jenkins Dashboard
  └─ New Item
      └─ Enter name: "RevTickets-Pipeline"
      └─ Select: Pipeline
      └─ Click: OK
```

### 3️⃣ Configure Pipeline

**Scroll to Pipeline section:**

```
Definition: Pipeline script from SCM
SCM: Git
Repository URL: [your-git-repo-url]
Branch: */main
Script Path: Jenkinsfile-simple
```

**Click Save**

### 4️⃣ Edit Jenkinsfile-simple

Open `Jenkinsfile-simple` and change line 5:
```groovy
DOCKER_HUB_REPO = 'yourusername'  // ← Change this to your Docker Hub username
```

### 5️⃣ Run Pipeline

```
Click: Build Now
```

Watch the build progress in Console Output!

---

## 📦 What Gets Built

| Service | Image Name | Port |
|---------|-----------|------|
| Eureka Server | yourusername/eureka-server:latest | 8761 |
| API Gateway | yourusername/api-gateway:latest | 8080 |
| User Service | yourusername/user-service:latest | 8081 |
| Movie Service | yourusername/movie-service:latest | 8082 |
| Venue Service | yourusername/venue-service:latest | 8083 |
| Booking Service | yourusername/booking-service:latest | 8084 |
| Payment Service | yourusername/payment-service:latest | 8085 |
| Frontend | yourusername/frontend:latest | 80 |

---

## 🎯 Pipeline Stages

```
Stage 1: Build All Services (Parallel)
├─ Eureka Server
├─ API Gateway
├─ User Service
├─ Movie Service
├─ Venue Service
├─ Booking Service
├─ Payment Service
└─ Frontend

Stage 2: Push to Registry
└─ Push all 8 images to Docker Hub

Stage 3: Cleanup
└─ Remove unused Docker images
```

---

## 🔧 Troubleshooting

### ❌ "docker: command not found"
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### ❌ "Permission denied while trying to connect to Docker"
```bash
sudo chmod 666 /var/run/docker.sock
```

### ❌ "Credentials not found: docker-hub-credentials"
- Check credential ID is exactly: `docker-hub-credentials`
- Verify it's in global scope

### ❌ "Cannot connect to Docker daemon"
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

---

## 🚀 Deploy After Build

### Option 1: Docker Compose (Recommended)
```bash
export DOCKER_REGISTRY=yourusername
docker-compose -f docker-compose-microservices.yml up -d
```

### Option 2: Individual Services
```bash
docker pull yourusername/eureka-server:latest
docker run -d -p 8761:8761 yourusername/eureka-server:latest

docker pull yourusername/api-gateway:latest
docker run -d -p 8080:8080 yourusername/api-gateway:latest
```

---

## ⏱️ Build Time

- **Parallel Build**: ~10-15 minutes
- **All 8 services built simultaneously**
- **Automatic push to Docker Hub**

---

## ✅ Verify Build

### Check Jenkins Console
```
BUILD SUCCESS
Finished: SUCCESS
```

### Check Docker Hub
```
https://hub.docker.com/u/yourusername
```

You should see 8 repositories created.

### Check Local Images
```bash
docker images | grep yourusername
```

---

## 🔄 Auto-Build on Git Push

### Add Webhook in GitHub
```
Repository → Settings → Webhooks → Add webhook
Payload URL: http://your-jenkins:8080/github-webhook/
Content type: application/json
Events: Just the push event
```

### Enable in Jenkins Job
```
Configure → Build Triggers → GitHub hook trigger for GITScm polling
```

---

## 📊 Pipeline Files

| File | Purpose |
|------|---------|
| `Jenkinsfile-simple` | Simple parallel build (recommended) |
| `Jenkinsfile` | Sequential build with more features |
| `Jenkinsfile-parallel` | Advanced parallel with notifications |

---

## 🎓 Next Steps

1. ✅ Build completes successfully
2. ✅ Images pushed to Docker Hub
3. ✅ Deploy using docker-compose
4. ✅ Access services at respective ports
5. ✅ Set up auto-build webhook

---

## 📞 Need Help?

- Check `JENKINS-STEPS.md` for detailed steps
- Check `jenkins-config.txt` for quick reference
- Review Jenkins Console Output for errors
