# Start with an Ubuntu-based n8n image
FROM n8nio/n8n:ubuntu

USER root

# Update and install FFmpeg
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up the custom nodes (optional)
RUN mkdir -p /home/node/.n8n/nodes

# Set up ElevenLabs and FFmpeg nodes without unnecessary build steps
WORKDIR /home/node/.n8n/nodes
RUN npm install https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git || true
RUN npm install https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git || true

# Set correct permissions for the node user
RUN chown -R node:node /home/node/.n8n

# Switch back to the node user
USER node

# Set the working directory back to the n8n directory
WORKDIR /home/node
