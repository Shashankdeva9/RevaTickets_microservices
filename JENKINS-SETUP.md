# Jenkins Pipeline Setup Guide

## Prerequisites
1. Jenkins installed with Docker plugin
2. Docker installed on Jenkins agent
3. Docker registry (Docker Hub, AWS ECR, or private registry)

## Jenkins Configuration Steps

### 1. Install Required Plugins
Go to Jenkins → Manage Jenkins → Manage Plugins → Available
- Docker Pipeline
- Docker plugin
- Git plugin
- Pipeline plugin

### 2. Configure Docker Registry Credentials
Go to Jenkins → Manage Jenkins → Manage Credentials → Add Credentials

**For Docker Hub:**
- Kind: Username with password
- ID: `docker-credentials-id`
- Username: Your Docker Hub username
- Password: Your Docker Hub password/token

**For AWS ECR:**
- Kind: AWS Credentials
- ID: `aws-credentials-id`
- Access Key ID: Your AWS Access Key
- Secret Access Key: Your AWS Secret Key

### 3. Add Docker Registry URL
Go to Jenkins → Manage Jenkins → Manage Credentials → Add Credentials
- Kind: Secret text
- ID: `docker-registry-url`
- Secret: Your registry URL
  - Docker Hub: `docker.io/your-username`
  - AWS ECR: `123456789.dkr.ecr.us-east-1.amazonaws.com`
  - Private: `registry.example.com`

### 4. Create Jenkins Pipeline Job

#### Option A: Pipeline from SCM (Recommended)
1. New Item → Pipeline
2. Configure:
   - Pipeline Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: Your Git repository URL
   - Script Path: `Jenkinsfile` (or `Jenkinsfile-parallel` for faster builds)

#### Option B: Direct Pipeline Script
1. New Item → Pipeline
2. Configure:
   - Pipeline Definition: Pipeline script
   - Copy content from Jenkinsfile

### 5. Update Jenkinsfile Variables
Edit the Jenkinsfile and update:
```groovy
environment {
    DOCKER_REGISTRY = credentials('docker-registry-url')  // Your registry
    DOCKER_CREDENTIALS = credentials('docker-credentials-id')  // Your credentials ID
    VERSION = "${BUILD_NUMBER}"
}
```

## Pipeline Files

### Jenkinsfile (Sequential Build)
- Builds services one by one
- Slower but uses less resources
- Better for limited Jenkins agents

### Jenkinsfile-parallel (Parallel Build)
- Builds all services simultaneously
- Faster (3-5x speedup)
- Requires more CPU/memory on Jenkins agent

## Running the Pipeline

### Manual Trigger
1. Go to your Jenkins job
2. Click "Build Now"
3. Monitor the build in Console Output

### Automatic Trigger (Webhook)
1. Configure webhook in your Git repository
2. Add Jenkins webhook URL: `http://your-jenkins-url/github-webhook/`
3. Pipeline triggers automatically on push

## Docker Registry Options

### Docker Hub
```groovy
DOCKER_REGISTRY = 'docker.io/yourusername'
```

### AWS ECR
```groovy
DOCKER_REGISTRY = '123456789.dkr.ecr.us-east-1.amazonaws.com'
```
Note: Use AWS credentials plugin for ECR authentication

### Private Registry
```groovy
DOCKER_REGISTRY = 'registry.example.com'
```

## Build Scripts (Alternative to Jenkins)

### Windows
```cmd
set DOCKER_REGISTRY=your-registry
build-and-push.bat
```

### Linux/Mac
```bash
export DOCKER_REGISTRY=your-registry
chmod +x build-and-push.sh
./build-and-push.sh
```

## Deployment

### Using Docker Compose
```bash
export DOCKER_REGISTRY=your-registry
docker-compose -f docker-compose-microservices.yml up -d
```

### Pull and Run Individual Services
```bash
docker pull your-registry/eureka-server:latest
docker run -d -p 8761:8761 your-registry/eureka-server:latest
```

## Troubleshooting

### Docker Permission Issues
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Registry Authentication Failed
- Verify credentials in Jenkins
- Test manually: `docker login your-registry`

### Build Fails on Maven
- Ensure Maven is installed on Jenkins agent
- Or use Docker-in-Docker approach

### Out of Memory
- Increase Jenkins agent memory
- Use sequential build instead of parallel
- Build fewer services at once

## Best Practices

1. **Use Parallel Builds** for faster CI/CD
2. **Tag with Build Number** for version tracking
3. **Clean Workspace** after builds to save space
4. **Use Multi-stage Dockerfiles** to reduce image size
5. **Implement Health Checks** in docker-compose
6. **Use .dockerignore** to exclude unnecessary files
7. **Scan Images** for vulnerabilities before pushing

## Next Steps

1. Set up automated testing before build
2. Add deployment stage to Kubernetes/ECS
3. Implement rollback mechanism
4. Add Slack/Email notifications
5. Set up monitoring and logging
