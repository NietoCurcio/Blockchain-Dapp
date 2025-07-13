// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ISolution} from "./interfaces/ISolution.sol";
import "../dependencies/forge-std-1.9.7/src/console.sol";
import "./ProgrammingCompetition.sol";

// The input is a binary tree encoded as an array of (int, left, right) tuples, where left/right are indices or -1 for null.
// The output should be an array of ints representing the postorder traversal.
contract PostOrderSolution is ISolution {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // The input is a binary tree encoded as an array of (int, left, right) tuples, where left/right are indices or -1 for null.
    // The output should be an array of ints representing the postorder traversal.
    function solution(bytes calldata args) external pure override returns (bytes memory) {
        (int256[3][] memory nodes) = abi.decode(args, (int256[3][]));
        int256[] memory result = new int256[](nodes.length);
        uint256 idx = 0;
        idx = _postOrder(nodes, 0, result, idx);
        // Resize result to actual length
        int256[] memory trimmed = new int256[](idx);
        for (uint256 i = 0; i < idx; i++) {
            trimmed[i] = result[i];
        }
        return abi.encode(trimmed);
    }

    function _postOrder(int256[3][] memory nodes, int256 nodeIdx, int256[] memory result, uint256 idx) internal pure returns (uint256) {
        if (nodeIdx == -1) return idx;
        int256 left = nodes[uint256(nodeIdx)][1];
        int256 right = nodes[uint256(nodeIdx)][2];
        idx = _postOrder(nodes, left, result, idx);
        idx = _postOrder(nodes, right, result, idx);
        result[idx] = nodes[uint256(nodeIdx)][0];
        return idx + 1;
    }

    function submitSolution() external {
        address competitionAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
        ProgrammingCompetition competition = ProgrammingCompetition(payable(competitionAddress));
        uint problemId = 3;
        address mySolutionContract = address(this);
        competition.evaluateSolution(problemId, mySolutionContract);
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}
