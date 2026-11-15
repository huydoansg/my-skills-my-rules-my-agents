#!/bin/sh
# Regression tests for tools/check-modularity.sh. Usage: sh tests/check-modularity.test.sh .
set -u
KIT=$1; PASS=0; FAILN=0
ok() { PASS=$((PASS+1)); echo "ok   $1"; }
ko() { FAILN=$((FAILN+1)); echo "FAIL $1"; }
expect() { # name expected-exit cmd...
  name=$1 want=$2; shift 2
  out=$("$@" 2>&1); got=$?
  if [ "$got" = "$want" ]; then ok "$name"; else ko "$name (exit $got, want $want): $out"; fi
}
new_repo() {
  D=$(mktemp -d); cd "$D"; git init -q; git config user.email t@t; git config user.name t
  mkdir -p .agents/tools; cp "$KIT"/tools/* .agents/tools/; cp "$KIT/tools/limits.default" .agents/limits
  S=.agents/tools/check-modularity.sh
}
gen() { seq 1 "$2" | sed 's/^/x = /' > "$1"; }
commit() { git add -A && git commit -qm "$1"; }

# 1. glob expansion: root README.md must not break nested *.md exemption
new_repo; echo hi > README.md; mkdir -p docs src tests; gen docs/guide.md 900; gen tests/a_test.py 600; commit base
expect "nested .md exempt with root README.md" 0 $S --all
expect "tests/ file uses test limit (600<800)" 0 $S --all

# 4. root-level vendor/migrations exempt
new_repo; mkdir -p vendor migrations; gen vendor/lib.go 900; gen migrations/0001.py 900; commit base
expect "root vendor/ and migrations/ exempt" 0 $S --all

# 2. staged reads the index, not the working tree
new_repo; gen src.py 10; commit base; gen src.py 700; git add src.py; gen src.py 10
expect "staged blob 700 lines blocks even if worktree small" 1 $S --staged
git reset -q; gen src.py 700; echo "" > /dev/null
git add src.py; git stash -q --keep-index 2>/dev/null; gen src.py 10; git add src.py; gen src.py 700
expect "staged small passes even if worktree big" 0 $S --staged

# baseline: legacy allowed, growth blocked
new_repo; gen big.py 600; commit base; $S --init >/dev/null
expect "legacy not growing passes" 0 $S --all
echo "x=1" >> big.py
expect "legacy growth blocks" 1 $S
git checkout -q big.py

# 6. --init refused when baseline exists
expect "--init refused when baseline exists" 2 $S --init

# 5. copy of legacy file does not inherit baseline
cp big.py copy.py; git add copy.py
expect "copy of legacy file blocks" 1 $S --staged
git rm -q --cached copy.py; rm copy.py

# rename keeps baseline (staged)
git mv big.py moved.py
expect "staged rename keeps baseline" 0 $S --staged
commit mv

# 7. --shrink follows the rename
$S --shrink >/dev/null
if grep -q '^moved.py' .agents/size-baseline; then ok "--shrink follows rename"; else ko "--shrink follows rename: $(cat .agents/size-baseline)"; fi
gen moved.py 550
expect "renamed legacy shrinking passes" 0 $S
$S --shrink >/dev/null
if grep -q '^moved.py	550' .agents/size-baseline; then ok "--shrink lowers"; else ko "--shrink lowers: $(cat .agents/size-baseline)"; fi
gen moved.py 560
expect "growth after shrink blocks" 1 $S

# 9. parenthesised constants are not functions
new_repo; i=0; : > c.ts; while [ $i -lt 30 ]; do echo "export const K$i = (60 * $i);" >> c.ts; i=$((i+1)); done; commit base
expect "parenthesised consts are not functions" 0 $S --all
i=0; : > f.ts; while [ $i -lt 30 ]; do echo "export const f$i = (a: number) => a;" >> f.ts; i=$((i+1)); done; commit fns
expect "30 arrow functions block" 1 $S --all

# several modules in one short file
new_repo; : > m.py; for c in A B C D E F; do printf 'class %s:\n    pass\n' $c >> m.py; done; commit base
expect "6 classes in one file block" 1 $S --all

# clean is silent
new_repo; gen ok.py 20; commit base
out=$($S --all 2>&1); if [ -z "$out" ]; then ok "silent when clean"; else ko "silent when clean: $out"; fi

echo "passed $PASS, failed $FAILN"; [ "$FAILN" = 0 ]
