FROM ollama/ollama:latest

# Install dependencies + cloudflared
RUN apt-get update && apt-get install -y curl ca-certificates

# Install Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh


# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Ollama default port
EXPOSE 11434


# Run both services
ENTRYPOINT ["/start.sh"]