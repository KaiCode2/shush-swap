// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {IHookFeeManager} from "@uniswap/v4-core/contracts/interfaces/IHookFeeManager.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {PoolKey, PoolId, PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import {Fees} from "@uniswap/v4-core/contracts/Fees.sol";
import {CurrencyLibrary, Currency} from "@uniswap/v4-core/contracts/types/Currency.sol";
import {BalanceDelta} from "@uniswap/v4-core/contracts/types/BalanceDelta.sol";
import {BaseHook, IHooks} from "v4-periphery/BaseHook.sol";

import {IncrementalBinaryTree, IncrementalTreeData} from "@zk-kit/merkle-tree/IncrementalBinaryTree.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IPlonkVerifier} from "../interfaces/IPlonkVerifier.sol";
import {PlonkVerifier} from "../SpendVerifier.sol";

import {BaseFactory} from "../BaseFactory.sol";

contract PrivacyHook is BaseHook, IHookFeeManager {
    using PoolIdLibrary for PoolKey;
    using IncrementalBinaryTree for IncrementalTreeData;

    error InvalidAmount(uint256 amount);
    error InsufficientAllowance(uint256 amount);
    error InsufficientBalance(uint256 amount);
    error ProofVerificationFailed();

    struct TokenState {
        IncrementalTreeData depositTree;
        uint8 treeEpoch;
        uint256[32] historicalRoots;
        mapping(bytes32 => bool) spendNullifiers;
    }

    mapping(address token => TokenState state) internal tokenStates;

    address public factory;
    IPlonkVerifier public verifier;

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {
        factory = msg.sender;
    }

    /// @dev Validates amount, balance of msg.sender and allowance of PrivacyHook
    modifier checkDeposit(address token, uint256 amount) {
        if (amount == 0) revert InvalidAmount(amount);
        else if (IERC20(token).balanceOf(msg.sender) < amount) revert InsufficientBalance(amount);
        else if (IERC20(token).allowance(msg.sender, address(this)) < amount) revert InsufficientAllowance(amount);
        _;
    }

    function setVerifier(IPlonkVerifier _verifier) external {
        require(msg.sender == factory, "PrivacyHook: FORBIDDEN");
        verifier = _verifier;
    }

    //  ─────────────────────────────────────────────────────────────────────────────
    //  Deposit Functions
    //  ─────────────────────────────────────────────────────────────────────────────

    /**
     *
     * @param token Input token address to pull funds from
     * @param amount Amount of token to pull
     * @param depositCommitment Deposit commitment to insert to deposit tree. Deposit commitment = poseidon("DEPOSIT", token, 0, amount, nullifier)
     */
    function depositFunds(address token, uint256 amount, bytes32 depositCommitment)
        external
        checkDeposit(token, amount)
    {
        _insertDepositCommitment(token, depositCommitment);

        SafeERC20.safeTransferFrom(IERC20(token), msg.sender, address(this), amount);
    }

    function privateSwap(
        PoolKey memory poolKey,
        bool zeroForOne,
        uint256 amountIn,
        uint256 exactAmountOut,
        bytes32 spendNullifier,
        bytes32 newDepositCommitment,
        uint256[24] memory proof
    ) external {
        // (uint160 sqrtPriceX96,,,,,) = poolManager.getSlot0(poolKey.toId());
        address tokenIn = zeroForOne ? Currency.unwrap(poolKey.currency0) : Currency.unwrap(poolKey.currency1);
        address tokenOut = zeroForOne ? Currency.unwrap(poolKey.currency1) : Currency.unwrap(poolKey.currency0);

        TokenState storage state = tokenStates[tokenIn];
        uint256[5] memory publicSignals = [
            uint256(uint160(tokenIn)),
            amountIn,
            uint256(state.depositTree.root),
            uint256(spendNullifier),
            uint256(newDepositCommitment)
        ];
        if (!verifier.verifyProof(proof, publicSignals)) revert ProofVerificationFailed();

        state.spendNullifiers[spendNullifier] = true;
        _insertDepositCommitment(tokenIn, newDepositCommitment);

        // BalanceDelta delta = poolManager.swap(
        //     poolKey,
        //     IPoolManager.SwapParams({
        //         zeroForOne: zeroForOne,
        //         amountSpecified: amountIn,
        //         sqrtPriceLimitX96: 0
        //     }),
        //     ""
        // );
        // uint256 amountOut = poolManager.swap(poolKey, msg.sender, amountIn, exactAmountOut, proof);
        SafeERC20.safeTransfer(IERC20(tokenOut), msg.sender, exactAmountOut);
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

    function getHookWithdrawFee(PoolKey calldata key) external view override returns (uint8 fee) {
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

    function _insertDepositCommitment(address token, bytes32 depositCommitment) internal {
        TokenState storage state = tokenStates[token];
        state.historicalRoots[state.treeEpoch % 32] = state.depositTree.root;
        state.depositTree.insert(uint256(depositCommitment));
        state.treeEpoch++;
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
        IPlonkVerifier verifier = new PlonkVerifier();
        PrivacyHook hook = new PrivacyHook{salt: salt}(poolManager);
        hook.setVerifier(verifier);
        return address(hook);
    }

    function _hashBytecode(IPoolManager poolManager) internal pure override returns (bytes32 bytecodeHash) {
        bytecodeHash = keccak256(abi.encodePacked(type(PrivacyHook).creationCode, abi.encode(poolManager)));
    }
}
