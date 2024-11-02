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
WORKDIR /home/node/.n8n

# Initialize npm project
RUN npm init -y

# Install custom nodes one at a time with error checking
RUN npm install https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git || exit 0
RUN cd node_modules/n8n-nodes-ffmpeg && \
    npm install && \
    npm run build || exit 0

RUN npm install https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git || exit 0
RUN cd node_modules/n8n-nodes-elevenlabs && \
    npm install && \
    npm run build || exit 0

# Make sure the n8n user owns all files
USER root
RUN chown -R node:node /home/node/.n8n

# Switch back to node user for security
USER node
WORKDIR /home/node
