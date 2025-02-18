PACK_TARGET = consulscriptum.pack
PACK_VERSION = 0.1.0

BUILD_DIR := ./build
RPFMSCHEMA_DIR := ./.deps/rpfmschema
RPFMCLI_DIR := ./.deps/rpfmcli
ETWNG_DIR := ./.deps/etwng
RUBY_DIR := ./.deps/ruby

BIN_RUBY := $(RUBY_DIR)/bin/ruby.exe
BIN_RPFMCLI := $(RPFMCLI_DIR)/rpfm_cli
BIN_XML2UI := $(ETWNG_DIR)/ui/bin/xml2ui
RPFMSCHEMA_PATH := $(RPFMSCHEMA_DIR)/schema_rom2.ron
BIN_RPFMCLI_ROME2 := $(realpath $(BIN_RPFMCLI)) --game rome_2

RPFMCLI_VERSION := v4.3.14
RPFMCLI_BASE_URL := https://github.com/Frodo45127/rpfm/releases/download
RPFMCLI_DOWNLOADURL := $(RPFMCLI_BASE_URL)/$(RPFMCLI_VERSION)/rpfm-$(RPFMCLI_VERSION)-x86_64-pc-windows-msvc.zip

RUBY_VERSION := 3.4.2-1
RUBY_DOWNLOADURL := https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-$(RUBY_VERSION)/rubyinstaller-$(RUBY_VERSION)-x64.7z
RUBY_EXTRACTED_DIR := $(RUBY_DIR)/rubyinstaller-$(RUBY_VERSION)-x64

SEVENZIP_URL := https://www.7-zip.org/a/7za920.zip
SEVENZIP_DIR := ./.deps/7zip
SEVENZIP_BIN := $(SEVENZIP_DIR)/7za.exe

ETWNG_REPO = https://github.com/taw/etwng.git
ETWNG_REVISION = f87f7c9e21ff8f0ee7cdf466368db8a0aee19f23

UI_TARGETS := \
	$(BUILD_DIR)/ui/common\ ui/multiplayer_chat \
	$(BUILD_DIR)/ui/common\ ui/options_mods

$(PACK_TARGET): $(UI_TARGETS)
	@{ \
	  ${BIN_RPFMCLI_ROME2} pack create --pack-path=$@ && \
	  ${BIN_RPFMCLI_ROME2} pack add --pack-path=$@ -F './$(BUILD_DIR)/;' -t ${RPFMSCHEMA_PATH}; \
	} || { rm $@; exit 1; }

$(BUILD_DIR)/ui/common\ ui/multiplayer_chat: \
src/ui/common\ ui/multiplayer_chat.xml
	$(BIN_XML2UI) "$<" "$@"

$(BUILD_DIR)/ui/common\ ui/options_mods: \
src/ui/common\ ui/options_mods.xml
	$(BIN_XML2UI) "$<" "$@"

UI_TARGETS: \
	$(BUILD_DIR)/ui/common\ ui/multiplayer_chat \
	$(BUILD_DIR)/ui/common\ ui/options_mods

setup: \
	setup-rpfmcli \
	setup-rpfmschema \
	setup-etwng \
	setup-7z \
	setup-ruby
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(ETWNG_DIR)
	@mkdir -p $(RPFMCLI_DIR)
	@mkdir -p $(RPFMSCHEMA_DIR)
	@echo "Setup complete, all dependencies are ready."

setup-rpfmcli:
	@if [ ! -f $(BIN_RPFMCLI) ]; then \
		echo "rpfm_cli not found, downloading:"&& \
		echo "${RPFMCLI_DOWNLOADURL}"&& \
		mkdir -p $(RPFMCLI_DIR) && \
		curl -sL $(RPFMCLI_DOWNLOADURL) -o $(RPFMCLI_DIR)/rpfm_cli.zip && \
		echo "unzipping rpfm_cli..."&& \
		unzip -q $(RPFMCLI_DIR)/rpfm_cli.zip -d $(RPFMCLI_DIR) && \
		rm $(RPFMCLI_DIR)/rpfm_cli.zip&& \
		echo "rpfm_cli has been downloaded and extracted."; \
	fi

setup-rpfmschema: setup-rpfmcli
	@if [ ! -f "$(RPFMSCHEMA_PATH)" ]; then \
		echo "rpfm schema not found, updating..."&& \
		mkdir -p "$(RPFMSCHEMA_DIR)" && \
		echo "changing directory to $(RPFMSCHEMA_DIR) to update schema..."&& \
		echo "$(BIN_RPFMCLI_ROME2) schemas update --schema-path ./"&& \
		( cd "$(RPFMSCHEMA_DIR)" && $(BIN_RPFMCLI_ROME2) schemas update --schema-path ./ )&& \
		echo "Schema update complete."; \
	fi

setup-etwng: setup-ruby
	@if [ ! -f $(BIN_XML2UI) ]; then \
		echo "etwng not found, cloning..."&& \
		mkdir -p $(ETWNG_DIR) && \
		git clone --depth 1 $(ETWNG_REPO) $(ETWNG_DIR) && \
		cd $(ETWNG_DIR) && \
		git checkout -q $(ETWNG_REVISION) && \
		echo "Checked out to specific revision."; \
	fi

setup-ruby: setup-7z
	@if [ ! -f "$(RUBY_DIR)/bin/ruby" ]; then \
		echo "ruby not found, downloading ..." && \
		echo $(RUBY_DOWNLOADURL) && \
		mkdir -p $(RUBY_DIR) && \
		curl -sL $(RUBY_DOWNLOADURL) -o $(RUBY_DIR)/ruby.7z && \
		echo "unzipping ruby..." && \
		$(SEVENZIP_DIR)/7za x $(RUBY_DIR)/ruby.7z -o$(RUBY_DIR) -y && \
		mv -f $(RUBY_EXTRACTED_DIR)/* $(RUBY_DIR) && \
		rm -rf $(RUBY_EXTRACTED_DIR) && \
		rm $(RUBY_DIR)/ruby.7z && \
		echo "Ruby version $(RUBY_VERSION) has been downloaded and extracted."; \
	fi

setup-7z:
	@if [ ! -f "$(SEVENZIP_BIN)" ]; then \
		echo "7zip not found, downloading ..."&& \
		mkdir -p $(SEVENZIP_DIR) && \
		curl -sL $(SEVENZIP_URL) -o $(SEVENZIP_DIR)/7za920.zip && \
		echo "unzipping 7zip..."&& \
		powershell -Command "Expand-Archive -Path $(SEVENZIP_DIR)/7za920.zip -DestinationPath $(SEVENZIP_DIR)" && \
		rm $(SEVENZIP_DIR)/7za920.zip&& \
		echo "7zip has been downloaded and extracted."; \
	fi

# Declare phony targets to prevent conflicts with file names
.PHONY: setup setup-rpfmcli setup-rpfmschema setup-ruby setup-etwng setup-7z

