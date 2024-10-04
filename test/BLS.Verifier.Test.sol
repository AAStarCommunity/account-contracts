// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/BLS.Verifier.sol";

contract BLSVerifierTest is Test {
    BLSVerifier blsVerifier;
    address owner;
    address addr1;

    function setUp() public {
        owner = address(this);
        addr1 = address(0x1234);
        blsVerifier = new BLSVerifier(owner);
    }

    function testOnlyOwnerCanInitialize() public {
        uint256[4] memory publicKey = [uint256(1), uint256(2), uint256(3), uint256(4)];
        blsVerifier.initialize(owner, publicKey);
        uint256[4] memory storedPublicKey = blsVerifier.getPublicKey();
        for (uint256 i = 0; i < 4; i++) {
            assertEq(storedPublicKey[i], publicKey[i]);
        }
    }

    function testNonOwnerCannotInitialize() public {
        uint256[4] memory publicKey = [uint256(1), uint256(2), uint256(3), uint256(4)];
        vm.prank(addr1);
        vm.expectRevert("Caller is not the owner");
        blsVerifier.initialize(owner, publicKey);
    }

    function testOnlyOwnerCanSetPublicKey() public {
        uint256[4] memory newPublicKey = [uint256(5), uint256(6), uint256(7), uint256(8)];
        blsVerifier.setBlsPublicKey(newPublicKey);
        uint256[4] memory storedPublicKey = blsVerifier.getPublicKey();
        for (uint256 i = 0; i < 4; i++) {
            assertEq(storedPublicKey[i], newPublicKey[i]);
        }
    }

    function testNonOwnerCannotSetPublicKey() public {
        uint256[4] memory newPublicKey = [uint256(5), uint256(6), uint256(7), uint256(8)];
        vm.prank(addr1);
        vm.expectRevert("Caller is not the owner");
        blsVerifier.setBlsPublicKey(newPublicKey);
    }

    function testValidateUserOpSignature() public {
        uint256[2] memory message = [uint256(1), uint256(2)];
        uint256[2] memory signature = [uint256(3), uint256(4)];
        uint256[4] memory publicKey = [uint256(5), uint256(6), uint256(7), uint256(8)];
        blsVerifier.setBlsPublicKey(publicKey);
        bool isValid = blsVerifier.validateUserOpSignature(message, signature);
        assertTrue(isValid);
    }
}
