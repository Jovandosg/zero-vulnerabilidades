#!/bin/bash

# Cores
RED='\033[0;41;37m'
ORANGE='\033[0;43;30m'
YELLOW='\033[1;103;30m'
BLUE='\033[0;44;37m'
RESET='\033[0m'
BOLD='\033[1m'

scan_image() {
    local img=$1
    local label=$2
    
    # Extrai contagens do JSON do Trivy
    local data=$(trivy image --format json "$img" 2>/dev/null)
    local critical=$(echo "$data" | jq '[.Results[].Vulnerabilities[]? | select(.Severity=="CRITICAL")] | length')
    local high=$(echo "$data" | jq '[.Results[].Vulnerabilities[]? | select(.Severity=="HIGH")] | length')
    local medium=$(echo "$data" | jq '[.Results[].Vulnerabilities[]? | select(.Severity=="MEDIUM")] | length')
    local low=$(echo "$data" | jq '[.Results[].Vulnerabilities[]? | select(.Severity=="LOW")] | length')

    # Formata a linha estilo Scout
    printf "${BOLD}%-20s${RESET} | %-25s | " "$label" "$img"
    printf "${RED} ${critical}C ${RESET} "
    printf "${ORANGE} ${high}H ${RESET} "
    printf "${YELLOW} ${medium}M ${RESET} "
    printf "${BLUE} ${low}L ${RESET}\n"
}

echo -e "\n${BOLD}Target               | Image Name                | Vulnerabilities${RESET}"
echo "--------------------------------------------------------------------------------"
scan_image "imagem-01:standard"   "Standard"
scan_image "imagem-02:distroless" "Distroless"
scan_image "imagem-03:wolfi"      "Wolfi"
echo -e "--------------------------------------------------------------------------------\n"
