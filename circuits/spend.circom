pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
include "./utils/smtverifier.circom";

template Spend (levels) {
    signal input token;
    signal input balance;
    signal input spendAmount;
    signal input nonce;
    signal input nullifier;
    signal input depositIndices;
    signal input depositElements[levels];
    signal input merkleRoot;

    signal output newDepositCommitment;
    signal output spendNullifier;

    // TODO: Use more efficient means of checking nullifier size
    _ <== Num2Bits(248)(nullifier);

    signal nullifierHash <== Poseidon(1)([nullifier]);
    log("nullifier hash: ", nullifierHash);

    signal spendNonce <== nonce + 1;
    var depositConstant = 0;
    var spendConstant = 1;

    signal isSpendAmountValid <== LessEqThan(248)([spendAmount, balance]);
    isSpendAmountValid === 1;
    signal balanceRemaining <== balance - spendAmount;

    // Verify Merkle proof
    signal leaf <== Poseidon(5)([depositConstant, token, nonce, balance, nullifierHash]);
    signal {binary} depositBinIndices[levels] <== Num2Bits(levels)(depositIndices);
    signal generatedRoot <== SMTVerifier(levels)(leaf, depositElements, depositBinIndices);
    log("recreated leaf: ", leaf);
    log("produced root: ", generatedRoot);
    merkleRoot === generatedRoot;


    newDepositCommitment <== Poseidon(5)([depositConstant, token, spendNonce, balanceRemaining, nullifierHash]);
    spendNullifier <== Poseidon(4)([spendConstant, token, nonce, nullifierHash]);
}
component main { public [ token, spendAmount, merkleRoot ] } = Spend(20);
