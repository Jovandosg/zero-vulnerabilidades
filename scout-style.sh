#!/bin/bash

# Cores
RED='\033[0;41;37m'
ORANGE='\033[0;43;30m'
YELLOW='\033[1;103;30m'
BLUE='\033[0;44;37m'
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

scan_image() {
    local img=$1
    local label=$2
    
    # Extrai contagens do JSON do Trivy
    local data=$(trivy image --format json "$img" 2>/dev/null)
    local critical=$(echo "$data" | jq '[.Results[].Vulnerabilities[]? | select(.Severity=="CRITICAL")] | length')
    local high=$(echo "$data" | jq '[.Results[].Vulnerabilities[]? | select(.Severity=="HIGH")] | length')
    local medium=$(echo "$data" | jq '[.Results[].Vulnerabilities[]? | select(.Severity=="MEDIUM")] | length')
    local low=$(echo "$data" | jq '[.Results[].Vulnerabilities[]? | select(.Severity=="LOW")] | length')
    
    # Extrai tamanho da imagem
    local size=$(docker images --format "{{.Size}}" "$img" 2>/dev/null | head -1)
    
    # Conta pacotes (OS packages + language-specific)
    local packages=$(echo "$data" | jq '[.Results[].Packages[]?] | length')
    
    # Linha principal
    printf "${BOLD}%-15s${RESET} " "$label"
    printf "│ %-20s │ " "$img"
    printf "${RED} ${critical}C ${RESET} "
    printf "${ORANGE} ${high}H ${RESET} "
    printf "${YELLOW} ${medium}M ${RESET} "
    printf "${BLUE} ${low}L ${RESET}\n"
    
    # Linha de detalhes (tamanho e pacotes)
    printf "${DIM}%-15s${RESET} " ""
    printf "│ ${DIM}%-8s${RESET}           │ ${DIM}%s pacotes${RESET}\n" "$size" "$packages"
}

echo -e "\n${BOLD}Target          │ Image Name           │ Vulnerabilities${RESET}"
echo "────────────────┼──────────────────────┼────────────────────────────────"
scan_image "imagem-01:standard"   "Standard"
echo "────────────────┼──────────────────────┼────────────────────────────────"
scan_image "imagem-02:distroless" "Distroless"
echo "────────────────┼──────────────────────┼────────────────────────────────"
scan_image "imagem-03:wolfi"      "Wolfi"
echo -e "────────────────┴──────────────────────┴────────────────────────────────\n"
