FROM n8nio/n8n:latest

USER root

# Install build essentials and FFmpeg
RUN apk update && apk add --no-cache \
    ffmpeg \
    python3 \
    make \
    g++ \
    git

# Create necessary directories
RUN mkdir -p /home/node/.n8n/custom && \
    mkdir -p /home/node/.n8n/custom/node_modules

# Create and set permissions for start script
RUN echo '#!/bin/sh\nn8n start' > /usr/local/bin/start.sh && \
    chmod +x /usr/local/bin/start.sh

# Set workdir and install community nodes
WORKDIR /home/node/.n8n/custom

# Initialize npm and install nodes
RUN npm init -y && \
    npm install -g n8n && \
    npm install https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git && \
    npm install https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git

# Set proper permissions
RUN chown -R node:node /home/node/.n8n

# Set environment variables to match your configuration
ENV GENERIC_TIMEZONE=Europe/Copenhagen
ENV N8N_CUSTOM_EXTENSIONS=/home/node/.n8n/custom
ENV N8N_USER_FOLDER=/home/node/.n8n
ENV NODE_PATH=/home/node/.n8n/custom/node_modules
ENV NODE_FUNCTION_ALLOW_EXTERNAL=*
ENV PATH="/home/node/.npm-global/bin:$PATH"
ENV NPM_CONFIG_PREFIX="/home/node/.npm-global"
ENV N8N_PORT=10000

# Switch back to the node user
USER node

# Set the working directory back to the n8n directory
WORKDIR /home/node/.n8n

# Use the start script as the entry point
CMD ["/usr/local/bin/start.sh"]
