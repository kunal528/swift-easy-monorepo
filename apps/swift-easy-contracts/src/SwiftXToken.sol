// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";

/**
 * @title SwiftXToken
 * @dev ERC20 Token with minting and burning capabilities, integrated with Wormhole for cross-chain transfers.
 */
contract SwiftEasyToken is ERC20, AxelarExecutable {
    string public parentContract;
    string public parentChain;
    IAxelarGasService public immutable gasService;

    event CompleteTransaction(
        uint256 indexed amount,
        address indexed account,
        uint256 indexed txId
    );

    constructor(
        string memory name_,
        string memory symbol_,
        string memory _parentContract,
        string memory _parentChain,
        address gateway_,
        address gasReceiver_
    ) ERC20(name_, symbol_) AxelarExecutable(gateway_) {
        gasService = IAxelarGasService(gasReceiver_);
        parentContract = _parentContract;
        parentChain = _parentChain;
    }

    /**
     * @notice Burns tokens from the caller"s account and notifies the parent contract via Wormhole.
     * @param amount Amount of tokens to burn.
     */
    function initTransfer(
        uint256 amount,
        uint256 txId,
        address recipient
    ) public payable {
        require(amount > 0, "Amount must be greater than zero");

        // Encode the payload: (amount, sender)
        bytes memory payload = abi.encode(txId, amount, recipient, msg.sender);

        gasService.payNativeGasForContractCall{ value: msg.value }(
            address(this),
            parentChain,
            parentContract,
            payload,
            msg.sender
        );

        _completeTransfer(txId, amount, recipient);

        gateway().callContract(parentChain, parentContract, payload);
    }

    function _completeTransfer(
        uint256 txId,
        uint256 amount,
        address recipient
    ) internal {
        _mint(address(this), amount);
        emit CompleteTransaction(amount, recipient, txId);
    }

    function confirmTransfer(
        uint256 amount,
        uint256 txId,
        address sender
    ) public payable {
        require(
            balanceOf(address(this)) >= amount,
            "Insufficient balance to burn"
        );

        _burn(address(this), amount);

        bytes memory payload = abi.encode(txId, -1, msg.sender, sender);

        gateway().callContract(parentChain, parentContract, payload);
    }

    /**
     * @notice Allows the owner to update the Parent Contract address.
     * @param _newParent Address of the new Parent Contract.
     */
    function updateParentContract(string memory _newParent) public {
        parentContract = _newParent;
    }

    /**
     * @notice Allows the owner to update the Parent Chain ID.
     * @param _newParentChain The new Parent Chain identifier.
     */
    function updateParentChainId(string memory _newParentChain) public {
        parentChain = _newParentChain;
    }

    function _execute(
        bytes32, /*commandId*/
        string calldata,
        string calldata,
        bytes calldata payload
    ) internal override {
    }
}
