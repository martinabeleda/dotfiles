# Systemd Services

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
