---
name: dcg
description: "Destructive Command Guard - A high-performance Rust-based Claude Code hook that blocks dangerous commands (git reset --hard, rm -rf, push --force, etc.) before they execute. Essential safety layer for agent workflows."
---

# DCG — Destructive Command Guard

> **What it is:** A Claude Code hook that intercepts and blocks destructive commands before they execute.
>
> **Why it matters:** When running agent swarms, you want safety rails. DCG prevents catastrophic mistakes like `rm -rf /`, `git push --force`, or `DROP TABLE` from ever running.

---

## Key Features

| Feature | Description |
|---------|-------------|
| **Pre-execution blocking** | Catches dangerous commands BEFORE they run |
| **Modular pack system** | Enable/disable categories of protection |
| **SIMD-accelerated** | Sub-millisecond filtering for zero perceived latency |
| **Contextual suggestions** | Tells you WHY it blocked and suggests safer alternatives |
| **Claude Code native** | Works as a hook in Claude Code's permission system |

---

## What It Blocks

### Git Destructive Operations
- `git reset --hard`
- `git push --force` / `git push -f`
- `git clean -fd`
- `git checkout -- .` (discard all changes)
- `git branch -D` (force delete branch)

### Filesystem Destruction
- `rm -rf /` and variants
- `rm -rf ~`
- `rm -rf .git`
- Commands targeting system directories

### Database Destruction
- `DROP DATABASE`
- `DROP TABLE`
- `TRUNCATE TABLE`
- `DELETE FROM` without WHERE clause

### System Destruction
- `mkfs` / formatting commands
- `dd` targeting disks
- `chmod -R 777 /`
- `chown -R` on system directories

---

## Installation

### Prerequisites
- Rust toolchain (for building from source)
- Claude Code CLI

### Build and Install

```bash
# Clone the repository
git clone https://github.com/Dicklesworthstone/destructive_command_guard.git
cd destructive_command_guard

# Build release binary
cargo build --release

# The binary will be at target/release/destructive_command_guard
```

### Configure Claude Code Hook

Add to your Claude Code settings (`~/.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/destructive_command_guard \"$TOOL_INPUT\""
          }
        ]
      }
    ]
  }
}
```

---

## How It Works

1. **Hook triggers** — Before any Bash command executes, Claude Code calls DCG
2. **Command parsing** — DCG parses the command into tokens
3. **Pattern matching** — SIMD-accelerated matching against known dangerous patterns
4. **Decision** — Either allows (exit 0) or blocks (exit 2 with explanation)
5. **Feedback** — If blocked, provides reason and safer alternative

### Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Command is safe, proceed |
| `2` | Command is blocked, do not execute |

---

## Pack System

DCG uses a modular "pack" system for organizing rules:

### Available Packs

| Pack | Description |
|------|-------------|
| `git` | Git destructive operations |
| `filesystem` | Dangerous file operations |
| `database` | SQL destructive commands |
| `system` | OS-level dangerous commands |
| `network` | Dangerous network operations |

### Configuring Packs

```bash
# Enable specific packs only
destructive_command_guard --packs git,filesystem "rm -rf ."

# Disable specific packs
destructive_command_guard --disable-packs database "DROP TABLE users"
```

---

## Example Blocked Commands

### Git Force Push

```
$ destructive_command_guard "git push --force origin main"

BLOCKED: git push --force

Reason: Force pushing to a shared branch can overwrite others' work
and cause permanent data loss in the remote repository.

Safer alternative: Use `git push --force-with-lease` which fails if
the remote has commits you haven't seen, preventing accidental overwrites.
```

### Recursive Delete

```
$ destructive_command_guard "rm -rf /"

BLOCKED: rm -rf /

Reason: This command would delete your entire filesystem, causing
complete and unrecoverable data loss.

Safer alternative: Specify the exact directory you want to delete,
and consider using `rm -ri` for interactive confirmation.
```

### Hard Reset

```
$ destructive_command_guard "git reset --hard HEAD~5"

BLOCKED: git reset --hard

Reason: Hard reset discards all uncommitted changes and can make
commits unreachable, potentially losing work.

Safer alternative: Use `git stash` to save changes first, or use
`git reset --soft` to keep changes staged.
```

---

## Integration with Agent Swarm Workflow

DCG is essential when running multiple agents:

1. **Install DCG** on all machines running Claude Code agents
2. **Configure as hook** in Claude Code settings
3. **Agents work safely** — destructive commands are caught before execution
4. **Review blocked commands** — check logs to see what was prevented

### Why This Matters for Agent Swarms

When you have 5+ agents working simultaneously:
- Mistakes multiply
- One bad `rm -rf` can destroy hours of work
- Git force pushes can corrupt shared branches
- DCG provides a safety net

---

## Performance

DCG is designed for zero perceived latency:

- **SIMD-accelerated** string matching
- **Sub-millisecond** typical response time
- **Minimal memory** footprint
- **No network calls** — purely local

You won't notice DCG is there until it saves you from disaster.

---

## Customization

### Adding Custom Rules

Create a custom rules file:

```toml
# ~/.config/dcg/custom_rules.toml

[[rules]]
pattern = "my-dangerous-command"
message = "This command is blocked for project-specific reasons"
suggestion = "Use my-safe-command instead"
```

### Allowlisting Specific Commands

For cases where you legitimately need a blocked command:

```bash
# Temporarily bypass DCG (use with extreme caution)
DCG_BYPASS=1 git push --force origin main
```

---

## Best Practices

1. **Always install DCG** before running agent swarms
2. **Don't disable packs** unless you have a specific reason
3. **Review blocked commands** — they often indicate bugs in agent logic
4. **Keep DCG updated** — new dangerous patterns are added regularly
5. **Test your workflow** — ensure DCG doesn't block legitimate operations

---

## Troubleshooting

### DCG blocks a command I need

1. Check if there's a safer alternative (usually there is)
2. If legitimately needed, use the bypass environment variable
3. Consider adding to allowlist if it's a recurring legitimate use

### DCG isn't catching a dangerous command

1. Check that the hook is properly configured
2. Verify DCG binary is in the correct path
3. Report the missing pattern as a GitHub issue

---

## Links

- **Repository:** https://github.com/Dicklesworthstone/destructive_command_guard
- **Issues:** https://github.com/Dicklesworthstone/destructive_command_guard/issues

---

## Integration with Other Flywheel Tools

| Tool | Integration |
|------|-------------|
| **Claude Code** | Native hook integration |
| **Agent Mail** | Agents can report blocked commands to coordinator |
| **BV** | Can flag tasks that repeatedly trigger DCG |
| **CASS** | Summarize DCG logs for review |
