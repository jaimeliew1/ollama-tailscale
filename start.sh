#!/bin/bash
set -e

# Start Tailscale
tailscaled &

# Wait for daemon
sleep 2

# Authenticate using env var
tailscaled --tun=userspace-networking &
tailscale up --authkey=${TAILSCALE_AUTHKEY}  --accept-routes 


###############################################################
# Usage:
#   Set the MODELS_TO_FETCH environment variable to a comma-separated
#   list of model names you want to fetch at container start.
#
#   Example (docker run):
#     docker run -e MODELS_TO_FETCH="llama2,phi" your-image
#
#   Example (manual):
#     export MODELS_TO_FETCH="llama2,phi"
#     ./start.sh
#
#   If MODELS_TO_FETCH is unset or empty, no models will be fetched.
###############################################################

# Start Ollama in the background
ollama serve &
OLLAMA_PID=$!

# Wait for Ollama server to be ready
until curl -s http://localhost:11434/api/tags > /dev/null; do
  echo "Waiting for Ollama server..."
  sleep 1
done

# Fetch models if MODELS_TO_FETCH is set
if [ -n "$MODELS_TO_FETCH" ]; then
  IFS=',' read -ra MODELS <<< "$MODELS_TO_FETCH"
  for model in "${MODELS[@]}"; do
    echo "Fetching model: $model"
    ollama pull "$model"
  done
fi

# Bring Ollama server to foreground
wait $OLLAMA_PID