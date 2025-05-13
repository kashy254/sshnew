#!/bin/bash
# VPS Installer with brand protection
# This script automatically installs your VPS setup with protected branding

# Display welcome message
echo "================================================="
echo "       EMMKASH TECH VPS INSTALLER SCRIPT        "
echo "================================================="
echo "Installing protected VPS configuration..."
echo ""

# Set up initial environment
apt update -y
apt upgrade -y

# Install required packages
apt install -y build-essential curl wget git

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR

# Download and extract your original script package
echo "Downloading main VPS scripts..."
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO

# Run your original setup script
echo "Running original setup script..."
chmod +x setup.sh
./setup.sh

# Protect the menu (automatically)
echo "Setting up menu protection..."

# 1. Create the binary-menu.c file
cat > binary-menu.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// This binary protects your branding/name in the menu
// Compile with: gcc -o display-menu binary-menu.c

void displayBanner() {
    printf("\e[1;33m -------------------------------------------------\e[0m\n");
    printf("\e[1;34m                      VPS INFO                    \e[0m\n");
    printf("\e[1;33m -------------------------------------------------\e[0m\n");
    
    // Get system info using commands
    FILE *cmd;
    char buffer[128];
    
    printf("\e[1;32m OS            \e[0m: ");
    cmd = popen("hostnamectl | grep \"Operating System\" | cut -d ' ' -f5-", "r");
    fgets(buffer, sizeof(buffer), cmd);
    printf("%s", buffer);
    pclose(cmd);
    
    printf("\e[1;32m Uptime        \e[0m: ");
    cmd = popen("uptime -p | cut -d \" \" -f 2-10", "r");
    fgets(buffer, sizeof(buffer), cmd);
    printf("%s", buffer);
    pclose(cmd);
    
    printf("\e[1;32m Public IP     \e[0m: ");
    cmd = popen("curl -s ifconfig.me", "r");
    fgets(buffer, sizeof(buffer), cmd);
    printf("%s\n", buffer);
    pclose(cmd);
    
    printf("\e[1;32m Country       \e[0m: ");
    cmd = popen("curl -s ifconfig.co/country", "r");
    fgets(buffer, sizeof(buffer), cmd);
    printf("%s", buffer);
    pclose(cmd);
    
    printf("\e[1;32m DOMAIN        \e[0m: ");
    cmd = popen("cat /etc/xray/domain", "r");
    fgets(buffer, sizeof(buffer), cmd);
    printf("%s", buffer);
    pclose(cmd);
    
    printf("\e[1;32m DATE & TIME   \e[0m: ");
    cmd = popen("date -R | cut -d \" \" -f -5", "r");
    fgets(buffer, sizeof(buffer), cmd);
    printf("%s", buffer);
    pclose(cmd);
}

void displayRamInfo() {
    printf("\e[1;33m -------------------------------------------------\e[0m\n");
    printf("\e[1;34m                      RAM INFO                    \e[0m\n");
    printf("\e[1;33m -------------------------------------------------\e[0m\n");
    printf("\n");
    
    FILE *cmd;
    char buffer[128];
    
    printf("\e[1;32m RAM USED   \e[0m: ");
    cmd = popen("free -m | awk 'NR==2 {print $3}' | tr -d '\n'", "r");
    fgets(buffer, sizeof(buffer), cmd);
    printf("%s MB\n", buffer);
    pclose(cmd);
    
    printf("\e[1;32m RAM TOTAL  \e[0m: ");
    cmd = popen("free -m | awk 'NR==2 {print $2}' | tr -d '\n'", "r");
    fgets(buffer, sizeof(buffer), cmd);
    printf("%s MB\n", buffer);
    pclose(cmd);
    
    printf("\n");
}

