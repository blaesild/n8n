FROM n8nio/n8n:latest

USER root

# Install build essentials and FFmpeg
RUN apk update && apk add --no-cache \
    ffmpeg \
    python3 \
    make \
    g++ \
    git

# Create the directory for custom nodes
RUN mkdir -p /home/node/.n8n/custom

# Set workdir and install community nodes
WORKDIR /home/node/.n8n/custom

# Install community nodes
RUN npm init -y && \
    npm install https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git && \
    npm install https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git

# Set proper permissions
RUN chown -R node:node /home/node/.n8n

# Important: Set environment variables for custom nodes
ENV N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/custom"
ENV NODE_PATH="/home/node/.n8n/custom/node_modules"

# Switch back to the node user
USER node

# Set the working directory back to the n8n directory
WORKDIR /home/node

# Optional: Verify custom nodes on startup
CMD ["n8n", "start"]
