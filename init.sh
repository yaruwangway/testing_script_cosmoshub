#!/bin/bash

echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "         set the first node       "
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
mkdir $GAIA_HOME
if [ $? -ne 0 ]; then
  echo "failed to mkdir $GAIA_HOME, please reconfig gaia home or delete the present gaia home!"
  exit 1
else
  $BINARY_0 init mynode0 --chain-id $CHAIN_ID --home $GAIA_HOME

  $BINARY_0 config chain-id $CHAIN_ID  --home $GAIA_HOME
  $BINARY_0 config keyring-backend $KEYRING --home $GAIA_HOME
  $BINARY_0 config broadcast-mode $BROADCAST_MODE --home $GAIA_HOME
  $BINARY_1 config node tcp://localhost:$RPCPORT_0 --home $GAIA_HOME

# gentx
  $BINARY_0 keys add $VALIDATOR --home $GAIA_HOME
  $BINARY_0 add-genesis-account $($BINARY_0 keys show $VALIDATOR -a --home $GAIA_HOME) ${VAL_TOKEN_AMOUNT}${DENOM} --home $GAIA_HOME
 echo $NMEMONIC0 | $BINARY_0 keys add rly0 --keyring-backend $KEYRING --home $GAIA_HOME --recover
 $BINARY_0 add-genesis-account $($BINARY_0 keys show rly0 -a --home $GAIA_HOME) 100000000000${DENOM} --home $GAIA_HOME

  $BINARY_0 gentx $VALIDATOR ${VAL_STAKE}${DENOM} --chain-id $CHAIN_ID --home $GAIA_HOME
  $BINARY_0 collect-gentxs --home $GAIA_HOME

  # min deposition amount
  sed -i '' 's%"amount": "10000000",%"amount": "1",%g' $GAIA_HOME/config/genesis.json
  #   min voting power that a proposal requires in order to be a valid proposal
  sed -i '' 's%"quorum": "0.334000000000000000",%"quorum": "0.000000000000000001",%g' $GAIA_HOME/config/genesis.json
  # the minimum proportion of "yes" votes requires for the proposal to pass
  sed -i '' 's%"threshold": "0.500000000000000000",%"threshold": "0.000000000000000001",%g' $GAIA_HOME/config/genesis.json
  # voting period
  sed -i '' 's%"voting_period": "172800s"%"voting_period": "20s"%g' $GAIA_HOME/config/genesis.json
fi

read -p "Do you want to add a second node to this chain [y/n]?" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  echo "         set the second node      "
  echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  mkdir $GAIA_HOME1
  if [ $? -ne 0 ]; then
    echo "failed to mkdir $GAIA_HOME1, please reconfig gaia home or delete the present gaia home!"
    exit 1
  else
   $BINARY_1 init mynode1 --chain-id $CHAIN_ID --home $GAIA_HOME1
   rm $GAIA_HOME1/config/genesis.json
   cp $GAIA_HOME/config/genesis.json $GAIA_HOME1/config/

   $BINARY_1 config chain-id $CHAIN_ID --home $GAIA_HOME1
   $BINARY_1 config keyring-backend $KEYRING1 --home $GAIA_HOME1
   $BINARY_1 config broadcast-mode $BROADCAST_MODE1 --home $GAIA_HOME1
   $BINARY_1 config node tcp://localhost:$RPCPORT_1 --home $GAIA_HOME1



   sed -i -e 's#"tcp://0.0.0.0:26656"#"tcp://0.0.0.0:'"$P2PPORT_1"'"#g' $GAIA_HOME1/config/config.toml
   sed -i -e 's#"tcp://127.0.0.1:26657"#"tcp://0.0.0.0:'"$RPCPORT_1"'"#g' $GAIA_HOME1/config/config.toml
   sed -i -e 's/"0.0.0.0:9090"/"0.0.0.0:'"$GRPCPORT_1"'"/g' $GAIA_HOME1/config/app.toml
   sed -i -e 's/"0.0.0.0:9091"/"0.0.0.0:'"$GRPCWEBPORT_1"'"/g' $GAIA_HOME1/config/app.toml
   sed -i -e 's#"tcp://0.0.0.0:1317"#"tcp://0.0.0.0:'"$RESTPORT_1"'"#g' $GAIA_HOME1/config/app.toml
   sed -i -e 's#":8080"#":'"$ROSETTA_1"'"#g' $GAIA_HOME1/config/app.toml

   VAL_NODE_ID=$($BINARY_0 tendermint show-node-id --home $GAIA_HOME)
   sed -i '' 's/persistent_peers = ""/persistent_peers = "'$VAL_NODE_ID'@'localhost':'$P2PPORT_0'"/g' $GAIA_HOME1/config/config.toml
   fi
