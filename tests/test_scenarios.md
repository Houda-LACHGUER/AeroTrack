# AeroTrack - Test Scenarios

## Test Environment
- **Platform:** Remix IDE (Remix VM)
- **Compiler Version:** Solidity 0.8.19
- **Test Accounts:** 10 fake accounts with 100 ETH each

---

## Test 1: Manufacture a Part ✅
**Account Used:** Account 1 (Manufacturer)

**Function Called:** `manufacturePart`

**Inputs:**
- `_serialNumber`: 999
- `_partName`: "Boeing 737 Landing Gear"

**Expected Result:** Green checkmark + `PartManufactured` event emitted

**Actual Result:** ✅ Passed — part registered on the blockchain

---

## Test 2: Verify State ✅
**Account Used:** Account 1

**Function Called:** `parts` (read)

**Input:** `999`

**Expected Result:** Struct returned with correct data

**Actual Result:** ✅ Passed — confirmed:
- `currentOwner` = Account 1 address
- `status` = 0 (Manufactured)
- `exists` = true

---

## Test 3: Unauthorized Transfer (Hacking Attempt) ✅
**Account Used:** Account 3 (Hacker)

**Function Called:** `transferPart`

**Inputs:**
- `_serialNumber`: 999
- `_newOwner`: Account 3 address

**Expected Result:** Transaction reverts with error message

**Actual Result:** ✅ Passed — transaction failed with:
> "Not the owner."

**Conclusion:** The `onlyPartOwner` modifier successfully blocked the unauthorized transfer

---

## Test 4: Legitimate Ownership Transfer ✅
**Account Used:** Account 1 (Manufacturer → transfers to Account 2)

**Function Called:** `transferPart`

**Inputs:**
- `_serialNumber`: 999
- `_newOwner`: Account 2 address

**Expected Result:** Green checkmark + `OwnershipTransferred` event emitted

**Actual Result:** ✅ Passed — confirmed:
- `currentOwner` updated to Account 2 address
- `status` = 1 (InTransit)

---

## Test 5: Log Maintenance ✅
**Account Used:** Account 2 (Airline)

**Function Called:** `logMaintenance`

**Inputs:**
- `_serialNumber`: 999
- `_report`: "10,000 hour inspection passed. No fatigue detected."

**Expected Result:** Green checkmark + `MaintenanceLogged` event emitted

**Actual Result:** ✅ Passed — confirmed:
- `MaintenanceLogged` event visible in terminal logs
- `status` = 2 (Installed)

---

## Summary

| Test | Function | Account | Result |
|------|----------|---------|--------|
| 1 | `manufacturePart` | Account 1 | ✅ Pass |
| 2 | `parts` (read) | Account 1 | ✅ Pass |
| 3 | `transferPart` (hack) | Account 3 | ✅ Blocked |
| 4 | `transferPart` (legit) | Account 1 | ✅ Pass |
| 5 | `logMaintenance` | Account 2 | ✅ Pass |
