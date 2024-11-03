FROM n8nio/n8n:latest


USER root


# Install FFmpeg
RUN apk update && apk add --no-cache ffmpeg


# Create the directory for custom nodes
RUN mkdir -p /home/node/.n8n/nodes


# Install community nodes
WORKDIR /home/node/.n8n/nodes
RUN npm install https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git
RUN npm install https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git


# Set permissions for the custom nodes folder
RUN chown -R node:node /home/node/.n8n


# Switch back to the node user
USER node


# Set the working directory to the n8n directory
WORKDIR /home/node


# Set environment variables for custom and community nodes
ENV N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/nodes"
ENV N8N_USE_EXTERNAL_MODULES=true


# Start n8n
CMD ["n8n"]
