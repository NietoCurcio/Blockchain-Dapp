// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std-1.9.7/Script.sol";
import {ProgrammingCompetition} from "../src/ProgrammingCompetition.sol";
import {AdditionSolution} from "../src/AdditionSolution.sol";

contract DeployAndSetup is Script {
    function run() external {
        ProgrammingCompetition competition = deployCompetition();
        registerAdditionProblem(competition);
        deployAdditionSolution();
    }

    function deployCompetition() internal returns (ProgrammingCompetition) {
        vm.startBroadcast();
        ProgrammingCompetition competition = new ProgrammingCompetition();
        vm.stopBroadcast();
        console.log("ProgrammingCompetition deployed at:", address(competition));
        return competition;
    }

    function registerAdditionProblem(ProgrammingCompetition competition) internal {
        bytes[] memory testCases = new bytes[](3);
        testCases[0] = abi.encode(1, 1);
        testCases[1] = abi.encode(2, 2);
        testCases[2] = abi.encode(5, 7);

        bytes memory allResults = "";
        allResults = abi.encodePacked(allResults, abi.encode(2));
        allResults = abi.encodePacked(allResults, abi.encode(4));
        allResults = abi.encodePacked(allResults, abi.encode(12));
        bytes32 expectedResultsHash = keccak256(allResults);

        string memory title = "Addition Problem";
        string memory description = "Solve the addition of two numbers. The expected results are the sum of the inputs provided in the test cases. The solution function receives a bytes args parameter, which should be decoded as two uints: (uint a, uint b) = abi.decode(args, (uint, uint));";

        vm.startBroadcast();
        competition.registerProblem{value: 100000000 ether}(
            1,
            expectedResultsHash,
            testCases,
            title,
            description
        );
        vm.stopBroadcast();
        console.log("Addition problem registered.");
    }

    function deployAdditionSolution() internal returns (AdditionSolution) {
        uint256 solutionDeployerPrivateKey = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;
        address solutionDeployer = vm.addr(solutionDeployerPrivateKey);
        console.log("Deploying AdditionSolution from:", solutionDeployer);

        vm.startBroadcast(solutionDeployerPrivateKey);
        AdditionSolution solution = new AdditionSolution();
        vm.stopBroadcast();

        console.log("AdditionSolution deployed at:", address(solution));
        return solution;
    }
}
