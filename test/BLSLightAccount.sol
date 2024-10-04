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
        bytes32 blsPublicKey = keccak256(bytes("blsPublicKey"));

        account.initialize(owner, blsPublicKey);

        assertEq(account.owner(), owner);
        assertEq(account.getBlsPublicKey(), blsPublicKey);
    }

    function testInitializeRevert() public {
        address owner = address(this);
        bytes32 blsPublicKey = keccak256(bytes("blsPublicKey"));

        account.initialize(owner, blsPublicKey);

        bytes memory errorSelector = abi.encodeWithSelector(CustomSlotInitializable.InvalidInitialization.selector);
        vm.expectRevert(errorSelector);
        account.initialize(owner, blsPublicKey);
    }

    function testSetBlsPublicKey() public {
        address owner = address(this);
        bytes32 blsPublicKey = keccak256(bytes("blsPublicKey"));
        bytes32 newBlsPublicKey = keccak256(bytes("newBlsPublicKey"));

        account.initialize(owner, blsPublicKey);

        account.setBlsPublicKey(newBlsPublicKey);

        assertEq(account.getBlsPublicKey(), newBlsPublicKey);
    }
}
