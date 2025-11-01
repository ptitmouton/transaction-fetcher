FROM ubuntu:25.04

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
  curl \
  wget \
  jq \
  cron \
  ca-certificates \
  aqbanking-tools \
  libaqbanking-data \
  libaqbanking-dev \
  libaqbanking44 \
  && rm -rf /var/lib/apt/lists/*

RUN wget "https://github.com/ptitmouton/aqbanking2json/releases/download/v0.0.3/aqbanking2json-linux-arm64" -O /usr/local/bin/aqbanking2json && \
  chmod +x /usr/local/bin/aqbanking2json


WORKDIR /app

COPY create-pinfile.sh /app/create-pinfile.sh
COPY fetch-transactions.sh /app/fetch-transactions.sh
COPY setup.sh /app/setup.sh
COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
