# -------------------------------------------
# Environment variables
# -------------------------------------------

APP_NAME = ido_keido
APP_VERSION ?= 0.0.1
PORT = 4004
VOLUME = `pwd`/data:/opt/app/data
COUNTRY_DB_KEY ?= ""
CITY_DB_KEY ?= ""

# -------------------------------------------
# Global commands
# -------------------------------------------

.DEFAULT_GOAL := help

help: ## [GLOBAL] Print this help
	@awk -F ':|##' '/^[^\t].+?:.*?##/ { printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST)

# -------------------------------------------
# Docker commands
# -------------------------------------------

docker-build: ## [DOCKER] Build the Docker image
	docker build --build-arg MIX_ENV=prod --build-arg APP_NAME=$(APP_NAME) --build-arg APP_VERSION=$(APP_VERSION) -t $(APP_NAME):latest .

docker-run: ## [DOCKER] Run the API server locally
	docker run -e PORT=$(PORT) -v $(VOLUME) -p $(PORT):$(PORT) --rm -it $(APP_NAME):latest

docker-iex: ## [DOCKER] Run IEx (Elixir's Interactive Shell)
	docker run -e PORT=$(PORT) -v $(VOLUME) --rm -it $(APP_NAME):latest bin/ido_keido console

# ---------------------------------------------
# -- Database commands
# ---------------------------------------------
#
download-databases: ## [DATABASE] Download geolocation databases
	./scripts/geoip_download.sh $(COUNTRY_DB_KEY) $(CITY_DB_KEY)
