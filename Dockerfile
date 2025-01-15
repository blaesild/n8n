FROM ubuntu:20.04

# Update and install system packages
RUN apt-get update && \
    apt-get install -y curl gnupg ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js 20 (using NodeSource repository)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && apt-get clean

# Verify Node.js version to ensure it is 20 or above
RUN node -v

# Create a new user named 'node' and set up the home directory
RUN useradd -m -s /bin/bash node

# Create a directory for n8n and set permissions for the 'node' user
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n

# Install n8n globally as root
RUN npm install -g n8n

# Install fluent-ffmpeg globally
RUN npm install -g fluent-ffmpeg

RUN apt-get update && apt-get install -y libimage-exiftool-perl

# Switch to the node user for running n8n
USER node
WORKDIR /home/node

# Default command to run n8n
CMD ["n8n"]
