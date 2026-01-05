---
name: bv
description: "Beads Viewer - TUI for the Beads issue tracker with graph analysis, recommendations, and agent-friendly robot commands."
---

# BV - Beads Viewer

A TUI viewer for the Beads issue tracker. Provides interactive task management, dependency graphs, recommendations, and AI agent integration.

## Quick Start

```bash
# Launch TUI in current directory
bv

# Launch TUI for specific project
bv --project /path/to/project
```

## TUI Navigation

| Key | Action |
|-----|--------|
| `j/k` or `↑/↓` | Navigate issues |
| `Enter` | View issue details |
| `Tab` | Switch panels |
| `g` | Go to graph view |
| `i` | Go to insights view |
| `b` | Go to board view |
| `q` | Quit |
| `?` | Help |

## Robot Commands (for AI Agents)

Machine-readable output for automation:

```bash
# Get prioritized recommendations
bv --robot-triage

# Get label attention priorities
bv --robot-label-attention

# Get current alerts
bv --robot-alerts

# Get all issues as JSON
bv --robot-issues

# Check for drift from baseline
bv --check-drift
```

## Agent Brief Export

Export comprehensive context for AI agents:

```bash
# Export to directory
bv --agent-brief ./agent_context/

# Creates:
# - triage.json     (prioritized issues)
# - insights.json   (analysis)
# - brief.md        (human-readable summary)
# - helpers.md      (suggested actions)
```

## Graph Analysis

```bash
# Export interactive HTML graph
bv --export-graph graph.html

# Export static graph
bv --export-graph graph.png
bv --export-graph graph.svg
```

## Filtering

```bash
# Filter by label
bv --label "bug"

# Filter robot alerts
bv --alert-type stale_issue
bv --alert-label "priority:high"

# Capacity simulation
bv --agents 3 --capacity-label "backend"
```

## Historical Analysis

```bash
# View state at point in time
bv --as-of "2024-01-15"
bv --as-of abc1234  # commit SHA
bv --as-of v1.0.0   # tag

# Show changes since point
bv --diff-since "2024-01-01"
bv --diff-since main
```

## Baseline Tracking

```bash
# Check drift from baseline
bv --check-drift
# Exit codes: 0=OK, 1=critical, 2=warning

# Get baseline info
bv --baseline-info
```

## Exports

```bash
# Export to Markdown
bv --export-md report.md

# Export static site
bv --export-pages ./bv-pages/
```

## Feedback System

Record feedback to tune recommendations:

```bash
# Accept a recommendation
bv --feedback-accept ISSUE-123

# Ignore a recommendation
bv --feedback-ignore ISSUE-456

# Reset feedback
bv --feedback-reset
```

## Issue History

```bash
# Show history for specific bead
bv --bead-history ISSUE-123
```

## Debug/Development

```bash
# Render view to file (for testing)
bv --debug-render insights --debug-width 180 --debug-height 50

# Check for updates
bv --check-update
```

## Integration with Beads

BV reads from `.beads/` directory created by the `bd` CLI:

```bash
# Initialize beads in a project
bd init

# Create an issue
bd create "Implement login flow" --label "feature"

# List issues
bd list

# Update issue
bd update ISSUE-123 --status done
```

## Robot Output Formats

All robot commands output JSON for parsing:

```bash
# Triage output structure
bv --robot-triage
# Returns: { "recommendations": [...], "insights": {...} }

# Alerts output
bv --robot-alerts
# Returns: { "alerts": [...], "summary": {...} }
```

## Configuration

Config location: `~/.config/bv/config.toml` or `.bv/config.toml` in project.

## Use Cases

1. **Agent task selection**: Use `--robot-triage` to get prioritized work
2. **Progress tracking**: Use `--diff-since` to show changes
3. **Team coordination**: Export graphs and briefs for sharing
4. **Quality monitoring**: Use `--check-drift` in CI/CD
