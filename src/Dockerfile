
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder

WORKDIR /app

COPY cartservice.csproj ./

RUN dotnet restore cartservice.csproj -r linux-x64

COPY . .

RUN dotnet publish cartservice.csproj \
    -r linux-x64 \
    --self-contained true \
    -p:PublishSingleFile=true \
    -c Release \
    -o /cartservice \
    --no-restore


FROM mcr.microsoft.com/dotnet/runtime-deps:8.0 AS runtime

WORKDIR /app

COPY --from=builder /cartservice/ ./

ENV DOTNET_EnableDiagnostics=0

EXPOSE 7070

USER 1000

ENTRYPOINT ["/app/cartservice"]

ENV ASPNETCORE_URLS=http://0.0.0.0:7070
ENV ASPNETCORE_HTTP_PORTS=7070
