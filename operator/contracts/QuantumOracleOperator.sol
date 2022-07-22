// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@chainlink/Operator.sol";

contract QuantumOracleOperator is Operator {
    constructor(address link) Operator(link, msg.sender){}
}
