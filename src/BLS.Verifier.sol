// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

import {BLSOpen} from "../lib/BLSOpen.sol";

contract BLSVerifier {
    function validateAggregatorSignature(uint256[2] memory signature, uint256[4][] memory pubkeys, uint256[2][] memory messages) external view returns (bool) {
        return BLSOpen.verifyMultiple(signature, pubkeys, messages);
    }
}
