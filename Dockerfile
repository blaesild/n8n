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

# Install global npm packages
RUN npm install -g typescript @types/node gulp-cli

# Create and set permissions for .n8n directory
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n

# Switch back to the node user
USER node

# Set the working directory
WORKDIR /home/node

# Install and build custom nodes
RUN cd /home/node/.n8n && \
    npm install https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git && \
    npm install https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git && \
    cd node_modules/n8n-nodes-ffmpeg && npm install && npm run build && \
    cd ../n8n-nodes-elevenlabs && npm install && npm run build
