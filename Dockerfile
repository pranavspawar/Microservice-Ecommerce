
# Stage 1: Base image
FROM python:3.10-slim-bookworm AS base

# Stage 2: Builder
FROM base AS builder

WORKDIR /build

# Install build tools required by google-cloud-profiler
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 3: Runtime
FROM base AS runtime

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    ENABLE_PROFILER=1

WORKDIR /email_server

# Copy Python dependencies from builder
COPY --from=builder /install /usr/local

# Copy application source
COPY . .

EXPOSE 8080

ENTRYPOINT ["python", "email_server.py"]
