FROM eclipse-temurin:17-jdk
COPY target/*.jar payment-service.jar
EXPOSE 8085
ENTRYPOINT ["java", "-jar", "payment-service.jar"]