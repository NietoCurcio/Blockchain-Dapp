# Blockchain Programming Competition DApp

This project is a full-stack decentralized application for hosting and solving programming problems in Blockchain. It includes:

- Smart contracts for problem registration, solution submission, and prize payout (using Foundry)
- A Next.js frontend for interacting with the competition (DApp)

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation.html) (for smart contract development)
- [Node.js](https://nodejs.org/) and npm (for frontend)

---

## Smart Contracts (Foundry)

### 1. Start a local Ethereum node

```sh
anvil --balance 9999999999999999999
```

### 2. Install dependencies

```sh
forge soldeer install
```

### 3. Compile contracts

```sh
forge build
```

### 4. Run tests

```sh
forge test
```

### 5. [Optional] Deploy only the ProgrammingCompetition contract

```sh
forge create --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 src/ProgrammingCompetition.sol:ProgrammingCompetition --broadcast
```

### 6. Deploy all problems and solutions (scripted)

```sh
forge script script/DeployAndSetup.s.sol:DeployAndSetup --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
```

### 7. Useful cast commands

- Check contract balance:
  ```sh
  cast balance 0x5FbDB2315678afecb367f032d93F642f64180aa3 --rpc-url http://localhost:8545
  ```
- Convert wei to ether:
  ```sh
  cast --from-wei 1000000000000000000
  ```
- Withdraw funds (owner only):
  ```sh
  cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "withdraw()()" --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
  ```

---

## Frontend (Next.js)

### 1. Install dependencies

```sh
cd frontend
npm install
```

### 2. Run the development server

```sh
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

---

## Project Structure

- `src/` — Solidity smart contracts
- `script/` — Deployment and setup scripts
- `test/` — Foundry tests
- `frontend/` — Next.js frontend

---

## Resources

- [Foundry Book](https://book.getfoundry.sh/)
- [Next.js Documentation](https://nextjs.org/docs)
