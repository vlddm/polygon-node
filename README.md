# polygon-node
Polygon (ex Matic) Fullnode dockerfiles

## Usage
### Blockchain snapshots download

Download and extract blockchain snapshots to make things faster 

Check for newer snapshots at [Polygon Forum](https://forum.matic.network/c/matic-mainnet/30)

```
curl -LOJ --retry 10 https://matic-blockchain-snapshots.s3.amazonaws.com/matic-mainnet/heimdall-fullnode-snapshot-2021-06-09.tar.gz
curl -LOJ --retry 10 https://matic-blockchain-snapshots.s3.amazonaws.com/matic-mainnet/bor-fullnode-snapshot-2021-06-09.tar.gz
mkdir -p /data/polygon/bor/bor/chaindata/
mkdir -p /data/polygon/heimdall/data/
tar -xzvf bor-fullnode-snapshot-2021-06-09.tar.gz -C /data/polygon/bor/bor/chaindata/
tar -xzvf heimdall-fullnode-snapshot-2021-06-09.tar.gz -C /data/polygon/heimdall/data/
```

### Run rabbitmq, heimdaild and heimdail-rest-server:
```
docker-compose -f heimdail.yml up -d
```

Wait for it to sync

Check sync status:
```
curl -s http://localhost:26657/status | jq .result.sync_info.catching_up
```

`true` means still syncing, `false` - synced

Do not start `bor` until `heimdall` full sync.

### Run `bor`
```
docker-compose -f bor.yml up -d
```

Check for `bor` sync status. 
```
docker exec bor bor attach --exec eth.syncing
```
`false` means synced

### JSONRPC

* HTTP JSONRPC at port 8145
* WebSocket at 8146
* IPC (unix socket) at /data/polygon/bor/geth.ipc

Test it using [geth](https://geth.ethereum.org/downloads/) binary:

```
geth attach http://localhost:8545
geth attach ws://localhost:8546
geth attach /data/polygon/bor/geth.ipc
# Last one needs root privileges
```

### Thanks to
Great article [How to run a Polygon (Matic) Mainnet Node with Docker](https://chasewright.com/how-to-run-a-polygon-matic-mainnet-node/) by [Chase Wright](https://chasewright.com)
