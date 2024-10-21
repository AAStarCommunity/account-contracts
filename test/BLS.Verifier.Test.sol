// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/BLS.Verifier.sol";

contract BLSVerifierTest is Test {
    address owner;
    address addr1;
    bytes32 domain = 0x0000000000000000000000000000000000000000000000000000000000000021;
    uint256[4][] pubkeys = new uint256[4][](2);
    uint256[2][] messages = new uint256[2][](2);
    uint256[2] signature;

    function setUp() public {
        signature = [
            uint256(0x2f71e7f05b887dd947424b3fe1885a32c7733a180b4bbf0eb0040a644bdfea26), 
            uint256(0x2f197beb9a8accb964c90dc387323bf0b9c5631b23f8bcb777e692361e5d331f)
        ];
        pubkeys.push([
            uint256(0x2be1d9edcadf9de755b605e3b4765da7850ba639e61599ff9929b2140c3f1bea), 
            uint256(0x1c3d49dc20bfce40087db02c1a85fa50ed936a03a8080ace0e3481166b0251e8), 
            uint256(0x1312fb11406ea8708e6054c48ff9dd4675506165ea8c7144322035eebf089150), 
            uint256(0x2a6b5e955e53d3acb1486970c8c4561ab6b4d3578667f8baa3185495c378af29)
        ]);
        pubkeys.push([
            uint256(0x10e0c276722c9a122e744c1f8825cf274765acfc70a0571bbcb1444f45959053), 
            uint256(0x48656c6c6f000000000000000000000000000000000000000000000000000000), 
            uint256(0x576f726c64000000000000000000000000000000000000000000000000000000), 
            uint256(0x0c9fd58100000000000000000000000000000000000000000000000000000000)
        ]);
        
        uint256[2] memory m1 = BLSOpen.hashToPoint(domain, abi.encode(0x48656c6c6f000000000000000000000000000000000000000000000000000000));
        messages.push([m1[0], m1[1]]);
        uint256[2] memory m2 = BLSOpen.hashToPoint(domain, abi.encode(0x576f726c64000000000000000000000000000000000000000000000000000000));
        messages.push([m2[0], m2[1]]);
    }

    function testValidateUserOpSignature2() public view {
        bool result = BLSOpen.verifyMultiple(signature, pubkeys, messages);
        assertTrue(result);
    }
}
