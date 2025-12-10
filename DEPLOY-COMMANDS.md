# Quick Deployment Commands

## 1. Launch EC2 Instance
```bash
# Use AWS Console or CLI
# Instance: t3.large, Ubuntu 22.04 LTS, 30GB storage
# Security Group: Allow ports 22, 80, 8080, 9090
```

## 2. Connect and Setup
```bash
# Connect to EC2
ssh -i your-key.pem ubuntu@YOUR-EC2-IP

# Upload your code
scp -i your-key.pem -r "Rev-Tickets-Microservices" ubuntu@YOUR-EC2-IP:~/

# Or clone from Git
git clone your-repo-url
cd Rev-Tickets-Microservices
```

## 3. Run Setup Script
```bash
chmod +x ec2-setup.sh
./ec2-setup.sh

# Reboot instance
sudo reboot
```

## 4. Deploy Application
```bash
# After reboot, reconnect and run
chmod +x deploy-ec2.sh
./deploy-ec2.sh
```

## 5. Access Application
```bash
# Get your public IP
curl http://169.254.169.254/latest/meta-data/public-ipv4

# Access services
# Frontend: http://YOUR-EC2-IP
# API: http://YOUR-EC2-IP:9090
# Eureka: http://YOUR-EC2-IP:8080
```

## 6. Troubleshooting
```bash
# Check container status
docker-compose ps

# View logs
docker-compose logs -f

# Restart failed service
docker-compose restart service-name

# Full restart
docker-compose down
docker-compose up -d
```

## 7. Monitoring
```bash
# Resource usage
docker stats

# System resources
htop
df -h

# Service health
curl http://localhost:9090/actuator/health
```