# Jenkins CI/CD Setup Guide

## 🎯 Overview

This guide helps you set up Jenkins for automated building, testing, and deploying the RevTickets microservices project.

---

## 📋 Prerequisites

- Jenkins 2.300+ installed and running
- Java 11+ (Jenkins requirement)
- Docker installed on Jenkins agent/worker
- Git installed
- Maven 3.8+
- Node.js 16+
- Docker Hub account (or private registry)

---

## 🔧 Jenkins Installation

### Linux/Mac

```bash
# Using Homebrew (Mac)
brew install jenkins-lts

# Using apt (Ubuntu/Debian)
sudo apt-get install jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins  # Auto-start on boot
```

### Docker

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(which docker):/usr/bin/docker \
  jenkins/jenkins:lts
```

### Windows

```batch
# Download from: https://www.jenkins.io/download/
# Run installer and follow wizard
# Default port: 8080
# Access: http://localhost:8080
```

---

## 🔐 Initial Configuration

### 1. Unlock Jenkins

```bash
# Get initial password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Or in Docker
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### 2. Install Suggested Plugins

1. Open http://localhost:8080
2. Enter unlock password
3. Click "Install suggested plugins"
4. Create first admin user
5. Configure Jenkins URL: `http://jenkins-server:8080`

### 3. Install Additional Plugins

Go to **Manage Jenkins** → **Manage Plugins** → **Available**

Search and install:
- ✅ **Pipeline** - Required for Jenkinsfile support
- ✅ **Git** - Source code management
- ✅ **Docker** - Docker integration
- ✅ **Docker Pipeline** - Docker in Pipeline
- ✅ **Credentials Binding** - Credentials management
- ✅ **Email Extension** - Email notifications
- ✅ **GitHub Integration** - GitHub webhooks (optional)
- ✅ **SonarQube Scanner** - Code quality (optional)

---

## 🔑 Configure Credentials

### Add Docker Hub Credentials

1. Go to **Manage Jenkins** → **Manage Credentials**
2. Click **Credentials** in left sidebar
3. Click **(global)** domain
4. Click **Add Credentials** → **Secret text**

```
Kind: Username with password
Scope: Global
Username: your-docker-username
Password: Your Docker Hub token/password
ID: docker-hub-credentials
Description: Docker Hub Credentials
```

5. Click **OK**

### Add Git Credentials (if private repo)

```
Kind: SSH Key
Scope: Global
Username: git
Private Key: [Paste your SSH key or upload file]
ID: github-credentials
```

Or for HTTPS:
```
Kind: Username with password
Username: your-github-username
Password: Your GitHub Personal Access Token
ID: github-credentials
```

### Add Jenkins API Token

1. Click your profile (top-right)
2. Click **Configure**
3. Click **Add new Token** under "API Token"
4. Copy and save the token securely

---

## 🔄 Create Pipeline Job

### Option 1: From Jenkinsfile (Recommended)

1. Go to Jenkins dashboard
2. Click **New Item**
3. Enter name: `RevTickets-Pipeline`
4. Select **Pipeline**
5. Click **OK**

**Configure:**
- Definition: **Pipeline script from SCM**
- SCM: **Git**
- Repository URL: `https://github.com/yourusername/Rev-Tickets-Microservices.git`
- Credentials: Select your git credentials
- Branch: `*/main` or `*/develop`
- Script Path: `Jenkinsfile`

6. Click **Save**

### Option 2: Inline Pipeline

1. New Item → **Pipeline** → **OK**
2. Under Pipeline, select **Pipeline script**
3. Copy content from Jenkinsfile
4. Click **Save**

---

## 🚀 Trigger Builds

### Manual Trigger

1. Open job: **RevTickets-Pipeline**
2. Click **Build Now**
3. View progress in **Build History**
4. Click build number to view logs

### GitHub Webhook Trigger

Setup automatic builds on push:

1. In Jenkins job, check **GitHub hook trigger**
2. In GitHub repo settings → **Webhooks** → **Add webhook**

```
Payload URL: http://jenkins-server:8080/github-webhook/
Content type: application/json
Events: Push events
Active: ✓
```

### Scheduled Trigger

In Jenkins job configuration:

```
Build Triggers → Build periodically
Schedule: H 2 * * * (Daily at 2 AM)
```

### CLI Trigger

```bash
curl -X POST http://jenkins-server:8080/job/RevTickets-Pipeline/build \
  -H "Authorization: Bearer YOUR_API_TOKEN"
```

---

## 📊 Pipeline Execution Details

### Build Stages

**1. Checkout**
- Clones repository
- Switches to specified branch

**2. Build Backend** (Parallel)
- Builds 7 microservices in parallel
- Maven clean package
- Skips tests for speed

**3. Build Frontend**
- npm install
- Angular production build
- Optimized bundles

**4. Run Tests** (main branch only)
- Unit tests for all services
- Continues on failure

**5. Code Quality** (main branch only)
- SonarQube analysis (when configured)
- Code coverage reports

**6. Build Docker Images**
- Creates Docker images for all services
- Tags with build version

**7. Push Images** (main branch only)
- Pushes to Docker registry
- Requires Docker credentials

**8. Deploy** (main branch only)
- Stops existing containers
- Deploys new version via docker-compose
- Waits 30 seconds for startup

