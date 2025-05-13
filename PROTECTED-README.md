# Menu Protection System for Emmkash Tech VPS Script

This protection system secures your VPS script's menu system, ensuring your branding remains intact even when the script is publicly available on GitHub.

## Protection Features

1. **Binary Conversion**: 
   - Core menu display functionality is compiled into a binary executable
   - Your name "Emmkash Tech" is hardcoded in the binary, not in shell scripts
   - Binary format makes it much harder to modify than shell scripts

2. **Symbol Stripping**:
   - Debugging symbols are removed from the binary
   - Makes reverse engineering more difficult

3. **Integrity Verification**:
   - Daily integrity check via cron job
   - Automatically restores original binary if tampering is detected
   - Keeps logs of any detected tampering attempts

## How It Works

1. The `binary-menu.c` file contains the C code for the menu display
2. This is compiled into `/usr/local/bin/display-menu` binary executable
3. The original menu script is replaced with a thin wrapper that calls this binary
4. System links ensure all menu calls go through the protected binary

## Files in This System

- `binary-menu.c`: C source code for the menu display
- `protect-menu.sh`: Script to compile and set up the initial protection
- `enhance-protection.sh`: Script to add additional protection measures
- `/usr/local/bin/display-menu`: The compiled binary (after running the scripts)
- `/etc/cron.daily/verify-menu`: Daily integrity check script

## Installation

1. Run the protection setup:
   ```bash
   chmod +x protect-menu.sh
   ./protect-menu.sh
   ```

2. Apply enhanced protection:
   ```bash
   chmod +x enhance-protection.sh
   ./enhance-protection.sh
   ```

## Notes

- This protection system makes it much harder for someone to modify your branding
- The binary approach keeps your name securely embedded in the executable
- While no protection is 100% foolproof, this significantly raises the barrier
- The integrity checking system adds an additional layer of protection

Created by Emmkash Tech 