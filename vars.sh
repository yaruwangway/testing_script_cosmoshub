#!/bin/bash

#node0, validator
export BINARY_0=./gaiad
export GAIA_HOME=~/.gaia0
export CHAIN_ID=test
export KEYRING=test
export BROADCAST_MODE=block
export VALIDATOR=val
export VAL_TOKEN_AMOUNT=10000000000000000
export VAL_STAKE=1000000000000
export DENOM=stake
export NMEMONIC0="alley afraid soup fall idea toss can goose become valve initial strong forward bright dish figure check leopard decide warfare hub unusual join cart"
export
export P2PPORT_0=26656
export RPCPORT_0=26657
export GRPCPORT_0=9090
export GRPCWEBPORT_0=9091
export RESTPORT_0=1317
export ROSETTA_0=8080
export
export #node1 is on the same chain as node0
export BINARY_1=gaiad
export KEYRING1=test
export GAIA_HOME1=~/.gaia1
export BROADCAST_MODE1=block
export P2PPORT_1=16656
export RPCPORT_1=16657
export GRPCPORT_1=9080
export GRPCWEBPORT_1=9081
export RESTPORT_1=1316
export ROSETTA_1=8081

export #node2 on another chain for ibc
export BINARY_2=gaiad
export CHAIN_ID2=test-ibc
export GAIA_HOME2=~/.gaia2
export VALIDATOR2=val2
export VAL2_TOKEN_AMOUNT=10000000000000000
export VAL2_STAKE=1000000000000
export DENOM2=stake

export P2PPORT_2=36656
export RPCPORT_2=36657
export GRPCPORT_2=9083
export GRPCWEBPORT_2=9084
export RESTPORT_2=3316
export ROSETTA_2=8083
export NMEMONIC2="record gift you once hip style during joke field prize dust unique length more pencil transfer quit train device arrive energy sort steak upset"
