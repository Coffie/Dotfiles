# Colima Configuration

This directory contains Colima VM configuration that is synced across machines via dotfiles.

## Structure

- `default/colima.yaml` - Main configuration file (committed to git)
- Runtime data (_lima/, docker.sock, etc.) - Ignored by git via .gitignore

## Setup on New Machine

1. Run `./install` from dotfiles root to:
   - Symlink `~/.config/colima` (config directory)
   - Symlink `~/bin/colima-start-safe` (self-healing startup script)
   - Symlink `~/Library/LaunchAgents/local.colima.plist` (auto-start on boot)

2. Ensure `DOCKER_HOST` is set in your shell (should be in `~/.zshrc_local`):
   ```bash
   export DOCKER_HOST=unix:///Users/$(whoami)/.config/colima/default/docker.sock
   ```

3. Enable auto-start on boot (macOS):
   ```bash
   launchctl load ~/Library/LaunchAgents/local.colima.plist
   ```

4. Or start manually:
   ```bash
   colima-start-safe  # Self-healing wrapper (recommended)
   # OR
   colima start       # Direct start
   ```

## Common Issues & Solutions

### After System Restart: "disk in use" Error (Power Loss Recovery)

**Problem**: Colima fails to start with "failed to run attach disk, in use by instance"

**Cause**: Unclean shutdown (power loss, kernel panic, force shutdown) leaves zombie processes:
- `colima daemon` processes
- `limactl usernet` and `limactl hostagent` processes
- Stale lock files and socket files

**Solution (Automatic)**: Use `colima-start-safe` wrapper (included in dotfiles):
```bash
colima-start-safe
```

This script automatically:
1. Detects stale processes from previous crashes
2. Kills zombie processes safely
3. Attempts to start colima
4. If that fails, deletes VM and recreates it
5. Logs everything to `~/.config/colima/startup.log`

**Solution (Manual)**:
```bash
# Kill stale processes
pkill -f "colima daemon"
pkill -f "limactl usernet"

# Delete and restart VM
colima delete -f
colima start
```

### Brew Services vs LaunchAgent

**Old Approach**: `brew services start colima` (has issues after power loss)

**New Approach**: Use custom LaunchAgent with self-healing script
- LaunchAgent calls `colima-start-safe` on boot
- Automatically handles stale process cleanup
- Works reliably after power loss or crashes
- Logs to `/tmp/colima-launchagent.log` for debugging

### Config Directory Warnings

If you see warnings about `~/.colima` vs `$XDG_CONFIG_HOME`, ensure:
- `~/.colima` does NOT exist (remove it)
- Only `~/.config/colima` exists (symlinked via dotfiles)

## Configuration Notes

- **vmType: vz** - Uses macOS Virtualization.Framework (faster on Apple Silicon)
- **mountType: virtiofs** - Fastest mount option for vz on macOS
- **mountInotify: true** - Enables file watching (useful for development)
- Resources: 4 CPU, 8GB RAM, 100GB disk (adjust in `default/colima.yaml`)

## Verifying Setup

```bash
# Check status
colima status

# Test Docker
docker ps

# Check socket location
echo $DOCKER_HOST

# View startup logs (if using LaunchAgent)
tail -f ~/.config/colima/startup.log
tail -f /tmp/colima-launchagent.log

# Check if LaunchAgent is loaded
launchctl list | grep colima
```

## Disabling Auto-Start

If you want to disable auto-start:
```bash
launchctl unload ~/Library/LaunchAgents/local.colima.plist
```

To re-enable:
```bash
launchctl load ~/Library/LaunchAgents/local.colima.plist
```
