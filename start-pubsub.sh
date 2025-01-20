#!/bin/bash

if [[ -z "${PUBSUB_PROJECT_ID}" ]]; then
  echo "No PUBSUB_PROJECT_ID supplied, setting default of docker-gcp-project"
  export PUBSUB_PROJECT_ID=docker-gcp-project
fi

# Start the emulator in the background so that we can continue the script to create topics and subscriptions.
gcloud beta emulators pubsub start --host-port=0.0.0.0:8085 &
PUBSUB_PID=$!

if [[ -z "${PUBSUB_CONFIG}" ]]; then
  echo "No PUBSUB_CONFIG supplied, no additional topics or subscriptions will be created"
else
  echo "Creating topics and subscriptions"
  python /root/bin/pubsub-client.py create ${PUBSUB_PROJECT_ID} "${PUBSUB_CONFIG}"
  if [ $? -eq 1 ]; then
    exit 1
  fi
fi

# After these actions we bring the process back to the foreground again and wait for it to complete.
# This restores Docker's expected behaviour of coupling the lifecycle of the Docker container to the primary process.
echo "[pubsub] Ready"
wait ${PUBSUB_PID}
