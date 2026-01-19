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

## Coverage

```
╭-------------------------------+-----------------+-----------------+----------------+----------------╮
| File                          | % Lines         | % Statements    | % Branches     | % Funcs        |
+=====================================================================================================+
| src/ChainLinlOracleChecks.sol | 93.10% (27/29)  | 96.15% (25/26)  | 63.64% (14/22) | 75.00% (3/4)   |
|-------------------------------+-----------------+-----------------+----------------+----------------|
| src/ChainlinkOracle.sol       | 100.00% (7/7)   | 100.00% (6/6)   | 100.00% (0/0)  | 100.00% (3/3)  |
|-------------------------------+-----------------+-----------------+----------------+----------------|
| src/PythOracle.sol            | 100.00% (10/10) | 100.00% (9/9)   | 50.00% (1/2)   | 100.00% (3/3)  |
|-------------------------------+-----------------+-----------------+----------------+----------------|
| src/PythOracleChecks.sol      | 100.00% (18/18) | 100.00% (16/16) | 62.50% (5/8)   | 100.00% (5/5)  |
|-------------------------------+-----------------+-----------------+----------------+----------------|
| Total                         | 96.88% (62/64)  | 98.25% (56/57)  | 62.50% (20/32) | 93.33% (14/15) |
```

## Deployment notes

- Chainlink: requires feed addresses per network (e.g., ETH/USD on Sepolia or Mainnet).
- Pyth: requires the Pyth contract on the network and the feed `priceId`; updates require off-chain `updateData` and enough `msg.value` to cover the fee.

## Documentation

Foundry: https://book.getfoundry.sh/
