# ollama-cloudflared

Run Ollama and a Cloudflare Tunnel in a single Docker container.

## What this does

- Starts `ollama serve` on port `11434`
- Starts `cloudflared tunnel run` using your tunnel token

## Build

```bash
docker build -f dockerfile -t ollama-cloudflared .
```

## Run

```bash
docker run --rm \
	-p 11434:11434 \
	-e CLOUDFLARE_TUNNEL_TOKEN=your_token_here \
	ollama-cloudflared
```

## Environment variables

- `CLOUDFLARE_TUNNEL_TOKEN` (required): Cloudflare tunnel token used by `cloudflared`

