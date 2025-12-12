FROM openjdk:17-jdk-slim
COPY target/*.jar api-gateway.jar
EXPOSE 9090
ENTRYPOINT ["java", "-jar", "api-gateway.jar"]