#!/bin/bash
# Enhanced protection script for the menu binary
# This script strips debugging symbols and applies additional protection

echo "Enhancing binary protection for display-menu..."

# Check if the binary exists
if [ ! -f "/usr/local/bin/display-menu" ]; then
    echo "Error: The display-menu binary does not exist."
    echo "Please run protect-menu.sh first."
    exit 1
fi

# Make a backup of the original binary
cp /usr/local/bin/display-menu /usr/local/bin/display-menu.backup

# Strip all debugging symbols to make reverse engineering more difficult
echo "Stripping debugging symbols from binary..."
strip --strip-all /usr/local/bin/display-menu

# Add to system startup to ensure it's not tampered with
echo "Setting up system checks..."
cat > /etc/cron.daily/verify-menu << 'EOF'
#!/bin/bash
# Daily verification of menu binary integrity
# This helps ensure the binary hasn't been tampered with

CHECKSUM=$(md5sum /usr/local/bin/display-menu | awk '{print $1}')
STORED_CHECKSUM=$(cat /etc/menu-checksum 2>/dev/null || echo "")

if [ "$STORED_CHECKSUM" == "" ]; then
    # First run, store the checksum
    md5sum /usr/local/bin/display-menu | awk '{print $1}' > /etc/menu-checksum
elif [ "$CHECKSUM" != "$STORED_CHECKSUM" ]; then
    # Checksum mismatch - the binary has been modified
    # Restore from backup
    cp /usr/local/bin/display-menu.backup /usr/local/bin/display-menu
    chmod +x /usr/local/bin/display-menu
    echo "Menu binary tamper detected and fixed on $(date)" >> /var/log/menu-security.log
fi
EOF

chmod +x /etc/cron.daily/verify-menu

# Store initial checksum
md5sum /usr/local/bin/display-menu | awk '{print $1}' > /etc/menu-checksum

echo "Enhanced protection applied to menu binary!"
echo "The binary is now stripped of debugging symbols and protected against tampering."
echo "A daily verification job will restore the original if it's modified." 