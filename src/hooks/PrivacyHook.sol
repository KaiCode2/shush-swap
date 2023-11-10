// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {IHookFeeManager} from "@uniswap/v4-core/contracts/interfaces/IHookFeeManager.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {PoolKey, PoolId, PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import {BalanceDelta} from "@uniswap/v4-core/contracts/types/BalanceDelta.sol";
import {BaseHook} from "v4-periphery/BaseHook.sol";
import {IncrementalBinaryTree, IncrementalTreeData} from "@zk-kit/merkle-tree/IncrementalBinaryTree.sol";

import {BaseFactory} from "../BaseFactory.sol";

contract PrivacyHook is BaseHook, IHookFeeManager {
    using PoolIdLibrary for PoolKey;
    using IncrementalBinaryTree for IncrementalTreeData;

    error InvalidAmount(uint256 amount);
    error ProofVerificationFailed();

    struct TokenState {
        IncrementalTreeData depositTree;
        mapping(bytes32 => bool) spendNullifiers;
    }

    mapping(address token => TokenState state) internal tokenStates;

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {}

    //  ─────────────────────────────────────────────────────────────────────────────
    //  Deposit Functions
    //  ─────────────────────────────────────────────────────────────────────────────

    function depositFunds(address token, uint256 amount, bytes32 depositCommitment) external {

    }

    //  ─────────────────────────────────────────────────────────────────────────────
    //  V4 Hooks
    //  ─────────────────────────────────────────────────────────────────────────────

    function getHooksCalls() public pure override returns (Hooks.Calls memory) {
        return Hooks.Calls({
            beforeInitialize: true,
            afterInitialize: true,
            beforeModifyPosition: true,
            afterModifyPosition: true,
            beforeSwap: true,
            afterSwap: true,
            beforeDonate: true,
            afterDonate: true
        });
    }

    function getHookSwapFee(PoolKey calldata key) external view returns (uint8 fee) {
        fee = 3;
    }

    function getHookWithdrawFee(PoolKey calldata key) external override view returns (uint8 fee) {
        fee = 10;
    }

    function beforeInitialize(address sender, PoolKey calldata key, uint160 sqrtPriceX96, bytes calldata)
        external
        override
        returns (bytes4 selector)
    {
        // insert hook logic here

        selector = BaseHook.beforeInitialize.selector;
    }

    function afterInitialize(address sender, PoolKey calldata key, uint160 sqrtPriceX96, int24 tick, bytes calldata)
        external
        override
        returns (bytes4 selector)
    {
        // insert hook logic here

        selector = BaseHook.afterInitialize.selector;
    }

    function beforeModifyPosition(
        address sender,
        PoolKey calldata key,
        IPoolManager.ModifyPositionParams calldata params,
        bytes calldata
    ) external override returns (bytes4 selector) {
        // insert hook logic here

        selector = BaseHook.beforeModifyPosition.selector;
    }

    function afterModifyPosition(
        address sender,
        PoolKey calldata key,
        IPoolManager.ModifyPositionParams calldata params,
        BalanceDelta delta,
        bytes calldata
    ) external override returns (bytes4 selector) {
        // insert hook logic here

        selector = BaseHook.afterModifyPosition.selector;
    }

    function beforeSwap(address sender, PoolKey calldata key, IPoolManager.SwapParams calldata params, bytes calldata)
        external
        override
        returns (bytes4 selector)
    {
        // insert hook logic here

        selector = BaseHook.beforeSwap.selector;
    }

    function afterSwap(
        address sender,
        PoolKey calldata key,
        IPoolManager.SwapParams calldata params,
        BalanceDelta delta,
        bytes calldata
    ) external override returns (bytes4 selector) {
        // insert hook logic here

        selector = BaseHook.afterSwap.selector;
    }

    function beforeDonate(address sender, PoolKey calldata key, uint256 amount0, uint256 amount1, bytes calldata)
        external
        override
        returns (bytes4 selector)
    {
        // insert hook logic here

        selector = BaseHook.beforeDonate.selector;
    }

    function afterDonate(address sender, PoolKey calldata key, uint256 amount0, uint256 amount1, bytes calldata)
        external
        override
        returns (bytes4 selector)
    {
        // insert hook logic here

        selector = BaseHook.afterDonate.selector;
    }

    function getHookFees(PoolKey calldata key) external view returns (uint24 fee) {
        fee = 0;
    }
}

contract PrivacyHookFactory is BaseFactory {
    constructor()
        BaseFactory(
            address(
                uint160(
                    Hooks.BEFORE_INITIALIZE_FLAG | Hooks.AFTER_INITIALIZE_FLAG | Hooks.BEFORE_MODIFY_POSITION_FLAG
                        | Hooks.AFTER_MODIFY_POSITION_FLAG | Hooks.BEFORE_SWAP_FLAG | Hooks.AFTER_SWAP_FLAG
                        | Hooks.BEFORE_DONATE_FLAG | Hooks.AFTER_DONATE_FLAG
                )
            )
        )
    {}

    function deploy(IPoolManager poolManager, bytes32 salt) public override returns (address) {
        return address(new PrivacyHook{salt: salt}(poolManager));
    }

    function _hashBytecode(IPoolManager poolManager) internal pure override returns (bytes32 bytecodeHash) {
        bytecodeHash = keccak256(abi.encodePacked(type(PrivacyHook).creationCode, abi.encode(poolManager)));
    }
}
