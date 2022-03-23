# Instructions
These local test scripts will test compatibilities of different minor gaiad versions. 
These scripts build 3 nodes, node0 and node1 will be on the first chain, node0 will be the validator. Node2 will be the single validator on the  second chain. Hermes relayer will create connections bewteen the first and second chain. 

The gov params on each chain are modified with very low deposit, short voting period, and low threshold of voting yes to make the proposal pass.

## start the chain
```shell
source ./var.sh
sh init.sh
$BINARY_0 start --home $GAIA_HOME > gaia.log 2>&1 &
$BINARY_2 start --home $GAIA_HOME2 > gaia2.log 2>&1 &
$BINARY_1 start --home $GAIA_HOME1
```

## start relayer
start a new terminal to start hermes, if hermes is not installed, please install according to the [tutorial](https://hermes.informal.systems/installation.html).
```shell
sh ./hermes/hermes.sh
```

## test functions
test functions:

```diff

```



## terminate all processes
```shell
pkill -f gaiad
pkill -f hermes
```
