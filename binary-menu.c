#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// Protected branding constants - these are hardcoded in the binary and cannot be easily changed
#define BRAND_NAME "Emmkash-Tech"
#define BRAND_CONTACT "0112735877"
#define BRAND_TELEGRAM "t.me/emmkash"
#define BRAND_COPYRIGHT "© Emmkash Tech 2023"
#define BRAND_SLOGAN "Premium VPS Solutions"

// This binary fully protects your branding/name in the menu
// Compile with: gcc -o display-menu binary-menu.c

void displayHeader() {
    // Display protected header with branding
    printf("\e[1;33m =====================================================\e[0m\n");
    printf("\e[1;34m                %s VPS PANEL                \e[0m\n", BRAND_NAME);
    printf("\e[1;33m =====================================================\e[0m\n");
    printf("\e[1;36m           %s           \e[0m\n", BRAND_SLOGAN);
    printf("\e[1;33m =====================================================\e[0m\n");
}

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
    printf("\e[1;32m Client Name \e[0m: %s\n", BRAND_NAME); // Protected name
    printf("\e[1;32m Expired     \e[0m: Lifetime\n");
    printf("\e[1;33m -------------------------------------------------\e[0m\n");
    printf("\n");
    printf("\e[1;36m -----------%s (%s)-------------------\e[0m\n", BRAND_NAME, BRAND_CONTACT); // Protected branding
    printf("\e[1;36m Contact: %s\e[0m\n", BRAND_TELEGRAM); // Protected contact
    printf("\e[1;36m %s\e[0m\n", BRAND_COPYRIGHT); // Protected copyright
    printf("\n");
}

// Protected version check functionality
void checkVersion() {
    FILE *cmd;
    char buffer[128];
    
    cmd = popen("curl -s https://raw.githubusercontent.com/kashy254/sshnew/master/menu/versi", "r");
    fgets(buffer, sizeof(buffer), cmd);
    pclose(cmd);
    
    float latest = atof(buffer);
    float current = 1.0; // Hardcoded current version
    
    if (latest > current) {
        printf("\e[1;33m !!! New version available: %.1f (current: %.1f) !!!\e[0m\n", latest, current);
        printf("\e[1;33m Contact %s for updates\e[0m\n", BRAND_TELEGRAM);
    }
}

int main() {
    system("clear");
    
    displayHeader();
    displayBanner();
    displayRamInfo();
    displayMenuOptions();
    displayFooter();
    checkVersion();
    
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