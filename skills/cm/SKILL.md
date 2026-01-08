---
name: cm
description: "CASS Memory System - procedural memory for AI coding agents. Transforms scattered sessions into persistent, cross-agent learnings."
---

# CM - CASS Memory System

Procedural memory for AI coding agents. Transforms scattered agent sessions into persistent, cross-agent memory so every agent learns from every other agent's experience.

## Quick Start (for Agents)

```bash
# Get relevant context for a task
cm context "implementing user authentication" --json

# Get system documentation
cm quickstart --json
```

## Core Commands

### Context Retrieval

```bash
# Get rules and history relevant to a task
cm context "fix the database connection timeout"

# JSON output for agents
cm context "implement OAuth flow" --json

# Include more historical context
cm context "refactor API" --depth deep
```

### Rule Management

```bash
# Show top effective rules
cm top 10

# Find rules similar to a query
cm similar "error handling patterns"

# Get full playbook
cm playbook list

# Show why a rule exists
cm why BULLET_ID
```

### Feedback

```bash
# Mark a rule as helpful
cm mark BULLET_ID --helpful

# Mark a rule as harmful
cm mark BULLET_ID --harmful

# Undo feedback
cm undo BULLET_ID
```

### Reflection

```bash
# Process recent sessions to extract new rules
cm reflect

# Reflect on specific time range
cm reflect --since "7d"

# Audit sessions against rules
cm audit
```

### Validation

```bash
# Validate a proposed rule against history
cm validate "Always use prepared statements for SQL queries"
```

## Playbook Commands

```bash
# List all playbook rules
cm playbook list

# Show playbook stats
cm playbook stats

# Export playbook
cm playbook export --format md > playbook.md
```

## Health & Diagnostics

```bash
# System health check
cm doctor

# Fix issues automatically
cm doctor --fix

# Show usage statistics
cm usage

# Show playbook health metrics
cm stats
```

## Stale Rules

```bash
# Find rules without recent feedback
cm stale

# Find rules older than threshold
cm stale --days 30
```

## Forgetting Rules

```bash
# Deprecate a rule
cm forget BULLET_ID

# Deprecate with reason
cm forget BULLET_ID --reason "Outdated pattern"
```

## Outcome Recording

```bash
# Record implicit feedback from session outcomes
cm outcome success "RULE1,RULE2,RULE3"
cm outcome failure "RULE4,RULE5"

# Apply recorded outcomes to playbook
cm outcome-apply
```

## MCP Server

Run as an MCP server for agent integration:

```bash
cm serve
cm serve --port 9000
```

## Starter Playbooks

```bash
# List available starters
cm starters

# Initialize with a starter
cm init --starter typescript
cm init --starter python
cm init --starter go
```

## Agent Onboarding

```bash
# Guided onboarding (no API costs)
cm onboard
```

## Privacy Controls

```bash
# View privacy settings
cm privacy

# Disable cross-agent enrichment
cm privacy --disable-enrichment
```

## Project Export

```bash
# Export playbook for project documentation
cm project --output docs/PATTERNS.md
```

## Three-Layer Architecture

| Layer | Role | Tool |
|-------|------|------|
| **Episodic Memory** | Raw sessions | `cass` |
| **Working Memory** | Session summaries | Diary entries |
| **Procedural Memory** | Distilled rules | `cm` playbook |

## Workflow Example

```bash
# 1. Agent starts a task
cm context "implement password reset flow" --json

# 2. Agent receives relevant rules and history

# 3. After task, record outcome
cm outcome success "RULE-123,RULE-456"

# 4. Periodically reflect on sessions
cm reflect

# 5. New rules are extracted and added to playbook
```

## Configuration

Config location: `~/.config/cm/` or `.cm/` in project.

```bash
# Initialize in a project
cm init

# Initialize with options
cm init --starter typescript --project-name "MyApp"
```
