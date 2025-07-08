// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ISolution {
    function solution(bytes calldata args) external pure returns (bytes memory);
}