// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

//the key components of this new BLSLightAccount contract:
// We inherit from LightAccount to maintain all original functionality.
// We introduce a new storage struct BLSAccountStorage to store the BLS public key.
// We override the initialize function to include setting the BLS public key.
// We add a setBlsPublicKey function to allow updating the BLS public key.
// We override the _validateSignature function to handle BLS signatures.
// We introduce a placeholder _validateBLSSignature function that needs to be implemented.

// TODO: Implement the BLS signature validation logic in _validateBLSSignature.
// Done: Update the SignatureType enum in BaseLightAccount to include the BLS type.
// Possibly integrate with a BLS library for the necessary cryptographic operations.

import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {LightAccount} from "../lib/light-account/src/LightAccount.sol";
import {IEntryPoint} from "../lib/light-account/lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {PackedUserOperation} from "../lib/light-account/lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

/// @title A LightAccount with added BLS signature support
/// @dev Extends LightAccount to support BLS signatures for user operations
contract BLSLightAccount is LightAccount {
    // BLS-specific storage
    struct BLSAccountStorage {
        bytes32 blsPublicKey;
    }

    /// @dev keccak256(abi.encode(uint256(keccak256("bls_light_account_v1.storage")) - 1)) & ~bytes32(uint256(0xff));
    bytes32 private constant _BLS_STORAGE_POSITION = 0x3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e00;

    event BLSPublicKeySet(bytes32 indexed blsPublicKey);

    error InvalidBLSSignature();

    constructor(IEntryPoint entryPoint_) LightAccount(entryPoint_) {}

    /// @notice Initializes the BLSLightAccount with an owner and a BLS public key
    /// @param owner_ The initial owner of the account
    /// @param blsPublicKey_ The BLS public key for this account
    function initialize(address owner_, bytes32 blsPublicKey_) external initializer {
        super._initialize(owner_);
        _setBlsPublicKey(blsPublicKey_);
    }

    /// @notice Sets or updates the BLS public key for this account
    /// @param blsPublicKey_ The new BLS public key
    function setBlsPublicKey(bytes32 blsPublicKey_) external onlyAuthorized {
        _setBlsPublicKey(blsPublicKey_);
    }

    /// @notice Returns the current BLS public key for this account
    function blsPublicKey() public view returns (bytes32) {
        return _getBLSStorage().blsPublicKey;
    }

    /// @dev Overrides the _validateSignature function to support BLS signatures
    function _validateSignature(PackedUserOperation calldata userOp, bytes32 userOpHash)
        internal
        virtual
        override
        returns (uint256 validationData)
    {
        // if (userOp.signature.length >= 1) {
        //     uint8 signatureType = uint8(userOp.signature[0]);
        //     if (signatureType == uint8(SignatureType.BLS)) {
        //         // BLS signature validation
        //         return _validateBLSSignature(userOp, userOpHash);
        //     }
        // }
        // If not a BLS signature, fall back to the original validation
        return super._validateSignature(userOp, userOpHash);
    }

    /// @dev Validates a BLS signature
    function _validateBLSSignature(PackedUserOperation calldata userOp, bytes32 userOpHash)
        internal
        view
        returns (uint256)
    {
        if (userOp.signature.length < 1) {
            revert InvalidSignatureType();
        }
        uint8 signatureType = uint8(userOp.signature[0]);
        if (signatureType == uint8(SignatureType.EOA)) {
            // EOA signature
            bytes32 signedHash = MessageHashUtils.toEthSignedMessageHash(userOpHash);
            bytes memory signature = userOp.signature[1:];
            return _successToValidationData(_isValidEOAOwnerSignature(signedHash, signature));
        } else if (signatureType == uint8(SignatureType.CONTRACT)) {
            // Contract signature without address
            bytes memory signature = userOp.signature[1:];
            return _successToValidationData(_isValidContractOwnerSignatureNow(userOpHash, signature));
        }
        revert InvalidSignatureType();
    }

    function _setBlsPublicKey(bytes32 blsPublicKey_) internal {
        _getBLSStorage().blsPublicKey = blsPublicKey_;
        emit BLSPublicKeySet(blsPublicKey_);
    }

    function _getBLSStorage() internal pure returns (BLSAccountStorage storage blsStorageStruct) {
        bytes32 position = _BLS_STORAGE_POSITION;
        assembly ("memory-safe") {
            blsStorageStruct.slot := position
        }
    }
}