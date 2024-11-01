FROM n8nio/n8n:latest

USER root

# Install FFmpeg using apk
RUN apk update && apk add --no-cache ffmpeg

# Install community nodes in the custom extension directory
RUN mkdir -p /home/node/.n8n/custom && \
    cd /home/node/.n8n/custom && \
    npm install n8n-nodes-ffmpeg n8n-nodes-elevenlabs && \
    chown -R node:node /home/node/.n8n

# Switch back to the node user
USER node
