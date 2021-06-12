# Simple usage with a mounted data directory:
# > docker build -t maticnetwork/heimdall:<tag> .
# > docker run -it -p 26657:26657 -p 26656:26656 -v ~/.heimdalld:/root/.heimdalld maticnetwork/heimdall:<tag> heimdalld init

# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang:latest as builder

ENV VERSION=v0.2.1-mainnet

# update available packages
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt install build-essential git -y && \
    cd /root && \
    git clone --depth=1 -b $VERSION https://github.com/maticnetwork/heimdall.git

# change work directory
WORKDIR /root/heimdall

# GOBIN required for go install
ENV GOBIN $GOPATH/bin

# run build
RUN make build


# Pull all binaries into a second stage deploy alpine container
FROM ubuntu:latest

RUN apt-get update -y \
  && apt-get install -y curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && curl -q -o /genesis.json https://raw.githubusercontent.com/maticnetwork/launch/master/mainnet-v1/without-sentry/heimdall/config/genesis.json

# Copy required binarires to new container
COPY --from=builder /root/heimdall/build/* /usr/local/bin/

COPY docker-entrypoint.sh /entrypoint.sh

ENV DATADIR=/root/.heimdalld

# add volumes
VOLUME ["$DATADIR"]

# expose ports
EXPOSE 1317 26656 26657

ENTRYPOINT ["/entrypoint.sh"]

# Run the binary.
CMD ["heimdalld","start"]
