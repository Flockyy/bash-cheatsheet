#!/bin/bash
# 03_sed.sh — Test all sed examples from BASH_CHEATSHEET.md

set -euo pipefail

BOLD='\033[1m'; CYAN='\033[0;36m'; RESET='\033[0m'
sep() { echo; echo -e "${CYAN}── $* ──${RESET}"; }
cmd() { echo -e "${BOLD}\$ $*${RESET}"; }

# Re-create sample.txt before each in-place test so state is predictable
make_sample() {
  cat > "$FILE" <<'EOF'
id,name,city,score
1,Alice,Bordeaux,88
2,Bob,Paris,75
3,Charlie,Bordeaux,92
4,Diana,Lyon,81
5,Eric,Bordeaux,75
EOF
}

FILE="$(dirname "$0")/../sample.txt"
make_sample

echo -e "${BOLD}=== sed — Stream Editor ===${RESET}"

sep "Replace first occurrence per line"
cmd 'sed '"'"'s/Bordeaux/Toulouse/'"'"' sample.txt'
sed 's/Bordeaux/Toulouse/' "$FILE"

sep "Replace all commas with semicolons (global)"
cmd 'sed '"'"'s/,/;/g'"'"' sample.txt'
sed 's/,/;/g' "$FILE"

sep "Delete the header line (line 1)"
cmd 'sed '"'"'1d'"'"' sample.txt'
sed '1d' "$FILE"

sep "Delete lines containing Paris"
cmd 'sed '"'"'/Paris/d'"'"' sample.txt'
sed '/Paris/d' "$FILE"

sep "Print only lines matching Bordeaux (-n suppresses default output)"
cmd 'sed -n '"'"'/Bordeaux/p'"'"' sample.txt'
sed -n '/Bordeaux/p' "$FILE"

sep "Add # prefix to every line"
cmd 'sed '"'"'s/^/# /'"'"' sample.txt'
sed 's/^/# /' "$FILE"

sep "In-place edit: replace Paris with Lille (file is restored after)"
make_sample
cmd "sed -i '' 's/Paris/Lille/' sample.txt  &&  grep 'Lille' sample.txt"
sed -i '' 's/Paris/Lille/' "$FILE"
grep 'Lille' "$FILE"
make_sample   # restore for any subsequent scripts

echo
echo -e "${BOLD}✓ sed tests done.${RESET}"
