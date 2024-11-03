FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install FFmpeg and all required build dependencies
RUN apk update && apk add --no-cache \
    ffmpeg \
    git \
    python3 \
    make \
    g++ \
    nodejs \
    npm \
    build-base

# Create and set permissions for .n8n directory
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n

# Switch back to the node user
USER node

# Set the working directory
WORKDIR /home/node/.n8n

# Initialize npm project and install build tools locally
RUN npm init -y && \
    npm install typescript gulp-cli @types/node --save-dev

# Clone and build FFmpeg node
WORKDIR /home/node/.n8n
RUN git clone https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git node_modules/n8n-nodes-ffmpeg
WORKDIR /home/node/.n8n/node_modules/n8n-nodes-ffmpeg
RUN npm install && \
    npm install typescript gulp @types/node --save-dev && \
    npx tsc && \
    npx gulp build:icons || true

# Clone and build ElevenLabs node
WORKDIR /home/node/.n8n
RUN git clone https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git node_modules/n8n-nodes-elevenlabs
WORKDIR /home/node/.n8n/node_modules/n8n-nodes-elevenlabs
RUN npm install && \
    npm install typescript gulp @types/node --save-dev && \
    npx tsc && \
    npx gulp build:icons || true

# Return to .n8n directory
WORKDIR /home/node/.n8n

# Make sure all files have correct ownership
USER root
RUN chown -R node:node /home/node/.n8n

# Switch back to node user
USER node
WORKDIR /home/node

# Set environment variable for available packages
ENV N8N_AVAILABLE_PACKAGES="https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git,https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git"
