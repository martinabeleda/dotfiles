# Systemd Services

## Llama models

`llama` (`~/.local/bin/llama`) saves Hugging Face downloads in the hub cache:

```text
~/.cache/huggingface/hub/
```

`HF_HOME` and `HF_HUB_CACHE` are unset, and `XDG_CACHE_HOME` is `~/.cache`, so that path is the default. Each repo is a directory named `models--<org>--<repo>`. The `.gguf` files under `snapshots/<rev>/` are symlinks. The file bytes are in that repo's `blobs/` directory.

List what is cached:

```bash
llama serve --cache-list
```

Models currently in the cache:

| Model | Directory |
|---|---|
| `ggml-org/Qwen3.5-0.8B-GGUF:Q8_0` | `~/.cache/huggingface/hub/models--ggml-org--Qwen3.5-0.8B-GGUF/` |
| `ggml-org/Qwen3.8-27B-GGUF:Q4_K_M` | `~/.cache/huggingface/hub/models--ggml-org--Qwen3.8-27B-GGUF/` |
| `bartowski/DeepSeek-Coder-V2-Lite-Instruct-GGUF:Q4_K_M` | `~/.cache/huggingface/hub/models--bartowski--DeepSeek-Coder-V2-Lite-Instruct-GGUF/` |

Run one from that cache. `--offline` uses the cache and does not touch the network. The name is the same `user/repo:quant` string printed by `--cache-list`:

```bash
llama cli -hf ggml-org/Qwen3.5-0.8B-GGUF:Q8_0 --offline
llama cli -hf ggml-org/Qwen3.8-27B-GGUF:Q4_K_M --offline
llama cli -hf bartowski/DeepSeek-Coder-V2-Lite-Instruct-GGUF:Q4_K_M --offline
```

For an HTTP server, use `serve` with the same flags:

```bash
llama serve -hf ggml-org/Qwen3.5-0.8B-GGUF:Q8_0 --offline
```

Or pass the snapshot file directly:

```bash
llama cli -m ~/.cache/huggingface/hub/models--ggml-org--Qwen3.5-0.8B-GGUF/snapshots/807dfd9a6fadbf703207aac3bfb0b2b3040d077c/Qwen3.5-0.8B-Q8_0.gguf
```

`systemd/system/llama-server.service` is a separate setup. It starts `/usr/bin/llama-server` with `LLAMA_CACHE=/data/llama.cpp`.

## Llama Server

Run the [Qwen3.5-9B](https://huggingface.co/unsloth/Qwen3.5-9B-GGUF) model with llama-server using systemd (always on, auto-restart):

### 1. Create the systemd service

```bash
sudo ln -sf /home/mabeleda/Development/dotfiles/systemd/system/llama-server.service /etc/systemd/system/llama-server.service
```

### 2. Enable and start the service

```bash
sudo systemctl daemon-reload
sudo systemctl enable llama-server
sudo systemctl start llama-server
```

You can test the server by calling:

```bash
# From the host
curl http://localhost:8081/v1/models

# From any machine on the tailnet
curl http://archlinux:8081/v1/models
```

### 3. Manage the service

**Check status:**

```bash
sudo systemctl status llama-server
```

**View logs:**

```bash
sudo journalctl -u llama-server -f
```

**Stop the server:**

```bash
sudo systemctl stop llama-server
```

**Restart:**

```bash
sudo systemctl restart llama-server
```

**View recent logs:**

```bash
sudo journalctl -u llama-server --no-pager
```

### 4. Set up tailscale serve

**Create a tailnet-wide service** using [tailscale serve](https://tailscale.com/docs/features/tailscale-serve):

```bash
sudo tailscale serve -bg 8081
```

**Check status:**

```bash
tailscale serve status
```

This verifies that:

- Tailscale is terminating HTTPS for the tailnet URL
- requests to `/` are being proxied to the local service on `127.0.0.1:8081`
- manually generated `tailscale cert` certificate files are not needed when using `tailscale serve`

**Verify the tailnet URL works:**

```bash
curl https://archlinux.trout-hadar.ts.net/v1/models
```

**Optional: check which process is listening on port 8081:**

```bash
ss -ltnp | grep ':8081'
```

## Hugging Face Hub Backup

Daily rsync of `~/.cache/huggingface/hub/` to the `ugreen-nas` NAS over Tailscale, run by a systemd **user** timer.

| Repo file | Linked to |
| --- | --- |
| `bin/hf-backup` | `~/.local/bin/hf-backup` |
| `systemd/user/hf-backup.service` | `~/.config/systemd/user/hf-backup.service` |
| `systemd/user/hf-backup.timer` | `~/.config/systemd/user/hf-backup.timer` |
| `ssh/config` | `~/.ssh/config` |

Destination on the NAS: `/volume1/Backups/huggingface-hub`.

### How it behaves

- Runs once a day, at a random time between 00:00 and 00:30 (`RandomizedDelaySec=30m`). If the machine was off, `Persistent=true` runs it at the next boot.
- Only new or changed files are sent. HF blobs are immutable and named by hash, so daily runs only copy newly downloaded models.
- No `--delete`: models removed locally stay on the NAS. Prune the NAS copy by hand if needed.
- Exits cleanly (skips) if the NAS is unreachable or the HF cache doesn't exist.

### 1. One-time setup

Create a dedicated, passphrase-less key and install it on the NAS (keys are **never** committed; `.gitignore` only allows `ssh/config`):

```bash
ssh-keygen -t ed25519 -f ~/.ssh/nas_backup -N "" -C "hf-backup"
ssh-copy-id -i ~/.ssh/nas_backup.pub mabeleda@ugreen-nas
```

On the NAS (UGOS web UI):

- Control Panel → Terminal → enable **SSH**
- Control Panel → File Services → enable the **rsync** service and grant `mabeleda` access to the `Backups` share

> UGOS ships a patched rsync: it refuses transfers unless the rsync service is enabled, and only accepts
> share-relative paths (`Backups/huggingface-hub/`), not `/volume1/...`.

Link the files (`bash install`, or just these links), then enable the timer:

```bash
systemctl --user daemon-reload
systemctl --user enable --now hf-backup.timer
loginctl enable-linger "$USER"   # run even when not logged in
```

### 2. Trigger a backup manually

Through systemd (same environment as the scheduled run, logs go to the journal):

```bash
systemctl --user start hf-backup.service
journalctl --user -u hf-backup -f
```

Or run the script directly in the terminal to see rsync's output:

```bash
hf-backup
```

Preview what would be transferred without copying anything:

```bash
rsync -a --dry-run -v --exclude '.locks/' --exclude '*.incomplete' \
  ~/.cache/huggingface/hub/ ugreen-nas:Backups/huggingface-hub/
```

### 3. Check status

```bash
systemctl --user list-timers hf-backup.timer   # next / last run
systemctl --user status hf-backup.service      # result of the last run
journalctl --user -u hf-backup --no-pager -n 50
ssh ugreen-nas 'du -sh /volume1/Backups/huggingface-hub'
```

### 4. Restore

```bash
rsync -a --partial ugreen-nas:Backups/huggingface-hub/ ~/.cache/huggingface/hub/
```

### 5. Change the schedule

Edit `OnCalendar` in `systemd/user/hf-backup.timer` (e.g. `*-*-* 03:00`, `weekly`, `*-*-* 00/6:00`), then:

```bash
systemctl --user daemon-reload
systemctl --user restart hf-backup.timer
```
