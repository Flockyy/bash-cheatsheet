# Bash Cheat Sheet

Quick reference for common Bash commands used in text processing and file compression, with short test examples you can run directly in a terminal.

## Test Setup

Use this small sample file for the text-processing examples:

```bash
cat > sample.txt <<'EOF'
id,name,city,score
1,Alice,Bordeaux,88
2,Bob,Paris,75
3,Charlie,Bordeaux,92
4,Diana,Lyon,81
5,Eric,Bordeaux,75
EOF
```

## Text Processing

### `grep` — Search Text

Find lines matching a word or pattern.

```bash
grep "Bordeaux" sample.txt
```

Expected result:

```text
1,Alice,Bordeaux,88
3,Charlie,Bordeaux,92
5,Eric,Bordeaux,75
```

Useful variants:

```bash
grep -i "bordeaux" sample.txt      # case-insensitive
grep -n "Bordeaux" sample.txt      # show line numbers
grep -v "Bordeaux" sample.txt      # exclude matches
grep -E "Alice|Bob" sample.txt     # extended regex
```

### `awk` — Pattern Scan

Process structured text column by column.

Print names where city is Bordeaux:

```bash
awk -F, '$3 == "Bordeaux" {print $2}' sample.txt
```

Expected result:

```text
Alice
Charlie
Eric
```

Sum scores:

```bash
awk -F, 'NR > 1 {sum += $4} END {print sum}' sample.txt
```

Filter rows with score greater than 80:

```bash
awk -F, 'NR == 1 || $4 > 80' sample.txt
```

### `sed` — Stream Editor

Edit or transform text in a stream.

Replace one word:

```bash
sed 's/Bordeaux/Toulouse/' sample.txt
```

Delete the header line:

```bash
sed '1d' sample.txt
```

Replace all commas with semicolons:

```bash
sed 's/,/;/g' sample.txt
```

Edit a file in place on macOS:

```bash
sed -i '' 's/Paris/Lille/' sample.txt
```

### `cut` — Remove Section

Extract selected columns or character ranges.

Show only the `name` column:

```bash
cut -d, -f2 sample.txt
```

Show `name` and `score`:

```bash
cut -d, -f2,4 sample.txt
```

Show the first 10 characters of each line:

```bash
cut -c1-10 sample.txt
```

### `sort` — Sort Lines

Sort text alphabetically or numerically.

Sort by the whole line:

```bash
sort sample.txt
```

Sort by score, numeric, on the 4th field:

```bash
sort -t, -k4,4n sample.txt
```

Sort by score descending:

```bash
sort -t, -k4,4nr sample.txt
```

Remove duplicates after sorting:

```bash
sort names.txt | uniq
```

### `tail` — View End

Show the last lines of a file.

```bash
tail sample.txt
```

Show the last 2 lines:

```bash
tail -n 2 sample.txt
```

Follow a growing log file:

```bash
tail -f app.log
```

### `head` — View Start

Show the first lines of a file.

```bash
head sample.txt
```

Show the first 3 lines:

```bash
head -n 3 sample.txt
```

## File Compression

Create test files:

```bash
mkdir -p demo_zip
echo "report" > demo_zip/report.txt
echo "notes" > demo_zip/notes.txt
```

### `zip` — Compress Files

Compress files into a `.zip` archive.

Zip one file:

```bash
zip sample.zip sample.txt
```

Zip a folder recursively:

```bash
zip -r demo_zip.zip demo_zip
```

List archive contents:

```bash
unzip -l demo_zip.zip
```

### `unzip` — Extract Files

Extract `.zip` archives.

Extract into the current folder:

```bash
unzip demo_zip.zip
```

Extract into a target folder:

```bash
unzip demo_zip.zip -d extracted_zip
```

### `tar` — Archive Files

Create or extract `.tar`, `.tar.gz`, and `.tgz` archives.

Create a plain tar archive:

```bash
tar -cvf demo.tar demo_zip
```

Create a gzipped tar archive:

```bash
tar -czvf demo.tar.gz demo_zip
```

Extract a tar archive:

```bash
tar -xvf demo.tar
```

Extract a gzipped tar archive:

```bash
tar -xzvf demo.tar.gz
```

List archive contents without extracting:

```bash
tar -tvf demo.tar.gz
```

## Cleanup

Remove the test files after practice:

```bash
rm -rf sample.txt sample.zip demo_zip demo_zip.zip extracted_zip demo.tar demo.tar.gz
```

## Summary Table

| Command | Purpose | Example |
|---|---|---|
| `grep` | Search matching text | `grep "Bordeaux" sample.txt` |
| `awk` | Scan fields and patterns | `awk -F, '$4 > 80' sample.txt` |
| `sed` | Replace or edit streamed text | `sed 's/,/;/g' sample.txt` |
| `cut` | Extract columns or character ranges | `cut -d, -f2 sample.txt` |
| `sort` | Sort lines | `sort -t, -k4,4nr sample.txt` |
| `tail` | Show file end | `tail -n 2 sample.txt` |
| `head` | Show file start | `head -n 3 sample.txt` |
| `zip` | Create zip archives | `zip -r demo_zip.zip demo_zip` |
| `unzip` | Extract zip archives | `unzip demo_zip.zip -d extracted_zip` |
| `tar` | Create and extract tar archives | `tar -czvf demo.tar.gz demo_zip` |