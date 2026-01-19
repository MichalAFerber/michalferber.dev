---
layout: default
title: "YubiKey Manager"
parent: "Dev Hub"
---

# YubiKey Manager

{: .highlight }
> **Yubico** announced that the **YubiKey Manager GUI (ykman GUI)** will reach **End of Life (EOL) in February 2026**.

That means:

- The GUI app (the one with the visual interface) won’t be updated after that date.
- But the **YubiKey Manager CLI (`ykman`)** will remain fully supported and is the main tool Yubico wants people to use going forward.
- The **Yubico Authenticator** app (for OTP/TOTP codes) is not affected.

🔑 For your PIN situation:

- You’ll want to use the **CLI version** (`ykman`) now instead of relying on the GUI.  
- On macOS, you can install it with **Homebrew**:  

```bash
brew install ykman
```

- Then, you can manage your PIV application, check the PIN/PUK attempts left, and reset if needed. For example:

```bash
ykman piv info
ykman piv change-pin
ykman piv reset   # ⚠️ only if you’ve lost the PIN/PUK and are okay wiping certificates
```

So even though the GUI is going away, you’ll still have full control over your PIN via the CLI.

---
### My YubiKey 5C NFC
```
michal@Mac-mini-Desktop ~ % ykman piv info
PIV version:              5.4.3
PIN tries remaining:      3/3
PUK tries remaining:      3/3
Management key algorithm: TDES
WARNING: Using default PIN!
WARNING: Using default PUK!
WARNING: Using default Management key!
CHUID: 3019d4e739da739ced39ce739d836858210842108421c84210c3eb3410517f4345c45fe50a3a57106841e3abe0350832303330303130313e00fe00
CCC:   No data available
Slot 9A (AUTHENTICATION):
  Private key type: ECCP256
  Public key type:  ECCP256
  Subject DN:       CN=Yubico PIV Authentication
  Issuer DN:        CN=Yubico PIV Authentication
  Serial:           14:c9:0a:e3:26:cf:45:9a:9c:99:3b:6f:8a:b3:f3:99:0a:8c:30:d0
  Fingerprint:      e0cccffcb6c418eb6e9fc3aa38916cb8979bc2ad544b2e0b96111a668a8bf25a
  Not before:       2025-09-07T08:03:29+00:00
  Not after:        2055-09-07T00:00:00+00:00

Slot 9D (KEY_MANAGEMENT):
  Private key type: ECCP256
  Public key type:  ECCP256
  Subject DN:       CN=Yubico PIV Authentication
  Issuer DN:        CN=Yubico PIV Authentication
  Serial:           59:b6:22:a0:82:46:54:33:e4:2e:8a:28:d0:1d:81:7a:14:07:f2:fb
  Fingerprint:      8cf402983bc4050ea0bc187f30e1151cec09972adf0eeacd0f3073e462dd371b
  Not before:       2025-09-07T08:03:29+00:00
  Not after:        2055-09-07T00:00:00+00:00
```