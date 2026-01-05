---
name: cass
description: "Coding Agent Session Search - unified TUI to index and search local coding agent history from Claude Code, Codex, Gemini, Cursor, Aider, and more."
---

# CASS - Coding Agent Session Search

Unified, high-performance TUI to index and search your local coding agent history. Aggregates sessions from Codex, Claude Code, Gemini CLI, Cline, Cursor, ChatGPT, Aider, and more.

## Quick Start

```bash
# Launch TUI
cass tui

# Or just
cass
```

## Indexing

```bash
# Run indexer to scan all agent sessions
cass index

# Check index status
cass status

# Show statistics
cass stats
```

## Search

### Interactive TUI

```bash
cass tui
```

TUI features:
- Three-pane layout: filter, results, preview
- Color-coded agents
- Syntax-highlighted code blocks
- Fuzzy search

### CLI Search

```bash
# One-off search
cass search "authentication error"

# Search with filters
cass search "database" --agent claude
cass search "react hooks" --after "2024-01-01"

# Output as JSON
cass search "api endpoint" --json
```

## Robot Mode (for AI Agents)

Machine-readable commands:

```bash
# Deterministic help output
cass --robot-help

# API version info
cass api-version

# Full API introspection
cass introspect

# Capabilities discovery
cass capabilities

# Health check (fast, for pre-flight)
cass health
```

## Viewing Results

```bash
# View source file at line
cass view /path/to/file.ts:42

# Export conversation to markdown
cass export SESSION_ID --format md > session.md

# Expand context around a line
cass expand SESSION_FILE --line 100 --context 20
```

## Timeline

```bash
# Show activity timeline
cass timeline --range "7d"
cass timeline --range "2024-01-01..2024-01-31"
```

## Context Discovery

Find related sessions for a file:

```bash
cass context /path/to/source.ts
```

## Diagnostics

```bash
# Full diagnostics
cass diag

# Quick status check
cass status

# Stats about indexed data
cass stats
```

## Supported Agents

CASS indexes sessions from:
- Claude Code
- Codex CLI
- Gemini CLI
- Cursor
- Cline
- OpenCode
- Amp
- ChatGPT (exports)
- Aider
- Pi-Agent
- Factory (Droid)

## Configuration

Database location: Platform-specific data dir, or use `--db` flag.

```bash
# Use custom database
cass --db /path/to/cass.db tui

# Verbose mode
cass -v index

# Quiet mode
cass -q search "error"
```

## Shell Completions

```bash
# Generate completions
cass completions zsh > _cass
cass completions bash > cass.bash
cass completions fish > cass.fish
```

## Output Options

```bash
# Color control
cass --color always search "test"
cass --color never search "test"

# Progress style
cass --progress bars index
cass --progress plain index
cass --progress none index

# Wrap output
cass --wrap 80 search "long query"
cass --nowrap search "query"
```

## Integration with CASS Memory

CASS provides the episodic memory layer that feeds into the CASS Memory System (cm):

```bash
# CASS indexes raw sessions (episodic memory)
cass index

# CM reflects on sessions to extract rules (procedural memory)
cm reflect
```

## Common Workflows

### Find Previous Solution
```bash
cass search "fixed authentication timeout"
```

### Review Recent Activity
```bash
cass timeline --range "1d"
```

### Export for Review
```bash
cass export SESSION_ID --format md > review.md
```

### Agent Pre-flight Check
```bash
cass health && echo "CASS ready"
```
