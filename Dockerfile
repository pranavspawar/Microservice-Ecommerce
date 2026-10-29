

FROM golang:1.22-alpine AS builder 

RUN apk add build-base
WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . . 

ARG SKAFFOLD_GO_GCFLAGS
RUN go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o /checkoutservice ./

FROM alpine:3.20 AS without-grpc-health-probe-bin

WORKDIR /src
COPY --from=builder /checkoutservice /src/checkoutservice

ENV GOTRACEBACK=single

EXPOSE 5050
ENTRYPOINT ["/src/checkoutservice"]
