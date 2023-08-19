## Usage

### Deploy

```shell
forge script script/DeployTokens.s.sol:DeployTokens --rpc-url base_goerli --broadcast --verify
forge script script/DeployFarming.s.sol:DeployFarming --rpc-url base_goerli --broadcast --verify
forge script script/DeployOracle.s.sol:DeployOracle --rpc-url base_goerli --broadcast --verify
forge script script/DeployPool.s.sol:DeployPool --rpc-url base_goerli --broadcast --verify
forge script script/DeployCreditGuard.s.sol:DeployCreditGuard --rpc-url base_goerli --broadcast --verify
```

### Configure and Testing

Next, create a Safe at https://app.safe.global/. Set the CreditGuard as the guard of the Safe using `setGuard` function of the deployed Safe contract.

ABI of `setGuard`:

```
{
        "constant": false,
        "inputs": [
            {
                "internalType": "address",
                "name": "guard",
                "type": "address"
            }
        ],
        "name": "setGuard",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    }
]
```

Next, you can perform a leverage farming strategy using Safe Transaction Builder.

1. Mint some `MockDAI` to the Safe as initial funds
2. Borrow more tokens from `TokenPool`
3. Approve `Farming` to spend tokens
4. Deposit tokens to `Farming`

`CreditGuard` post-transaction check will make sure that the Safe is not over-leveraged after the batch of transactions.

If you try to borrow more funds that causes the health factor to be too low, the transaction will be reverted.

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

```shell
$ forge build
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
$ forge script script/BaseScript.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
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
