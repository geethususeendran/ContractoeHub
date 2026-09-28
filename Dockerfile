FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar /app/app.jar
RUN ls -la /app
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
