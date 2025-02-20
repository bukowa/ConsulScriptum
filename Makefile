# Mod package information
MOD_PACKAGE = consulscriptum.pack
MOD_VERSION = 0.1.0

# ============================================================
# Instructions for Executing This Makefile on Windows
# ============================================================
#
# 1. Install GNU Make for Windows:
#    - Download it from:
#      https://sourceforge.net/projects/gnuwin32/files/make/3.81/make-3.81-bin.zip/download
#
# 2. Install Git for Windows (which includes Git Bash):
#    - Download it from:
#      https://git-scm.com/downloads/win
#
# 3. Update Your System PATH:
#    - After installing GNU Make, add its installation directory (where make.exe is located)
#      to your system's PATH environment variable.
#
# 4. Running the Makefile:
#    - Open the Git Bash shell.
#    - Navigate to the directory containing this Makefile.
#    - Execute the command: `make setup`
#
# Note:
# This Makefile has been designed and tested for use with GNU Make in the Git Bash shell.
# ============================================================

# Directories for dependencies and build files
BUILD_DIR         := ./build
DEPS_DIR		  := ./.deps
RPFM_SCHEMA_DIR   := $(DEPS_DIR)/rpfm_schema
RPFM_CLI_DIR      := $(DEPS_DIR)/rpfm_cli
ETWNG_DIR         := $(DEPS_DIR)/etwng
RUBY_DIR          := $(DEPS_DIR)/ruby

# Binaries and paths
RUBY_BIN          := $(RUBY_DIR)/bin/ruby.exe
RPFM_CLI_BIN      := $(RPFM_CLI_DIR)/rpfm_cli
XML2UI_BIN        := $(ETWNG_DIR)/ui/bin/xml2ui
RPFM_SCHEMA_PATH  := $(RPFM_SCHEMA_DIR)/schema_rom2.ron
RPFM_CLI_ROME2_CMD := $(realpath $(RPFM_CLI_BIN)) --game rome_2

# rpfm_cli details
RPFM_CLI_VERSION       := v4.3.14
RPFM_CLI_BASE_URL      := https://github.com/Frodo45127/rpfm/releases/download
RPFM_CLI_DOWNLOAD_URL  := $(RPFM_CLI_BASE_URL)/$(RPFM_CLI_VERSION)/rpfm-$(RPFM_CLI_VERSION)-x86_64-pc-windows-msvc.zip

# Ruby details
RUBY_VERSION          := 3.4.2-1
RUBY_DOWNLOAD_URL     := https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-$(RUBY_VERSION)/rubyinstaller-$(RUBY_VERSION)-x64.7z
RUBY_EXTRACTED_DIR    := $(RUBY_DIR)/rubyinstaller-$(RUBY_VERSION)-x64

# 7-Zip details
SEVENZIP_DOWNLOAD_URL := https://www.7-zip.org/a/7za920.zip
SEVENZIP_DIR          := $(DEPS_DIR)/7zip
SEVENZIP_BIN          := $(SEVENZIP_DIR)/7za.exe

# ETWNG repository details
ETWNG_REPO     = https://github.com/taw/etwng.git
ETWNG_REVISION = f87f7c9e21ff8f0ee7cdf466368db8a0aee19f23

# Installation directories
INSTALL_ALONE_DIR := C:/Games/Total War - Rome 2
INSTALL_STEAM_DIR := C:/Program Files (x86)/Steam/steamapps/common/Total War Rome II
INSTALL_USER_SCRIPT := C:/Users/$(USERNAME)/AppData/Roaming/The\ Creative\ Assembly/Rome2/scripts

# ============================================================
# Start Source Files
# ============================================================

DIR_TARGETS := \
	$(BUILD_DIR)/lua_scripts \
	$(BUILD_DIR)/script/consulscriptum \
	$(BUILD_DIR)/ui/common\ ui \
	$(BUILD_DIR)/ui/frontend\ ui

UI_TARGETS := \
	$(BUILD_DIR)/ui/common\ ui/options_mods \
	$(BUILD_DIR)/ui/common\ ui/menu_bar \
	$(BUILD_DIR)/ui/frontend\ ui/sp_frame

