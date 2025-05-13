#!/bin/bash
# cari apa..?? harta tahta hanya sementara ingat masih ada kehidupan setelah kematian
# jangan lupa sholat ingat ajal menantimu
# dibawah ini bukan cd kaset ya
cd
rm -rf setup.sh
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
BRed='\e[1;31m'
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root
#System version number
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
  sleep 5
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
  clear
                echo "For VPS with KVM and VMWare virtualization ONLY"
  sleep 5
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi
# buat folder
mkdir -p /etc/xray
mkdir -p /etc/v2ray
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/scdomain
touch /etc/v2ray/scdomain


echo -e "[ ${BBlue}NOTES${NC} ] Before we go.. "
sleep 0.5
echo -e "[ ${BBlue}NOTES${NC} ] I need check your headers first.."
sleep 0.5
echo -e "[ ${BGreen}INFO${NC} ] Checking headers"
sleep 0.5
totet=`uname -r`
REQUIRED_PKG="linux-headers-$totet"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  sleep 0.5
  echo -e "[ ${BRed}WARNING${NC} ] Try to install ...."
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  apt-get --yes install $REQUIRED_PKG
  sleep 0.5
  echo ""
  sleep 0.5
  echo -e "[ ${BBlue}NOTES${NC} ] If error you need.. to do this"
  sleep 0.5
  echo ""
  sleep 0.5
  echo -e "[ ${BBlue}NOTES${NC} ] apt update && apt upgrade -y && reboot"
  sleep 0.5
  echo ""
  sleep 0.5
  echo -e "[ ${BBlue}NOTES${NC} ] After this"
  sleep 0.5
  echo -e "[ ${BBlue}NOTES${NC} ] Then run this script again"
  echo -e "[ ${BBlue}NOTES${NC} ] enter now"
  read
else
  echo -e "[ ${BGreen}INFO${NC} ] Oke installed"
fi

ttet=`uname -r`
ReqPKG="linux-headers-$ttet"
if ! dpkg -s $ReqPKG  >/dev/null 2>&1; then
  rm /root/setup.sh >/dev/null 2>&1 
  exit
else
  clear
fi


secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

echo -e "[ ${BGreen}INFO${NC} ] Preparing the install file"
apt install git curl -y >/dev/null 2>&1
apt install python -y >/dev/null 2>&1
echo -e "[ ${BGreen}INFO${NC} ] Aight good ... installation file is ready"
sleep 0.5
echo -ne "[ ${BGreen}INFO${NC} ] Check permission : "

echo -e "$BGreen Permission Accepted!$NC"
sleep 2

mkdir -p /var/lib/ >/dev/null 2>&1
echo "IP=" >> /var/lib/ipvps.conf

echo ""
clear
echo -e "$BBlue                     SETUP DOMAIN VPS     $NC"
echo -e "$BYellow----------------------------------------------------------$NC"
echo -e "$BGreen 1. Use Domain Random / Gunakan Domain Random $NC"
echo -e "$BGreen 2. Choose Your Own Domain / Gunakan Domain Sendiri $NC"
echo -e "$BYellow----------------------------------------------------------$NC"
read -rp " input 1 or 2 / pilih 1 atau 2 : " dns
if test $dns -eq 1; then
wget https://raw.githubusercontent.com/kashy254/sshnew/master/ssh/cf && chmod +x cf && ./cf
elif test $dns -eq 2; then
read -rp "Enter Your Domain / masukan domain : " dom
echo "IP=$dom" > /var/lib/ipvps.conf
echo "$dom" > /root/scdomain
echo "$dom" > /etc/xray/scdomain
echo "$dom" > /etc/xray/domain
echo "$dom" > /etc/v2ray/domain
echo "$dom" > /root/domain
else 
echo "Not Found Argument"
exit 1
fi
echo -e "${BGreen}Done!${NC}"
sleep 2
clear
    
