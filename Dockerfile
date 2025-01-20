FROM google/cloud-sdk:emulators

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    git 

# Set environment variables and expose port
ENV PUBSUB_EMULATOR_HOST=localhost:8085

# Clone the repository and install Python dependencies
RUN git clone https://github.com/googleapis/python-pubsub.git

# Clone the repository and install Python dependencies
RUN pip3 install -r /python-pubsub/samples/snippets/requirements.txt

# Create the bin directory and copy scripts
RUN mkdir -p /root/bin
COPY start-pubsub.sh pubsub-client.py /root/bin/

EXPOSE 8085

# Set the command to run the start script
CMD ["/root/bin/start-pubsub.sh"]