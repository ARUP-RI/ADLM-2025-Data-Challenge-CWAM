FRONT_END_DIR=./app/frontend
BACK_END_DIR=./app/backend

download-pdfs:
	curl -L -C - -o ./resources/labdocs.zip \
    "https://zenodo.org/records/16328490/files/LabDocs.zip?download=1"
	unzip -o ./resources/labdocs.zip -d ./resources/

build-docker:
# Build the Docker containers
	@echo "Building Docker containers..."
	docker-compose up -d
	sleep 5
	docker exec -it ollama ollama pull qwen3:4b

build-backend:
# Build the backend application
	@echo "Building backend application..."
	cd $(BACK_END_DIR) && uv sync

run-backend:
# Run the backend application in development mode
	@echo "Running backend application in development mode..."
	$(MAKE) build-backend
	cd $(BACK_END_DIR) && uv run start-api

build-frontend:
# Build the frontend application
	@echo "Building frontend application..."
	cd $(FRONT_END_DIR) && npm install && npm cache clean --force && npm install && npm run build

run-frontend:
# Run the frontend application in development mode
	@echo "Running frontend application in development mode..."
	cd $(FRONT_END_DIR) && npm run dev