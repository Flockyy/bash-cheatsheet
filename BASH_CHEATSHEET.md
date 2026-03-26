# Bash Cheat Sheet

Quick reference for common Bash commands used in text processing, file compression and scripting, with detailed explanations and runnable examples.

---

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

---

## Text Processing

### `grep` — Search Text

**Syntax:** `grep [OPTIONS] PATTERN [FILE...]`

`grep` scans each line of a file and prints lines that match the given pattern.  
The pattern is a regular expression by default (BRE), or ERE with `-E`.

| Flag | Meaning |
|------|---------|
| `-i` | Case-insensitive match |
| `-n` | Prefix each result with its line number |
| `-v` | Invert match — print lines that do NOT match |
| `-c` | Print only the count of matching lines |
| `-l` | Print only the file names that contain a match |
| `-r` | Recurse into directories |
| `-E` | Use extended regex (allows `+`, `?`, `\|`, `()` without escaping) |
| `-w` | Match whole words only |
| `-A N` | Print N lines After each match |
| `-B N` | Print N lines Before each match |

Basic search:

```bash
grep "Bordeaux" sample.txt
```

```text
1,Alice,Bordeaux,88
3,Charlie,Bordeaux,92
5,Eric,Bordeaux,75
```

Common variants:

```bash
grep -i "bordeaux" sample.txt      # case-insensitive
grep -n "Bordeaux" sample.txt      # show line numbers
grep -v "Bordeaux" sample.txt      # lines NOT matching
grep -c "Bordeaux" sample.txt      # just the count → 3
grep -E "Alice|Bob" sample.txt     # OR pattern with extended regex
grep -w "75" sample.txt            # whole-word match (not "750")
grep -A1 "Charlie" sample.txt      # match + 1 line after
```

Using a regex pattern (scores starting with 8):

```bash
grep -E ",8[0-9]$" sample.txt
```

```text
1,Alice,Bordeaux,88
4,Diana,Lyon,81
```

### `awk` — Pattern Scan & Report

**Syntax:** `awk [OPTIONS] 'PROGRAM' [FILE...]`

`awk` reads input line by line, splits each line into fields, and runs a program against them.  
A program is made of `condition { action }` blocks. Both are optional — omitting the condition runs the action on every line.

**Key built-in variables:**

| Variable | Meaning |
|----------|---------|
| `$0` | The whole current line |
| `$1`, `$2`, … | Field 1, field 2, … |
| `NF` | Number of fields on the current line |
| `NR` | Current line number (record number) |
| `FS` | Input field separator (same as `-F`) |
| `OFS` | Output field separator |

| Flag/Block | Meaning |
|------------|---------|
| `-F,` | Set the field separator to `,` |
| `BEGIN { }` | Run once before reading any line |
| `END { }` | Run once after all lines are read |
| `NR > 1` | Condition: skip the header row |

Print names where city is Bordeaux:

```bash
awk -F, '$3 == "Bordeaux" {print $2}' sample.txt
```

```text
Alice
Charlie
Eric
```

Sum all scores (skip header with `NR > 1`):

```bash
awk -F, 'NR > 1 {sum += $4} END {print "Total:", sum}' sample.txt
```

```text
Total: 411
```

Compute the average score:

```bash
awk -F, 'NR > 1 {sum += $4; count++} END {printf "Avg: %.1f\n", sum/count}' sample.txt
```

Filter rows with score > 80 and reprint them:

```bash
awk -F, 'NR == 1 || $4 > 80' sample.txt
```

Add a computed column (score × 2):

```bash
awk -F, 'NR == 1 {print $0 ",doubled"} NR > 1 {print $0 "," $4*2}' sample.txt
```

Change the output separator to `;`:

```bash
awk -F, 'BEGIN{OFS=";"} {$1=$1; print}' sample.txt
```

### `sed` — Stream Editor

**Syntax:** `sed [OPTIONS] 'SCRIPT' [FILE...]`

