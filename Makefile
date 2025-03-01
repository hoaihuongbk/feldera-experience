SHELL := /bin/bash

setup:
	@echo "Initializing the testing environment"
	@docker compose up -d pipeline-manager redpanda

clean:
	@echo "Clean up the spark environment"
	@docker-compose down --remove-orphans

validate_delta_output:
	@echo "Validating the output of the pipeline"
	@uv run python test_delta_output.py