FROM n8nio/n8n:latest

USER root

# Install build essentials and FFmpeg
RUN apk update && apk add --no-cache \
    ffmpeg \
    python3 \
    make \
    g++ \
    Git

# Create necessary directories
RUN mkdir -p /home/node/.n8n/custom && \
    mkdir -p /home/node/.n8n/custom/node_modules

# Install community nodes
WORKDIR /home/node/.n8n/custom
RUN npm install https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git
RUN npm install https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git

# Set proper permissions
RUN chown -R node:node /home/node/.n8n

# Switch back to the node user
USER node

# Set the working directory back to the n8n directory
WORKDIR /home/node