`sed` reads each line, applies transformation commands from the script, and writes the result to stdout.  
The most common command is `s/PATTERN/REPLACEMENT/FLAGS` (substitute).

| Flag / Command | Meaning |
|----------------|---------|
| `s/old/new/` | Replace the first occurrence on each line |
| `s/old/new/g` | Replace **all** occurrences (global) |
| `s/old/new/i` | Case-insensitive replacement |
| `Nd` | Delete line N |
| `Np` | Print line N |
| `/pattern/d` | Delete lines matching pattern |
| `/pattern/p` | Print lines matching pattern |
| `-n` | Suppress default output (useful with `p`) |
| `-i ''` | Edit the file **in-place** (macOS requires `''`) |
| `-E` | Use extended regex |

Replace one word:

```bash
sed 's/Bordeaux/Toulouse/' sample.txt
```

Replace all commas with semicolons (global flag):

```bash
sed 's/,/;/g' sample.txt
```

Delete the header line (line 1):

```bash
sed '1d' sample.txt
```

Delete lines containing "Paris":

```bash
sed '/Paris/d' sample.txt
```

Print only lines that match (suppress others with `-n`):

```bash
sed -n '/Bordeaux/p' sample.txt
```

Edit a file in place on macOS:

```bash
sed -i '' 's/Paris/Lille/' sample.txt
```

Add a `#` prefix to every line:

```bash
sed 's/^/# /' sample.txt
```

### `cut` — Extract Columns

**Syntax:** `cut OPTION [FILE...]`

`cut` removes sections from each line. You select by delimiter+field or by character position.  
It does not reorder fields — use `awk` if you need custom ordering.

| Flag | Meaning |
|------|---------|
| `-d CHAR` | Set the field delimiter (default is TAB) |
| `-f LIST` | Select fields by number (e.g. `2`, `1,3`, `2-4`) |
| `-c LIST` | Select characters by position (e.g. `1-5`, `3`) |
| `--complement` | Invert selection |

Show only the `name` column:

```bash
cut -d, -f2 sample.txt
```

Show `name` and `score` (non-contiguous fields):

```bash
cut -d, -f2,4 sample.txt
```

Show columns 2 to 4 (range):

```bash
cut -d, -f2-4 sample.txt
```

Show only the first 10 characters of each line:

```bash
cut -c1-10 sample.txt
```

Drop the first field (complement):

```bash
cut -d, -f1 --complement sample.txt
```

### `sort` — Sort Lines

**Syntax:** `sort [OPTIONS] [FILE...]`

`sort` reads all lines and outputs them in sorted order. By default it sorts lexicographically (dictionary order) on the full line.

| Flag | Meaning |
|------|---------|
| `-t CHAR` | Set the field delimiter |
| `-k POS` | Sort by field at position POS (e.g. `-k4,4` = field 4 only) |
| `-n` | Numeric sort (so `10` > `9`, not `"10" < "9"`) |
| `-r` | Reverse order |
| `-u` | Remove duplicate lines (unique) |
| `-f` | Case-insensitive sort |
| `-h` | Human-readable numbers (`1K`, `2M`, …) |

Sort the whole file lexicographically:

```bash
sort sample.txt
```

Sort by score field numerically (ascending):

```bash
sort -t, -k4,4n sample.txt
```

Sort by score descending (highest first):

```bash
sort -t, -k4,4nr sample.txt
```

Sort by city name, then by score descending:

```bash
sort -t, -k3,3 -k4,4nr sample.txt
```

Remove duplicate lines after sorting:

```bash
sort -u names.txt
```

Count unique cities:

```bash
cut -d, -f3 sample.txt | sort -u | grep -v "^city$"
```

### `tail` — View End of File

**Syntax:** `tail [OPTIONS] [FILE...]`

`tail` outputs the last part of a file (10 lines by default). The `-f` flag is essential for monitoring live logs.

| Flag | Meaning |
|------|---------|
| `-n N` | Show last N lines |
| `-n +N` | Show all lines starting from line N |
| `-f` | Follow — keep watching and print new lines as they are appended |
| `-c N` | Show last N bytes |

