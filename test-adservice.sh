```bash
#!/usr/bin/env bash
set -euo pipefail

# Run from the Microservice-ecom project root.
PROTO_DIR="./src/main/proto"
PROTO_FILE="./src/main/proto/demo.proto"
REQUEST_FILE="./ad-request.json"
HOST="localhost:9555"
SERVICE="hipstershop.AdService/GetAds"

# Check grpcurl installation.
if ! command -v grpcurl >/dev/null 2>&1; then
  echo "Error: grpcurl is not installed."
  exit 1
fi

# Check proto file.
if [[ ! -f "$PROTO_FILE" ]]; then
  echo "Error: Proto file not found: $PROTO_FILE"
  exit 1
fi

# Check request JSON.
if [[ ! -f "$REQUEST_FILE" ]]; then
  echo "Error: Request file not found: $REQUEST_FILE"
  exit 1
fi

# Check that the Ad Service container is running.
if ! docker ps --filter "publish=9555" --format '{{.ID}}' | grep -q .; then
  echo "Warning: No running container appears to publish port 9555."
  echo "Continuing with the gRPC request..."
fi

# Call the Ad Service RPC.
grpcurl -plaintext \
  -import-path "$PROTO_DIR" \
  -proto "$PROTO_FILE" \
  -d "@$REQUEST_FILE" \
  "$HOST" \
  "$SERVICE"
```

