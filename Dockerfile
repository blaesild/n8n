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

# Initialize npm project with more complete package.json
RUN npm init -y && \
    npm pkg set name="@n8n/custom-nodes" && \
    npm pkg set version="1.0.0"

# Clone and build FFmpeg node
RUN git clone https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git node_modules/n8n-nodes-ffmpeg && \
    cd node_modules/n8n-nodes-ffmpeg && \
    npm install && \
    ./node_modules/.bin/tsc && \
    ./node_modules/.bin/gulp build:icons && \
    cd ../..

# Clone and build ElevenLabs node
RUN git clone https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git node_modules/n8n-nodes-elevenlabs && \
    cd node_modules/n8n-nodes-elevenlabs && \
    npm install && \
    ./node_modules/.bin/tsc && \
    ./node_modules/.bin/gulp build:icons && \
    cd ../..

# Update main package.json to include the custom nodes
RUN npm pkg set dependencies.n8n-nodes-ffmpeg="file:node_modules/n8n-nodes-ffmpeg" && \
    npm pkg set dependencies.n8n-nodes-elevenlabs="file:node_modules/n8n-nodes-elevenlabs"

# Make sure all files have correct ownership
USER root
RUN chown -R node:node /home/node/.n8n

# Switch back to node user
USER node
WORKDIR /home/node

# Set environment variable for available packages
ENV N8N_AVAILABLE_PACKAGES="https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git,https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git"
