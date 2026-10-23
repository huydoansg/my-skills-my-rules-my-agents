#!/usr/bin/env bash
# ==============================================================================
# MY-SKILLS-MY-RULES-MY-AGENTS INSTALLER & SYNC TOOL
# Repository: git@github.com:huydoansg/my-skills-my-rules-my-agents.git
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR=""
MODE="symlink" # or "copy"
STACKS=""
GLOBAL=false
WITH_DOCS=false

print_banner() {
  cat << 'EOF'
  __  __         ____  _    _ _ _      __  __         ____        _           
 |  \/  |_   _  / ___|| | _(_) | |___  |  \/  |_   _  |  _ \ _   _| | ___  ___ 
 | |\/| | | | | \___ \| |/ / | | / __| | |\/| | | | | | |_) | | | | |/ _ \/ __|
 | |  | | |_| |  ___) |   <| | | \__ \ | |  | | |_| | |  _ <| |_| | |  __/\__ \
 |_|  |_|\__, | |____/|_|\_\_|_|_|___/ |_|  |_|\__, | |_| \_\\__,_|_|\___||___/
         |___/                                 |___/                            
EOF
  echo "🚀 Enterprise AI Agent Rules & Skills Deployment Tool"
  echo "------------------------------------------------------------------------"
}

usage() {
  cat << EOF
Usage: ./install.sh [OPTIONS]

Options:
  -t, --target <path>      Target project directory to install into
  -m, --mode <symlink|copy> Installation mode: 'symlink' (default) or 'copy'
  -s, --stacks <list>      Comma-separated list of tech stacks to configure
                           Available: aws,typescript-javascript,react,rust,python,golang,
                                      postgresql,docker,kubernetes,gitops,electron,tauri,
                                      sdk-library,all
  -g, --global             Install rules/skills globally into ~/.gemini/config/
  -d, --with-docs          Also create the .docs/ skeleton (adr, plans, research, ...
                           each with an index file) in the target project
  -h, --help               Show this help message

Examples:
  ./install.sh --target /path/to/my-app --stacks typescript-javascript,react,docker
  ./install.sh --target /path/to/my-desktop-app --stacks rust,tauri,postgresql --mode copy
  ./install.sh --target /path/to/my-app --with-docs
  ./install.sh --global
EOF
  exit 0
}

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--target)
      TARGET_DIR="$2"
      shift 2
      ;;
    -m|--mode)
      MODE="$2"
      shift 2
      ;;
    -s|--stacks)
      STACKS="$2"
      shift 2
      ;;
    -g|--global)
      GLOBAL=true
      shift
      ;;
    -d|--with-docs)
      WITH_DOCS=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "❌ Unknown argument: $1"
      usage
      ;;
  esac
done

print_banner

