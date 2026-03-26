#!/bin/bash
# 07_compression.sh — Test all zip / unzip / tar examples from BASH_CHEATSHEET.md

set -euo pipefail

BOLD='\033[1m'; CYAN='\033[0;36m'; RESET='\033[0m'
sep() { echo; echo -e "${CYAN}── $* ──${RESET}"; }
cmd() { echo -e "${BOLD}\$ $*${RESET}"; }

ROOT="$(dirname "$0")/.."
cd "$ROOT"

# ── clean slate ───────────────────────────────────────────────────────────────
rm -rf demo_zip demo_zip.zip sample.zip demo.tar demo.tar.gz extracted_zip extracted_tar

# ── test data ─────────────────────────────────────────────────────────────────
cat > sample.txt <<'EOF'
id,name,city,score
1,Alice,Bordeaux,88
2,Bob,Paris,75
3,Charlie,Bordeaux,92
4,Diana,Lyon,81
5,Eric,Bordeaux,75
EOF

mkdir -p demo_zip
echo "report" > demo_zip/report.txt
echo "notes"  > demo_zip/notes.txt

echo -e "${BOLD}=== zip / unzip ===${RESET}"

sep "Zip a single file"
cmd 'zip sample.zip sample.txt'
zip sample.zip sample.txt

sep "Zip a folder recursively"
cmd 'zip -r demo_zip.zip demo_zip'
zip -r demo_zip.zip demo_zip

sep "Zip with maximum compression (-9)"
cmd 'zip -r -9 demo_zip.zip demo_zip'
zip -r -9 demo_zip.zip demo_zip

sep "List archive contents"
cmd 'unzip -l demo_zip.zip'
unzip -l demo_zip.zip

sep "Extract into current folder"
cmd 'unzip -o demo_zip.zip'
unzip -o demo_zip.zip

sep "Extract into a specific folder"
cmd 'unzip -o demo_zip.zip -d extracted_zip'
unzip -o demo_zip.zip -d extracted_zip
echo "Extracted files:"
ls extracted_zip/demo_zip/

echo
echo -e "${BOLD}=== tar ===${RESET}"

sep "Create a plain tar archive"
cmd 'tar -cvf demo.tar demo_zip'
tar -cvf demo.tar demo_zip

sep "Create a gzipped archive"
cmd 'tar -czvf demo.tar.gz demo_zip'
tar -czvf demo.tar.gz demo_zip

sep "List contents without extracting"
cmd 'tar -tvf demo.tar.gz'
tar -tvf demo.tar.gz

sep "Extract into current folder"
cmd 'tar -xzvf demo.tar.gz'
tar -xzvf demo.tar.gz

sep "Extract into a specific folder"
mkdir -p extracted_tar
cmd 'tar -xzvf demo.tar.gz -C extracted_tar'
tar -xzvf demo.tar.gz -C extracted_tar
echo "Extracted:"
ls extracted_tar/demo_zip/

sep "Archive with exclusion (--exclude must come BEFORE the source path on macOS)"
cmd "tar -czvf demo.tar.gz --exclude='demo_zip/notes.txt' demo_zip"
tar -czvf demo.tar.gz --exclude='demo_zip/notes.txt' demo_zip
echo "Contents after exclusion:"
tar -tvf demo.tar.gz

# ── cleanup ───────────────────────────────────────────────────────────────────
echo
sep "Cleanup test artefacts"
rm -rf demo_zip demo_zip.zip sample.zip demo.tar demo.tar.gz extracted_zip extracted_tar sample.txt
echo "Done."

echo
echo -e "${BOLD}✓ compression tests done.${RESET}"
