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
- [Workshop]

## Requisitos

- Entender el funcionamiento y los tipos de Stablecoins.
- Entender el funcionamiento de Oracles.
- Entender el funcionamiento de [Chainlink Price Feeds](https://docs.chain.link/data-feeds/getting-started).

## Taller

Primero vamos a instalar Chainlink y los contratos de OpenZeppelin dentro de nuestro proyecto:

```bash
yarn add @chainlink/contracts
yarn add @openzeppelin/contracts
```

Usaremos el contrato StableMint.sol como base para este taller.