Show the last 10 lines (default):

```bash
tail sample.txt
```

Show the last 2 lines:

```bash
tail -n 2 sample.txt
```

Show all lines from line 3 onward (skip header):

```bash
tail -n +2 sample.txt
```

Follow a growing log file in real time:

```bash
tail -f app.log
```

Show the last 50 lines and keep following:

```bash
tail -n 50 -f app.log
```

### `head` — View Start of File

**Syntax:** `head [OPTIONS] [FILE...]`

`head` outputs the first part of a file (10 lines by default). Useful for previewing large files without loading them entirely.

| Flag | Meaning |
|------|---------|
| `-n N` | Show first N lines |
| `-c N` | Show first N bytes |

Show the first 10 lines (default):

```bash
head sample.txt
```

Show only the header row:

```bash
head -n 1 sample.txt
```

Show first 3 lines:

```bash
head -n 3 sample.txt
```

Preview the first 100 bytes:

```bash
head -c 100 sample.txt
```

---

## File Compression

Create test files:

```bash
mkdir -p demo_zip
echo "report" > demo_zip/report.txt
echo "notes"  > demo_zip/notes.txt
```

### `zip` — Compress to `.zip`

**Syntax:** `zip [OPTIONS] ARCHIVE.zip FILE...`

| Flag | Meaning |
|------|---------|
| `-r` | Recurse into directories |
| `-9` | Maximum compression level |
| `-e` | Encrypt with a password |
| `-u` | Update — add/replace only changed files |
| `-d` | Delete a file from an existing archive |

Zip a single file:

```bash
zip sample.zip sample.txt
```

Zip a folder recursively:

```bash
zip -r demo_zip.zip demo_zip
```

Zip with maximum compression:

```bash
zip -r -9 demo_zip.zip demo_zip
```

List archive contents:

```bash
unzip -l demo_zip.zip
```

### `unzip` — Extract `.zip`

**Syntax:** `unzip [OPTIONS] ARCHIVE.zip`

| Flag | Meaning |
|------|---------|
| `-l` | List contents without extracting |
| `-d DIR` | Extract into directory DIR |
| `-o` | Overwrite existing files without prompting |
| `-q` | Quiet mode |

Extract into the current folder:

```bash
unzip demo_zip.zip
```

Extract into a specific folder:

```bash
unzip demo_zip.zip -d extracted_zip
```

Preview contents without extracting:

```bash
unzip -l demo_zip.zip
```

### `tar` — Archive Files

**Syntax:** `tar [OPTIONS] ARCHIVE [FILE...]`

`tar` groups files into a single archive. Add `-z` for gzip compression (`.tar.gz`) or `-j` for bzip2 (`.tar.bz2`).

**Key flags — remember `c`reate / e`x`tract / lis`t`:**

| Flag | Meaning |
|------|---------|
| `-c` | Create a new archive |
| `-x` | Extract an archive |
| `-t` | List archive contents |
| `-v` | Verbose — print each file name |
| `-f FILE` | Specify the archive file name (always needed) |
| `-z` | Filter through gzip (`.tar.gz` / `.tgz`) |
| `-j` | Filter through bzip2 (`.tar.bz2`) — better compression, slower |
| `-C DIR` | Extract into directory DIR |
| `--exclude=PATTERN` | Exclude matching files |

Create a plain tar archive:

```bash
tar -cvf demo.tar demo_zip
```

Create a gzipped archive (common format):

```bash
tar -czvf demo.tar.gz demo_zip
```

Extract into the current folder:

```bash
tar -xzvf demo.tar.gz
```

Extract into a specific folder:

```bash
tar -xzvf demo.tar.gz -C /tmp/extracted
```

List contents without extracting:

```bash
tar -tvf demo.tar.gz
```

Exclude a subdirectory when archiving:

```bash
tar -czvf demo.tar.gz demo_zip --exclude='demo_zip/notes.txt'
```
