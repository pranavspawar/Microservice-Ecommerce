FROM eclipse-temurin:19-jdk AS builder

WORKDIR /app


COPY build.gradle gradlew ./
COPY gradle gradle
RUN chmod +x gradlew
RUN ./gradlew downloadRepos

COPY . .
RUN chmod +x gradlew
RUN ./gradlew installDist

FROM eclipse-temurin:19-jre

WORKDIR /app
COPY --from=builder /app .
EXPOSE 9555
ENTRYPOINT ["/app/build/install/hipstershop/bin/AdService"]