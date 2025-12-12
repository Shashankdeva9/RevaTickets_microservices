FROM eclipse-temurin:17-jdk
COPY target/*.jar venue-service.jar
EXPOSE 8083
ENTRYPOINT ["java", "-jar", "venue-service.jar"]