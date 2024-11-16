// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';

/**
 * @title SwiftEasy
 * @dev Parent contract managing cross-chain transactions via Wormhole.
 */
contract SwiftEasy is AxelarExecutable, Ownable {
    struct SwiftEasyMetadata {
        address sender;
        address recipient;
        uint256 amount;
    }

    IAxelarGasService public immutable gasService;

    mapping(uint256 => SwiftEasyMetadata) public ledger;

    event LedgerUpdated(uint256 indexed nonce, SwiftEasyMetadata txn);

    constructor(address _gateway, address _gasReceiver) Ownable(msg.sender) AxelarExecutable(_gateway) {
        gasService = IAxelarGasService(_gasReceiver);
    }

    function _execute(
        bytes32,
        string calldata ,
        string calldata,
        bytes calldata payload
    ) internal override {
        (uint256 txId, uint256 amount, address recipient, address sender) = abi
            .decode(payload, (uint256, uint256, address, address));

        SwiftEasyMetadata memory txn = SwiftEasyMetadata({
            sender: sender,
            recipient: recipient,
            amount: amount
        });

        ledger[txId] = txn;

        emit LedgerUpdated(txId, txn);
    }

    function getTransaction(
        uint256 txId
    ) public view returns (SwiftEasyMetadata memory) {
        SwiftEasyMetadata memory metadata = ledger[txId];
        return metadata;
    }
}
