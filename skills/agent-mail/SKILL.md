---
name: agent-mail
description: "MCP Agent Mail - coordination layer for coding agents with mailboxes, identity, file reservations, and searchable message history."
---

# MCP Agent Mail

A mail-like coordination layer for coding agents. Gives agents memorable identities, inbox/outbox, searchable history, and file reservation leases to avoid conflicts.

## Starting the Server

```bash
# Start server (after installation)
am

# Or manually
cd ~/projects/mcp_agent_mail
./scripts/run_server_with_token.sh
```

Default port: 8765

## Core Concepts

### Agent Identity
Agents register with adjective+noun names (e.g., "GreenCastle", "BlueLake") for easy identification.

### Messages
GitHub-Flavored Markdown messages with threading, importance levels, and acknowledgments.

### File Reservations
Advisory leases on file paths/globs to signal editing intent and avoid conflicts.

### Projects
Each working directory is a project. Agents in the same directory share a project.

## CLI Commands (via uv run)

```bash
cd ~/projects/mcp_agent_mail

# Server management
uv run python -m mcp_agent_mail.cli server start
uv run python -m mcp_agent_mail.cli server status

# Configuration
uv run python -m mcp_agent_mail.cli config show
uv run python -m mcp_agent_mail.cli config set-port 9000
```

## MCP Tools Reference

These tools are available to agents via MCP:

### Project & Agent Management

```
ensure_project(human_key)
  - Create/ensure a project exists
  - human_key: absolute path to working directory

register_agent(project_key, program, model, name?, task_description?)
  - Register an agent identity
  - Names are adjective+noun (e.g., "BlueLake")

whois(project_key, agent_name)
  - Get agent profile details
```

### Messaging

```
send_message(project_key, sender_name, to, subject, body_md)
  - Send a markdown message
  - to: list of recipient agent names
  - Optional: cc, bcc, importance, ack_required

reply_message(project_key, message_id, sender_name, body_md)
  - Reply to a message (preserves thread)

fetch_inbox(project_key, agent_name, limit?, since_ts?, urgent_only?)
  - Get recent messages for an agent

mark_message_read(project_key, agent_name, message_id)
  - Mark a message as read

acknowledge_message(project_key, agent_name, message_id)
  - Acknowledge receipt of ack_required message

search_messages(project_key, query)
  - Full-text search over messages (FTS5 syntax)

summarize_thread(project_key, thread_id)
  - Get participants, key points, action items
```

### File Reservations

```
file_reservation_paths(project_key, agent_name, paths, ttl_seconds?, exclusive?)
  - Reserve file paths/globs for editing
  - Returns granted leases and conflicts

release_file_reservations(project_key, agent_name, paths?)
  - Release active reservations

renew_file_reservations(project_key, agent_name, extend_seconds?)
  - Extend reservation TTL
```

### Session Helpers

```
macro_start_session(human_key, program, model, agent_name?, task_description?)
  - One-call session bootstrap
  - Ensures project, registers agent, fetches inbox

macro_prepare_thread(project_key, thread_id, program, model)
  - Join an existing thread conversation
```

## Example Agent Workflow

```python
# 1. Start session
result = macro_start_session(
    human_key="/path/to/project",
    program="claude-code",
    model="opus-4.5",
    task_description="Implementing auth module"
)
agent_name = result["agent"]["name"]  # e.g., "GreenCastle"

# 2. Check inbox
messages = fetch_inbox(project_key, agent_name, limit=10)

# 3. Reserve files before editing
reservations = file_reservation_paths(
    project_key, agent_name,
    paths=["src/auth/*.ts"],
    ttl_seconds=3600,
    exclusive=True
)

# 4. Send status update to team
send_message(
    project_key, agent_name,
    to=["BlueLake"],
    subject="Auth module progress",
    body_md="Completed login flow. Starting on session management."
)

# 5. Release reservations when done
release_file_reservations(project_key, agent_name)
```

## Message Importance Levels

- `low` - FYI only
- `normal` - Standard message
- `high` - Needs attention
- `urgent` - Requires immediate action

## Search Syntax

FTS5 query syntax:
```
"exact phrase"
prefix*
term1 AND term2
term1 OR term2
```

Example:
```
search_messages(project_key, '"auth module" AND error')
```

## Integration

Agent Mail integrates with:
- Claude Code (via MCP)
- Codex CLI (via MCP)
- Gemini CLI (via MCP)
- Cursor, Windsurf, Cline (via MCP configs)

Config files are auto-generated during installation.
