// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std-1.9.7/console.sol";

contract RainInsurance {
    address public owner;

    struct RainRecord {
        uint256 timestamp;
        string location;
        uint256 rainfallMM;
    }

    struct Policy {
        address farmer;
        string location;
        uint256 startTime;
        uint256 endTime;
        uint256 minRainfallThreshold;
        uint256 maxRainfallThreshold;
        uint256 premium;
        uint256 payout;
        bool claimed;
    }

    struct InsuranceProduct {
        string location;
        uint256 minRainfallThreshold;
        uint256 maxRainfallThreshold;
        uint256 premiumMultiplier; // For pricing calculation
        bool active;
    }

    uint256 public rainRecordCount = 0;
    uint256 public policyCount = 0;
    uint256 public productCount = 0;

    mapping(uint256 => RainRecord) public rainRecords;
    mapping(uint256 => Policy) public policies;
    mapping(uint256 => InsuranceProduct) public insuranceProducts;

    event RainDataSubmitted(
        uint256 indexed id,
        string location,
        uint256 rainfall,
        uint256 timestamp
    );
    event PolicyCreated(uint256 indexed id, address indexed farmer);
    event PolicyClaimed(
        uint256 indexed id,
        address indexed farmer,
        uint256 payout
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function testFunction() external pure returns (string memory) {
        console.log("Test function called");
        return "Hello, World!";
    }

    function submitRainData(
        string memory _location,
        uint256 _rainfallMM
    ) external onlyOwner {
        rainRecordCount++;
        rainRecords[rainRecordCount] = RainRecord({
            timestamp: block.timestamp,
            location: _location,
            rainfallMM: _rainfallMM
        });

        emit RainDataSubmitted(
            rainRecordCount,
            _location,
            _rainfallMM,
            block.timestamp
        );
    }

    function createInsuranceProduct(
        string memory _location,
        uint256 _minRainfallThreshold,
        uint256 _maxRainfallThreshold,
        uint256 _premiumMultiplier
    ) external onlyOwner {
        require(
            _minRainfallThreshold <= _maxRainfallThreshold,
            "Invalid rainfall thresholds"
        );

        productCount++;
        insuranceProducts[productCount] = InsuranceProduct({
            location: _location,
            minRainfallThreshold: _minRainfallThreshold,
            maxRainfallThreshold: _maxRainfallThreshold,
            premiumMultiplier: _premiumMultiplier,
            active: true
        });
    }

    function createPolicy(
        uint256 _productId,
        uint256 _startTime,
        uint256 _endTime
    ) external payable {
        InsuranceProduct storage product = insuranceProducts[_productId];
        require(product.active, "Product not available");
        require(_startTime < _endTime, "Invalid time window");
        require(
            _startTime >= block.timestamp,
            "Start time must be in the future"
        );
        require(_endTime <= _startTime + 7 days, "Policy duration too long");
        require(msg.value > 0, "Must pay premium");

        policyCount++;
        policies[policyCount] = Policy({
            farmer: msg.sender,
            location: product.location,
            startTime: _startTime,
            endTime: _endTime,
            minRainfallThreshold: product.minRainfallThreshold,
            maxRainfallThreshold: product.maxRainfallThreshold,
            premium: msg.value,
            payout: msg.value * product.premiumMultiplier,
            claimed: false
        });

        emit PolicyCreated(policyCount, msg.sender);
    }

    function claimPolicy(uint256 _policyId) external {
        Policy storage policy = policies[_policyId];
        require(policy.farmer == msg.sender, "Not policy owner");
        require(!policy.claimed, "Already claimed");
        require(block.timestamp > policy.endTime, "Policy not ended");

        uint256 totalRainfall = getTotalRainfall(
            policy.location,
            policy.startTime,
            policy.endTime
        );

        if (
            totalRainfall >= policy.minRainfallThreshold &&
            totalRainfall <= policy.maxRainfallThreshold
        ) revert("Conditions not met");

        policy.claimed = true;
        payable(policy.farmer).transfer(policy.payout);
        emit PolicyClaimed(_policyId, policy.farmer, policy.payout);
    }

    function getTotalRainfall(
        string memory _location,
        uint256 _startTime,
        uint256 _endTime
    ) public view returns (uint256 total) {
        for (uint256 i = 1; i <= rainRecordCount; i++) {
            RainRecord storage record = rainRecords[i];
            if (
                keccak256(abi.encodePacked(record.location)) ==
                keccak256(abi.encodePacked(_location)) &&
                record.timestamp >= _startTime &&
                record.timestamp <= _endTime
            ) {
                total += record.rainfallMM;
            }
        }
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}
