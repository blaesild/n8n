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

# Create a directory for n8n and set permissions
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n

# Install n8n globally
RUN npm install -g n8n

# Set the correct permissions and switch to the node user
USER node
WORKDIR /home/node

# Default command to run n8n
CMD ["n8n"]
