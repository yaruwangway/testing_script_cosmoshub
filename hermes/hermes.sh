#!/bin/bash

HERMES_BINARY=hermes
CONFIG_DIR=./rly-config.toml

# Sleep is needed otherwise the relayer crashes when trying to init
sleep 1s
### Restore Keys
$HERMES_BINARY -c $CONFIG_DIR keys restore test -m "alley afraid soup fall idea toss can goose become valve initial strong forward bright dish figure check leopard decide warfare hub unusual join cart"
sleep 5s

$HERMES_BINARY -c $CONFIG_DIR keys restore test-ibc -m "record gift you once hip style during joke field prize dust unique length more pencil transfer quit train device arrive energy sort steak upset"
sleep 5s


### Configure the clients and connection
echo "Initiating connection handshake..."
$HERMES_BINARY -c $CONFIG_DIR create connection test test-ibc

sleep 2

#
#$HERMES_BINARY -c $CONFIG_DIR  create channel --port-a transfer --port-b transfer test test-ibc

# Start the hermes relayer in multi-paths mode
echo "Starting hermes relayer..."
$HERMES_BINARY -c $CONFIG_DIR start

hermes -c $CONFIG_DIR start
