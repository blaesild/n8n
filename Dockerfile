FROM n8nio/n8n:latest

USER root

# Install FFmpeg and dependencies using apk
RUN apk update && apk add --no-cache ffmpeg git python3 make g++

# Switch back to the node user
USER node

# Set the working directory
WORKDIR /home/node
