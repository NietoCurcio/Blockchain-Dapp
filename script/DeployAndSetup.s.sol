// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std-1.9.7/Script.sol";
import {ProgrammingCompetition} from "../src/ProgrammingCompetition.sol";
import {AdditionSolution} from "../src/AdditionSolution.sol";
import {MaxValueSolution} from "../src/MaxValueSolution.sol";

contract DeployAndSetup is Script {
    function run() external {
        ProgrammingCompetition competition = deployCompetition();
        registerAdditionProblem(competition);
        registerMaxValueProblem(competition);
        deployAdditionSolution();
        deployMaxValueSolution();
    }

    function registerMaxValueProblem(ProgrammingCompetition competition) internal {

        bytes[] memory testCases = new bytes[](3);
        uint[] memory arr1 = new uint[](5);
        arr1[0] = 3;
        arr1[1] = 1;
        arr1[2] = 2;
        arr1[3] = 0;
        arr1[4] = 5;

        uint[] memory arr2 = new uint[](6);
        arr2[0] = 10;
        arr2[1] = 2;
        arr2[2] = 7;
        arr2[3] = 4;
        arr2[4] = 80;
        arr2[5] = 1;

        uint[] memory arr3 = new uint[](10);
        arr3[0] = 42;
        arr3[1] = 13;
        arr3[2] = 7;
        arr3[3] = 0;
        arr3[4] = 50;
        arr3[5] = 8;
        arr3[6] = 2;
        arr3[7] = 9;
        arr3[8] = 6;
        arr3[9] = 3;

        testCases[0] = abi.encode(arr1);
        testCases[1] = abi.encode(arr2);
        testCases[2] = abi.encode(arr3);

        bytes memory allResults = "";
        allResults = abi.encodePacked(allResults, abi.encode(5));
        allResults = abi.encodePacked(allResults, abi.encode(80));
        allResults = abi.encodePacked(allResults, abi.encode(50));
        bytes32 expectedResultsHash = keccak256(allResults);

        string memory title = "Find Maximum";
        string memory description = "Find the maximum value in an array. The solution function receives a bytes args parameter, which should be decoded as a uint[]: uint[] memory arr = abi.decode(args, (uint[])); Return the maximum value in the array.";

        vm.startBroadcast();
        competition.registerProblem{value: 100000000 ether}(
            2,
            expectedResultsHash,
            testCases,
            title,
            description
        );
        vm.stopBroadcast();
        console.log("Max value problem registered.");
    }
    function deployMaxValueSolution() internal returns (MaxValueSolution) {
        uint256 solutionDeployerPrivateKey = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;
        address solutionDeployer = vm.addr(solutionDeployerPrivateKey);
        console.log("Deploying MaxValueSolution from:", solutionDeployer);

        vm.startBroadcast(solutionDeployerPrivateKey);
        MaxValueSolution solution = new MaxValueSolution();
        vm.stopBroadcast();

        console.log("MaxValueSolution deployed at:", address(solution));
        return solution;
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
