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
