FROM n8nio/n8n:latest

USER root

# Install FFmpeg using apk
RUN apk update && apk add --no-cache ffmpeg

# Install community nodes
RUN npm install -g n8n-nodes-ffmpeg n8n-nodes-elevenlabs

# Switch back to the node user
USER node
