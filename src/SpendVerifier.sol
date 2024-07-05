// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity ^0.8.20;

import {IPlonkVerifier} from "./interfaces/IPlonkVerifier.sol";

contract PlonkVerifier is IPlonkVerifier {
    // Omega
    uint256 constant w1 = 12650941915662020058015862023665998998969191525479888727406889100124684769509;
    // Scalar field size
    uint256 constant q = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant qf = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // [1]_1
    uint256 constant G1x = 1;
    uint256 constant G1y = 2;
    // [1]_2
    uint256 constant G2x1 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant G2x2 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant G2y1 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant G2y2 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;

    // Verification Key data
    uint32 constant n = 131072;
    uint16 constant nPublic = 5;
    uint16 constant nLagrange = 5;

    uint256 constant Qmx = 17146953354357358156076209407020058772492539388970606357490686962452183981308;
    uint256 constant Qmy = 8559347454482203278738327980955693555386535829394033696983462158353471886399;
    uint256 constant Qlx = 9499081088889898009383428724724869041716051193497413438675889891377940905668;
    uint256 constant Qly = 21631219625775467556522867924665682567499560520896088526214531897598386487842;
    uint256 constant Qrx = 446193758444410748944840340628790524806563524451570753032947070745102982299;
    uint256 constant Qry = 1082941911311027565394932717374704483618250656152583321512189994254765499111;
    uint256 constant Qox = 8408867489735245763014095209659860930805864369634531793415049411082866027186;
    uint256 constant Qoy = 18788617712306939255047168244376859924014293785491911266644070661087628510263;
    uint256 constant Qcx = 3123714769371865133629984593509101692482650886147553319711267714971556211698;
    uint256 constant Qcy = 14063160021663249346499706731299343142954328261538801042457584721667668029920;
    uint256 constant S1x = 8353083822241335164794904624544903292254549860082557756040752924474974733413;
    uint256 constant S1y = 5840262604175857107367125215675784942210831824860841022656024950519710366803;
    uint256 constant S2x = 8828796696374819593208836317370190349287951927584478387094345021258498470410;
    uint256 constant S2y = 2714768647767442263778509730954987986921648838539978642779835293770877793739;
    uint256 constant S3x = 8867949948637390707499938271342708934209338714252418186648707231315176643890;
    uint256 constant S3y = 6881325412277295324618542099533012117635604351167465769096609717850870026617;
    uint256 constant k1 = 2;
    uint256 constant k2 = 3;
    uint256 constant X2x1 = 21831381940315734285607113342023901060522397560371972897001948545212302161822;
    uint256 constant X2x2 = 17231025384763736816414546592865244497437017442647097510447326538965263639101;
    uint256 constant X2y1 = 2388026358213174446665280700919698872609886601280537296205114254867301080648;
    uint256 constant X2y2 = 11507326595632554467052522095592665270651932854513688777769618397986436103170;

    // Proof calldata
    // Byte offset of every parameter of the calldata
    // Polynomial commitments
    uint16 constant pA = 4 + 0;
    uint16 constant pB = 4 + 64;
    uint16 constant pC = 4 + 128;
    uint16 constant pZ = 4 + 192;
    uint16 constant pT1 = 4 + 256;
    uint16 constant pT2 = 4 + 320;
    uint16 constant pT3 = 4 + 384;
    uint16 constant pWxi = 4 + 448;
    uint16 constant pWxiw = 4 + 512;
    // Opening evaluations
    uint16 constant pEval_a = 4 + 576;
    uint16 constant pEval_b = 4 + 608;
    uint16 constant pEval_c = 4 + 640;
    uint16 constant pEval_s1 = 4 + 672;
    uint16 constant pEval_s2 = 4 + 704;
    uint16 constant pEval_zw = 4 + 736;

    // Memory data
    // Challenges
    uint16 constant pAlpha = 0;
    uint16 constant pBeta = 32;
    uint16 constant pGamma = 64;
    uint16 constant pXi = 96;
    uint16 constant pXin = 128;
    uint16 constant pBetaXi = 160;
    uint16 constant pV1 = 192;
    uint16 constant pV2 = 224;
    uint16 constant pV3 = 256;
    uint16 constant pV4 = 288;
    uint16 constant pV5 = 320;
    uint16 constant pU = 352;

    uint16 constant pPI = 384;
    uint16 constant pEval_r0 = 416;
    uint16 constant pD = 448;
    uint16 constant pF = 512;
    uint16 constant pE = 576;
    uint16 constant pTmp = 640;
    uint16 constant pAlpha2 = 704;
    uint16 constant pZh = 736;
    uint16 constant pZhInv = 768;

    uint16 constant pEval_l1 = 800;

    uint16 constant pEval_l2 = 832;

    uint16 constant pEval_l3 = 864;

    uint16 constant pEval_l4 = 896;

    uint16 constant pEval_l5 = 928;

    uint16 constant lastMem = 960;

    function verifyProof(uint256[24] calldata _proof, uint256[5] calldata _pubSignals) public view returns (bool) {
        assembly {
            /////////
            // Computes the inverse using the extended euclidean algorithm
            /////////
            function inverse(a, q) -> inv {
                let t := 0
                let newt := 1
                let r := q
                let newr := a
                let quotient
                let aux

                for {} newr {} {
                    quotient := sdiv(r, newr)
                    aux := sub(t, mul(quotient, newt))
                    t := newt
                    newt := aux

                    aux := sub(r, mul(quotient, newr))
                    r := newr
                    newr := aux
                }

                if gt(r, 1) { revert(0, 0) }
                if slt(t, 0) { t := add(t, q) }

                inv := t
            }

            ///////
            // Computes the inverse of an array of values
            // See https://vitalik.ca/general/2018/07/21/starks_part_3.html in section where explain fields operations
            //////
            function inverseArray(pVals, n) {
                let pAux := mload(0x40) // Point to the next free position
                let pIn := pVals
                let lastPIn := add(pVals, mul(n, 32)) // Read n elemnts
                let acc := mload(pIn) // Read the first element
                pIn := add(pIn, 32) // Point to the second element
                let inv

                for {} lt(pIn, lastPIn) {
                    pAux := add(pAux, 32)
                    pIn := add(pIn, 32)
                } {
                    mstore(pAux, acc)
                    acc := mulmod(acc, mload(pIn), q)
                }
                acc := inverse(acc, q)

                // At this point pAux pint to the next free position we substract 1 to point to the last used
                pAux := sub(pAux, 32)
                // pIn points to the n+1 element, we substract to point to n
                pIn := sub(pIn, 32)
                lastPIn := pVals // We don't process the first element
                for {} gt(pIn, lastPIn) {
                    pAux := sub(pAux, 32)
                    pIn := sub(pIn, 32)
                } {
                    inv := mulmod(acc, mload(pAux), q)
                    acc := mulmod(acc, mload(pIn), q)
                    mstore(pIn, inv)
                }
                // pIn points to first element, we just set it.
                mstore(pIn, acc)
            }

            function checkField(v) {
                if iszero(lt(v, q)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkInput() {
                checkField(calldataload(pEval_a))
                checkField(calldataload(pEval_b))
                checkField(calldataload(pEval_c))
                checkField(calldataload(pEval_s1))
                checkField(calldataload(pEval_s2))
                checkField(calldataload(pEval_zw))
            }

            function calculateChallenges(pMem, pPublic) {
                let beta
                let aux

                let mIn := mload(0x40) // Pointer to the next free memory position

                // Compute challenge.beta & challenge.gamma
                mstore(mIn, Qmx)
                mstore(add(mIn, 32), Qmy)
                mstore(add(mIn, 64), Qlx)
                mstore(add(mIn, 96), Qly)
                mstore(add(mIn, 128), Qrx)
                mstore(add(mIn, 160), Qry)
                mstore(add(mIn, 192), Qox)
                mstore(add(mIn, 224), Qoy)
                mstore(add(mIn, 256), Qcx)
                mstore(add(mIn, 288), Qcy)
                mstore(add(mIn, 320), S1x)
                mstore(add(mIn, 352), S1y)
                mstore(add(mIn, 384), S2x)
                mstore(add(mIn, 416), S2y)
                mstore(add(mIn, 448), S3x)
                mstore(add(mIn, 480), S3y)

                mstore(add(mIn, 512), calldataload(add(pPublic, 0)))

                mstore(add(mIn, 544), calldataload(add(pPublic, 32)))

                mstore(add(mIn, 576), calldataload(add(pPublic, 64)))

                mstore(add(mIn, 608), calldataload(add(pPublic, 96)))

                mstore(add(mIn, 640), calldataload(add(pPublic, 128)))

                mstore(add(mIn, 672), calldataload(pA))
                mstore(add(mIn, 704), calldataload(add(pA, 32)))
                mstore(add(mIn, 736), calldataload(pB))
                mstore(add(mIn, 768), calldataload(add(pB, 32)))
                mstore(add(mIn, 800), calldataload(pC))
                mstore(add(mIn, 832), calldataload(add(pC, 32)))

                beta := mod(keccak256(mIn, 864), q)
                mstore(add(pMem, pBeta), beta)

                // challenges.gamma
                mstore(add(pMem, pGamma), mod(keccak256(add(pMem, pBeta), 32), q))

                // challenges.alpha
                mstore(mIn, mload(add(pMem, pBeta)))
                mstore(add(mIn, 32), mload(add(pMem, pGamma)))
                mstore(add(mIn, 64), calldataload(pZ))
                mstore(add(mIn, 96), calldataload(add(pZ, 32)))

                aux := mod(keccak256(mIn, 128), q)
                mstore(add(pMem, pAlpha), aux)
                mstore(add(pMem, pAlpha2), mulmod(aux, aux, q))

                // challenges.xi
                mstore(mIn, aux)
                mstore(add(mIn, 32), calldataload(pT1))
                mstore(add(mIn, 64), calldataload(add(pT1, 32)))
                mstore(add(mIn, 96), calldataload(pT2))
                mstore(add(mIn, 128), calldataload(add(pT2, 32)))
                mstore(add(mIn, 160), calldataload(pT3))
                mstore(add(mIn, 192), calldataload(add(pT3, 32)))

                aux := mod(keccak256(mIn, 224), q)
                mstore(add(pMem, pXi), aux)

                // challenges.v
                mstore(mIn, aux)
                mstore(add(mIn, 32), calldataload(pEval_a))
                mstore(add(mIn, 64), calldataload(pEval_b))
                mstore(add(mIn, 96), calldataload(pEval_c))
                mstore(add(mIn, 128), calldataload(pEval_s1))
                mstore(add(mIn, 160), calldataload(pEval_s2))
                mstore(add(mIn, 192), calldataload(pEval_zw))

                let v1 := mod(keccak256(mIn, 224), q)
                mstore(add(pMem, pV1), v1)

                // challenges.beta * challenges.xi
                mstore(add(pMem, pBetaXi), mulmod(beta, aux, q))

                // challenges.xi^n

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                aux := mulmod(aux, aux, q)

                mstore(add(pMem, pXin), aux)

                // Zh
                aux := mod(add(sub(aux, 1), q), q)
                mstore(add(pMem, pZh), aux)
                mstore(add(pMem, pZhInv), aux) // We will invert later together with lagrange pols

                // challenges.v^2, challenges.v^3, challenges.v^4, challenges.v^5
                aux := mulmod(v1, v1, q)
                mstore(add(pMem, pV2), aux)
                aux := mulmod(aux, v1, q)
                mstore(add(pMem, pV3), aux)
                aux := mulmod(aux, v1, q)
                mstore(add(pMem, pV4), aux)
                aux := mulmod(aux, v1, q)
                mstore(add(pMem, pV5), aux)

                // challenges.u
                mstore(mIn, calldataload(pWxi))
                mstore(add(mIn, 32), calldataload(add(pWxi, 32)))
                mstore(add(mIn, 64), calldataload(pWxiw))
                mstore(add(mIn, 96), calldataload(add(pWxiw, 32)))

                mstore(add(pMem, pU), mod(keccak256(mIn, 128), q))
            }

            function calculateLagrange(pMem) {
                let w := 1

                mstore(add(pMem, pEval_l1), mulmod(n, mod(add(sub(mload(add(pMem, pXi)), w), q), q), q))

                w := mulmod(w, w1, q)

                mstore(add(pMem, pEval_l2), mulmod(n, mod(add(sub(mload(add(pMem, pXi)), w), q), q), q))

                w := mulmod(w, w1, q)

                mstore(add(pMem, pEval_l3), mulmod(n, mod(add(sub(mload(add(pMem, pXi)), w), q), q), q))

                w := mulmod(w, w1, q)

                mstore(add(pMem, pEval_l4), mulmod(n, mod(add(sub(mload(add(pMem, pXi)), w), q), q), q))

                w := mulmod(w, w1, q)

                mstore(add(pMem, pEval_l5), mulmod(n, mod(add(sub(mload(add(pMem, pXi)), w), q), q), q))

                inverseArray(add(pMem, pZhInv), 6)

                let zh := mload(add(pMem, pZh))
                w := 1

                mstore(add(pMem, pEval_l1), mulmod(mload(add(pMem, pEval_l1)), zh, q))

                w := mulmod(w, w1, q)

                mstore(add(pMem, pEval_l2), mulmod(w, mulmod(mload(add(pMem, pEval_l2)), zh, q), q))

                w := mulmod(w, w1, q)

                mstore(add(pMem, pEval_l3), mulmod(w, mulmod(mload(add(pMem, pEval_l3)), zh, q), q))

                w := mulmod(w, w1, q)

                mstore(add(pMem, pEval_l4), mulmod(w, mulmod(mload(add(pMem, pEval_l4)), zh, q), q))

                w := mulmod(w, w1, q)

                mstore(add(pMem, pEval_l5), mulmod(w, mulmod(mload(add(pMem, pEval_l5)), zh, q), q))
            }

            function calculatePI(pMem, pPub) {
                let pl := 0

                pl := mod(add(sub(pl, mulmod(mload(add(pMem, pEval_l1)), calldataload(add(pPub, 0)), q)), q), q)

                pl := mod(add(sub(pl, mulmod(mload(add(pMem, pEval_l2)), calldataload(add(pPub, 32)), q)), q), q)

                pl := mod(add(sub(pl, mulmod(mload(add(pMem, pEval_l3)), calldataload(add(pPub, 64)), q)), q), q)

                pl := mod(add(sub(pl, mulmod(mload(add(pMem, pEval_l4)), calldataload(add(pPub, 96)), q)), q), q)

                pl := mod(add(sub(pl, mulmod(mload(add(pMem, pEval_l5)), calldataload(add(pPub, 128)), q)), q), q)

                mstore(add(pMem, pPI), pl)
            }

            function calculateR0(pMem) {
                let e1 := mload(add(pMem, pPI))

                let e2 := mulmod(mload(add(pMem, pEval_l1)), mload(add(pMem, pAlpha2)), q)

                let e3a := addmod(calldataload(pEval_a), mulmod(mload(add(pMem, pBeta)), calldataload(pEval_s1), q), q)
                e3a := addmod(e3a, mload(add(pMem, pGamma)), q)

                let e3b := addmod(calldataload(pEval_b), mulmod(mload(add(pMem, pBeta)), calldataload(pEval_s2), q), q)
                e3b := addmod(e3b, mload(add(pMem, pGamma)), q)

                let e3c := addmod(calldataload(pEval_c), mload(add(pMem, pGamma)), q)

                let e3 := mulmod(mulmod(e3a, e3b, q), e3c, q)
                e3 := mulmod(e3, calldataload(pEval_zw), q)
                e3 := mulmod(e3, mload(add(pMem, pAlpha)), q)

                let r0 := addmod(e1, mod(sub(q, e2), q), q)
                r0 := addmod(r0, mod(sub(q, e3), q), q)

                mstore(add(pMem, pEval_r0), r0)
            }

            function g1_set(pR, pP) {
                mstore(pR, mload(pP))
                mstore(add(pR, 32), mload(add(pP, 32)))
            }

            function g1_setC(pR, x, y) {
                mstore(pR, x)
                mstore(add(pR, 32), y)
            }

            function g1_calldataSet(pR, pP) {
                mstore(pR, calldataload(pP))
                mstore(add(pR, 32), calldataload(add(pP, 32)))
            }

            function g1_acc(pR, pP) {
                let mIn := mload(0x40)
                mstore(mIn, mload(pR))
                mstore(add(mIn, 32), mload(add(pR, 32)))
                mstore(add(mIn, 64), mload(pP))
                mstore(add(mIn, 96), mload(add(pP, 32)))

                let success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function g1_mulAcc(pR, pP, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, mload(pP))
                mstore(add(mIn, 32), mload(add(pP, 32)))
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function g1_mulSetC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function g1_mulSet(pR, pP, s) {
                g1_mulSetC(pR, mload(pP), mload(add(pP, 32)), s)
            }

            function calculateD(pMem) {
                let _pD := add(pMem, pD)
                let gamma := mload(add(pMem, pGamma))
                let mIn := mload(0x40)
                mstore(0x40, add(mIn, 256)) // d1, d2, d3 & d4 (4*64 bytes)

                g1_setC(_pD, Qcx, Qcy)
                g1_mulAccC(_pD, Qmx, Qmy, mulmod(calldataload(pEval_a), calldataload(pEval_b), q))
                g1_mulAccC(_pD, Qlx, Qly, calldataload(pEval_a))
                g1_mulAccC(_pD, Qrx, Qry, calldataload(pEval_b))
                g1_mulAccC(_pD, Qox, Qoy, calldataload(pEval_c))

                let betaxi := mload(add(pMem, pBetaXi))
                let val1 := addmod(addmod(calldataload(pEval_a), betaxi, q), gamma, q)

                let val2 := addmod(addmod(calldataload(pEval_b), mulmod(betaxi, k1, q), q), gamma, q)

                let val3 := addmod(addmod(calldataload(pEval_c), mulmod(betaxi, k2, q), q), gamma, q)

                let d2a := mulmod(mulmod(mulmod(val1, val2, q), val3, q), mload(add(pMem, pAlpha)), q)

                let d2b := mulmod(mload(add(pMem, pEval_l1)), mload(add(pMem, pAlpha2)), q)

                // We'll use mIn to save d2
                g1_calldataSet(add(mIn, 192), pZ)
                g1_mulSet(mIn, add(mIn, 192), addmod(addmod(d2a, d2b, q), mload(add(pMem, pU)), q))

                val1 :=
                    addmod(
                        addmod(calldataload(pEval_a), mulmod(mload(add(pMem, pBeta)), calldataload(pEval_s1), q), q),
                        gamma,
                        q
                    )

                val2 :=
                    addmod(
                        addmod(calldataload(pEval_b), mulmod(mload(add(pMem, pBeta)), calldataload(pEval_s2), q), q),
                        gamma,
                        q
                    )

                val3 := mulmod(mulmod(mload(add(pMem, pAlpha)), mload(add(pMem, pBeta)), q), calldataload(pEval_zw), q)

                // We'll use mIn + 64 to save d3
                g1_mulSetC(add(mIn, 64), S3x, S3y, mulmod(mulmod(val1, val2, q), val3, q))

                // We'll use mIn + 128 to save d4
                g1_calldataSet(add(mIn, 128), pT1)

                g1_mulAccC(add(mIn, 128), calldataload(pT2), calldataload(add(pT2, 32)), mload(add(pMem, pXin)))
                let xin2 := mulmod(mload(add(pMem, pXin)), mload(add(pMem, pXin)), q)
                g1_mulAccC(add(mIn, 128), calldataload(pT3), calldataload(add(pT3, 32)), xin2)

                g1_mulSetC(add(mIn, 128), mload(add(mIn, 128)), mload(add(mIn, 160)), mload(add(pMem, pZh)))

                mstore(add(add(mIn, 64), 32), mod(sub(qf, mload(add(add(mIn, 64), 32))), qf))
                mstore(add(mIn, 160), mod(sub(qf, mload(add(mIn, 160))), qf))
                g1_acc(_pD, mIn)
                g1_acc(_pD, add(mIn, 64))
                g1_acc(_pD, add(mIn, 128))
            }

            function calculateF(pMem) {
                let p := add(pMem, pF)

                g1_set(p, add(pMem, pD))
                g1_mulAccC(p, calldataload(pA), calldataload(add(pA, 32)), mload(add(pMem, pV1)))
                g1_mulAccC(p, calldataload(pB), calldataload(add(pB, 32)), mload(add(pMem, pV2)))
                g1_mulAccC(p, calldataload(pC), calldataload(add(pC, 32)), mload(add(pMem, pV3)))
                g1_mulAccC(p, S1x, S1y, mload(add(pMem, pV4)))
                g1_mulAccC(p, S2x, S2y, mload(add(pMem, pV5)))
            }

            function calculateE(pMem) {
                let s := mod(sub(q, mload(add(pMem, pEval_r0))), q)

                s := addmod(s, mulmod(calldataload(pEval_a), mload(add(pMem, pV1)), q), q)
                s := addmod(s, mulmod(calldataload(pEval_b), mload(add(pMem, pV2)), q), q)
                s := addmod(s, mulmod(calldataload(pEval_c), mload(add(pMem, pV3)), q), q)
                s := addmod(s, mulmod(calldataload(pEval_s1), mload(add(pMem, pV4)), q), q)
                s := addmod(s, mulmod(calldataload(pEval_s2), mload(add(pMem, pV5)), q), q)
                s := addmod(s, mulmod(calldataload(pEval_zw), mload(add(pMem, pU)), q), q)

                g1_mulSetC(add(pMem, pE), G1x, G1y, s)
            }

            function checkPairing(pMem) -> isOk {
                let mIn := mload(0x40)
                mstore(0x40, add(mIn, 576)) // [0..383] = pairing data, [384..447] = pWxi, [448..512] = pWxiw

                let _pWxi := add(mIn, 384)
                let _pWxiw := add(mIn, 448)
                let _aux := add(mIn, 512)

                g1_calldataSet(_pWxi, pWxi)
                g1_calldataSet(_pWxiw, pWxiw)

                // A1
                g1_mulSet(mIn, _pWxiw, mload(add(pMem, pU)))
                g1_acc(mIn, _pWxi)
                mstore(add(mIn, 32), mod(sub(qf, mload(add(mIn, 32))), qf))

                // [X]_2
                mstore(add(mIn, 64), X2x2)
                mstore(add(mIn, 96), X2x1)
                mstore(add(mIn, 128), X2y2)
                mstore(add(mIn, 160), X2y1)

                // B1
                g1_mulSet(add(mIn, 192), _pWxi, mload(add(pMem, pXi)))

                let s := mulmod(mload(add(pMem, pU)), mload(add(pMem, pXi)), q)
                s := mulmod(s, w1, q)
                g1_mulSet(_aux, _pWxiw, s)
                g1_acc(add(mIn, 192), _aux)
                g1_acc(add(mIn, 192), add(pMem, pF))
                mstore(add(pMem, add(pE, 32)), mod(sub(qf, mload(add(pMem, add(pE, 32)))), qf))
                g1_acc(add(mIn, 192), add(pMem, pE))

                // [1]_2
                mstore(add(mIn, 256), G2x2)
                mstore(add(mIn, 288), G2x1)
                mstore(add(mIn, 320), G2y2)
                mstore(add(mIn, 352), G2y1)

                let success := staticcall(sub(gas(), 2000), 8, mIn, 384, mIn, 0x20)

                isOk := and(success, mload(mIn))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, lastMem))

            checkInput()
            calculateChallenges(pMem, _pubSignals)
            calculateLagrange(pMem)
            calculatePI(pMem, _pubSignals)
            calculateR0(pMem)
            calculateD(pMem)
            calculateF(pMem)
            calculateE(pMem)
            let isValid := checkPairing(pMem)

            mstore(0x40, sub(pMem, lastMem))
            mstore(0, isValid)
            return(0, 0x20)
        }
    }
}
