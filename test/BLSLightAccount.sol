// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {EntryPoint} from "light-account/lib/account-abstraction/contracts/core/EntryPoint.sol";
import {BLSLightAccount, IEntryPoint, CustomSlotInitializable} from "../src/BLSLightAccount.sol";

contract BLSLightAccountTest is Test {
    BLSLightAccount account;
    EntryPoint entryPoint;

    function setUp() public {
        entryPoint = new EntryPoint();
        account = new BLSLightAccount(entryPoint);
    }

    function testInitialize() public {
        address owner = address(this);

        // 初始化合约
        account.initialize(owner);
        
        // 检查初始化后的状态
        assertEq(account.owner(), owner);
    }

    function testInitializeRevert() public {
        address owner = address(this);

        // 第一次初始化合约
        account.initialize(owner);
        
        // 尝试再次初始化合约，应该失败
        bytes memory errorSelector = abi.encodeWithSelector(CustomSlotInitializable.InvalidInitialization.selector);
        vm.expectRevert(errorSelector);
        account.initialize(owner);
    }
}