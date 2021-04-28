VERSION := $(shell cat VERSION)
IMAGE_NAME := determinedai/tf-wheel-builder
CONTAINER_NAME := tf-wheel-builder
WHEEL_DIR := whl/

.PHONY: build
build: build-builder
	docker rm $(CONTAINER_NAME)
	docker run -t --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION)
	mkdir -p $(WHEEL_DIR)
	docker cp $(CONTAINER_NAME):/tensorflow/pip_test/whl/tensorflow_gpu-1.15.5-cp37-cp37m-linux_x86_64.whl $(WHEEL_DIR)

.PHONY: build-builder
build-builder:
	docker build -t $(IMAGE_NAME):$(VERSION) .

.PHONY: clean
clean:
	docker rm $(CONTAINER_NAME)
	rm whl/*.whl
