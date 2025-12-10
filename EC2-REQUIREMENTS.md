# EC2 Instance Requirements for Rev-Tickets

## Instance Specifications
- **Instance Type**: t3.large or t3.xlarge (minimum 2 vCPU, 8GB RAM)
- **Storage**: 30GB GP3 SSD minimum
- **OS**: Ubuntu 22.04 LTS
- **Region**: Any (recommend us-east-1 for lower latency)

## Security Group Configuration
Create security group with these inbound rules:

| Port | Protocol | Source | Description |
|------|----------|---------|-------------|
| 22   | TCP      | Your IP | SSH Access |
| 80   | TCP      | 0.0.0.0/0 | Frontend (HTTP) |
| 443  | TCP      | 0.0.0.0/0 | Frontend (HTTPS) |
| 8080 | TCP      | 0.0.0.0/0 | Eureka Dashboard |
| 9090 | TCP      | 0.0.0.0/0 | API Gateway |
| 3306 | TCP      | 10.0.0.0/8 | MySQL (internal) |

## Services Running on Single Instance

### Container Architecture
```
┌─────────────────────────────────────────┐
│                EC2 Instance             │
├─────────────────────────────────────────┤
│ Frontend (nginx:80)                     │
│ API Gateway (Spring Boot:9090)          │
│ Eureka Server (Spring Boot:8080)        │
│ User Service (Spring Boot:8081)         │
│ Movie Service (Spring Boot:8082)        │
│ Venue Service (Spring Boot:8083)        │
│ Booking Service (Spring Boot:8084)      │
│ Payment Service (Spring Boot:8085)      │
│ MySQL Database (MySQL:3306)             │
└─────────────────────────────────────────┘
```

## Resource Usage Estimates
- **CPU**: 60-80% under normal load
- **Memory**: 6-7GB used
- **Storage**: 10-15GB for containers + logs
- **Network**: Minimal (internal communication)

## Monitoring Commands
```bash
# Check all containers
docker-compose ps

# Monitor resource usage
docker stats

# View logs
docker-compose logs -f [service-name]

# Restart specific service
docker-compose restart [service-name]

# Full system restart
docker-compose down && docker-compose up -d
```