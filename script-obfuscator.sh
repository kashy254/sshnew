#!/bin/bash
# Script obfuscator - Makes scripts unreadable while keeping functionality
# This provides an additional layer of protection for your VPS scripts

echo "Starting script obfuscation system..."

# Create a directory for original scripts
mkdir -p /root/original-scripts

# Create the obfuscation function
obfuscate_script() {
    local input_script="$1"
    local script_name=$(basename "$input_script")
    
    echo "Obfuscating script: $script_name"
    
    # Make backup of the original script
    cp "$input_script" "/root/original-scripts/$script_name.original"
    
    # Base64 encode the script
    ENCODED=$(base64 -w0 "$input_script")
    
    # Create self-decoding script that replaces the original
    cat > "$input_script.temp" << EOF
#!/bin/bash
# Obfuscated script - DO NOT MODIFY
# Protected by Emmkash Tech Obfuscation System
# Attempting to modify this script may break functionality
# Original script stored securely and will be restored if tampered with

eval \$(echo "$ENCODED" | base64 -d)
EOF
    
    # Replace the original with the obfuscated version
    mv "$input_script.temp" "$input_script"
    chmod +x "$input_script"
    
    echo "✓ Obfuscation complete for $script_name"
}

# Create the verification script to check if scripts have been tampered with
create_verification() {
    echo "Creating obfuscation verification system..."
    
    cat > /etc/cron.daily/verify-obfuscation << 'EOF'
#!/bin/bash
# Daily verification of obfuscated scripts
# Ensures scripts haven't been tampered with

ORIG_DIR="/root/original-scripts"
LOG_FILE="/var/log/obfuscation-security.log"

# Create log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi

# Check all obfuscated scripts
for original in "$ORIG_DIR"/*.original; do
    if [ -f "$original" ]; then
        filename=$(basename "$original" .original)
        actual_script=$(find /root -name "$filename" | grep -v "$ORIG_DIR")
        
        # Skip if actual script not found
        if [ -z "$actual_script" ]; then
            continue
        fi
        
        # Check if script is still obfuscated
        if ! grep -q "Obfuscated script - DO NOT MODIFY" "$actual_script"; then
            echo "Script $filename has been modified, restoring on $(date)" >> "$LOG_FILE"
            
            # Re-obfuscate from original
            ENCODED=$(base64 -w0 "$original")
            
            cat > "$actual_script" << INNEREOF
#!/bin/bash
# Obfuscated script - DO NOT MODIFY
# Protected by Emmkash Tech Obfuscation System
# Attempting to modify this script may break functionality
# Original script stored securely and will be restored if tampered with

eval \$(echo "$ENCODED" | base64 -d)
INNEREOF
            
            chmod +x "$actual_script"
        fi
    fi
done
EOF
    
    chmod +x /etc/cron.daily/verify-obfuscation
    echo "✓ Verification system created"
}

# Find and obfuscate primary scripts
obfuscate_primary_scripts() {
    echo "Starting to obfuscate primary scripts..."
    
    # List of scripts to obfuscate
    scripts=(
        "/root/menu/m-sshovpn.sh"
        "/root/menu/m-vmess.sh"
        "/root/menu/m-vless.sh"
        "/root/menu/m-trojan.sh"
        "/root/menu/m-ssws.sh"
        "/root/menu/m-system.sh"
        "/root/menu/running.sh"
        "/root/menu/clearcache.sh"
        "/root/menu/restart.sh"
        "/root/menu/m-domain.sh"
        "/root/menu/m-webmin.sh"
        "/root/menu/m-dns.sh"
        "/root/menu/bw.sh"
        "/root/menu/tcp.sh"
    )
    
    # Obfuscate each script
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            obfuscate_script "$script"
        fi
    done
    
    echo "✓ Primary scripts obfuscation complete"
}

# Main execution
echo "======================================================"
echo "      EMMKASH TECH SCRIPT OBFUSCATION SYSTEM         "
echo "======================================================"
echo "This will make your scripts unreadable while keeping"
echo "full functionality. Obfuscated scripts will be"
echo "automatically restored if tampered with."
echo "======================================================"

obfuscate_primary_scripts
create_verification

echo "======================================================"
echo "      SCRIPT OBFUSCATION SYSTEM COMPLETE             "
echo "======================================================"
echo "All primary scripts have been obfuscated!"
echo "Original scripts are safely stored in /root/original-scripts"
echo "Daily verification will restore scripts if tampered with"
echo "======================================================" 