FROM eclipse-temurin:17-jdk
COPY target/*.jar api-gateway.jar
EXPOSE 9090
ENTRYPOINT ["java", "-jar", "api-gateway.jar"]