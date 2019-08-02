TAG             := $(TAG)
DOCKER_USERNAME := $(DOCKER_USERNAME)
DOCKER_PASSWORD := $(DOCKER_PASSWORD)
SAVE_DIR        := $(SAVE_DIR)


build: check-common-env
	sed -i -e "s/\(FROM.*\):dev/\1:$(TAG)/" */Dockerfile
	docker build -t sider/devon_rex_base:$(TAG) base
	docker build -t sider/devon_rex_go:$(TAG) go
	docker build -t sider/devon_rex_java:$(TAG) java
	docker build -t sider/devon_rex_npm:$(TAG) npm
	docker build -t sider/devon_rex_php:$(TAG) php
	docker build -t sider/devon_rex_python:$(TAG) python
	docker build -t sider/devon_rex_ruby:$(TAG) ruby
	docker build -t sider/devon_rex_swift:$(TAG) swift


save: check-common-env
	docker save sider/devon_rex_base:$(TAG) | gzip -c > $(SAVE_DIR)/devon_rex_base:$(TAG).tgz
	docker save sider/devon_rex_go:$(TAG) | gzip -c > $(SAVE_DIR)/devon_rex_go:$(TAG).tgz
	docker save sider/devon_rex_java:$(TAG) | gzip -c > $(SAVE_DIR)/devon_rex_java:$(TAG).tgz
	docker save sider/devon_rex_npm:$(TAG) | gzip -c > $(SAVE_DIR)/devon_rex_npm:$(TAG).tgz
	docker save sider/devon_rex_php:$(TAG) | gzip -c > $(SAVE_DIR)/devon_rex_php:$(TAG).tgz
	docker save sider/devon_rex_python:$(TAG) | gzip -c > $(SAVE_DIR)/devon_rex_python:$(TAG).tgz
	docker save sider/devon_rex_ruby:$(TAG) | gzip -c > $(SAVE_DIR)/devon_rex_ruby:$(TAG).tgz
	docker save sider/devon_rex_swift:$(TAG) | gzip -c > $(SAVE_DIR)/devon_rex_swift:$(TAG).tgz


load: check-common-env
	docker load $(SAVE_DIR)/devon_rex_base:$(TAG).tgz
	docker load $(SAVE_DIR)/devon_rex_go:$(TAG).tgz
	docker load $(SAVE_DIR)/devon_rex_java:$(TAG).tgz
	docker load $(SAVE_DIR)/devon_rex_npm:$(TAG).tgz
	docker load $(SAVE_DIR)/devon_rex_php:$(TAG).tgz
	docker load $(SAVE_DIR)/devon_rex_python:$(TAG).tgz
	docker load $(SAVE_DIR)/devon_rex_ruby:$(TAG).tgz
	docker load $(SAVE_DIR)/devon_rex_swift:$(TAG).tgz


release: check-common-env check-release-env
	docker login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD)
	docker tag sider/devon_rex_base:$(TAG) sider/devon_rex_base:latest
	docker tag sider/devon_rex_go:$(TAG) sider/devon_rex_go:latest
	docker tag sider/devon_rex_java:$(TAG) sider/devon_rex_java:latest
	docker tag sider/devon_rex_npm:$(TAG) sider/devon_rex_npm:latest
	docker tag sider/devon_rex_php:$(TAG) sider/devon_rex_php:latest
	docker tag sider/devon_rex_python:$(TAG) sider/devon_rex_python:latest
	docker tag sider/devon_rex_ruby:$(TAG) sider/devon_rex_ruby:latest
	docker tag sider/devon_rex_swift:$(TAG) sider/devon_rex_swift:latest
	docker push sider/devon_rex_base:$(TAG)
	docker push sider/devon_rex_go:$(TAG)
	docker push sider/devon_rex_java:$(TAG)
	docker push sider/devon_rex_npm:$(TAG)
	docker push sider/devon_rex_php:$(TAG)
	docker push sider/devon_rex_python:$(TAG)
	docker push sider/devon_rex_ruby:$(TAG)
	docker push sider/devon_rex_swift:$(TAG)
	docker push sider/devon_rex_base:latest
	docker push sider/devon_rex_go:latest
	docker push sider/devon_rex_java:latest
	docker push sider/devon_rex_npm:latest
	docker push sider/devon_rex_php:latest
	docker push sider/devon_rex_python:latest
	docker push sider/devon_rex_ruby:latest
	docker push sider/devon_rex_swift:latest


check-common-env:
ifndef TAG
	$(error TAG is undefined)
endif
ifndef SAVE_DIR
	$(error SAVE_DIR is undefined)
endif


check-release-env:
ifndef DOCKER_USERNAME
	$(error DOCKER_USERNAME is undefined)
endif
ifndef DOCKER_PASSWORD
	$(error DOCKER_PASSWORD is undefined)
endif


.PHONY: build save load release check-common-env check-release-env