LUA_TARGETS := \
	$(BUILD_DIR)/lua_scripts/all_scripted.lua \
	$(BUILD_DIR)/script/consulscriptum/consulscriptum_logging.lua

# Rule for creating the mod package with rpfm_cli
$(MOD_PACKAGE): $(DIR_TARGETS) $(UI_TARGETS) $(LUA_TARGETS)
	@{ \
	  ${RPFM_CLI_ROME2_CMD} pack create --pack-path=$@ && \
	  ${RPFM_CLI_ROME2_CMD} pack add --pack-path=$@ -F './$(BUILD_DIR)/;' -t ${RPFM_SCHEMA_PATH} && \
	  echo "Pack file built successfully." ; \
	} || { rm $@; exit 1; }

$(DIR_TARGETS):
	@mkdir -p $@

$(BUILD_DIR)/ui/common\ ui/options_mods: \
	src/ui/common\ ui/options_mods.xml
	$(XML2UI_BIN) "$<" "$@"

$(BUILD_DIR)/ui/common\ ui/menu_bar: \
	src/ui/common\ ui/menu_bar.xml
	$(XML2UI_BIN) "$<" "$@"

$(BUILD_DIR)/ui/frontend\ ui/sp_frame: \
	src/ui/frontend\ ui/sp_frame.xml
	$(XML2UI_BIN) "$<" "$@"

$(BUILD_DIR)/lua_scripts/all_scripted.lua: \
	src/lua_scripts/all_scripted.lua
	@cp "$<" "$@"

$(BUILD_DIR)/script/consulscriptum/consulscriptum_logging.lua: \
	src/script/consulscriptum/consulscriptum_logging.lua
	@cp "$<" "$@"

# ============================================================
# End Source Files
# ============================================================

# Setup target to prepare all necessary dependencies
setup: \
	setup-rpfm_cli \
	setup-rpfm_schema \
	setup-etwng \
	setup-7zip \
	setup-ruby
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(ETWNG_DIR)
	@mkdir -p $(RPFM_CLI_DIR)
	@mkdir -p $(RPFM_SCHEMA_DIR)
	@echo "Setup complete, all dependencies are ready."

# Cleaning up all build artifacts and generated mod packages
clean:
	@rm -rf $(BUILD_DIR)
	@rm -f $(MOD_PACKAGE)
	@rm -f $(INSTALL_ALONE_DIR)/data/$(MOD_PACKAGE)
	@rm -f '$(INSTALL_STEAM_DIR)/data/$(MOD_PACKAGE)'
	@echo "Cleaned up build directory and mod package."

# Rule for setting up rpfm_cli
setup-rpfm_cli:
	@if [ ! -f $(RPFM_CLI_BIN) ]; then \
		echo "rpfm_cli not found, downloading:" && \
		echo "${RPFM_CLI_DOWNLOAD_URL}" && \
		mkdir -p $(RPFM_CLI_DIR) && \
		curl -sL $(RPFM_CLI_DOWNLOAD_URL) -o $(RPFM_CLI_DIR)/rpfm_cli.zip && \
		echo "unzipping rpfm_cli..." && \
		unzip -q $(RPFM_CLI_DIR)/rpfm_cli.zip -d $(RPFM_CLI_DIR) && \
		rm $(RPFM_CLI_DIR)/rpfm_cli.zip && \
		echo "rpfm_cli has been downloaded and extracted."; \
	fi

# Rule for setting up rpfm schema
setup-rpfm_schema: setup-rpfm_cli
	@if [ ! -f "$(RPFM_SCHEMA_PATH)" ]; then \
		echo "rpfm schema not found, updating..." && \
		mkdir -p "$(RPFM_SCHEMA_DIR)" && \
		echo "changing directory to $(RPFM_SCHEMA_DIR) to update schema..." && \
		echo "$(RPFM_CLI_ROME2_CMD) schemas update --schema-path ./" && \
		( cd "$(RPFM_SCHEMA_DIR)" && $(RPFM_CLI_ROME2_CMD) schemas update --schema-path ./ ) && \
		echo "Schema update complete."; \
	fi

