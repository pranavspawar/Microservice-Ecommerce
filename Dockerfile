FROM golang:1.26 AS builder 

WORKDIR /app
 
COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -o /app/server .

#------RUNTIME-----

FROM alpine:3.22

WORKDIR /app

COPY --from=builder /app/server ./server

COPY products.json .

EXPOSE 3550

ENTRYPOINT ["/app/server"]

