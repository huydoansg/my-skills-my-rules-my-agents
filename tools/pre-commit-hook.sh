#!/bin/sh
# Installed by install.sh as .git/hooks/pre-commit. Works for any agent or human.
exec "$(git rev-parse --show-toplevel)/.agents/tools/check-modularity.sh" --staged
