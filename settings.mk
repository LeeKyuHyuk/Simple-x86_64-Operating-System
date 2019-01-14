-include config.mk

export SHELL := /bin/bash
export PARALLEL_JOBS := $(shell cat /proc/cpuinfo | grep cores | wc -l)
export WORKSPACE_DIR := $(shell cd "$(dirname "$0")" && pwd)
export SOURCES_DIR := $(WORKSPACE_DIR)/sources
export SCRIPTS_DIR := $(WORKSPACE_DIR)/scripts
export OUTPUT_DIR := $(WORKSPACE_DIR)/out
export BUILD_DIR := $(OUTPUT_DIR)/build
export TOOLS_DIR := $(OUTPUT_DIR)/tools
export IMAGES_DIR := $(OUTPUT_DIR)/images
export KERNEL_DIR := $(OUTPUT_DIR)/kernel
export PATH := $(TOOLS_DIR)/bin:$(TOOLS_DIR)/usr/bin:$(PATH)
