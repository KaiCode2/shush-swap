#!/bin/bash

# ARGS:
# $1: hooks address
# $2: token address
# $3: nullifier

source .env

echo $1
echo $2
echo $3

cast send $2 "mint(address,uint256)" 0xD4cb6D99a2056e36586942383734b2f79C311301 1000000000000000000000000 --private-key $PRIVATE_KEY
cast send $2 "approve(address,uint256)" $1 115792089237316195423570985008687907853269984665640564039457584007913129639935 --private-key $PRIVATE_KEY

NULLIFIER="$(node ./tasks/deposit.ts deposit -t $2 -a 5000000000000000000 -n $3)"

echo $NULLIFIER

cast send $1 "depositFunds(address,uint256,bytes32)" $2 5000000000000000000 "$(echo $NULLIFIER)" --private-key $PRIVATE_KEY
