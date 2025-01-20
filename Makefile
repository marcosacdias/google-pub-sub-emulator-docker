# Nome da sua imagem Docker
IMAGE_NAME=pubsub-emulator
CONTAINER_NAME=pubsub-emulator
PORT=8085

# Regra para criar a imagem Docker
build:
	@echo "Building the Docker image..."
	docker build -t $(IMAGE_NAME) .

# Regra para rodar o container com a imagem e aguardar até que esteja healthy
run: build
	@echo "Running the Docker container..."
	docker run -d --name $(CONTAINER_NAME) -p $(PORT):8085 $(IMAGE_NAME)

	@echo "Waiting for the container to become healthy..."
	while [ "`docker inspect --format='{{.State.Health.Status}}' $(CONTAINER_NAME)`" != "healthy" ]; do \
		echo "Container not ready yet. Retrying..."; \
		sleep 1; \
	done

	@echo "Pub/Sub Emulator is healthy and ready to use!"

# Regra para verificar os logs do container e esperar o texto "[pubsub] Ready"
logs:
	@echo "Waiting for [pubsub] Ready message in logs..."
	until docker logs $(CONTAINER_NAME) 2>&1 | grep -q "\[pubsub\] Ready"; do \
		echo "Waiting for '[pubsub] Ready' message..."; \
		sleep 1; \
	done
	@echo "Pub/Sub Emulator is ready to use!"

# Parar e remover o container rodando
clean:
	@echo "Stopping and removing the container..."
	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)
	@echo "Container cleaned up."

# Parar, remover o container e recomeçar do zero
restart: clean run

# Apenas verificar o status do container
status:
	@docker inspect --format='Status: {{.State.Status}}, Health: {{.State.Health.Status}}' $(CONTAINER_NAME)

.PHONY: build run clean logs restart status