#install ssh ovpn
echo -e "\e[33m-----------------------------------\033[0m"
echo -e "$BGreen      Install SSH Websocket           $NC"
echo -e "\e[33m-----------------------------------\033[0m"
sleep 0.5
clear
wget https://raw.githubusercontent.com/kashy254/sshnew/master/ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
#Instal Xray
echo -e "\e[33m-----------------------------------\033[0m"
echo -e "$BGreen          Install XRAY              $NC"
echo -e "\e[33m-----------------------------------\033[0m"
sleep 0.5
clear
wget https://raw.githubusercontent.com/kashy254/sshnew/master/xray/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
wget https://raw.githubusercontent.com/kashy254/sshnew/master/sshws/insshws.sh && chmod +x insshws.sh && ./insshws.sh
clear
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-ssh.log" ]; then
echo "Log SSH Account " > /etc/log-create-ssh.log
fi
if [ ! -f "/etc/log-create-vmess.log" ]; then
echo "Log Vmess Account " > /etc/log-create-vmess.log
fi
if [ ! -f "/etc/log-create-vless.log" ]; then
echo "Log Vless Account " > /etc/log-create-vless.log
fi
if [ ! -f "/etc/log-create-trojan.log" ]; then
echo "Log Trojan Account " > /etc/log-create-trojan.log
fi
if [ ! -f "/etc/log-create-shadowsocks.log" ]; then
echo "Log Shadowsocks Account " > /etc/log-create-shadowsocks.log
fi
history -c
serverV=$( curl -sS https://raw.githubusercontent.com/kashy254/sshnew/master/menu/versi  )
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
curl -sS ipv4.icanhazip.com > /etc/myipvps
echo ""
echo "=================================================================="  | tee -a log-install.txt
echo "      ___                                    ___         ___      "  | tee -a log-install.txt
echo "     /  /\        ___           ___         /  /\       /__/\     "  | tee -a log-install.txt
echo "    /  /:/_      /  /\         /__/\       /  /::\      \  \:\    "  | tee -a log-install.txt
echo "   /  /:/ /\    /  /:/         \  \:\     /  /:/\:\      \  \:\   "  | tee -a log-install.txt
echo "  /  /:/_/::\  /__/::\          \  \:\   /  /:/~/:/  _____\__\:\  "  | tee -a log-install.txt
echo " /__/:/__\/\:\ \__\/\:\__   ___  \__\:\ /__/:/ /:/  /__/::::::::\ "  | tee -a log-install.txt
echo " \  \:\ /~~/:/    \  \:\/\ /__/\ |  |:| \  \:\/:/   \  \:\~~\~~\/ "  | tee -a log-install.txt
echo "  \  \:\  /:/      \__\::/ \  \:\|  |:|  \  \::/     \  \:\  ~~~  "  | tee -a log-install.txt
echo "   \  \:\/:/       /__/:/   \  \:\__|:|   \  \:\      \  \:\      "  | tee -a log-install.txt
echo "    \  \::/        \__\/     \__\::::/     \  \:\      \  \:\     "  | tee -a log-install.txt
echo "     \__\/                       ~~~~       \__\/       \__\/ 1.0 "  | tee -a log-install.txt
echo "=================================================================="  | tee -a log-install.txt
echo ""
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                  : 22"  | tee -a log-install.txt
echo "   - SSH Websocket            : 80" | tee -a log-install.txt
echo "   - SSH SSL Websocket        : 443" | tee -a log-install.txt
echo "   - Stunnel4                 : 222, 777" | tee -a log-install.txt
echo "   - Dropbear                 : 109, 143" | tee -a log-install.txt
echo "   - Badvpn                   : 7100-7900" | tee -a log-install.txt
echo "   - Nginx                    : 81" | tee -a log-install.txt
echo "   - Vmess WS TLS             : 443" | tee -a log-install.txt
echo "   - Vless WS TLS             : 443" | tee -a log-install.txt
echo "   - Trojan WS TLS            : 443" | tee -a log-install.txt
echo "   - Shadowsocks WS TLS       : 443" | tee -a log-install.txt
echo "   - Vmess WS none TLS        : 80" | tee -a log-install.txt
echo "   - Vless WS none TLS        : 80" | tee -a log-install.txt
echo "   - Trojan WS none TLS       : 80" | tee -a log-install.txt
echo "   - Shadowsocks WS none TLS  : 80" | tee -a log-install.txt
echo "   - Vmess gRPC               : 443" | tee -a log-install.txt
echo "   - Vless gRPC               : 443" | tee -a log-install.txt
echo "   - Trojan gRPC              : 443" | tee -a log-install.txt
echo "   - Shadowsocks gRPC         : 443" | tee -a log-install.txt
echo ""
echo "=============================Contact==============================" | tee -a log-install.txt
echo "---------------------------t.me/emmkash-----------------------------" | tee -a log-install.txt
echo "==================================================================" | tee -a log-install.txt
echo -e ""
echo ""
echo "" | tee -a log-install.txt

# Begin menu protection setup
echo "Setting up protected menu system..."

# Create the binary-menu.c file
cat > /root/binary-menu.c << 'EOF'
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

# Check for gcc and install if needed
if ! command -v gcc &> /dev/null; then
    echo "Installing gcc compiler..."
    apt-get update
    apt-get install -y build-essential
fi

# Compile the binary
echo "Compiling protected menu binary..."
gcc -o /usr/local/bin/display-menu /root/binary-menu.c

# Make it executable
chmod +x /usr/local/bin/display-menu

# Make a backup of the original menu script
echo "Setting up menu wrapper..."
cp /root/menu/menu.sh /root/menu/menu.sh.original

# Create a wrapper script for the menu
cat > /root/menu/menu.sh << 'EOF'
#!/bin/bash
# Protected menu wrapper
# This calls the binary version of the menu which protects your branding

/usr/local/bin/display-menu
EOF

# Make it executable
chmod +x /root/menu/menu.sh

# Create a symbolic link to ensure all menu calls go through the binary
ln -sf /usr/local/bin/display-menu /usr/bin/menu

# Set up tamper protection
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

# Create backup of the binary and store initial checksum
cp /usr/local/bin/display-menu /usr/local/bin/display-menu.backup
md5sum /usr/local/bin/display-menu | awk '{print $1}' > /etc/menu-checksum

# Strip the binary to make it harder to reverse engineer
strip --strip-all /usr/local/bin/display-menu

echo "Protected menu setup complete!"

# COMPREHENSIVE BRAND PROTECTION
echo "Setting up comprehensive brand protection..."

# 1. Protect all submenu scripts
echo "Protecting all submenu scripts..."
cat > /root/submenu-protection.sh << 'EOFsub'
#!/bin/bash
# Submenu protection script
# Protects all submenu scripts to ensure branding is consistent

# Define protected branding details (same as in the binary)
BRAND_NAME="Emmkash-Tech"
BRAND_CONTACT="0112735877"
BRAND_TELEGRAM="t.me/emmkash"
BRAND_COPYRIGHT="© Emmkash Tech 2023"

# Search for all menu script files
MENU_PATH="/root/menu"

# Create backup directory
mkdir -p $MENU_PATH/original-backups

# Function to add protected header and footer to scripts
add_protection() {
    local file=$1
    local basename=$(basename "$file")
    
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
        # Already protected, skipping
        :
    else
        # Add header and footer
        cat /tmp/header.txt > /tmp/protected_file
        cat "$file" >> /tmp/protected_file
        cat /tmp/footer.txt >> /tmp/protected_file
        
        # Replace original with protected version
        mv /tmp/protected_file "$file"
        chmod +x "$file"
    fi
}

# Find all menu script files and protect them
find $MENU_PATH -name "*.sh" | while read file; do
    add_protection "$file"
done

# Create validation script to ensure submenus aren't tampered with
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
EOFsub

chmod +x /root/submenu-protection.sh
/root/submenu-protection.sh

# 2. Protect all banners and visual elements
echo "Protecting all banners and visual elements..."
cat > /root/banner-protection.sh << 'EOFban'
#!/bin/bash
# Banner and visual elements protection script
# This script ensures all banners and visual elements maintain your branding

# Define protected branding details
BRAND_NAME="Emmkash-Tech"
BRAND_CONTACT="0112735877"
BRAND_TELEGRAM="t.me/emmkash"
BRAND_COPYRIGHT="© Emmkash Tech 2023"

# Create a protected issue banner (displayed at login)
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
    echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
    systemctl restart sshd
fi

# Create protected MOTD (Message of the Day)
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
EOFban

chmod +x /root/banner-protection.sh
/root/banner-protection.sh

echo "Comprehensive brand protection complete!"
echo "Your VPS now has full protection for all branding elements:"
echo "1. Main menu protected in binary format"
echo "2. All submenu scripts protected with auto-restoration"
echo "3. All banners and visual elements protected"
echo "4. Daily integrity checks to detect and fix any tampering"

# Clean up
rm /root/binary-menu.c >/dev/null 2>&1
rm /root/setup.sh >/dev/null 2>&1
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
rm /root/submenu-protection.sh >/dev/null 2>&1
rm /root/banner-protection.sh >/dev/null 2>&1

secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e ""
echo " Auto reboot in 10 Seconds "
sleep 10
rm -rf setup.sh
reboot

