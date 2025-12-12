FROM eclipse-temurin:17-jdk
COPY target/*.jar user-service.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "user-service.jar"]