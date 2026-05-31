# ✈️ AeroTrack — Airplane Spare Parts Provenance on Ethereum

## 📋 Overview
AeroTrack is an Ethereum smart contract built with Solidity that secures
the lifecycle tracking of airplane spare parts on the blockchain.
It eliminates the risk of counterfeit parts and data manipulation
by creating an immutable, transparent, and decentralized registry.

This project was developed as part of the Industrial Blockchain Laboratory,
applying core Solidity concepts to a real-world aviation safety problem.

---

## 🎯 Objectives
- Track airplane spare parts from manufacturing to retirement
- Prevent unauthorized ownership transfers using Role-Based Access Control
- Log maintenance reports permanently and cheaply using Events
- Eliminate single points of failure in aviation supply chain data

---

## 🏗️ Contract Architecture

### Enum — `PartStatus`
Tracks the physical state of each part:
| Value | Status | Meaning |
|-------|--------|---------|
| 0 | `Manufactured` | Freshly created by manufacturer |
| 1 | `InTransit` | Being transferred to new owner |
| 2 | `Installed` | Active on aircraft after maintenance |
| 3 | `Retired` | Permanently decommissioned |

### Struct — `Part`
| Field | Type | Description |
|-------|------|-------------|
| `serialNumber` | uint256 | Unique identifier |
| `partName` | string | Description of the part |
| `manufacturer` | address | Address of the creator |
| `currentOwner` | address | Address of current owner |
| `status` | PartStatus | Current lifecycle state |
| `exists` | bool | Security flag against empty mappings |

### Modifiers — Access Control
| Modifier | Protection |
|----------|------------|
| `partExists` | Prevents interaction with unregistered parts |
| `onlyPartOwner` | Ensures only the owner can modify a part |

### Functions
| Function | Access | Description |
|----------|--------|-------------|
| `manufacturePart` | Public | Registers a new part |
| `transferPart` | Owner only | Transfers ownership |
| `logMaintenance` | Owner only | Logs a maintenance report |

### Events
| Event | Trigger |
|-------|---------|
| `PartManufactured` | New part registered |
| `OwnershipTransferred` | Part changes hands |
| `MaintenanceLogged` | Maintenance report submitted |

---

## 🚀 How to Run

### Requirements
- Browser with internet access
- No installation needed

### Steps
1. Open [Remix IDE](https://remix.ethereum.org)
2. Create a new file named `AeroTrack.sol`
3. Paste the contract from `contracts/AeroTrack.sol`
4. Go to **Solidity Compiler** → select `0.8.19` → click **Compile**
5. Go to **Deploy & Run** → select **Remix VM** → click **Deploy**
6. Run the test scenarios from `tests/test_scenarios.md`

---

## 🧪 Test Results
All 5 test scenarios passed successfully.
See [`tests/test_scenarios.md`](tests/test_scenarios.md) for full details.

---

## 🔐 Security Features
- **Immutability:** Once written, part data cannot be altered without a transaction
- **Access Control:** Modifiers enforce ownership before any state change
- **Cryptographic Verification:** `msg.sender` is verified against stored owner address
- **Collision Prevention:** `exists` flag prevents serial number duplication

---

## 🛠️ Built With
- [Solidity](https://soliditylang.org/) `^0.8.19`
- [Ethereum](https://ethereum.org/) Smart Contracts
- [Remix IDE](https://remix.ethereum.org/) — Development & Testing

---

## 📄 License
MIT
