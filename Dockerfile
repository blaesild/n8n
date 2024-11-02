FROM n8nio/n8n:latest

USER root

# Install FFmpeg using apk
RUN apk update && apk add --no-cache ffmpeg

# Install Git and build tools
RUN apk add --no-cache git python3 make g++

# Create the directory for custom nodes
RUN mkdir -p /home/node/.n8n/custom

# Install community nodes into the custom directory
WORKDIR /home/node/.n8n/custom

# Install community nodes via git
RUN npm install https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git
RUN npm install https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git

# Set proper permissions
RUN chown -R node:node /home/node/.n8n

# Switch back to the node user
USER node

# Set the working directory back to the n8n directory
WORKDIR /home/node
