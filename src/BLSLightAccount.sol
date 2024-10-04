// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

import {BLSOpen} from  "./BLSOpen.sol";

contract BLSLightAccount {

    uint256[4] private publicKey;
    address private owner;
    
    function validateUserOpSignature(uint256[] message, uint256[2] signature)
    external view returns (bool)  {
        return BLSOpen.verifySingle(signature, publicKey, message);
    }

    function initialize(address owner_, uint256[4] memory aPublicKey) external {
        if (owner_ == address(0)) {
            revert InvalidOwner(address(0));
        }
        owner = owner_;
        publicKey = aPublicKey;
    }

    function setBlsPublicKey(uint256[4] memory newPublicKey) public {
        publicKey = newPublicKey;
    }
}
