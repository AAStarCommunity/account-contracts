// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

import {BLSOpen} from "../lib/BLSOpen.sol";

contract BLSVerifier {
    uint256[4] private publicKey;
    address private owner;

    constructor(address owner_) {
        if (owner_ == address(0)) {
            revert("invalid owner");
        }
        owner = owner_;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function validateUserOpSignature(uint256[2] memory message, uint256[2] memory signature)
        external
        view
        returns (bool)
    {
        return BLSOpen.verifySingle(signature, publicKey, message);
    }

    function initialize(address owner_, uint256[4] memory aPublicKey) external onlyOwner {
        owner = owner_;
        publicKey = aPublicKey;
    }

    function setBlsPublicKey(uint256[4] memory newPublicKey) public onlyOwner {
        publicKey = newPublicKey;
    }

    function getPublicKey() public view returns (uint256[4] memory) {
        return publicKey;
    }
}
