FROM eclipse-temurin:17-jdk-slim
COPY target/*.jar movie-service.jar
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "movie-service.jar"]