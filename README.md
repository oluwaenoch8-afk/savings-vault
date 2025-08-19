# savings-vault
# 💰 STX Savings Vault

A **decentralized savings app** on Stacks blockchain.  
Users can create personal **STX vaults**, set a **savings goal**, lock their tokens for a chosen time, and only withdraw once the lock expires.

---

## ✨ Features
- 🔒 **Time-Locked Vaults** — funds cannot be withdrawn before unlock.  
- 🎯 **Savings Goals** — every vault has a financial goal (e.g., 500 STX for vacation).  
- 📊 **Track Deposits** — vault balance grows over time.  
- 🏦 **Self-Custody** — no third party can touch user funds.  

---

## 🚀 Why This Project Stands Out
- **Smart Financial Utility**: Shows how STX enables real-world savings behavior.  
- **Unique**: Goes beyond tip jars & voting — focuses on personal finance.  
- **Demo-Ready**: Easy to show → lock STX, attempt early withdraw (fail), unlock, withdraw (success).  
- **Attractive to Judges**: Combines **clarity, usefulness, and transparency**.  

---

## 📖 Example Flow

### 1. Create Vault
```clarity
(contract-call? .savings-vault create-vault u500 u50)
 
