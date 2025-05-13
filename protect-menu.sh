#!/bin/bash
# Protect menu script with binary protection
# This script will compile the binary-menu.c file and set up the system to use it

echo "Setting up menu protection for Emmkash Tech..."

# Check for gcc
if ! command -v gcc &> /dev/null; then
    echo "Installing gcc compiler..."
    apt-get update
    apt-get install -y build-essential
fi

# Compile the binary
echo "Compiling protected menu binary..."
gcc -o /usr/local/bin/display-menu binary-menu.c

# Make it executable
chmod +x /usr/local/bin/display-menu

# Make a backup of the original menu script
echo "Making backup of original menu script..."
cp /root/menu/menu.sh /root/menu/menu.sh.backup

# Create a wrapper script for the menu
echo "Creating wrapper script..."
cat > /root/menu/menu.sh << 'EOF'
#!/bin/bash
# Protected menu wrapper
# This calls the binary version of the menu which protects your branding

/usr/local/bin/display-menu
EOF

# Make it executable
chmod +x /root/menu/menu.sh

# Create a symbolic link to ensure all menu calls go through the binary
echo "Creating system-wide link..."
ln -sf /usr/local/bin/display-menu /usr/bin/menu

echo "Menu protection setup complete!"
echo "Your menu now uses a binary file that protects your branding."
echo "Your name 'Emmkash Tech' is now embedded in the binary and cannot be easily modified." 