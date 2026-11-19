# Pi Dotfiles

Configuration files and scripts for my Pi setup.

## Install `pi` agent

```bash
npm i @mariozechner/pi-coding-agent
```

To update:

```bash
npm install -g @mariozechner/pi-coding-agent
```

## Dependencies

- A llama.cpp server on the tailnet provides the local LLM backend used by the `omarchy` provider in `agent/models.json`. It is not set up by this repo.
