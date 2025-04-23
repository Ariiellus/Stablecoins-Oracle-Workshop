# Stablecoins-Oracle-Workshop

Workshop in Spanish about Stablecoins and Oracles for FruteroClub and UNAM

## Objetivo

En este taller construiremos una Stablecoin sobrecolateralizada utilizando Chainlink Price Feeds, aprendiendo los conceptos fundamentales detrás de su funcionamiento en DeFi.

## ¿Qué vas a aprender?

- Cómo funcionan las stablecoins y sus diferentes tipos.
- Qué es un oráculo y por qué son esenciales para contratos inteligentes.
- Cómo integrar oráculos de Chainlink para obtener precios del mundo real.
- Implementar un contrato inteligente que emita una stablecoin respaldada por colateral cripto (como WETH).

## Material

- [Slides](https://www.canva.com/design/DAGkzobRn0Y/dhJOSMOm1-Ip13JultiN7g/edit?utm_content=DAGkzobRn0Y&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)
- [Workshop](https://www.youtube.com/watch?v=UDdoyYURNz0)

Dentro del contracto SamplePriceFeed.sol encontraremos un ejemplo de cómo utilizar los Data Feeds de Chainlink para obtener el último precio de BTC y ETH en USD.

## Requisitos

- Entender el funcionamiento y los tipos de Stablecoins.
- Entender el funcionamiento de Oracles.
- Entender el funcionamiento de [Chainlink Price Feeds](https://docs.chain.link/data-feeds/getting-started).

## Taller

### Instalación

Primero vamos a instalar Chainlink y los contratos de OpenZeppelin dentro de nuestro proyecto:

```bash
yarn add @chainlink/contracts
yarn add @openzeppelin/contracts
```

### Mint Stablecoin Contract

**Contrato:** 0x657295981f2bac074d1144251b41276018292655 ([ver en Etherscan](https://sepolia.etherscan.io/address/0x657295981f2bac074d1144251b41276018292655))

[Ver workshop en línea](https://www.youtube.com/watch?v=UDdoyYURNz0)
