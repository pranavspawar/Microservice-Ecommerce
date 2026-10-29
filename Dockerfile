

FROM golang:1.22-alpine AS builder 

RUN apk add build-base
WORKDIR /src


COPY . .
RUN go mod download

ARG SKAFFOLD_GO_GCFLAGS
RUN go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o /checkoutservice ./

FROM alpine:3.20 AS without-grpc-health-probe-bin
RUN apk add --no-cache ca-certificates

WORKDIR /src
COPY --from=builder /checkoutservice /src/checkoutservice

ENV GOTRACEBACK=single

EXPOSE 5050
ENTRYPOINT ["/src/checkoutservice"]
