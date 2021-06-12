# Build Geth in a stock Go builder container
FROM golang:1.16-alpine as builder

ENV VERSION=v0.2.6

RUN apk add --no-cache make gcc musl-dev linux-headers git && \
    cd / && git clone --depth=1 -b $VERSION https://github.com/maticnetwork/bor.git && \
    cd /bor && make bor 

# Pull Bor into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates curl && \
    curl -q -o /genesis.json https://raw.githubusercontent.com/maticnetwork/launch/master/mainnet-v1/without-sentry/bor/genesis.json

COPY --from=builder /bor/build/bin/bor /usr/local/bin/

COPY config.toml /config.toml

COPY docker-entrypoint.sh /entrypoint.sh

# Bor uses /root/.ethereum by default. 
ENV DATADIR=/root/.ethereum

EXPOSE 8545 8546 8547 30303 30303/udp

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bor"]