**9. Health Check**
- Verifies Eureka is responsive
- Verifies API Gateway is responsive
- Verifies Frontend is accessible

### Build Variables

```groovy
${BUILD_NUMBER}          // Jenkins build number (e.g., 42)
${GIT_COMMIT}            // Full git commit hash
${BUILD_VERSION}         // ${BUILD_NUMBER}-${GIT_COMMIT_SHORT}
${DOCKER_NAMESPACE}      // revtickets
${WORKSPACE}             // Job workspace directory
```

---

## 🔧 Advanced Configuration

### Configure Email Notifications

1. **Manage Jenkins** → **Configure System**
2. Scroll to **E-mail Notification**

```
SMTP server: smtp.gmail.com
SMTP Port: 587
Use SMTP Authentication: ✓
Username: your-email@gmail.com
Password: Your app password
Use TLS: ✓
```

### Add Post-Build Actions

In job configuration, under **Post-build Actions**:

```groovy
post {
    always {
        echo 'Cleaning workspace'
    }
    success {
        mail to: 'team@example.com',
             subject: "Build Successful: ${env.JOB_NAME}",
             body: "Build ${env.BUILD_NUMBER} succeeded"
    }
    failure {
        mail to: 'team@example.com',
             subject: "Build Failed: ${env.JOB_NAME}",
             body: "Build ${env.BUILD_NUMBER} failed"
    }
}
```

### Configure SonarQube Integration

1. In **Manage Jenkins** → **Configure System** → **SonarQube servers**

```
Name: SonarQube
Server URL: http://sonarqube-server:9000
Server authentication token: [Token]
```

2. In job configuration:

```groovy
stage('Code Quality') {
    steps {
        withSonarQubeEnv('SonarQube') {
            sh 'mvn clean verify sonar:sonar'
        }
    }
}
```

---

## 📈 Monitoring Pipeline

### View Build Logs

1. Open job
2. Click build number from Build History
3. Click **Console Output**
4. Search for errors/warnings

### Timeout Configuration

In job configuration:

```groovy
options {
    timeout(time: 1, unit: 'HOURS')
    timestamps()  // Add timestamps to logs
}
```

### Retry Failed Stages

```groovy
stage('Build Docker') {
    steps {
        retry(2) {
            sh 'docker build -t revtickets/user-service .'
        }
    }
}
```

---

## 🐛 Troubleshooting

### Docker Command Not Found

**Error:** `docker: command not found`

**Solution:**
```bash
# Run Jenkins Docker container with docker socket mounted
docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

### Maven Build Fails

**Error:** `Cannot find or load main class...`

**Solution:**
```bash
# Ensure Maven is installed in Jenkins
# Check: Manage Jenkins → Configure System → Maven

# Or install in Jenkinsfile:
sh '''
  mvn --version
  which maven
'''
```

### Credentials Not Found

**Error:** `Credentials not found`

**Solution:**
1. Ensure credentials are in **global** scope
2. Verify credential ID matches in Jenkinsfile
3. Check Jenkins user has permission to access credentials

### Docker Registry Login Fails

**Error:** `denied: requested access to the resource is denied`

**Solution:**
```bash
# Verify Docker credentials
docker login -u username -p password docker.io

# Test with explicit registry
docker push docker.io/username/revtickets/user-service:tag
```

### Out of Disk Space

**Error:** `No space left on device`

**Solution:**
```bash
# Clean old builds
# Manage Jenkins → Configure System → Disk Space Threshold

# Manual cleanup
rm -rf /var/lib/jenkins/workspace/*
docker system prune -a  # Remove unused Docker resources
```

---

## 🔒 Security Best Practices

1. ✅ **Use Credentials** - Never hardcode passwords
2. ✅ **Limit Permissions** - Use role-based access control
3. ✅ **Keep Jenkins Updated** - Regular security patches
4. ✅ **Use HTTPS** - Enable SSL for Jenkins
5. ✅ **API Tokens** - Use tokens instead of passwords
6. ✅ **Restrict Job Triggers** - Limit who can trigger builds
7. ✅ **Audit Logs** - Monitor Jenkins activity

---

## 📞 Jenkins Administration

### Backup Jenkins Configuration

```bash
# Backup Jenkins home
sudo tar -czf jenkins-backup.tar.gz /var/lib/jenkins/

# Or in Docker
docker cp jenkins:/var/jenkins_home ./jenkins-backup
```

### Restart Jenkins

```bash
# Linux
sudo systemctl restart jenkins

# Docker
docker restart jenkins

# Graceful restart (completes current builds)
curl -X POST http://localhost:8080/safeRestart
```

### Update Jenkins

```bash
# Check for updates in UI
Manage Jenkins → Manage Plugins → Updates

# Or command line
sudo apt-get install jenkins  # Auto-updates on Linux
brew upgrade jenkins          # Mac
```

---

## 📚 Additional Resources

- [Jenkins Official Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)
- [Docker Pipeline Plugin](https://plugins.jenkins.io/docker-workflow/)
- [Jenkinsfile Best Practices](https://www.jenkins.io/doc/book/pipeline/jenkinsfile-examples/)

---

**Last Updated:** December 14, 2025
**Jenkins Version:** 2.361+
**Status:** Production Ready
