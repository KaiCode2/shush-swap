#!/bin/bash

# Check if build dir exists
if [ ./circuits/build ]; then
    mkdir ./circuits/build
fi

circom ./circuits/spend.circom --r1cs --wasm --sym -o ./circuits/build

npx snarkjs r1cs export json ./circuits/build/spend.r1cs ./circuits/build/spend.r1cs.json

npx snarkjs plonk setup ./circuits/build/spend.r1cs ./circuits/powersOfTau28_hez_final_17.ptau circuit_0000.zkey

mv circuit_0000.zkey ./circuits/build/circuit_0000.zkey

npx snarkjs zkey export verificationkey ./circuits/build/circuit_0000.zkey ./circuits/build/verification_key.json

npx snarkjs zkey export solidityverifier ./circuits/build/circuit_0000.zkey ./src/SpendVerifier.sol

# TODO: Revisit, not working
sed -i "s/import/import {IPlonkVerifier} from/g" ./src/SpendVerifier.sol
sed -i "s/hardhat\/console.sol/.\/interfaces\/IPlonkVerifier.sol/g" ./src/SpendVerifier.sol
sed -i "s/contract PlonkVerifier/contract SpendVerifier is IPlonkVerifier/g" ./src/SpendVerifier.sol

# # Bit annoying, should figure out why above puts two files...
# rm ./src/SpendVerifier.sol-e
