FROM n8nio/n8n:latest

USER root

# Install FFmpeg using apk
RUN apk update && apk add --no-cache ffmpeg git python3 make g++

# Install community nodes globally
RUN npm install -g https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git
RUN npm install -g https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git

# Switch back to the node user
USER node

# Set the working directory back to the n8n directory
WORKDIR /home/node
