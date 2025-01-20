#!/bin/bash

LOG_FILE="/var/log/stdout"

# Redirecionar saída padrão e erros para o arquivo de log
exec > >(tee -a "${LOG_FILE}") 2>&1

if [[ -z "${PUBSUB_PROJECT_ID}" ]]; then
  echo "No PUBSUB_PROJECT_ID supplied, setting default of my-gcp-project"
  export PUBSUB_PROJECT_ID=my-gcp-project
fi

# Start the emulator in the background so that we can continue the script to create topics and subscriptions.
gcloud beta emulators pubsub start --host-port=0.0.0.0:8085 &
PUBSUB_PID=$!

echo "waiting for Pub/Sub emulator to start..."
sleep 5 # Give the emulator time to initialize

if [[ -z "${PUBSUB_CONFIG}" ]]; then
  echo "No PUBSUB_CONFIG supplied, no additional topics or subscriptions will be created"
else
  echo "Creating topics and subscriptions..."
  python /root/bin/pubsub-client.py create ${PUBSUB_PROJECT_ID} "${PUBSUB_CONFIG}"

  # Verifica o status da execução do comando Python
  if [ $? -ne 0 ]; then
    echo "Error: Failed to create Pub/Sub configuration. Exiting..."
    kill $PUBSUB_PID
    exit 1
  fi
  echo "Topics and subscriptions created successfully."
fi

# After these actions we bring the process back to the foreground again and wait for it to complete.
# This restores Docker's expected behaviour of coupling the lifecycle of the Docker container to the primary process.
echo "[pubsub] Ready"
wait ${PUBSUB_PID}
