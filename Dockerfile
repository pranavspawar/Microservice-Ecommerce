

FROM python:3.10-slim-bookworm AS base


FROM base AS builder

WORKDIR /build

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        g++ \
    && rm -rf /var/lib/apt/lists/*


COPY requirements.txt .


RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


FROM base AS runtime

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    ENABLE_PROFILER=1

WORKDIR /email_server

COPY --from=builder /install /usr/local


COPY . .

EXPOSE 8080

ENTRYPOINT ["python", "email_server.py"]
