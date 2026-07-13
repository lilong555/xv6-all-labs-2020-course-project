#!/usr/bin/env bash
set -euo pipefail

ROOT=$(git rev-parse --show-toplevel)
WORKTREE_ROOT="$ROOT/.worktrees"
LOG_ROOT="$ROOT/artifacts/grades"
LABS=(util syscall pgtbl traps lazy cow thread lock fs mmap net)

for tool in git make python python3 qemu-system-riscv64 riscv64-linux-gnu-gcc timeout; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required tool: $tool" >&2
    exit 1
  fi
done

mkdir -p "$WORKTREE_ROOT" "$LOG_ROOT"
git worktree prune

passed=0
failed=0
printf '%-10s %-8s %s\n' LAB RESULT SCORE
printf '%-10s %-8s %s\n' ---------- -------- -----

for lab in "${LABS[@]}"; do
  worktree="$WORKTREE_ROOT/$lab"
  log="$LOG_ROOT/$lab.log"
  cpus=${XV6_CPUS:-1}
  if [[ "$lab" == "lock" ]]; then
    cpus=${XV6_LOCK_CPUS:-3}
  fi

  if [[ -e "$worktree/.git" ]]; then
    git worktree remove --force "$worktree" >/dev/null
  fi
  git worktree add --force --detach "$worktree" "$lab" >/dev/null

  # One vCPU is faster under TCG for functional labs; lock needs concurrency.
  if (cd "$worktree" && timeout 900 make grade CPUS="$cpus") >"$log" 2>&1; then
    score=$(grep -a 'Score:' "$log" | tail -n 1 | sed 's/.*Score:/Score:/')
    printf '%-10s %-8s %s\n' "$lab" PASS "${score:-completed}"
    passed=$((passed + 1))
  else
    printf '%-10s %-8s %s\n' "$lab" FAIL "see $log"
    failed=$((failed + 1))
  fi

  git worktree remove --force "$worktree" >/dev/null 2>&1 || true
done

echo
echo "Passed: $passed/${#LABS[@]}; Failed: $failed"
echo "Logs: $LOG_ROOT"
[[ "$failed" -eq 0 ]]