# Global Installation Mode
if [ "$GLOBAL" = true ]; then
  GLOBAL_CONFIG_DIR="$HOME/.gemini/config"
  echo "📦 Installing globally to Antigravity CLI config: $GLOBAL_CONFIG_DIR"
  mkdir -p "$GLOBAL_CONFIG_DIR/skills" "$GLOBAL_CONFIG_DIR/rules"

  for skill_dir in "$SCRIPT_DIR"/skills/*; do
    if [ -d "$skill_dir" ]; then
      skill_name=$(basename "$skill_dir")
      target_skill="$GLOBAL_CONFIG_DIR/skills/$skill_name"
      rm -rf "$target_skill"
      if [ "$MODE" = "symlink" ]; then
        ln -s "$skill_dir" "$target_skill"
        echo "  🔗 Linked skill: $skill_name"
      else
        cp -R "$skill_dir" "$target_skill"
        echo "  📋 Copied skill: $skill_name"
      fi
    fi
  done

  echo "✅ Global installation complete!"
  exit 0
fi

# Target Directory Check
if [ -z "$TARGET_DIR" ]; then
  echo "❌ Error: Target directory is required. Use --target <path> or --global."
  echo "Run ./install.sh --help for instructions."
  exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "📁 Creating target directory: $TARGET_DIR"
  mkdir -p "$TARGET_DIR"
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
echo "🎯 Target Project: $TARGET_DIR"
echo "⚙️ Mode: $MODE"

# Create .agents structure in target
AGENTS_TARGET="$TARGET_DIR/.agents"
mkdir -p "$AGENTS_TARGET/rules" "$AGENTS_TARGET/skills" "$AGENTS_TARGET/templates"
mkdir -p "$TARGET_DIR/.docs"

# 1. Install Core Rules
echo "📦 Installing Core Rules & Pillars..."
for core_file in "$SCRIPT_DIR"/core/*.md; do
  file_name=$(basename "$core_file")
  target_file="$AGENTS_TARGET/rules/$file_name"
  rm -f "$target_file"
  if [ "$MODE" = "symlink" ]; then
    ln -s "$core_file" "$target_file"
  else
    cp "$core_file" "$target_file"
  fi
done
echo "  ✓ Core rules installed (00 to 10)"

# 2. Install Conventions
if [ -z "$STACKS" ] || [ "$STACKS" = "all" ]; then
  SELECTED_STACKS=$(ls "$SCRIPT_DIR/conventions")
else
  IFS=',' read -r -a SELECTED_STACKS <<< "$STACKS"
fi

echo "📦 Installing Tech Stack Conventions..."
mkdir -p "$AGENTS_TARGET/rules/conventions"
for stack in "${SELECTED_STACKS[@]}"; do
  stack=$(echo "$stack" | xargs) # trim whitespace
  source_conv="$SCRIPT_DIR/conventions/$stack/conventions.md"
  if [ -f "$source_conv" ]; then
    target_conv="$AGENTS_TARGET/rules/conventions/$stack.md"
    rm -f "$target_conv"
    if [ "$MODE" = "symlink" ]; then
      ln -s "$source_conv" "$target_conv"
    else
      cp "$source_conv" "$target_conv"
    fi
    echo "  ✓ Stack convention installed: $stack"
  else
    echo "  ⚠️ Warning: Stack '$stack' not found in conventions."
  fi
done

# 3. Install Skills
echo "📦 Installing On-Demand Skills..."
for skill_dir in "$SCRIPT_DIR"/skills/*; do
  if [ -d "$skill_dir" ]; then
    skill_name=$(basename "$skill_dir")
    target_skill="$AGENTS_TARGET/skills/$skill_name"
    rm -rf "$target_skill"
    if [ "$MODE" = "symlink" ]; then
      ln -s "$skill_dir" "$target_skill"
    else
      cp -R "$skill_dir" "$target_skill"
    fi
    echo "  ✓ Skill installed: $skill_name"
  fi
done

# 4. Install Templates
echo "📦 Installing Templates..."
for tpl_file in "$SCRIPT_DIR"/templates/*.md; do
  file_name=$(basename "$tpl_file")
  target_tpl="$AGENTS_TARGET/templates/$file_name"
  rm -f "$target_tpl"
  if [ "$MODE" = "symlink" ]; then
    ln -s "$tpl_file" "$target_tpl"
  else
    cp "$tpl_file" "$target_tpl"
  fi
done
echo "  ✓ Templates installed (architecture-spec, adr, plan, investigation, requirement, verification, developer-guidelines, pr, postmortem, changelog, release-notes, migration-guide, sdk-versioning-policy)"

# 4b. Install workflow description (skills and rules refer to .docs/workflow.md)
workflow_target="$TARGET_DIR/.docs/workflow.md"
rm -f "$workflow_target"
if [ "$MODE" = "symlink" ]; then
  ln -s "$SCRIPT_DIR/workflow/workflow.md" "$workflow_target"
else
  cp "$SCRIPT_DIR/workflow/workflow.md" "$workflow_target"
fi
echo "  ✓ Workflow installed (.docs/workflow.md)"

# 4c. Optional .docs skeleton (never overwrites existing files)
if [ "$WITH_DOCS" = true ]; then
  for sub in adr plans research requirements investigations verifications; do
    mkdir -p "$TARGET_DIR/.docs/$sub"
    index_name="INDEX.md"
    [ "$sub" = "adr" ] && index_name="README.md"
    index_file="$TARGET_DIR/.docs/$sub/$index_name"
    if [ ! -e "$index_file" ]; then
      printf '# %s index\n\n| ID | Title | Status | Link |\n| --- | --- | --- | --- |\n' "$sub" > "$index_file"
    fi
  done
  echo "  ✓ .docs skeleton created (adr, plans, research, requirements, investigations, verifications)"
fi

# 5. Link Master Directives across AI Agents
echo "🔗 Setting up Cross-Agent Entrypoints..."
if [ -f "$TARGET_DIR/AGENTS.md" ] && [ ! -L "$TARGET_DIR/AGENTS.md" ]; then
  echo "  ℹ️ Existing AGENTS.md detected in target. Preserving and integrating..."
  if ! grep -q "Enterprise Skills & Standards Integration" "$TARGET_DIR/AGENTS.md"; then
    cat << 'EOF' >> "$TARGET_DIR/AGENTS.md"

---

## Enterprise Skills & Standards Integration
This repository is augmented with foundational enterprise rules and on-demand skills:
- **Core Directives**:
  - [`00-agent-manifesto`](.agents/rules/00-agent-manifesto.md) — Principal Engineer operating standards
  - [`01-solid-dry-clean-code`](.agents/rules/01-solid-dry-clean-code.md) — SOLID, DRY, and clean architectural boundaries
  - [`02-architectural-pillars`](.agents/rules/02-architectural-pillars.md) — 9 Architectural Pillars (HA, Security, Resilience, Cost...)
  - [`03-verification-loop`](.agents/rules/03-verification-loop.md) — Automated testing, linting, regression prevention loop
  - [`04-documentation-and-diagrams`](.agents/rules/04-documentation-and-diagrams.md) — C4 Model & Mermaid diagram specifications
  - [`05-logging-and-observability`](.agents/rules/05-logging-and-observability.md) — Structured JSON logging, PII masking & 5 checkpoints
  - [`06-technical-writing-and-evidence-grounding`](.agents/rules/06-technical-writing-and-evidence-grounding.md) — Anti-wall-of-text, tables & anti-hallucination
  - [`10-visual-communication`](.agents/rules/10-visual-communication.md) — Diagram encoding, palette, legend & text emphasis
- **On-Demand Skills**:
  - [`arch-designer`](.agents/skills/arch-designer/SKILL.md) — System design workflow with 9 pillars & C4 diagrams
  - [`tech-writer`](.agents/skills/tech-writer/SKILL.md) — High-signal technical documentation & diagram crafting
  - [`log-investigator`](.agents/skills/log-investigator/SKILL.md) — Log-driven incident investigation & root cause discovery
  - [`desktop-app-hardening`](.agents/skills/desktop-app-hardening/SKILL.md) — Desktop app security auditing (Electron & Tauri)
  - [`rust-optimizer`](.agents/skills/rust-optimizer/SKILL.md) — Rust performance profiling & safety auditing
  - [`code-auditor`](.agents/skills/code-auditor/SKILL.md) — Full codebase audit against SOLID, DRY & OWASP
EOF
    echo "  ✓ Appended Enterprise Directives to AGENTS.md"
  else
    echo "  ✓ AGENTS.md already contains Enterprise Integration"
  fi
  # Workflow policy block: idempotent, delimited by markers
  POLICY_BEGIN="<!-- BEGIN my-skills-policy -->"
  POLICY_END="<!-- END my-skills-policy -->"
  if grep -q "$POLICY_BEGIN" "$TARGET_DIR/AGENTS.md"; then
    echo "  ✓ AGENTS.md already contains the workflow policy block (left unchanged)"
  else
    {
      echo ""
      echo "$POLICY_BEGIN"
      cat "$SCRIPT_DIR/snippets/agents-policy.md"
      echo "$POLICY_END"
    } >> "$TARGET_DIR/AGENTS.md"
    echo "  ✓ Appended workflow policy block to AGENTS.md"
  fi
else
  rm -f "$TARGET_DIR/AGENTS.md"
  if [ "$MODE" = "symlink" ]; then
    ln -s "$SCRIPT_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
  else
    cp "$SCRIPT_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
  fi
  echo "  ✓ Configured master AGENTS.md"
fi

# CLAUDE.md
if [ ! -f "$TARGET_DIR/CLAUDE.md" ] || [ -L "$TARGET_DIR/CLAUDE.md" ]; then
  rm -f "$TARGET_DIR/CLAUDE.md"
  ln -sf "AGENTS.md" "$TARGET_DIR/CLAUDE.md"
  echo "  ✓ Linked CLAUDE.md"
fi

# .cursorrules
if [ ! -f "$TARGET_DIR/.cursorrules" ] || [ -L "$TARGET_DIR/.cursorrules" ]; then
  rm -f "$TARGET_DIR/.cursorrules"
  ln -sf "AGENTS.md" "$TARGET_DIR/.cursorrules"
  echo "  ✓ Linked .cursorrules"
fi

# GitHub Copilot / Codex
mkdir -p "$TARGET_DIR/.github"
if [ ! -f "$TARGET_DIR/.github/copilot-instructions.md" ] || [ -L "$TARGET_DIR/.github/copilot-instructions.md" ]; then
  rm -f "$TARGET_DIR/.github/copilot-instructions.md"
  if [ "$MODE" = "symlink" ]; then
    ln -s "$SCRIPT_DIR/.github/copilot-instructions.md" "$TARGET_DIR/.github/copilot-instructions.md"
  else
    cp "$SCRIPT_DIR/.github/copilot-instructions.md" "$TARGET_DIR/.github/copilot-instructions.md"
  fi
  echo "  ✓ Configured .github/copilot-instructions.md"
fi

echo "------------------------------------------------------------------------"
echo "🎉 SUCCESS! Your repository is now empowered with enterprise AI agent rules."
echo "Agents supported: Antigravity, Claude Code, Cursor, Copilot, Codex, Windsurf."
