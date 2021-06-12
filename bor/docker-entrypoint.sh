#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for bor"

  set -- bor "$@"
fi

if [ "$1" = "bor" ]; then

  if [ ! -d $DATADIR/bor/chaindata ]; then
    echo "$0: creating $DATADIR"
    mkdir -p "$DATADIR"
    chmod 700 "$DATADIR"
    echo "$0: initiating blockchain"
    bor --datadir "$DATADIR" init /genesis.json
  fi

  if [ ! -f $DATADIR/config.toml ]; then
    echo "$0: copying config.toml to $DATADIR/"
    cp /config.toml $DATADIR/
  fi

  echo "$0: setting data directory to $DATADIR"

  shift
  set -- bor --datadir "$DATADIR" --config $DATADIR/config.toml "$@"
fi

echo
exec "$@"
