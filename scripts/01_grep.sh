#!/bin/bash
# 01_grep.sh — Test all grep examples from BASH_CHEATSHEET.md

set -euo pipefail

# ── helpers ──────────────────────────────────────────────────────────────────
BOLD='\033[1m'; CYAN='\033[0;36m'; RESET='\033[0m'
sep()  { echo; echo -e "${CYAN}── $* ──${RESET}"; }
cmd()  { echo -e "${BOLD}\$ $*${RESET}"; }

# ── sample data ───────────────────────────────────────────────────────────────
FILE="$(dirname "$0")/../sample.txt"
cat > "$FILE" <<'EOF'
id,name,city,score
1,Alice,Bordeaux,88
2,Bob,Paris,75
3,Charlie,Bordeaux,92
4,Diana,Lyon,81
5,Eric,Bordeaux,75
EOF

echo -e "${BOLD}=== grep — Search Text ===${RESET}"

# ── basic search ──────────────────────────────────────────────────────────────
sep "Basic search"
cmd 'grep "Bordeaux" sample.txt'
grep "Bordeaux" "$FILE"

# ── case-insensitive ──────────────────────────────────────────────────────────
sep "-i  Case-insensitive"
cmd 'grep -i "bordeaux" sample.txt'
grep -i "bordeaux" "$FILE"

# ── show line numbers ─────────────────────────────────────────────────────────
sep "-n  Show line numbers"
cmd 'grep -n "Bordeaux" sample.txt'
grep -n "Bordeaux" "$FILE"

# ── invert match ─────────────────────────────────────────────────────────────
sep "-v  Invert — lines NOT matching"
cmd 'grep -v "Bordeaux" sample.txt'
grep -v "Bordeaux" "$FILE"

# ── count ─────────────────────────────────────────────────────────────────────
sep "-c  Count matching lines"
cmd 'grep -c "Bordeaux" sample.txt'
grep -c "Bordeaux" "$FILE"

# ── extended regex OR ────────────────────────────────────────────────────────
sep "-E  Extended regex (OR pattern)"
cmd 'grep -E "Alice|Bob" sample.txt'
grep -E "Alice|Bob" "$FILE"

# ── whole word ───────────────────────────────────────────────────────────────
sep "-w  Whole-word match"
cmd 'grep -w "75" sample.txt'
grep -w "75" "$FILE"

# ── context lines after ──────────────────────────────────────────────────────
sep "-A1  Match + 1 line after"
cmd 'grep -A1 "Charlie" sample.txt'
grep -A1 "Charlie" "$FILE"

# ── regex pattern ────────────────────────────────────────────────────────────
sep "-E  Regex: scores starting with 8"
cmd 'grep -E ",8[0-9]$" sample.txt'
grep -E ",8[0-9]$" "$FILE"

echo
echo -e "${BOLD}✓ grep tests done.${RESET}"
