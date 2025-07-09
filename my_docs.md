# My docs

1. Start anvil:

```sh
anvil
```

2. Compile the contracts:

```sh
forge build
```

3. Run the tests:

```sh
forge test
```

4. Deploy the `ProgrammingCompetition.sol` contract, using the first account:

```sh
forge create --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 src/ProgrammingCompetition.sol:ProgrammingCompetition --broadcast

# Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
# Deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3
# Transaction hash: 0x7b6701e4a540faac9dde27f1b53590374d5882628a93e9068390bcc7a68561b3
```

anvil --balance 9999999999999999999

forge script script/DeployAndSetup.s.sol:DeployAndSetup --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast

deploy CP.sol:

forge create --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 src/ProgrammingCompetition.sol:ProgrammingCompetition --broadcast

deploy AdditionSolution.sol:

forge create --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 src/AdditionSolution.sol:AdditionSolution --broadcast

##### cast bizus

Balance of ProgrammingCompetition contract:

```sh
cast balance 0x5FbDB2315678afecb367f032d93F642f64180aa3 --rpc-url http://localhost:8545
```

Converting wei to ethers:

```sh
cast --from-wei 1000000000000000000
```

Withdraw funds from ProgrammingCompetition contract to owner:

```sh
cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "withdraw()()" --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "number()(uint)" --rpc-url http://localhost:8545

cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "increment()()" --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

deploy CP.sol:

################### TODO

1. anvil --balance 9999999999999999999

forge test -vvv

forge script script/DeployAndSetup.s.sol:DeployAndSetup --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
