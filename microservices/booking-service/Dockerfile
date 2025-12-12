FROM eclipse-temurin:17-jdk
COPY target/*.jar booking-service.jar
EXPOSE 8084
ENTRYPOINT ["java", "-jar", "booking-service.jar"]