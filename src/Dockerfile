
# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS builder

WORKDIR /app

COPY cartservice.csproj ./

RUN dotnet restore cartservice.csproj -r linux-musl-x64

COPY . .

RUN dotnet publish cartservice.csproj \
    -p:PublishSingleFile=true \
    -r linux-musl-x64 \
    --self-contained true \
    -p:PublishTrimmed=true \
    -p:TrimMode=Link \
    -c Release \
    -o /cartservice \
    --no-restore


# Stage 2: Runtime dependencies
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-alpine AS runtime

WORKDIR /app

COPY --from=builder /cartservice/ ./

EXPOSE 7070

ENV DOTNET_EnableDiagnostics=0 \
    ASPNETCORE_URLS=http://*:7070

USER 1000

ENTRYPOINT ["/app/cartservice"]
