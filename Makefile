# Mod file name
PACK_TARGET = consulscriptum.pack
PACK_VERSION = 0.1.0

# Directories for dependencies and build files
RPFMSCHEMA_DIR := ./.deps/rpfmschema
RPFMCLI_DIR := ./.deps/rpfmcli
ETWNG_DIR := ./.deps/etwng
BIN_XML2UI := $(ETWNG_DIR)/ui/bin/xml2ui
BUILD_DIR := ./build

# Paths to executables and schema file
BIN_RPFMCLI := $(RPFMCLI_DIR)/rpfm_cli
RPFMSCHEMA_PATH := $(RPFMSCHEMA_DIR)/schema_rom2.ron

# URL for downloading rpfm_cli tool
RPFMCLI_VERSION := v4.3.14
RPFMCLI_BASE_URL := https://github.com/Frodo45127/rpfm/releases/download
RPFMCLI_DOWNLOADURL := $(RPFMCLI_BASE_URL)/$(RPFMCLI_VERSION)/rpfm-$(RPFMCLI_VERSION)-x86_64-pc-windows-msvc.zip

# Game-specific settings for rpfm_cli tool
BIN_RPFMCLI_ROME2 := $(realpath $(BIN_RPFMCLI)) --game rome_2

# UI targets for specific game components
UI_TARGETS := \
	$(BUILD_DIR)/ui/common\ ui/multiplayer_chat \
	$(BUILD_DIR)/ui/common\ ui/options_mods

# Rule for creating the mod package with rpfm_cli
$(PACK_TARGET): $(UI_TARGETS)
	@{ \
	  ${BIN_RPFMCLI_ROME2} pack create --pack-path=$@ && \
	  ${BIN_RPFMCLI_ROME2} pack add --pack-path=$@ -F './$(BUILD_DIR)/;' -t ${RPFMSCHEMA_PATH}; \
	} || { rm $@; exit 1; }

# Build rule for multiplayer_chat UI component
$(BUILD_DIR)/ui/common\ ui/multiplayer_chat: \
src/ui/common\ ui/multiplayer_chat.xml
	$(BIN_XML2UI) "$<" "$@"

# Build rule for options_mods UI component
$(BUILD_DIR)/ui/common\ ui/options_mods: \
src/ui/common\ ui/options_mods.xml
	$(BIN_XML2UI) "$<" "$@"

# Phony target for grouping multiple UI targets
UI_TARGETS: \
	$(BUILD_DIR)/ui/common\ ui/multiplayer_chat \
	$(BUILD_DIR)/ui/common\ ui/options_mods

# Setup target to prepare all necessary dependencies
setup: \
	setup-rpfmcli \
	setup-rpfmschema \
	setup-etwng
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(ETWNG_DIR)
	@mkdir -p $(RPFMCLI_DIR)
	@mkdir -p $(RPFMSCHEMA_DIR)
	@echo "Setup complete, all dependencies are ready."

# Rule for setting up rpfm_cli
setup-rpfmcli:
	@if [ ! -f $(BIN_RPFMCLI) ]; then \
		echo "rpfm_cli not found, downloading:"; \
		echo "${RPFMCLI_DOWNLOADURL}"; \
		mkdir -p $(RPFMCLI_DIR) && \
		curl -sL $(RPFMCLI_DOWNLOADURL) -o $(RPFMCLI_DIR)/rpfm_cli.zip && \
		echo "unzipping rpfm_cli..."; \
		unzip -q $(RPFMCLI_DIR)/rpfm_cli.zip -d $(RPFMCLI_DIR) && \
		rm $(RPFMCLI_DIR)/rpfm_cli.zip; \
		echo "rpfm_cli has been downloaded and extracted."; \
	fi

# Rule for setting up rpfm schema using rpfm_cli
setup-rpfmschema: setup-rpfmcli
	@if [ ! -f "$(RPFMSCHEMA_PATH)" ]; then \
		echo "rpfm schema not found, updating..."; \
		mkdir -p "$(RPFMSCHEMA_DIR)" && \
		echo "changing directory to $(RPFMSCHEMA_DIR) to update schema..."; \
		echo "$(BIN_RPFMCLI_ROME2) schemas update --schema-path ./"; \
		( cd "$(RPFMSCHEMA_DIR)" && $(BIN_RPFMCLI_ROME2) schemas update --schema-path ./ ); \
		echo "Schema update complete."; \
	fi

# Setup target to download and clone etwng at specific revision
setup-etwng:
	@if [ ! -f $(BIN_XML2UI) ]; then \
		echo "etwng not found, cloning..."; \
		mkdir -p $(ETWNG_DIR) && \
		git clone --depth 1 https://github.com/taw/etwng.git $(ETWNG_DIR) && \
		cd $(ETWNG_DIR) && \
		git checkout -q f87f7c9e21ff8f0ee7cdf466368db8a0aee19f23 && \
		echo "Checked out to specific revision."; \
	fi

# Declare phony targets to prevent conflicts with file names
.PHONY: setup setup-rpfmcli setup-rpfmschema