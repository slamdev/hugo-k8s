IMAGE := slamdev/hugo

.PHONY: build
build:
	docker build -t $(IMAGE) .
	docker push $(IMAGE)

.PHONY: test
test:
	docker run --rm -v $$(pwd)/test:/opt/content -p 8080:8080 $(IMAGE)
