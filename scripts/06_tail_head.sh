#!/bin/bash
# 06_tail_head.sh — Test all tail and head examples from BASH_CHEATSHEET.md

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

echo -e "${BOLD}=== tail — View End of File ===${RESET}"

sep "Default (last 10 lines — shows all 6 here)"
cmd 'tail sample.txt'
tail "$FILE"

sep "-n 2  Last 2 lines"
cmd 'tail -n 2 sample.txt'
tail -n 2 "$FILE"

sep "-n +2  All lines from line 2 onward (skip header)"
cmd 'tail -n +2 sample.txt'
tail -n +2 "$FILE"

# tail -f skipped — it blocks; document it instead
sep "-f  Follow a growing file (demo: append then follow briefly)"
cmd 'tail -f app.log  # skipped in automated test (blocks indefinitely)'
echo "(skipped — use 'tail -f logfile' manually to follow live log output)"

echo
echo -e "${BOLD}=== head — View Start of File ===${RESET}"

sep "Default (first 10 lines)"
cmd 'head sample.txt'
head "$FILE"

sep "-n 1  Header row only"
cmd 'head -n 1 sample.txt'
head -n 1 "$FILE"

sep "-n 3  First 3 lines"
cmd 'head -n 3 sample.txt'
head -n 3 "$FILE"

sep "-c 100  First 100 bytes"
cmd 'head -c 100 sample.txt'
head -c 100 "$FILE"

echo
echo -e "${BOLD}✓ tail / head tests done.${RESET}"
