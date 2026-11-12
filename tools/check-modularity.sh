#!/bin/sh
# check-modularity: keep files small and single-responsibility. Agent-agnostic (POSIX sh + awk).
#
# Usage: check-modularity.sh [SCOPE] [--init | --shrink]
#   SCOPE (default: files changed vs HEAD, incl. untracked)
#     --staged        files in the git index (pre-commit)
#     --base <ref>    files changed since <ref> (CI: --base origin/main)
#     --all           every tracked file
#   --init            write .agents/size-baseline with every current violator (adoption, once;
#                     refused when a baseline exists)
#   --shrink          lower baseline entries / drop fixed files / follow renames; never raises or adds
#
# Silent and exit 0 when clean. Exit 1 on a block-level violation.
# Ratchet: a file already over a block limit is listed in the baseline and may not grow.
set -eu

SCOPE=changed BASE=HEAD ACTION=check
while [ $# -gt 0 ]; do
  case "$1" in
    --staged) SCOPE=staged ;;
    --all) SCOPE=all ;;
    --base) SCOPE=base; BASE="${2:?--base needs a ref}"; shift ;;
    --init) ACTION=init; SCOPE=all ;;
    --shrink) ACTION=shrink; SCOPE=all ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    *) echo "check-modularity: unknown argument $1" >&2; exit 2 ;;
  esac
  shift
done

set -f  # globs from .agents/limits are case patterns, never pathname expansions

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "check-modularity: not a git repo" >&2; exit 2; }
cd "$ROOT"
HERE=$(cd "$(dirname "$0")" && pwd)
CFG=.agents/limits; [ -f "$CFG" ] || CFG="$HERE/limits.default"
BASELINE=.agents/size-baseline
SKILL=.agents/skills/split-module/SKILL.md
MAXOUT=10
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT INT TERM

# --- file list -------------------------------------------------------------
case "$SCOPE" in
  all) git ls-files ;;
  staged) git diff --cached --name-only --diff-filter=ACMR ;;
  base) git diff --name-only --diff-filter=ACMR "$BASE"...HEAD 2>/dev/null || git diff --name-only --diff-filter=ACMR "$BASE" ;;
  changed) { git diff --name-only --diff-filter=ACMR HEAD 2>/dev/null; git ls-files --others --exclude-standard; } ;;
esac | sort -u > "$TMP/files"

# rename map "new<TAB>old" so a moved file keeps its baseline entry
case "$SCOPE" in
  staged) git diff --cached -M --name-status ;;
  base) git diff -M --name-status "$BASE"...HEAD 2>/dev/null || true ;;
  changed) git diff -M --name-status HEAD 2>/dev/null || true ;;
  *) true ;;
esac | awk -F'\t' '$1 ~ /^R/ {print $3 "\t" $2}' > "$TMP/renames"

matches() { # $1=file $2=comma-separated globs
  _old=$IFS; IFS=,
  for _g in $2; do
    IFS=$_old
    # shellcheck disable=SC2254
    case "$1" in $_g) return 0 ;; esac
    IFS=,
  done
  IFS=$_old; return 1
}

SYM=$(awk '$1=="symbols"{print $2, $3, $4, $5}' "$CFG"); SYM=${SYM:-"3 5 15 25"}
set -- $SYM; TW=$1 TB=$2 FW=$3 FB=$4

measure() { # prints: lines types funcs
  awk '
    BEGIN { m = "(export[ \t]+|default[ \t]+|pub(\\([a-z]+\\))?[ \t]+|public[ \t]+|private[ \t]+|internal[ \t]+|abstract[ \t]+|final[ \t]+|sealed[ \t]+|open[ \t]+|data[ \t]+|static[ \t]+|partial[ \t]+|declare[ \t]+|async[ \t]+|unsafe[ \t]+|extern[ \t]+)*" }
    { n++ }
    $0 ~ ("^" m "(class|struct|enum|interface|trait|protocol|record|object|union)[ \t]+[A-Za-z_]") { t++ }
    $0 ~ "^type[ \t]+[A-Za-z_][A-Za-z0-9_]*[ \t]+(struct|interface)" { t++ }
    $0 ~ ("^" m "(function\\*?|def|fn|func)[ \t]+[A-Za-z_(]") { f++ }
    $0 ~ "^(export[ \t]+)?(const|let)[ \t]+[A-Za-z_$][A-Za-z0-9_$]*[ \t]*(:[^=]*)?=[ \t]*(async[ \t]*)?(function|\\([^)]*\\)[^=]*=>|[A-Za-z_$][A-Za-z0-9_$]*[ \t]*=>)" { f++ }
    END { print n + 0, t + 0, f + 0 }' "$1"
}

# content to check: the staged blob in --staged mode, else the working-tree file.
# prints the path to read, or nothing when the entry must be skipped (symlink, submodule, missing)
source_of() {
  if [ "$SCOPE" = staged ]; then
    mode=$(git ls-files -s -- "$1" | cut -d' ' -f1)
    case "$mode" in 100644|100755) ;; *) return 0 ;; esac
    git show ":$1" > "$TMP/blob" 2>/dev/null || return 0
    echo "$TMP/blob"
  else
    [ -f "$1" ] && [ ! -L "$1" ] && echo "$1"
    return 0
  fi
}

