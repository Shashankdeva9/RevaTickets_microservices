# Multi-stage build for all microservices
FROM openjdk:17-jdk-slim as builder

# Install Maven
RUN apt-get update && apt-get install -y maven

# Copy source code
COPY . /app
WORKDIR /app

# Build all microservices
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:17-jdk-slim

# Install required packages
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy built JARs
COPY --from=builder /app/microservices/eureka-server/target/*.jar eureka-server.jar
COPY --from=builder /app/microservices/api-gateway/target/*.jar api-gateway.jar
COPY --from=builder /app/microservices/user-service/target/*.jar user-service.jar
COPY --from=builder /app/microservices/movie-service/target/*.jar movie-service.jar
COPY --from=builder /app/microservices/venue-service/target/*.jar venue-service.jar
COPY --from=builder /app/microservices/booking-service/target/*.jar booking-service.jar
COPY --from=builder /app/microservices/payment-service/target/*.jar payment-service.jar

# Copy startup script
COPY start-services.sh /app/
RUN chmod +x /app/start-services.sh

# Expose ports
EXPOSE 8761 9090 8081 8082 8083 8084 8085

# Start all services
CMD ["./start-services.sh"]