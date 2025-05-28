## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

Compile the contracts
```shell
$ forge build
```
Run the tests
```shell
$ forge test
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```


=============
Felipe docs

start anvil
```sh
anvil
```

install project dependencies:
```sh
forge soldeer install
```

Compile contracts
```sh
forge build
```

Simulate Deploy contracts
```sh
forge script script/Counter.s.sol:CounterScript --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

Deploy contracts::
```sh
forge script script/Counter.s.sol:CounterScript --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
```

Deploy with `forge create` (without `forge script`):
```sh
forge create --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 src/RainInsurance.sol:RainInsurance --broadcast
# [⠒] Compiling...
# No files changed, compilation skipped
# Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
# Deployed to: 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707
# Transaction hash: 0x53208d1abc7169a1f7b5b5d5baab1978ef6496e9ef3e3e1401c7e68c45338db4
```

Call test function:
```sh
cast call 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707 "testFunction()(string)" --rpc-url http://localhost:8545
# "Hello, World!"
```