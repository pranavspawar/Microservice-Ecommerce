FROM golang:1.26 AS builder 

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

CPOY . . 

#------RUNTIME-----

FROM alpine:3.22

WORKDIR /app

COPY --FROM=builder /productcatalogservice ./server