# Rule for setting up ETWNG (requires Ruby)
setup-etwng: setup-ruby
	@if [ ! -f $(XML2UI_BIN) ]; then \
		echo "etwng not found, cloning..." && \
		mkdir -p $(ETWNG_DIR) && \
		git clone --depth 1 $(ETWNG_REPO) $(ETWNG_DIR) && \
		cd $(ETWNG_DIR) && \
		git checkout -q $(ETWNG_REVISION) && \
		echo "Checked out to specific revision."; \
	fi

# Rule for setting up 7-Zip
setup-7zip:
	@if [ ! -f "$(SEVENZIP_BIN)" ]; then \
		echo "7zip not found, downloading..." && \
		mkdir -p $(SEVENZIP_DIR) && \
		curl -sL $(SEVENZIP_DOWNLOAD_URL) -o $(SEVENZIP_DIR)/7za920.zip && \
		echo "unzipping 7zip..." && \
		powershell -Command "Expand-Archive -Path $(SEVENZIP_DIR)/7za920.zip -DestinationPath $(SEVENZIP_DIR)" && \
		rm $(SEVENZIP_DIR)/7za920.zip && \
		echo "7zip has been downloaded and extracted."; \
	fi

# Rule for setting up Ruby (requires 7-Zip)
setup-ruby: setup-7zip
	@if [ ! -f "$(RUBY_DIR)/bin/ruby" ]; then \
		echo "ruby not found, downloading ..." && \
		echo $(RUBY_DOWNLOAD_URL) && \
		mkdir -p $(RUBY_DIR) && \
		curl -sL $(RUBY_DOWNLOAD_URL) -o $(RUBY_DIR)/ruby.7z && \
		echo "unzipping ruby..." && \
		$(SEVENZIP_DIR)/7za x $(RUBY_DIR)/ruby.7z -o$(RUBY_DIR) -y && \
		mv -f $(RUBY_EXTRACTED_DIR)/* $(RUBY_DIR) && \
		rm -rf $(RUBY_EXTRACTED_DIR) && \
		rm $(RUBY_DIR)/ruby.7z && \
		echo "Ruby version $(RUBY_VERSION) has been downloaded and extracted."; \
	fi

# Install Steam and alone
install: \
	install-alone \
	install-steam

# Install the built .pack file only if different for Steam
install-steam: $(MOD_PACKAGE)
	$(call install-to-dir,$(INSTALL_STEAM_DIR)/data)

# Install the built .pack file only if different for standalone
install-alone: $(MOD_PACKAGE)
	@echo 'mod "$(MOD_PACKAGE)";' > $(INSTALL_USER_SCRIPT)/user.script.txt
	$(call install-to-dir,$(INSTALL_ALONE_DIR)/data)

# Function to install the mod package to a specified directory
install-to-dir = \
	@if [ ! -f "$1/$(MOD_PACKAGE)" ] || ! cmp -s "$<" "$1/$(MOD_PACKAGE)"; then \
		cp "$<" "$1/$(MOD_PACKAGE)" && \
		echo "Mod package installed successfully to $1"; \
	fi

# Attempt to find and terminate the Rome 2 process by its name.
kill-rome2:
	@pid=$$(tasklist | grep Rome2.exe | head -n 1 | awk '{print $$2}') && \
	if [ -n "$$pid" ]; then \
		cmd //C "taskkill /F /PID $$pid" && \
		while tasklist | grep -q $$pid; do sleep 1; done; \
	fi

# Launch the standalone version of Rome2.exe with the specified working directory
run-alone: \
	kill-rome2 \
	install-alone
	@powershell -Command Start-Process "Rome2.exe" -WorkingDirectory '"$(INSTALL_ALONE_DIR)"'

# Launch the Steam version of Rome2 using its Steam app ID
run-steam: \
	kill-rome2 \
	install-steam
	@powershell -Command start steam://rungameid/214950


alone: run-alone

# Its strongly suggested to run steam in offline mode due to various bugs/
steam: run-steam

# Declare phony targets to prevent conflicts with file names
.PHONY: setup \
			setup-7zip \
			setup-rpfm_cli \
			setup-rpfm_schema \
			setup-ruby \
			setup-etwng \
		install \
			install-steam \
			install-alone \
		kill-rome \
		run-alone \
		run-steam \
		steam \
		alone \
		clean
