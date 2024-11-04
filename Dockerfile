FROM n8nio/n8n:latest

USER root

# Install FFmpeg using apk
RUN apk update && apk add --no-cache ffmpeg

# Set up the custom nodes (optional)
# Comment out these lines if community nodes aren't needed.
RUN mkdir -p /home/node/.n8n/nodes

# Set up ElevenLabs and FFmpeg nodes without over-complicating the build process.
WORKDIR /home/node/.n8n/nodes
RUN npm install https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git || true
RUN npm install https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git || true

# Set proper permissions for the node user
RUN chown -R node:node /home/node/.n8n

# Switch back to the node user
USER node

# Set the working directory back to the n8n directory
WORKDIR /home/node
