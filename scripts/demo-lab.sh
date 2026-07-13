#!/usr/bin/env bash
set -euo pipefail

LABS=" util syscall pgtbl traps lazy cow thread lock fs mmap net "
lab=${1:-}

if [[ -z "$lab" || "$LABS" != *" $lab "* ]]; then
  echo "Usage: $0 {util|syscall|pgtbl|traps|lazy|cow|thread|lock|fs|mmap|net}" >&2
  exit 1
fi

ROOT=$(git rev-parse --show-toplevel)
worktree="$ROOT/.worktrees/demo-$lab"

git worktree prune
if [[ -e "$worktree/.git" ]]; then
  git worktree remove --force "$worktree" >/dev/null
fi
git worktree add --force --detach "$worktree" "$lab" >/dev/null

echo "Starting xv6 from branch '$lab'."
echo "Exit QEMU with Ctrl-a, then x."
cd "$worktree"
exec make qemu
