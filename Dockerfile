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

COPY aqbanking2json-install.sh /tmp/aqbanking2json-install.sh
RUN bash /tmp/aqbanking2json-install.sh && rm /tmp/aqbanking2json-install.sh


WORKDIR /app

COPY create-pinfile.sh /app/create-pinfile.sh
COPY fetch-transactions.sh /app/fetch-transactions.sh
COPY setup.sh /app/setup.sh
COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
