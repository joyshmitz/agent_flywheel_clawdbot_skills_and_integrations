---
name: ntm
description: "Named Tmux Manager - orchestrate multiple AI coding agents (Claude Code, Codex, Gemini) in tiled tmux panes with visual dashboards and command palette."
---

# NTM - Named Tmux Manager

A powerful tmux session management tool for orchestrating multiple AI coding agents in parallel. Spawn, manage, and coordinate agents across tiled panes with a stunning TUI.

## Quick Start

```bash
# Check dependencies
ntm deps -v

# Create a multi-agent session
ntm spawn myproject --cc=2 --cod=1 --gmi=1

# Send a prompt to all Claude agents
ntm send myproject --cc "Explore this codebase and summarize its architecture."

# Open the command palette
ntm palette myproject
```

## Spawning Sessions

Create agent panes with specific counts:

```bash
# Spawn with Claude Code, Codex, and Gemini
ntm spawn projectname --cc=3 --cod=2 --gmi=1

# Quick project setup (creates dir, git init, spawns agents)
ntm quick myproject --template=go
ntm spawn myproject --cc=2

# Spawn in existing directory
ntm spawn ~/projects/existing --cc=2 --cod=1
```

Agent flags:
- `--cc=N` - Claude Code instances
- `--cod=N` - Codex CLI instances
- `--gmi=N` - Gemini CLI instances

## Sending Prompts

Broadcast messages to agents:

```bash
# Send to all Claude agents in session
ntm send myproject --cc "Implement the user auth module"

# Send to all Codex agents
ntm send myproject --cod "Write unit tests for auth"

# Send to all agents of all types
ntm send myproject --all "Review the current codebase state"

# Send to specific pane by name
ntm send myproject --pane myproject__cc_1 "Focus on the API layer"
```

## Session Management

```bash
# List all ntm sessions
ntm list

# Attach to a session
ntm attach myproject

# Detach from current session
# (use standard tmux: Ctrl-b d)

# Kill a session
ntm kill myproject

# Show session status
ntm status myproject
```

## Command Palette

Interactive TUI for session control:

```bash
# Open palette for a session
ntm palette myproject

# Features:
# - Visual pane selection
# - Send prompts to selected panes
# - View agent status
# - Animated gradients and themes
```

## Dashboard

Visual monitoring dashboard:

```bash
# Open dashboard for a session
ntm dashboard myproject

# Shows:
# - All pane statuses
# - Recent activity
# - Context usage
# - File conflicts
```

## Pane Operations

```bash
# List panes in a session
ntm panes myproject

# Focus a specific pane
ntm focus myproject --pane myproject__cc_1

# Get pane output
ntm capture myproject --pane myproject__cc_1

# Zoom a pane (toggle fullscreen)
ntm zoom myproject --pane myproject__cc_1
```

## Shell Integration

Add to your shell config:

```bash
# Add to ~/.zshrc
eval "$(ntm init zsh)"

# Or for bash
eval "$(ntm init bash)"
```

## Interactive Tutorial

```bash
ntm tutorial
```

## Configuration

Config location: `~/.config/ntm/config.toml`

```toml
[defaults]
cc_count = 2
cod_count = 1
gmi_count = 0
projects_dir = "~/projects"

[ui]
theme = "catppuccin"
animations = true
```

## Advanced Features

### Context Monitoring
NTM detects when agents hit context limits and can trigger compaction.

### File Conflict Tracking
Detects when multiple agents modify the same files.

### Notifications
Desktop, webhook, and log notifications for important events.

### Event Logging
JSONL logging of all session activity for audit.

## Project Structure

NTM creates structured panes:
```
Session: myproject
├── myproject__cc_1    (Claude Code #1)
├── myproject__cc_2    (Claude Code #2)
├── myproject__cod_1   (Codex #1)
└── myproject__gmi_1   (Gemini #1)
```
