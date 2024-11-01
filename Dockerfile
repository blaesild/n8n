FROM n8nio/n8n:latest

USER root

# Install FFmpeg using apk
RUN apk update && apk add --no-cache ffmpeg

# Create the directory for custom nodes
RUN mkdir -p /home/node/.n8n/nodes

# Install community nodes
WORKDIR /home/node/.n8n/nodes
RUN npm install https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git
RUN npm install https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git

# Set proper permissions
RUN chown -R node:node /home/node/.n8n

# Switch back to the node user
USER node

# Set the working directory back to the n8n directory
WORKDIR /home/node
