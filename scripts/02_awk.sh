#!/bin/bash
# 02_awk.sh — Test all awk examples from BASH_CHEATSHEET.md

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

echo -e "${BOLD}=== awk — Pattern Scan & Report ===${RESET}"

sep "Print names where city is Bordeaux"
cmd 'awk -F, '"'"'$3 == "Bordeaux" {print $2}'"'"' sample.txt'
awk -F, '$3 == "Bordeaux" {print $2}' "$FILE"

sep "Sum all scores (skip header with NR > 1)"
cmd 'awk -F, '"'"'NR > 1 {sum += $4} END {print "Total:", sum}'"'"' sample.txt'
awk -F, 'NR > 1 {sum += $4} END {print "Total:", sum}' "$FILE"

sep "Average score"
cmd 'awk -F, '"'"'NR > 1 {sum += $4; count++} END {printf "Avg: %.1f\n", sum/count}'"'"' sample.txt'
awk -F, 'NR > 1 {sum += $4; count++} END {printf "Avg: %.1f\n", sum/count}' "$FILE"

sep "Filter rows with score > 80"
cmd 'awk -F, '"'"'NR == 1 || $4 > 80'"'"' sample.txt'
awk -F, 'NR == 1 || $4 > 80' "$FILE"

sep "Add computed column (score × 2)"
cmd 'awk -F, '"'"'NR == 1 {print $0 ",doubled"} NR > 1 {print $0 "," $4*2}'"'"' sample.txt'
awk -F, 'NR == 1 {print $0 ",doubled"} NR > 1 {print $0 "," $4*2}' "$FILE"

sep "Change output separator to ;"
cmd 'awk -F, '"'"'BEGIN{OFS=";"} {$1=$1; print}'"'"' sample.txt'
awk -F, 'BEGIN{OFS=";"} {$1=$1; print}' "$FILE"

echo
echo -e "${BOLD}✓ awk tests done.${RESET}"