fi

read -p "Do you want to add a third node as a new chain to test ibc [y/n]?" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  echo "set the third node as the second chain"
  echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  mkdir $GAIA_HOME2
  if [ $? -ne 0 ]; then
    echo "failed to mkdir $GAIA_HOME2, please reconfig gaia home or delete the present gaia home!"
    exit 1
  else
    $BINARY_2 init mynode2 --chain-id $CHAIN_ID2 --home $GAIA_HOME2

    $BINARY_2 config chain-id $CHAIN_ID2  --home $GAIA_HOME2
    $BINARY_2 config keyring-backend $KEYRING --home $GAIA_HOME2
    $BINARY_2 config broadcast-mode $BROADCAST_MODE --home $GAIA_HOME2
    $BINARY_1 config node tcp://localhost:$RPCPORT_2 --home $GAIA_HOME2

# gentx
    $BINARY_2 keys add $VALIDATOR2 --home $GAIA_HOME2
    $BINARY_2 add-genesis-account $($BINARY_2 keys show $VALIDATOR2 -a --home $GAIA_HOME2) ${VAL2_TOKEN_AMOUNT}${DENOM2} --home $GAIA_HOME2
        # add rly2 for relayer conn
    echo $NMEMONIC2 | $BINARY_2 keys add rly2 --keyring-backend $KEYRING --home $GAIA_HOME2 --recover
    $BINARY_2 add-genesis-account $($BINARY_2 keys show rly2 -a --home=$GAIA_HOME2) 100000000000${DENOM2} --home $GAIA_HOME2

    $BINARY_2 gentx $VALIDATOR2 ${VAL2_STAKE}${DENOM2} --chain-id $CHAIN_ID2 --home $GAIA_HOME2
    $BINARY_2 collect-gentxs --home $GAIA_HOME2


    sed -i -e 's#"tcp://0.0.0.0:26656"#"tcp://0.0.0.0:'"$P2PPORT_2"'"#g' $GAIA_HOME2/config/config.toml
    sed -i -e 's#"tcp://127.0.0.1:26657"#"tcp://0.0.0.0:'"$RPCPORT_2"'"#g' $GAIA_HOME2/config/config.toml
    sed -i -e 's/"0.0.0.0:9090"/"0.0.0.0:'"$GRPCPORT_2"'"/g' $GAIA_HOME2/config/app.toml
    sed -i -e 's/"0.0.0.0:9091"/"0.0.0.0:'"$GRPCWEBPORT_2"'"/g' $GAIA_HOME2/config/app.toml
    sed -i -e 's#"tcp://0.0.0.0:1317"#"tcp://0.0.0.0:'"$RESTPORT_2"'"#g' $GAIA_HOME2/config/app.toml
    sed -i -e 's#":8080"#":'"$ROSETTA_2"'"#g' $GAIA_HOME2/config/app.toml
      # min deposition amount
    sed -i '' 's%"amount": "10000000",%"amount": "1",%g' $GAIA_HOME2/config/genesis.json
    sed -i '' 's%"quorum": "0.334000000000000000",%"quorum": "0.000000000000000001",%g' $GAIA_HOME2/config/genesis.json
    sed -i '' 's%"threshold": "0.500000000000000000",%"threshold": "0.000000000000000001",%g' $GAIA_HOME2/config/genesis.json
    sed -i '' 's%"voting_period": "172800s"%"voting_period": "20s"%g' $GAIA_HOME2/config/genesis.json
  fi
fi
