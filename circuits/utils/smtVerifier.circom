pragma circom 2.1.6;

include "../../node_modules/circomlib/circuits/switcher.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";

// SMTVerifier is a circuit that verifies a Merkle proof for a single leaf
template SMTVerifier(levels) {
    signal input leaf;
    signal input pathElements[levels];
    signal input {binary} pathIndices[levels];
    signal output root;

    component switcher[levels];
    component hasher[levels];

    for (var i = 0; i < levels; i++) {
        switcher[i] = Switcher();
        switcher[i].L <== i == 0 ? leaf : hasher[i - 1].out;
        switcher[i].R <== pathElements[i];
        switcher[i].sel <== pathIndices[i];

        hasher[i] = Poseidon(2);
        hasher[i].inputs[0] <== switcher[i].outL;
        hasher[i].inputs[1] <== switcher[i].outR;
    }

    root <== hasher[levels - 1].out;
}
