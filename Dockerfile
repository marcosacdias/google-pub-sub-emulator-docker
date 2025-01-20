FROM google/cloud-sdk:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    build-essential \
    git

# Set environment variables and expose port
ENV PUBSUB_EMULATOR_HOST=localhost:8085

# Create a virtual environment and install Python dependencies
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"
RUN /venv/bin/pip install --upgrade pip

# Clone the repository and install Python dependencies
RUN git clone https://github.com/googleapis/python-pubsub.git /python-pubsub
RUN /venv/bin/pip install -r /python-pubsub/samples/snippets/requirements.txt

# Create the bin directory and copy scripts
RUN mkdir -p /root/bin
COPY start-pubsub.sh pubsub-client.py /root/bin/
RUN chmod +x /root/bin/start-pubsub.sh

EXPOSE 8085

# Set the command to run the start script
CMD ["/root/bin/start-pubsub.sh"]

# Add healthcheck to monitor readiness
HEALTHCHECK --interval=5s --timeout=10s --start-period=10s --retries=3 \
    CMD grep -q "\[pubsub\] Ready" /var/log/stdout || exit 1