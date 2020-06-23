WORKFLOW_NAME?=rnaseq-star-align
VERSION := $(shell date -u +"%Y%m%dT%H%MZ")
REPO = rnaseq-star-align

GIT_SHORT_HASH:=$(shell git rev-parse --short HEAD)
COMMIT_HASH:=$(shell git rev-parse HEAD)

DOCKER_REPO := quay.io/repository/ncigdc
DOCKER_IMAGE_COMMIT := ${DOCKER_REPO}/${REPO}:${COMMIT_HASH}
DOCKER_IMAGE_LATEST := ${DOCKER_REPO}/${REPO}:latest
DOCKER_IMAGE := ${DOCKER_REPO}/${REPO}:${VERSION}

ENTRY_CWL = "star2pass.rnaseq_harmonization.cwl"

.PHONY: docker-*
docker-login:
	@echo
	$(shell docker login -u="${SQUAY_USERNAME}" -p="${SQUAY_PASSWORD}" quay.io)

.PHONY: version version-* name
name:
	@echo ${WORKFLOW_NAME}

version:
	@echo --- VERSION: ${VERSION} ---

version-docker:
	@echo ${DOCKER_IMAGE_COMMIT}
	@echo ${DOCKER_IMAGE}

.PHONY: build build-* clean init init-* lint requirements run version
init: init-pip init-hooks

init-pip:
	@echo
	@echo -- Installing pip packages --
	pip3 install --no-cache-dir cwltool==1.0.20180306163216

.PHONY: pack pack-%
pack:
	@python -m cwltool --pack "${ENTRY_CWL}"

.PHONY: run
run:
	@docker run --rm ${DOCKER_IMAGE_LATEST} pack ENTRY_CWL=${ENTRY_CWL}

.PHONY: validate validate-docker
validate:
	@python -m cwltool --validate "${ENTRY_CWL}"

validate-docker:
	@docker run --rm ${DOCKER_IMAGE_LATEST} validate ENTRY_CWL=${ENTRY_CWL}

.PHONY: build build-*

build: build-docker

build-docker:
	@echo
	@echo -- Building docker --
	docker build .. \
		--no-cache \
		--file ./Dockerfile \
		--build-arg WORKFLOW=${WORKFLOW_NAME} \
		-t "${DOCKER_IMAGE_COMMIT}" \
		-t "${DOCKER_IMAGE}" \
		-t "${DOCKER_IMAGE_LATEST}"

