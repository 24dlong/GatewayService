export DOCKER_BUILDKIT   := 1
export PROJECT_SLUG 	 := gateway-service

bootstrap:
	docker compose build ${PROJECT_SLUG} && docker compose up