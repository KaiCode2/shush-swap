#!/bin/bash

# Args:
# $1: privacy hook address
# $2: token address
# $3: balance
# $4: amount
# $5: nullifier
# $6: nonce
# $7: path indices
# $8: path elements

cast call $1 "getCurrentRoot(address)" $2
