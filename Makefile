.PHONY: build
build:
	docker build -t ghcr.io/devem-tech/vpn:latest .

.PHONY: push
push: build
	# Settings > Developer Settings
	# docker login ghcr.io -u <username> -p <personal_access_token>
	docker push ghcr.io/devem-tech/vpn:latest
