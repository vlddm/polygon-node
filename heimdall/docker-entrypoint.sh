#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for daemon"

  set -- heimdalld "$@"
fi

if [ "$1" = "heimdalld" ]; then

  if [ ! -d $DATADIR/config ]; then
    echo "$0: creating $DATADIR"
    mkdir -p "$DATADIR"
    chmod 700 "$DATADIR"
    echo "$0: initiating blockchain"
    heimdalld init --chain-id 137
    echo "$0: copying genesis.json to $DATADIR/config/"
    cp /genesis.json $DATADIR/config/
    sed -i 's/^cors_allowed_origins.*/cors_allowed_origins = ["*"]/' $DATADIR/config/config.toml
    sed -i 's/^seeds.*/seeds = "f4f605d60b8ffaaf15240564e58a81103510631c@159.203.9.164:26656,4fb1bc820088764a564d4f66bba1963d47d82329@44.232.55.71:26656"/' $DATADIR/config/config.toml
    sed -i 's/^amqp_url.*/amqp_url = "amqp:\/\/guest:guest@rabbitmq:5672"/' $DATADIR/config/heimdall-config.toml
  fi

fi

echo
exec "$@"
