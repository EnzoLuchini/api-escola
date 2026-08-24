FROM maven:3.9.8-eclipse-temurin-21-alpine AS build
WORKDIR /opt/app
COPY . .
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-alpine-3.23
WORKDIR /opt/app
COPY --from=build /opt/app/target/*jar /opt/app/app.jar
ENV SPRING_PROFILES_ACTIVE=default
CMD [ "java", "-Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}", "-jar", "app.jar" ]