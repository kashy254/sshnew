#!/bin/bash
# Banner and visual elements protection script
# This script ensures all banners and visual elements maintain your branding

echo "Starting banner and visual branding protection..."

# Define protected branding details
BRAND_NAME="Emmkash-Tech"
BRAND_CONTACT="0112735877"
BRAND_TELEGRAM="t.me/emmkash"
BRAND_COPYRIGHT="© Emmkash Tech 2023"

# Create a protected issue banner (displayed at login)
echo "Creating protected SSH login banner..."

# Create backup directory
mkdir -p /root/banner-backups

# Backup original if it exists
if [ -f "/etc/issue.net" ]; then
    cp /etc/issue.net /root/banner-backups/issue.net.original
fi

# Create a new issue banner with your protected branding
cat > /etc/issue.net << EOF
<b>════════════════════════════════════════════</b>
             ★ $BRAND_NAME VPS ★
<b>════════════════════════════════════════════</b>
           Premium VPS Solutions
<b>════════════════════════════════════════════</b>

✅ NO SPAM ✅ NO DDOS ✅ NO FRAUD
✅ NO TORRENT ✅ NO HACKING

Contact: $BRAND_TELEGRAM
$BRAND_COPYRIGHT

<b>════════════════════════════════════════════</b>
EOF

# Make sure SSH banner is enabled
if ! grep -q "Banner /etc/issue.net" /etc/ssh/sshd_config; then
    echo "Enabling SSH banner in sshd_config..."
    echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
    systemctl restart sshd
fi

# Create protected MOTD (Message of the Day)
echo "Creating protected MOTD banner..."

# Backup original motd files
mkdir -p /root/banner-backups/motd
if [ -d "/etc/update-motd.d" ]; then
    cp -r /etc/update-motd.d/* /root/banner-backups/motd/
fi

# Create/update MOTD with brand protection
mkdir -p /etc/update-motd.d
cat > /etc/update-motd.d/00-header << EOF
#!/bin/sh
echo ""
echo "\033[1;33m════════════════════════════════════════════\033[0m"
echo "             \033[1;34m★ $BRAND_NAME VPS ★\033[0m"
echo "\033[1;33m════════════════════════════════════════════\033[0m"
echo ""
echo "     \033[1;36mWelcome to \$(hostname) Server\033[0m"
echo ""
echo "\033[1;33m════════════════════════════════════════════\033[0m"
echo ""
EOF

chmod +x /etc/update-motd.d/00-header

cat > /etc/update-motd.d/99-footer << EOF
#!/bin/sh
echo ""
echo "\033[1;33m════════════════════════════════════════════\033[0m"
echo "       \033[1;32mContact Admin: $BRAND_TELEGRAM\033[0m"
echo "       \033[1;32m$BRAND_COPYRIGHT\033[0m"
echo "\033[1;33m════════════════════════════════════════════\033[0m"
echo ""
EOF

chmod +x /etc/update-motd.d/99-footer

# Create a protected version check script
echo "Creating protected version check script..."

cat > /etc/cron.daily/version-check << EOF
#!/bin/bash
# Daily version check with protected branding

BRAND_NAME="$BRAND_NAME"
BRAND_TELEGRAM="$BRAND_TELEGRAM"

CURRENT_VERSION=\$(cat /opt/.ver 2>/dev/null || echo "1.0")
LATEST_VERSION=\$(curl -s https://raw.githubusercontent.com/kashy254/sshnew/master/menu/versi)

if [ "\$LATEST_VERSION" != "\$CURRENT_VERSION" ]; then
    echo "New version available: \$LATEST_VERSION (current: \$CURRENT_VERSION)" >> /var/log/version-check.log
    echo "Contact $BRAND_TELEGRAM for updates" >> /var/log/version-check.log
fi
EOF

chmod +x /etc/cron.daily/version-check

# Create a protection verification script for banners
echo "Creating banner integrity verification script..."

cat > /etc/cron.daily/verify-banners << 'EOF'
#!/bin/bash
# Daily verification of banner integrity
# This ensures banners maintain your protected branding

BRAND_NAME="Emmkash-Tech"
BRAND_CONTACT="0112735877"
BRAND_TELEGRAM="t.me/emmkash"
BRAND_COPYRIGHT="© Emmkash Tech 2023"

# Check issue.net banner
if ! grep -q "$BRAND_NAME" /etc/issue.net; then
    echo "Banner tampered with, restoring from template on $(date)" >> /var/log/menu-security.log
    
    # Restore from template
    cat > /etc/issue.net << EOFB
<b>════════════════════════════════════════════</b>
             ★ $BRAND_NAME VPS ★
<b>════════════════════════════════════════════</b>
           Premium VPS Solutions
<b>════════════════════════════════════════════</b>

✅ NO SPAM ✅ NO DDOS ✅ NO FRAUD
✅ NO TORRENT ✅ NO HACKING

Contact: $BRAND_TELEGRAM
$BRAND_COPYRIGHT

<b>════════════════════════════════════════════</b>
EOFB
fi

# Check MOTD files
if [ -f "/etc/update-motd.d/00-header" ]; then
    if ! grep -q "$BRAND_NAME" /etc/update-motd.d/00-header; then
        echo "MOTD header tampered with, restoring from template on $(date)" >> /var/log/menu-security.log
        
        # Restore from template
        cat > /etc/update-motd.d/00-header << EOFM
#!/bin/sh
echo ""
echo "\033[1;33m════════════════════════════════════════════\033[0m"
echo "             \033[1;34m★ $BRAND_NAME VPS ★\033[0m"
echo "\033[1;33m════════════════════════════════════════════\033[0m"
echo ""
echo "     \033[1;36mWelcome to \$(hostname) Server\033[0m"
echo ""
echo "\033[1;33m════════════════════════════════════════════\033[0m"
echo ""
EOFM
        chmod +x /etc/update-motd.d/00-header
    fi
fi

if [ -f "/etc/update-motd.d/99-footer" ]; then
    if ! grep -q "$BRAND_NAME" /etc/update-motd.d/99-footer; then
        echo "MOTD footer tampered with, restoring from template on $(date)" >> /var/log/menu-security.log
        
        # Restore from template
        cat > /etc/update-motd.d/99-footer << EOFF
#!/bin/sh
echo ""
echo "\033[1;33m════════════════════════════════════════════\033[0m"
echo "       \033[1;32mContact Admin: $BRAND_TELEGRAM\033[0m"
echo "       \033[1;32m$BRAND_COPYRIGHT\033[0m"
echo "\033[1;33m════════════════════════════════════════════\033[0m"
echo ""
EOFF
        chmod +x /etc/update-motd.d/99-footer
    fi
fi
EOF

chmod +x /etc/cron.daily/verify-banners

echo "Running initial verification..."
/etc/cron.daily/verify-banners

echo "Banner protection complete!"
echo "All visual elements now have protected branding that will auto-restore if modified." 