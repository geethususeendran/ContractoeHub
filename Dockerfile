FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests
RUN ls -la /app/target

FROM eclipse-temurin:17-jre-alpine
WORKDIR /opt/app
COPY --from=build /app/target/*.jar /opt/app/
RUN ls -la /opt/app && test -n "$(ls /opt/app/*.jar)"
EXPOSE 8080
ENTRYPOINT ["sh", "-c", "java -jar /opt/app/*.jar"]