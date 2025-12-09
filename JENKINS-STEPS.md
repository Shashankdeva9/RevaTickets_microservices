# Jenkins Pipeline Setup - Step by Step

## Step 1: Install Jenkins Plugins (5 min)

1. Open Jenkins: `http://localhost:8080`
2. Go to: **Manage Jenkins** → **Manage Plugins** → **Available**
3. Install these plugins:
   - Docker Pipeline
   - Docker
   - Git
   - Pipeline

## Step 2: Add Docker Hub Credentials (2 min)

1. Go to: **Manage Jenkins** → **Manage Credentials**
2. Click: **(global)** → **Add Credentials**
3. Fill in:
   - **Kind**: Username with password
   - **Username**: Your Docker Hub username
   - **Password**: Your Docker Hub password/token
   - **ID**: `docker-hub-credentials`
   - Click **Create**

## Step 3: Create Jenkins Pipeline Job (3 min)

1. Click: **New Item**
2. Enter name: `RevTickets-Pipeline`
3. Select: **Pipeline**
4. Click: **OK**

## Step 4: Configure Pipeline (2 min)

### Option A: From Git Repository (Recommended)
1. Scroll to **Pipeline** section
2. Select: **Pipeline script from SCM**
3. **SCM**: Git
4. **Repository URL**: Your Git repo URL
5. **Script Path**: `Jenkinsfile-simple`
6. Click **Save**

### Option B: Direct Script
1. Scroll to **Pipeline** section
2. Select: **Pipeline script**
3. Copy content from `Jenkinsfile-simple`
4. Replace `yourusername` with your Docker Hub username
5. Click **Save**

## Step 5: Update Jenkinsfile

Edit `Jenkinsfile-simple` and change:
```groovy
DOCKER_HUB_REPO = 'yourusername'  // Change to your Docker Hub username
```

## Step 6: Run Pipeline

1. Click: **Build Now**
2. Watch the build progress
3. Check Console Output for logs

## Step 7: Verify Images

After build completes, verify on Docker Hub:
```
https://hub.docker.com/u/yourusername
```

You should see 8 images:
- eureka-server
- api-gateway
- user-service
- movie-service
- venue-service
- booking-service
- payment-service
- frontend

## Step 8: Deploy

Pull and run your services:
```bash
docker pull yourusername/eureka-server:latest
docker pull yourusername/api-gateway:latest
# ... etc

# Or use docker-compose
export DOCKER_REGISTRY=yourusername
docker-compose -f docker-compose-microservices.yml up -d
```

## Troubleshooting

### Error: "docker: command not found"
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Error: "Permission denied"
```bash
sudo chmod 666 /var/run/docker.sock
```

### Error: "Credentials not found"
- Check credential ID matches: `docker-hub-credentials`
- Verify credentials are in global scope

## Build Time
- Expected: 10-15 minutes for all services
- Parallel builds speed up the process

## Next Steps
- Set up webhook for auto-build on git push
- Add deployment stage
- Add testing stage