void displayMenuOptions() {
    printf("\e[1;33m -------------------------------------------------\e[0m\n");
    printf("\e[1;34m                       MENU                       \e[0m\n");
    printf("\e[1;33m -------------------------------------------------\e[0m\n");
    printf("\n");
    printf("\e[1;36m 1 \e[0m: Menu SSH\n");
    printf("\e[1;36m 2 \e[0m: Menu Vmess\n");
    printf("\e[1;36m 3 \e[0m: Menu Vless\n");
    printf("\e[1;36m 4 \e[0m: Menu Trojan\n");
    printf("\e[1;36m 5 \e[0m: Menu Shadowsocks\n");
    printf("\e[1;36m 6 \e[0m: Menu Setting\n");
    printf("\e[1;36m 7 \e[0m: Status Service\n");
    printf("\e[1;36m 8 \e[0m: Clear RAM Cache\n");
    printf("\e[1;36m 9 \e[0m: Reboot VPS\n");
    printf("\e[1;36m x \e[0m: Exit Script\n");
    printf("\n");
}

void displayFooter() {
    // This is the protected part that can't be edited
    printf("\e[1;33m -------------------------------------------------\e[0m\n");
    printf("\e[1;32m Client Name \e[0m: Emmkash-Tech\n"); // Protected name
    printf("\e[1;32m Expired     \e[0m: Lifetime\n");
    printf("\e[1;33m -------------------------------------------------\e[0m\n");
    printf("\n");
    printf("\e[1;36m -----------SCRIPT BY EMMKASH-TECH(0112735877)-------------------\e[0m\n"); // Protected branding
    printf("\n");
}

int main() {
    system("clear");
    
    displayBanner();
    displayRamInfo();
    displayMenuOptions();
    displayFooter();
    
    char opt[10];
    printf(" Select menu :  ");
    fgets(opt, sizeof(opt), stdin);
    
    // Clean up the newline character
    size_t len = strlen(opt);
    if (len > 0 && opt[len-1] == '\n') {
        opt[len-1] = '\0';
    }
    
    if (strcmp(opt, "1") == 0) {
        system("clear && m-sshovpn");
    } else if (strcmp(opt, "2") == 0) {
        system("clear && m-vmess");
    } else if (strcmp(opt, "3") == 0) {
        system("clear && m-vless");
    } else if (strcmp(opt, "4") == 0) {
        system("clear && m-trojan");
    } else if (strcmp(opt, "5") == 0) {
        system("clear && m-ssws");
    } else if (strcmp(opt, "6") == 0) {
        system("clear && m-system");
    } else if (strcmp(opt, "7") == 0) {
        system("clear && running");
    } else if (strcmp(opt, "8") == 0) {
        system("clear && clearcache");
    } else if (strcmp(opt, "9") == 0) {
        system("clear && reboot && /sbin/reboot");
    } else if (strcmp(opt, "x") == 0) {
        exit(0);
    } else {
        printf("Anda salah tekan\n");
        sleep(1);
        system("menu");
    }
    
    return 0;
}
EOF

# 2. Compile the binary
echo "Compiling protected menu binary..."
gcc -o /usr/local/bin/display-menu binary-menu.c

# 3. Make it executable
chmod +x /usr/local/bin/display-menu

# 4. Make a backup of the original menu script
echo "Setting up menu wrapper..."
cp /root/menu/menu.sh /root/menu/menu.sh.original

# 5. Create a wrapper script for the menu
cat > /root/menu/menu.sh << 'EOF'
#!/bin/bash
# Protected menu wrapper
# This calls the binary version of the menu which protects your branding

/usr/local/bin/display-menu
EOF

# 6. Make it executable
chmod +x /root/menu/menu.sh

# 7. Create a symbolic link to ensure all menu calls go through the binary
ln -sf /usr/local/bin/display-menu /usr/bin/menu

# 8. Set up tamper protection
echo "Setting up tamper protection..."
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

# 9. Create backup of the binary and store initial checksum
cp /usr/local/bin/display-menu /usr/local/bin/display-menu.backup
md5sum /usr/local/bin/display-menu | awk '{print $1}' > /etc/menu-checksum

# 10. Strip the binary to make it harder to reverse engineer
strip --strip-all /usr/local/bin/display-menu

# Clean up temp files
cd /
rm -rf $TEMP_DIR

echo "================================================="
echo "     EMMKASH TECH VPS INSTALLATION COMPLETE     "
echo "================================================="
echo "Your VPS is now set up with protected branding!"
echo "Your name and branding are secured in binary format."
echo "Any tampering will be automatically detected and fixed."
echo "" 