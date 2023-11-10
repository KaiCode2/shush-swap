#!/bin/bash

# ARGS:
# $0: hooks address
# $1: token address
# $2: nullifier

source ../.env

cast send $1 "mint(address,uint256)" 0xD4cb6D99a2056e36586942383734b2f79C311301 1000000000000000000000000 --private-key $PRIVATE_KEY
cast send $1 "approve(address,uint256)" $0 115792089237316195423570985008687907853269984665640564039457584007913129639935 --private-key $PRIVATE_KEY

NULLIFIER = $(node ./deposit deposit -t $1 -a 1000000000000000000000000 $2)

cast send $0 "depositFunds(address,uint256,bytes32)" $1 5000000000000000000 $NULLIFIER --private-key $PRIVATE_KEY
