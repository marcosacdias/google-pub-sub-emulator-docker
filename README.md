Building and running the Dockerfile can be done as follows:
```bash

docker build . -t pubsub

docker run  --name pubsub \
            -p 8085:8085 \
            -e PUBSUB_PROJECT_ID=my-gcp-project \
            -e PUBSUB_CONFIG='[{"name": "my-topic", "subscriptions": ["my-subscription"]}]' \
            -d pubsub

docker logs -f pubsub
```
