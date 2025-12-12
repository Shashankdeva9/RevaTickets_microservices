FROM openjdk:17-jdk-slim
COPY target/*.jar payment-service.jar
EXPOSE 8085
ENTRYPOINT ["java", "-jar", "payment-service.jar"]