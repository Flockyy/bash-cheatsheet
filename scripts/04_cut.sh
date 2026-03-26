#!/bin/bash
# 04_cut.sh — Test all cut examples from BASH_CHEATSHEET.md

set -euo pipefail

BOLD='\033[1m'; CYAN='\033[0;36m'; RESET='\033[0m'
sep() { echo; echo -e "${CYAN}── $* ──${RESET}"; }
cmd() { echo -e "${BOLD}\$ $*${RESET}"; }

FILE="$(dirname "$0")/../sample.txt"
cat > "$FILE" <<'EOF'
id,name,city,score
1,Alice,Bordeaux,88
2,Bob,Paris,75
3,Charlie,Bordeaux,92
4,Diana,Lyon,81
5,Eric,Bordeaux,75
EOF

echo -e "${BOLD}=== cut — Extract Columns ===${RESET}"

sep "-f2  Show only the name column"
cmd 'cut -d, -f2 sample.txt'
cut -d, -f2 "$FILE"

sep "-f2,4  Show name and score (non-contiguous)"
cmd 'cut -d, -f2,4 sample.txt'
cut -d, -f2,4 "$FILE"

sep "-f2-4  Show columns 2 to 4 (range)"
cmd 'cut -d, -f2-4 sample.txt'
cut -d, -f2-4 "$FILE"

sep "-c1-10  First 10 characters of each line"
cmd 'cut -c1-10 sample.txt'
cut -c1-10 "$FILE"

sep "--complement  Drop field 1 (GNU coreutils only — not on macOS BSD cut)"
cmd 'cut -d, -f1 --complement sample.txt  # GNU only'
echo "(skipped on macOS — awk equivalent:)"
cmd 'awk -F, '"'"'BEGIN{OFS=","} {$1=""; sub(/^,/,""); print}'"'"' sample.txt'
awk -F, 'BEGIN{OFS=","} {$1=""; sub(/^,/,""); print}' "$FILE"

echo
echo -e "${BOLD}✓ cut tests done.${RESET}"
