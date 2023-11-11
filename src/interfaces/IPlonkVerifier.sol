// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IPlonkVerifier {
    function verifyProof(uint256[24] calldata _proof, uint256[5] calldata _pubSignals) external view returns (bool);
}
