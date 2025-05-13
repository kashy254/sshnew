#!/bin/bash
# Submenu protection script
# Protects all submenu scripts to ensure branding is consistent

echo "Starting comprehensive submenu branding protection..."

# Define protected branding details (same as in the binary)
BRAND_NAME="Emmkash-Tech"
BRAND_CONTACT="0112735877"
BRAND_TELEGRAM="t.me/emmkash"
BRAND_COPYRIGHT="© Emmkash Tech 2023"

# Search for all menu script files
MENU_PATH="/root/menu"
echo "Scanning for menu scripts in $MENU_PATH..."

# Create backup directory
mkdir -p $MENU_PATH/original-backups

# Function to add protected header and footer to scripts
add_protection() {
    local file=$1
    local basename=$(basename "$file")
    
    echo "Protecting $basename..."
    
    # Make backup if not already done
    if [ ! -f "$MENU_PATH/original-backups/$basename" ]; then
        cp "$file" "$MENU_PATH/original-backups/$basename"
    fi
    
    # Create temporary file with protected header
    cat > /tmp/header.txt << EOF
#!/bin/bash
# Protected submenu - DO NOT MODIFY
# Automatically restores if tampered with
# =====================================================
#                $BRAND_NAME SCRIPT                  
# =====================================================

EOF

    # Create temporary file with protected footer
    cat > /tmp/footer.txt << EOF

# =====================================================
# SCRIPT BY $BRAND_NAME ($BRAND_CONTACT)
# Contact: $BRAND_TELEGRAM
# $BRAND_COPYRIGHT
# =====================================================
EOF

    # Check if file already has protection header
    if grep -q "Protected submenu - DO NOT MODIFY" "$file"; then
        echo "  Already protected, skipping..."
    else
        # Add header and footer
        cat /tmp/header.txt > /tmp/protected_file
        cat "$file" >> /tmp/protected_file
        cat /tmp/footer.txt >> /tmp/protected_file
        
        # Replace original with protected version
        mv /tmp/protected_file "$file"
        chmod +x "$file"
        echo "  Protected successfully!"
    fi
}

# Find all menu script files and protect them
find $MENU_PATH -name "*.sh" | while read file; do
    add_protection "$file"
done

# Create validation script to ensure submenus aren't tampered with
echo "Creating submenu integrity checker..."

cat > /etc/cron.daily/verify-submenus << 'EOF'
#!/bin/bash
# Daily verification of submenu scripts integrity
# This helps ensure the scripts haven't been tampered with

MENU_PATH="/root/menu"
ORIGINAL_BACKUPS="$MENU_PATH/original-backups"

# Create log file if it doesn't exist
if [ ! -f "/var/log/menu-security.log" ]; then
    touch /var/log/menu-security.log
fi

# Verify each submenu file
find $MENU_PATH -name "*.sh" | while read file; do
    basename=$(basename "$file")
    
    # Skip if it's a new file without backup
    if [ ! -f "$ORIGINAL_BACKUPS/$basename" ]; then
        continue
    fi
    
    # Check if protected header is still there
    if ! grep -q "Protected submenu - DO NOT MODIFY" "$file"; then
        echo "Submenu $basename tampered with, restoring from backup on $(date)" >> /var/log/menu-security.log
        cp "$ORIGINAL_BACKUPS/$basename" "$file"
        
        # Re-apply protection
        BRAND_NAME="Emmkash-Tech"
        BRAND_CONTACT="0112735877"
        BRAND_TELEGRAM="t.me/emmkash"
        BRAND_COPYRIGHT="© Emmkash Tech 2023"
        
        # Create temporary file with protected header
        cat > /tmp/header.txt << EOH
#!/bin/bash
# Protected submenu - DO NOT MODIFY
# Automatically restores if tampered with
# =====================================================
#                $BRAND_NAME SCRIPT                  
# =====================================================

EOH

        # Create temporary file with protected footer
        cat > /tmp/footer.txt << EOF

# =====================================================
# SCRIPT BY $BRAND_NAME ($BRAND_CONTACT)
# Contact: $BRAND_TELEGRAM
# $BRAND_COPYRIGHT
# =====================================================
EOF

        # Add header and footer
        cat /tmp/header.txt > /tmp/protected_file
        cat "$ORIGINAL_BACKUPS/$basename" >> /tmp/protected_file
        cat /tmp/footer.txt >> /tmp/protected_file
        
        # Replace original with protected version
        mv /tmp/protected_file "$file"
        chmod +x "$file"
    fi
done

# Remove temporary files if they exist
rm -f /tmp/header.txt /tmp/footer.txt 2>/dev/null
EOF

chmod +x /etc/cron.daily/verify-submenus

echo "Running initial verification..."
/etc/cron.daily/verify-submenus

echo "Submenu protection complete!"
echo "All menu scripts now have protected branding that will auto-restore if modified." 