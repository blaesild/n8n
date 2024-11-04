FROM ubuntu:20.04

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ffmpeg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && apt-get clean

# Create n8n directory
RUN mkdir -p /home/node/.n8n
WORKDIR /home/node/.n8n

# Install n8n globally
RUN npm install -g n8n

# Set correct permissions
RUN chown -R node:node /home/node/.n8n
USER node

# Default command to run n8n
CMD ["n8n"]
