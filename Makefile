#!make
#
# Copyright (C) 2021-2025 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause
#
COMMIT_ID := $(shell git rev-parse --short=8 HEAD)
COMMIT_DATE := $(shell git show -s --format=%cd --date=short HEAD)
COMMIT_TIME := $(shell git show -s --format=%cd --date=format:'%H:%M:%S' HEAD)
VERSION_FILE := ./version.txt
VERSION_NUMBER := $(shell cat ${VERSION_FILE})
VERSION := $(VERSION_NUMBER)_$(COMMIT_DATE)_$(COMMIT_ID)

default: perfspect-riscv64

GOFLAGS_COMMON=-trimpath -mod=readonly -ldflags="-X perfspect/cmd.gVersion=$(VERSION) -s -w"
GO=CGO_ENABLED=0 GOOS=linux go

# Build the perfspect binary
.PHONY: perfspect
perfspect:
	GOARCH=amd64 $(GO) build $(GOFLAGS_COMMON) -gcflags="all=-spectre=all -N -l" -asmflags="all=-spectre=all" -o $@

# Build the perfspect binary for AARCH64
.PHONY: perfspect-aarch64
perfspect-aarch64:
	GOARCH=arm64 $(GO) build $(GOFLAGS_COMMON) -o $@

#Build the perfspect binary for RISC-V 64-bit
.PHONY: perfspect-riscv64 resources
perfspect-riscv64: resources
	GOARCH=riscv64 $(GO) build $(GOFLAGS_COMMON) -o $@

# Copy prebuilt tools to script resources
.PHONY: resources
resources:
	mkdir -p internal/script/resources
ifneq ("$(wildcard /prebuilt/tools)","") # /prebuilt/tools is a directory in the container
	@echo "Copying prebuilt tools from /prebuilt/tools to script resources"
	cp -r /prebuilt/tools/* internal/script/resources/
else # copy dev system tools to script resources
ifneq ("$(wildcard tools/bin)","")
		@echo "Copying dev system tools from tools/bin to script resources"
		cp -r tools/bin/* internal/script/resources/
else # no prebuilt tools found
		@echo "No prebuilt tools found in /prebuilt/tools or tools/bin"
endif
endif

# Build the distribution package
.PHONY: dist
dist: resources check perfspect perfspect-aarch64
	rm -rf dist/perfspect
	mkdir -p dist/perfspect/tools/x86_64
	mkdir -p dist/perfspect/tools/aarch64
	mkdir -p dist/perfspect/tools/riscv64
	cp LICENSE dist/perfspect/
	cp THIRD_PARTY_PROGRAMS dist/perfspect/
	cp NOTICE dist/perfspect/
	cp targets.yaml dist/perfspect/
	cp perfspect dist/perfspect/
	cd dist && tar -czf perfspect.tgz perfspect
	cd dist && md5sum perfspect.tgz > perfspect.tgz.md5.txt
	# for aarch64 dist, overwrite perfspect binary
	cp perfspect-aarch64 dist/perfspect/perfspect
	cd dist && tar -czf perfspect-aarch64.tgz perfspect
	cd dist && md5sum perfspect-aarch64.tgz > perfspect-aarch64.tgz.md5.txt
	# for riscv64 dist
	cp perfspect-riscv64 dist/perfspect/perfspect
	cd dist && tar -czf perfspect-riscv64.tgz perfspect
	cd dist && md5sum perfspect-riscv64.tgz > perfspect-riscv64.tgz.md5.txt
	rm -rf dist/perfspect
	echo '{"version": "$(VERSION_NUMBER)", "date": "$(COMMIT_DATE)", "time": "$(COMMIT_TIME)", "commit": "$(COMMIT_ID)" }' | jq '.' > dist/manifest.json
ifneq ("$(wildcard /prebuilt)","") # /prebuilt is a directory in the container
	cp -r /prebuilt/oss_source* dist/
endif

# Run package-level unit tests
.PHONY: test
test:
	@echo "Running unit tests..."
	go test -v ./...
	cd tools/stackcollapse-perf && go test -v ./...

.PHONY: update-deps
update-deps:
	@echo "Updating Go dependencies..."
	go get -u ./...
	go mod tidy

# Check code formatting
.PHONY: check_format
check_format:
	@echo "Running gofmt to check for code formatting issues..."
	@test -z "$(shell gofmt -l -s ./)" || { echo "[WARN] Formatting issues detected. Resolve with 'make format'"; exit 1; }
	@echo "gofmt detected no issues"

# Format code
.PHONY: format
format:
	@echo "Running gofmt to format code..."
	gofmt -l -w -s ./

.PHONY: check_vet
check_vet:
	@echo "Running go vet to check for suspicious constructs..."
	@test -z "$(shell go vet ./...)" || { echo "[WARN] go vet detected issues"; exit 1; }
	@echo "go vet detected no issues"

.PHONY: check_static
check_static:
	@echo "Skipping staticcheck on RISC-V (unsupported)"

.PHONY: check_license
check_license:
	@echo "Confirming source files have license headers..."
	@for f in `find . -type f \
		! -path './perfspect_202*' \
		! -path './tools/bin/*' \
		! -path './tools/bin-aarch64/*' \
		! -path './tools/bin-riscv64/*' \
		! -path './internal/script/resources/*' \
		! -path './scripts/.venv/*' \
		! -path './test/output/*' \
		! -path './debug_out/*' \
		! -path './tools/perf-archive/*' \
		! -path './tools/avx-turbo/*' \
		\( -name "*.go" -o -name "*.s" -o -name "*.html" -o -name "Makefile" -o -name "*.sh" -o -name "*.Dockerfile" -o -name "*.py" \)`; do \
			if ! grep -E 'SPDX-License-Identifier: BSD-3-Clause' "$$f" >/dev/null; then echo "Error: license not found: $$f"; fail=1; fi; \
		done; if [ -n "$$fail" ]; then exit 1; fi

.PHONY: check_lint
check_lint:
	@echo "Skipping golangci-lint on RISC-V (unsupported)"

.PHONY: check_vuln
check_vuln:
	@echo "Skipping govulncheck on RISC-V (unsupported)"

.PHONY: check_sec
check_sec:
	@echo "Skipping gosec on RISC-V (unsupported)"

.PHONY: check_semgrep
check_semgrep:
	@echo "Skipping semgrep on RISC-V (unsupported)"

.PHONY: check_modernize
check_modernize:
	@echo "Skipping go-modernize on RISC-V (unsupported)"

.PHONY: modernize
modernize:
	@echo "Skipping go-modernize fix on RISC-V (unsupported)"

.PHONY: check
check: check_format check_vet check_static check_license check_lint check_vuln check_modernize

.PHONY: sweep
sweep:
	rm -rf perfspect_2025-*
	rm -rf debug_out/*
	rm -rf test/output
	rm -f __debug_bin*.log
	rm -f perfspect.log

.PHONY: clean
clean: sweep
	@echo "Cleaning up..."
	rm -f perfspect
	rm -f perfspect-aarch64
	rm -f perfspect-riscv64
	sudo rm -rf dist
	rm -rf internal/script/resources
