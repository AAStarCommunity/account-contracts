// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {EntryPoint} from "../lib/light-account/lib/account-abstraction/contracts/core/EntryPoint.sol";
import {BLSLightAccount, IEntryPoint} from "../src/BLSLightAccount.sol";
import {LightAccountFactory} from "../lib/light-account/src/LightAccountFactory.sol";
import {LightAccount} from "../lib/light-account/src/LightAccount.sol";

contract BLSLightAccountTest is Test {
    address owner = address(this);
    IEntryPoint entryPoint;
    LightAccountFactory factory;
    bytes32 blsPublicKey = keccak256(bytes("blsPublicKey"));
    // BLSLightAccount account;
    LightAccount public account;
    address public eoaAddress;
    uint256 public constant EOA_PRIVATE_KEY = 1;

    function setUp() public {
        eoaAddress = vm.addr(EOA_PRIVATE_KEY);
        entryPoint = new EntryPoint();
        factory = new LightAccountFactory(address(this), entryPoint);
        account = factory.createAccount(eoaAddress, 1);
    }

    function testInitialize() public {
        assertEq(entryPoint.getNonce(owner, 0), account.getNonce());
        assertNotEq(account.owner(), owner);
        // account.initialize(owner, blsPublicKey);
        // account.setBlsPublicKey(blsPublicKey);
    }
}