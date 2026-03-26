#!/bin/bash
# run_all.sh — Run all cheatsheet test scripts in order

set -euo pipefail

BOLD='\033[1m'; GREEN='\033[0;32m'; RED='\033[0;31m'; RESET='\033[0m'

DIR="$(dirname "$0")/scripts"
SCRIPTS=(
  01_grep.sh
  02_awk.sh
  03_sed.sh
  04_cut.sh
  05_sort.sh
  06_tail_head.sh
  07_compression.sh
)

PASS=0
FAIL=0

for script in "${SCRIPTS[@]}"; do
  echo
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${BOLD}  Running: $script${RESET}"
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

  if bash "$DIR/$script"; then
    echo -e "${GREEN}  ✓ $script passed${RESET}"
    ((PASS++))
  else
    echo -e "${RED}  ✗ $script FAILED (exit $?)${RESET}"
    ((FAIL++))
  fi
done

echo
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}Results: ${GREEN}$PASS passed${RESET}${BOLD}, ${RED}$FAIL failed${RESET}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

[[ $FAIL -eq 0 ]]
