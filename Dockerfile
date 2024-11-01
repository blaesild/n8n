FROM n8nio/n8n:latest

USER root

# Install necessary packages
RUN apk add --no-cache python3

# Create directories for custom nodes
RUN mkdir -p /home/node/.n8n/nodes
RUN mkdir -p /home/node/.n8n/custom

# Set working directory
WORKDIR /home/node/.n8n

# Install community nodes
RUN npm install https://github.com/n8n-ninja/n8n-nodes-elevenlabs.git
RUN npm install https://github.com/n8n-ninja/n8n-nodes-ffmpeg.git

# Create a script to check installed community nodes
RUN echo "import os\n\nfor path in ['/home/node/.n8n/nodes', '/home/node/.n8n/custom']:\n    print(f'Checking {path}:')\n    try:\n        installed_nodes = os.listdir(path)\n        print('Installed nodes:', installed_nodes)\n    except FileNotFoundError:\n        print('Path not found.')\n    print()\n" > /home/node/check_nodes.py

# Set proper permissions
RUN chown -R node:node /home/node/.n8n

# Switch back to the node user
USER node

# Command to run the check script and start n8n
CMD python3 /home/node/check_nodes.py && n8n start
