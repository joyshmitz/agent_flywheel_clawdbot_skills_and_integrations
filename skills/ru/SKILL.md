---
name: ru
description: "Repo Updater - A Bash CLI for synchronizing dozens or hundreds of GitHub repositories with a single command. Features parallel sync, conflict resolution, JSON output, and resume capability."
---

# RU — Repo Updater

> **What it is:** A Bash CLI tool that synchronizes multiple GitHub repositories in parallel.
>
> **Why it matters:** When you work with dozens of repos (personal projects, forks, dependencies), keeping them all up-to-date manually is tedious. RU handles it with one command.

---

## Key Features

| Feature | Description |
|---------|-------------|
| **Parallel sync** | Updates multiple repos simultaneously |
| **Conflict resolution** | Detects and reports conflicts without breaking |
| **Git plumbing** | Uses git plumbing commands, not string parsing |
| **JSON output** | Machine-readable output for automation |
| **Resume capability** | Pick up where you left off after interruption |
| **Dry run mode** | See what would happen without making changes |

---

## Installation

```bash
# Clone the repository
git clone https://github.com/Dicklesworthstone/repo_updater.git
cd repo_updater

# Make executable
chmod +x repo_updater.sh

# Optional: Add to PATH
sudo ln -s $(pwd)/repo_updater.sh /usr/local/bin/ru
```

---

## Basic Usage

### Update All Repos in a Directory

```bash
# Update all git repos in ~/projects
ru ~/projects

# Update with verbose output
ru -v ~/projects

# Dry run (show what would happen)
ru --dry-run ~/projects
```

### Update Specific Repos

```bash
# Update specific repositories
ru ~/projects/repo1 ~/projects/repo2 ~/projects/repo3
```

### JSON Output for Automation

```bash
# Get JSON output for scripting
ru --json ~/projects > sync_results.json
```

---

## Command Line Options

| Option | Description |
|--------|-------------|
| `-v, --verbose` | Verbose output |
| `-q, --quiet` | Minimal output |
| `--dry-run` | Show what would happen without making changes |
| `--json` | Output results as JSON |
| `-j, --jobs N` | Number of parallel jobs (default: 4) |
| `--resume` | Resume from previous interrupted run |
| `--force` | Force update even with local changes |
| `--prune` | Prune deleted remote branches |

---

## How It Works

1. **Discovery** — Finds all git repositories in specified directories
2. **Analysis** — Checks each repo's status (clean, dirty, ahead, behind)
3. **Planning** — Determines what actions are needed
4. **Execution** — Runs updates in parallel with conflict detection
5. **Reporting** — Summarizes results with any issues

### Git Plumbing Approach

RU uses git plumbing commands directly instead of parsing porcelain output:

```bash
# Instead of parsing `git status`
git rev-parse --verify HEAD
git rev-list --count @{u}..HEAD
git rev-list --count HEAD..@{u}

# This is more reliable and faster
```

---

## Sync Strategies

### Default: Safe Merge

```bash
ru ~/projects
```

- Fetches from remote
- Fast-forwards if possible
- Reports conflicts if local changes exist

### Rebase Mode

```bash
ru --rebase ~/projects
```

- Fetches from remote
- Rebases local commits on top of remote
- Cleaner history but requires clean working directory

### Force Mode

```bash
ru --force ~/projects
```

- Stashes local changes
- Forces update to match remote
- Restores stashed changes after
- Use with caution

---

## Handling Conflicts

When RU encounters conflicts:

```
CONFLICT: ~/projects/my-repo
  Local branch 'main' has diverged from 'origin/main'
  Local commits: 3
  Remote commits: 5

  Options:
    1. Manually resolve: cd ~/projects/my-repo && git pull
    2. Force remote: ru --force ~/projects/my-repo
    3. Skip: This repo will be skipped
```

RU never automatically resolves conflicts that could lose work.

---

## JSON Output Format

```json
{
  "timestamp": "2025-01-08T10:30:00Z",
  "total_repos": 45,
  "updated": 38,
  "skipped": 5,
  "conflicts": 2,
  "errors": 0,
  "repos": [
    {
      "path": "/home/user/projects/repo1",
      "status": "updated",
      "commits_pulled": 3,
      "branch": "main"
    },
    {
      "path": "/home/user/projects/repo2",
      "status": "conflict",
      "reason": "local_diverged",
      "local_commits": 2,
      "remote_commits": 5
    }
  ]
}
```

---

## Resume Capability

If RU is interrupted (Ctrl+C, network failure, etc.):

```bash
# Resume from where you left off
ru --resume ~/projects
```

RU maintains state in `~/.cache/repo_updater/` to track progress.

---

## Parallel Execution

Control parallelism with the `-j` flag:

```bash
# Use 8 parallel jobs (good for SSDs)
ru -j 8 ~/projects

# Use 1 job (sequential, for debugging)
ru -j 1 ~/projects

# Auto-detect based on CPU cores
ru -j auto ~/projects
```

---

## Filtering Repos

### By Pattern

```bash
# Only update repos matching pattern
ru --filter "claude-*" ~/projects

# Exclude repos matching pattern
ru --exclude "archive-*" ~/projects
```

### By Remote

```bash
# Only update repos from specific remote
ru --remote github ~/projects
```

### By Status

```bash
# Only update repos that are behind
ru --behind-only ~/projects
```

---

## Integration with Cron

Set up automatic daily updates:

```bash
# Add to crontab
0 6 * * * /usr/local/bin/ru --quiet --json ~/projects >> ~/logs/repo_sync.json 2>&1
```

---

## Use Cases

### 1. Daily Development Sync

```bash
# Morning routine: update all your projects
ru ~/projects ~/work ~/oss
```

### 2. CI/CD Cache Warming

```bash
# Keep dependency caches fresh
ru --prune --json /opt/dependency-cache > /var/log/cache-sync.json
```

### 3. Backup Verification

```bash
# Ensure backup repos are up to date
ru --dry-run /backup/repos
```

### 4. Multi-Machine Sync

```bash
# Keep repos in sync across machines
ru --json ~/projects | ssh other-machine "ru --from-json -"
```

---

## Performance Tips

1. **Use SSDs** — Parallel git operations benefit enormously from SSD speeds
2. **Increase parallelism** — On fast networks, `-j 8` or higher works well
3. **Prune regularly** — `--prune` removes stale remote tracking branches
4. **Use shallow clones** — For repos you only read, shallow clones are faster to update

---

## Troubleshooting

### "Permission denied" errors

```bash
# Check SSH key is loaded
ssh-add -l

# Add SSH key if needed
ssh-add ~/.ssh/id_ed25519
```

### "Repository not found" errors

```bash
# Check if remote still exists
ru --verify ~/projects
```

### Slow performance

```bash
# Check for large repos slowing things down
ru --stats ~/projects
```

---

## Best Practices

1. **Run daily** — Keep repos fresh to minimize conflicts
2. **Use `--dry-run` first** — Especially before `--force`
3. **Review conflicts** — Don't blindly force update
4. **Enable JSON logging** — Easier to track issues over time
5. **Set up notifications** — Alert on conflicts or errors

---

## Links

- **Repository:** https://github.com/Dicklesworthstone/repo_updater
- **Issues:** https://github.com/Dicklesworthstone/repo_updater/issues

---

## Integration with Other Flywheel Tools

| Tool | Integration |
|------|-------------|
| **Agent Mail** | Notify agents when repos are updated |
| **BV** | Track repo sync as a recurring task |
| **CASS** | Summarize sync logs |
| **DCG** | RU itself is safe (read-mostly), but runs inside DCG protection |
