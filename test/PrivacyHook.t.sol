// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";
import {IHooks} from "@uniswap/v4-core/contracts/interfaces/IHooks.sol";
import {FeeLibrary} from "@uniswap/v4-core/contracts/libraries/FeeLibrary.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {TickMath} from "@uniswap/v4-core/contracts/libraries/TickMath.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {BalanceDelta} from "@uniswap/v4-core/contracts/types/BalanceDelta.sol";
import {PoolKey, PoolId, PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import {Deployers} from "@uniswap/v4-core/test/foundry-tests/utils/Deployers.sol";
import {CurrencyLibrary, Currency} from "@uniswap/v4-core/contracts/types/Currency.sol";
import {Pool} from "@uniswap/v4-core/contracts/libraries/Pool.sol";

import {TestPoolManager} from "./utils/TestPoolManager.sol";
import {PrivacyHook, PrivacyHookFactory} from "../src/hooks/PrivacyHook.sol";

contract PrivacyTest is Test, TestPoolManager, Deployers, GasSnapshot {
    using PoolIdLibrary for PoolKey;
    using CurrencyLibrary for Currency;

    PrivacyHook hook;
    PoolKey poolKey;

    function setUp() public {
        // creates the pool manager, test tokens and generic routers
        TestPoolManager.initialize();

        // Deploy the factory contract
        PrivacyHookFactory factory = new PrivacyHookFactory();
        // Use the factory to create a new hook contract
        hook = PrivacyHook(factory.mineDeploy(manager));

        // Create the pool
        poolKey = PoolKey(
            Currency.wrap(address(tokenA)),
            Currency.wrap(address(tokenB)),
            FeeLibrary.DYNAMIC_FEE_FLAG,
            60,
            IHooks(hook)
        );
        manager.initialize(poolKey, SQRT_RATIO_1_1, "");

        // Provide liquidity over different ranges to the pool
        caller.addLiquidity(poolKey, address(this), -60, 60, 10 ether);
        caller.addLiquidity(poolKey, address(this), -120, 120, 10 ether);
        caller.addLiquidity(poolKey, address(this), TickMath.minUsableTick(60), TickMath.maxUsableTick(60), 10 ether);
    }

    // function testDeposittokenA() public {
    //     caller.deposit(address(tokenA), address(this), address(this), 1e18);
    // }

    // function testDeposittokenB() public {
    //     caller.deposit(address(tokenB), address(this), address(this), 1e18);
    // }

    // function testHookFee() public {
    //     // Check the hook fee
    //     (Pool.Slot0 memory slot0,,,) = manager.pools(poolKey.toId());
    //     // assertEq(slot0.hookSwapFee, FeeLibrary.DYNAMIC_FEE_FLAG);
    //     assertEq(slot0.hookSwapFee, 3);

    //     assertEq(manager.hookFeesAccrued(address(hook), poolKey.currency0), 0);
    //     assertEq(manager.hookFeesAccrued(address(hook), poolKey.currency1), 0);
    // }

    // function testSwap0_1() public {
    //     // Swap tokenA for tokenB
    //     bytes[] memory results = caller.swap(poolKey, address(this), address(this), poolKey.currency0, 100);

    //     // Check settle result
    //     BalanceDelta delta = abi.decode(results[0], (BalanceDelta));
    //     assertEq(delta.amount0(), 100);
    //     assertEq(delta.amount1(), -98);

    //     // assertGt(manager.hookFeesAccrued(address(hook), poolKey.currency0), 0);
    //     // assertEq(manager.hookFeesAccrued(address(hook), poolKey.currency1), 0);
    // }

    // function testSwap1_0() public {
    //     // Swap tokenB for tokenA
    //     bytes[] memory results = caller.swap(poolKey, address(this), address(this), poolKey.currency1, 100);

    //     // Check settle result
    //     BalanceDelta delta = abi.decode(results[0], (BalanceDelta));
    //     assertEq(delta.amount0(), -98);
    //     assertEq(delta.amount1(), 100);
    // }

    // function testImbalancedAdd() public {
    //     caller.addLiquidity(poolKey, address(this), -60, 0, 10 ether);
    //     caller.addLiquidity(poolKey, address(this), 0, 120, 10 ether);
    //     caller.addLiquidity(poolKey, address(this), 60, 180, 10 ether);
    // }

    // function testSwap1_0_tilt0() public {
    //     caller.addLiquidity(poolKey, address(this), 0, 60, 10 ether);

    //     // Swap tokenB for tokenA
    //     bytes[] memory results = caller.swap(poolKey, address(this), address(this), poolKey.currency1, 100);

    //     // Check settle result
    //     BalanceDelta delta = abi.decode(results[0], (BalanceDelta));
    //     assertEq(delta.amount0(), -98);
    //     assertEq(delta.amount1(), 100);
    // }
}