: > "$TMP/viol"; : > "$TMP/warn"; : > "$TMP/current"
while IFS= read -r f; do
  exempt=0
  while read -r kw globs _; do
    [ "$kw" = exempt ] && matches "$f" "$globs" && { exempt=1; break; }
  done < "$CFG"
  [ "$exempt" = 0 ] || continue
  src=$(source_of "$f"); [ -n "$src" ] || continue
  grep -Iq . "$src" 2>/dev/null || continue          # skip binary / empty
  LW=300 LB=500
  while read -r kw globs w b; do
    [ "$kw" = limit ] && matches "$f" "$globs" && { LW=$w LB=$b; break; }
  done < "$CFG"
  set -- $(measure "$src"); L=$1 T=$2 F=$3
  H=$(cksum < "$src" | cut -d' ' -f1)
  reasons="" level=""
  [ "$L" -gt "$LB" ] && { reasons="$reasons lines $L>$LB"; level=block; }
  [ "$T" -gt "$TB" ] && { reasons="$reasons types $T>$TB (several modules in one file)"; level=block; }
  [ "$F" -gt "$FB" ] && { reasons="$reasons functions $F>$FB"; level=block; }
  if [ -z "$level" ]; then
    [ "$L" -gt "$LW" ] && reasons="$reasons lines $L>$LW"
    [ "$T" -gt "$TW" ] && reasons="$reasons types $T>$TW"
    [ "$F" -gt "$FW" ] && reasons="$reasons functions $F>$FW"
    [ -n "$reasons" ] && level=warn
  fi
  printf '%s\t%s\t%s\t%s\t%s\n' "$f" "$L" "$T" "$F" "$H" >> "$TMP/current"
  [ -n "$level" ] || continue
  echo "$level	$L	$f	$T	$F	$H	$reasons" >> "$TMP/viol"
done < "$TMP/files"

# --- baseline actions ---------------------------------------------------------
case "$ACTION" in
  init)
    if [ -f "$BASELINE" ]; then
      echo "check-modularity: $BASELINE exists; --init is for first adoption only. Use --shrink." >&2; exit 2
    fi
    awk -F'\t' '$1=="block"{print $3 "\t" $2 "\t" $4 "\t" $5 "\t" $6}' "$TMP/viol" | sort > "$BASELINE"
    echo "check-modularity: baseline written ($(wc -l < "$BASELINE" | tr -d ' ') files) -> $BASELINE"; exit 0 ;;
  shrink)
    [ -f "$BASELINE" ] || { echo "check-modularity: no baseline"; exit 0; }
    # an entry whose path is gone follows its content hash (rename); min() so nothing is raised
    awk -F'\t' 'NR==FNR { cur[$1]=$0; byhash[$5]=$0; next }
      { if ($1 in cur) row = cur[$1]; else if ($5 in byhash) row = byhash[$5]; else next
        split(row, c, "\t")
        print c[1] "\t" (c[2] < $2 ? c[2] : $2) "\t" (c[3] < $3 ? c[3] : $3) "\t" (c[4] < $4 ? c[4] : $4) "\t" c[5] }' \
      "$TMP/current" "$BASELINE" > "$TMP/newbase"
    # drop entries that no longer violate
    awk -F'\t' 'NR==FNR { if ($1=="block") b[$3]=1; next } ($1 in b)' "$TMP/viol" "$TMP/newbase" | sort > "$BASELINE"
    echo "check-modularity: baseline shrunk -> $(wc -l < "$BASELINE" | tr -d ' ') files"; exit 0 ;;
esac

# --- evaluate against the ratchet -------------------------------------------------
FAIL=0; : > "$TMP/out"
while IFS='	' read -r level L f T F H reasons; do
  if [ "$level" = block ]; then
    old=$f
    [ -f "$TMP/renames" ] && r=$(awk -F'\t' -v n="$f" '$1==n{print $2}' "$TMP/renames") && [ -n "$r" ] && old=$r
    entry=""
    if [ -f "$BASELINE" ]; then
      entry=$(awk -F'\t' -v p="$old" '$1==p {print; exit}' "$BASELINE")
      # hash fallback only for a pure rename: the baselined path must no longer exist (a copy does not inherit)
      [ -n "$entry" ] || entry=$(awk -F'\t' -v h="$H" '$5==h {print}' "$BASELINE" | while IFS= read -r row; do
        bp=${row%%	*}
        if [ "$SCOPE" = staged ]; then
          git ls-files --error-unmatch -- "$bp" >/dev/null 2>&1 && continue
        else
          [ -e "$bp" ] && continue
        fi
        echo "$row"; break
      done)
    fi
    if [ -n "$entry" ]; then
      bl=$(echo "$entry" | cut -f2); bt=$(echo "$entry" | cut -f3); bf=$(echo "$entry" | cut -f4)
      if [ "$L" -gt "$bl" ] || [ "$T" -gt "$bt" ] || [ "$F" -gt "$bf" ]; then
        echo "BLOCK $f grew past baseline (lines $bl->$L, types $bt->$T, funcs $bf->$F): split instead of adding" >> "$TMP/out"; FAIL=1
      else
        [ "$SCOPE" = all ] || echo "LEGACY $f over limit but not growing (lines $L): shrink when you touch it" >> "$TMP/out"
      fi
    else
      echo "BLOCK $f:$reasons" >> "$TMP/out"; FAIL=1
    fi
  else
    echo "WARN $f:$reasons" >> "$TMP/out"
  fi
done < "$TMP/viol"

if [ -s "$TMP/out" ]; then
  total=$(wc -l < "$TMP/out" | tr -d ' ')
  sort "$TMP/out" | head -n "$MAXOUT"
  [ "$total" -gt "$MAXOUT" ] && echo "... +$((total - MAXOUT)) more"
  [ "$FAIL" = 1 ] && echo "One responsibility per file. Split by responsibility: $SKILL"
fi
exit "$FAIL"
