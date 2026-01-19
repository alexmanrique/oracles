## Chainlink and Pyth Oracles (Foundry)

Example project with contracts that consume Chainlink and Pyth oracles, including basic versions and versions with safety validations.

## Contracts

- `src/ChainlinkOracle.sol`: simple wrapper over a single Chainlink feed. Exposes `getLatestPrice()` and `getRoundData()`.
- `src/ChainLinlOracleChecks.sol`: `SecureChainlinkOracle` with validations. Uses primary and secondary feeds, checks positive price, valid timestamp, and configurable staleness threshold.
- `src/PythOracle.sol`: basic Pyth integration. Allows price updates with `updatePrice()` and reads via `getPriceUnsafe()`.
- `src/PythOracleChecks.sol`: hardened version that updates prices and uses `getPriceNoOlderThan()` with an age limit, plus price, expo, and confidence ratio checks.

## Tests

- `test/ChainlinkOracleCheckTest.t.sol`: tests for `SecureChainlinkOracle` with fallback and staleness scenarios.

## Structure

```
src/
  ChainlinkOracle.sol
  ChainLinlOracleChecks.sol
  PythOracle.sol
  PythOracleChecks.sol
test/
  ChainlinkOracleCheckTest.t.sol
```

## Usage

```shell
forge build
forge test
forge fmt
```

## Deployment notes

- Chainlink: requires feed addresses per network (e.g., ETH/USD on Sepolia or Mainnet).
- Pyth: requires the Pyth contract on the network and the feed `priceId`; updates require off-chain `updateData` and enough `msg.value` to cover the fee.

## Documentation

Foundry: https://book.getfoundry.sh/
