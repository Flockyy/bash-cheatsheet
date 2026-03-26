#!/bin/bash
# 05_sort.sh — Test all sort examples from BASH_CHEATSHEET.md

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

echo -e "${BOLD}=== sort — Sort Lines ===${RESET}"

sep "Sort whole file lexicographically"
cmd 'sort sample.txt'
sort "$FILE"

sep "-k4,4n  Sort by score field numerically (ascending)"
cmd 'sort -t, -k4,4n sample.txt'
sort -t, -k4,4n "$FILE"

sep "-k4,4nr  Sort by score descending (highest first)"
cmd 'sort -t, -k4,4nr sample.txt'
sort -t, -k4,4nr "$FILE"

sep "-k3,3 -k4,4nr  Sort by city, then score descending"
cmd 'sort -t, -k3,3 -k4,4nr sample.txt'
sort -t, -k3,3 -k4,4nr "$FILE"

sep "-u  Unique cities (via pipeline)"
cmd 'cut -d, -f3 sample.txt | sort -u | grep -v "^city$"'
cut -d, -f3 "$FILE" | sort -u | grep -v "^city$"

sep "uniq — remove duplicate consecutive lines"
cmd 'cut -d, -f3 sample.txt | sort | uniq -c | sort -rn'
echo "(city occurrence count, sorted)"
cut -d, -f3 "$FILE" | sort | uniq -c | sort -rn

echo
echo -e "${BOLD}✓ sort tests done.${RESET}"
