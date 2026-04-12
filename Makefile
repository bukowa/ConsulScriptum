# Mod package information
MOD_PACKAGE = consulscriptum.pack
MOD_VERSION = 0.1.0

# Game selection (Rome2 or Attila)
GAME ?= Attila
# Development mode (1 to enable)
DEV ?= 0

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
LDOC_DIR 		  := $(DEPS_DIR)/ldoc
LUA_DIR           := $(DEPS_DIR)/lua
PENLIGHT_DIR      := $(DEPS_DIR)/penlight
MAKE_DIR          := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

# Game-specific settings
ifeq ($(GAME),Rome2)
    RPFM_GAME_ID := rome_2
    RPFM_SCHEMA_FILE := schema_rom2.ron
    INSTALL_ALONE_DIR := C:/Program Files (x86)/Steam/steamapps/common/Total War Rome II
    INSTALL_STEAM_DIR := C:/Program Files (x86)/Steam/steamapps/common/Total War Rome II
    INSTALL_USER_SCRIPT := C:/Users/$(USERNAME)/AppData/Roaming/The\ Creative\ Assembly/Rome2/scripts
    GAME_EXE := Rome2.exe
    STEAM_APP_ID := 214950
    ALL_SCRIPTED_SRC := src/lua_scripts/all_scripted_rome2.lua
else
    # Default is Attila
    RPFM_GAME_ID := attila
    RPFM_SCHEMA_FILE := schema_att.ron
    INSTALL_ALONE_DIR := C:\Games\Total War - Attila_16
    INSTALL_STEAM_DIR := C:/Program Files (x86)/Steam/steamapps/common/Total War Attila
    INSTALL_USER_SCRIPT := C:/Users/$(USERNAME)/AppData/Roaming/The\ Creative\ Assembly/Attila/scripts
    GAME_EXE := Attila.exe
    STEAM_APP_ID := 325610
    ALL_SCRIPTED_SRC := src/lua_scripts/all_scripted_attila.lua
endif

# Binaries and paths
RUBY_BIN          := $(RUBY_DIR)/bin/ruby.exe
RPFM_CLI_BIN      := $(RPFM_CLI_DIR)/rpfm_cli
XML2UI_BIN        := $(ETWNG_DIR)/ui/bin/xml2ui
UI2XML_BIN        := $(ETWNG_DIR)/ui/bin/ui2xml
RPFM_SCHEMA_PATH  := $(RPFM_SCHEMA_DIR)/$(RPFM_SCHEMA_FILE)
RPFM_CLI_CMD      := $(realpath $(RPFM_CLI_BIN)) --game $(RPFM_GAME_ID)
LUA_FOR_LDOC_PATH := $(LUA_DIR)/lua5.1.exe

# Gems
PATH := $(RUBY_DIR)/bin:$(PATH)
GEM_HOME := $(RUBY_DIR)/lib/ruby/gems/3.4.0
GEM_PATH := $(GEM_HOME)

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

# ldoc details
LDOC_REPO     = "https://github.com/lunarmodules/ldoc.git"
LDOC_REVISION = "b8b574c8a67019e26a423af1b8c141d306ab58b2"

# Lua (for running ldoc)
LUA_VERSION      := 5.1.5
LUA_DOWNLOAD_URL := https://sourceforge.net/projects/luabinaries/files/$(LUA_VERSION)/Tools%20Executables/lua-$(LUA_VERSION)_Win64_bin.zip/download
PENLIGHT_REPO    = https://github.com/lunarmodules/Penlight.git
PENLIGHT_REVISION = 1c85dd5418ee9aef71b4dc527fedf6714c139a6b

# ============================================================
# Start Source Files
# ============================================================
UI_TARGETS :=
ifeq ($(GAME),Attila)
UI_TARGETS += $(BUILD_DIR)/ui/common\ ui/consul
ifeq ($(DEV),1)
UI_TARGETS += $(BUILD_DIR)/ui/frontend\ ui/layout
endif
endif
ifeq ($(GAME),Rome2)
UI_TARGETS += $(BUILD_DIR)/ui/common\ ui/menu_bar \
			  $(BUILD_DIR)/ui/frontend\ ui/sp_frame
endif

LUA_TARGETS := \
	$(BUILD_DIR)/lua_scripts/all_scripted.lua \
	$(BUILD_DIR)/consul/consul_logging.lua \
	$(BUILD_DIR)/consul/consul.lua \
	$(BUILD_DIR)/consul/consul_battle.lua \
	$(BUILD_DIR)/consul/consul_changelog.lua \
	$(BUILD_DIR)/consul/consul_game_events.lua \
	$(BUILD_DIR)/consul/consul_commands.lua \
	$(BUILD_DIR)/consul/consul_commands_dei.lua

IMAGE_TARGETS := \
	$(BUILD_DIR)/ui/skins/default/consul_v_slider_end.png \
	$(BUILD_DIR)/ui/skins/default/arrow_out.png

CONTRIB_TARGETS := \
	$(BUILD_DIR)/consul/inspect/inspect.lua \
	$(BUILD_DIR)/consul/serpent/serpent.lua \
	$(BUILD_DIR)/consul/penlight/compat.lua \
	$(BUILD_DIR)/consul/penlight/lexer.lua \
	$(BUILD_DIR)/consul/penlight/pretty.lua \
	$(BUILD_DIR)/consul/penlight/stringx.lua \
	$(BUILD_DIR)/consul/penlight/types.lua \
	$(BUILD_DIR)/consul/penlight/utils.lua \
	$(BUILD_DIR)/consul/profi/profi.lua \
	$(BUILD_DIR)/consul/profile/profile.lua

# Rule for creating the mod package with rpfm_cli
$(MOD_PACKAGE): $(UI_TARGETS) $(LUA_TARGETS) $(CONTRIB_TARGETS) $(IMAGE_TARGETS)
	@{ \
	  ${RPFM_CLI_CMD} pack create --pack-path=$@ && \
	  ${RPFM_CLI_CMD} pack add --pack-path=$@ -F './$(BUILD_DIR)/;' -t ${RPFM_SCHEMA_PATH} && \
	  echo "Pack file built successfully." ; \
	} || { rm $@; exit 1; }

define create_dir
	@mkdir -p $(dir $@)
endef

$(BUILD_DIR)/ui/skins/default/consul_v_slider_end.png: \
	src/ui/skins/default/consul_v_slider_end.png
	$(create_dir)
	@cp "$<" "$@"


$(BUILD_DIR)/ui/skins/default/arrow_out.png: \
	src/ui/skins/default/arrow_out.png
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/pl: src/pl $(wildcard $(BUILD_DIR)/pl/*.lua)
	@mkdir -p "$@"
	@cp -r src/pl/* $@

$(BUILD_DIR)/ui/common\ ui/multiplayer_chat: \
	src/ui/common\ ui/multiplayer_chat.xml
	$(create_dir)
	$(XML2UI_BIN) "$<" "$@"

$(BUILD_DIR)/ui/common\ ui/options_mods: \
	src/ui/common\ ui/options_mods.xml
	$(create_dir)
	$(XML2UI_BIN) "$<" "$@"

$(BUILD_DIR)/ui/common\ ui/consul: \
	src/ui/common\ ui/consul.xml
	$(create_dir)
	$(XML2UI_BIN) "$<" "$@"

$(BUILD_DIR)/ui/common\ ui/menu_bar: \
	src/ui/common\ ui/menu_bar.xml
	$(create_dir)
	$(XML2UI_BIN) "$<" "$@"

$(BUILD_DIR)/ui/frontend\ ui/sp_frame: \
	src/ui/frontend\ ui/sp_frame.xml
	$(create_dir)
	$(XML2UI_BIN) "$<" "$@"

$(BUILD_DIR)/ui/frontend\ ui/layout: \
	src/ui/frontend\ ui/layout.xml
	$(create_dir)
	$(XML2UI_BIN) "$<" "$@"

$(BUILD_DIR)/ui/common\ ui/encyclopedia_unit_info_template: \
	src/ui/common\ ui/encyclopedia_unit_info_template.xml
	$(create_dir)
	$(XML2UI_BIN) "$<" "$@"

$(BUILD_DIR)/lua_scripts/all_scripted.lua: \
	$(ALL_SCRIPTED_SRC)
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/lua_scripts/frontend_scripted.lua: \
	src/lua_scripts/frontend_scripted.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/lua_scripts/battle_scripted.lua: \
	src/lua_scripts/battle_scripted.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/consul_logging.lua: \
	src/consul/consul_logging.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/consul_config.lua: \
	src/consul/consul_config.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/consul_game_events.lua: \
	src/consul/$(if $(filter Attila,$(GAME)),consul_game_events_attila.lua,consul_game_events.lua)
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/consul_changelog.lua: \
	src/consul/consul_changelog.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/consul_toggle.lua: \
	src/consul/consul_toggle.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/consul.lua: \
	src/consul/consul.lua
	$(create_dir)
	@sed 's/consul_build = ".*"/consul_build = "$(GAME)"/' "$<" > "$@"

$(BUILD_DIR)/consul/consul_commands.lua: \
	src/consul/consul_commands.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/consul_commands_dei.lua: \
	src/consul/consul_commands_dei.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/consul_battle.lua: \
	src/consul/consul_battle.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/serpent/serpent.lua: \
	src/serpent/serpent.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/inspect/inspect.lua: \
	src/inspect/inspect.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/profi/profi.lua: \
	src/profi/profi.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/profile/profile.lua: \
	src/profile/profile.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/penlight/compat.lua: \
	src/penlight/compat.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/penlight/lexer.lua: \
	src/penlight/lexer.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/penlight/pretty.lua: \
	src/penlight/pretty.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/penlight/stringx.lua: \
	src/penlight/stringx.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/penlight/types.lua: \
	src/penlight/types.lua
	$(create_dir)
	@cp "$<" "$@"

$(BUILD_DIR)/consul/penlight/utils.lua: \
	src/penlight/utils.lua
	$(create_dir)
	@cp "$<" "$@"


#$(BUILD_DIR)/ui/skins/default/consul_v_slider_end.png: \
#	src/ui/skins/default/consul_v_slider_end.png
	#$(create_dir)
	@#cp "$<" "$@"


# ============================================================
# End Source Files
# ============================================================

# Cleaning up all build artifacts and generated mod packages
clean:
	@rm -rf $(BUILD_DIR)
	@rm -f $(MOD_PACKAGE)
	@rm -f $(INSTALL_ALONE_DIR)/data/$(MOD_PACKAGE)
	@rm -f '$(INSTALL_STEAM_DIR)/data/$(MOD_PACKAGE)'
	@echo "Cleaned up build directory and mod package."

# Setup target to prepare all necessary dependencies
setup: \
	setup-rpfm_cli \
	setup-rpfm_schema \
	setup-etwng \
	setup-7zip \
	setup-ruby \
	setup-gems \
	setup-lua \
	setup-lua-libs \
	setup-ldoc
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(ETWNG_DIR)
	@mkdir -p $(RPFM_CLI_DIR)
	@mkdir -p $(RPFM_SCHEMA_DIR)
	@echo "Setup complete, all dependencies are ready."

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
		echo "$(RPFM_CLI_CMD) schemas update --schema-path ./" && \
		( cd "$(RPFM_SCHEMA_DIR)" && $(RPFM_CLI_CMD) schemas update --schema-path ./ ) && \
		echo "Schema update complete."; \
	fi

# Rule for setting up ETWNG (requires Ruby)
setup-etwng: setup-ruby
	@if [ ! -f $(XML2UI_BIN) ]; then \
		echo "etwng not found, cloning..." && \
		mkdir -p $(ETWNG_DIR) && \
		git clone $(ETWNG_REPO) $(ETWNG_DIR) && \
		cd $(ETWNG_DIR) && \
		git checkout -q $(ETWNG_REVISION) && \
		echo "Checked out to specific revision."; \
	fi

# Rule for setting up Ruby Gems
setup-gems: setup-ruby
	@if ! "$(RUBY_DIR)/bin/gem" list -i nokogiri > /dev/null 2>&1; then \
		echo "nokogiri not found, installing..."; \
		"$(RUBY_DIR)/bin/gem" install nokogiri --install-dir "$(GEM_HOME)"; \
	else \
		echo "nokogiri is already installed."; \
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

# Rule for setting up ldoc
setup-ldoc:
	@if [ ! -f "$(LDOC_DIR)/ldoc/doc.lua" ]; then \
		echo "ldoc not found, cloning..."; \
		mkdir -p $(LDOC_DIR); \
		git clone $(LDOC_REPO) $(LDOC_DIR); \
		cd $(LDOC_DIR) && git checkout -q $(LDOC_REVISION); \
	else \
		cd $(LDOC_DIR) && \
		current_rev=$$(git rev-parse HEAD) && \
		if [ "$$current_rev" != "$(LDOC_REVISION)" ]; then \
			echo "Updating LDoc from $$current_rev to $(LDOC_REVISION)..."; \
			git fetch --all --quiet && git checkout -q $(LDOC_REVISION); \
		else \
			echo "LDoc is already at revision $(LDOC_REVISION)."; \
		fi; \
	fi

# Rule for setting up Lua for ldoc execution
setup-lua:
	@if [ ! -f "$(LUA_FOR_LDOC_PATH)" ]; then \
		echo "lua not found, downloading..." && \
		mkdir -p "$(LUA_DIR)" && \
		curl -sL "$(LUA_DOWNLOAD_URL)" -o "$(LUA_DIR)/lua.zip" && \
		echo "unzipping lua..." && \
		powershell -Command "Expand-Archive -Path '$(LUA_DIR)/lua.zip' -DestinationPath '$(LUA_DIR)' -Force" && \
		rm "$(LUA_DIR)/lua.zip" && \
		echo "Lua $(LUA_VERSION) has been downloaded and extracted."; \
	fi

# Rule for setting up Lua libraries required by ldoc
setup-lua-libs:
	@if [ ! -f "$(PENLIGHT_DIR)/lua/pl/class.lua" ]; then \
		echo "Penlight not found, cloning..." && \
		mkdir -p "$(PENLIGHT_DIR)" && \
		git clone $(PENLIGHT_REPO) "$(PENLIGHT_DIR)" && \
		cd "$(PENLIGHT_DIR)" && \
		git checkout -q $(PENLIGHT_REVISION) && \
		echo "Penlight checked out to $(PENLIGHT_REVISION)."; \
	else \
		cd "$(PENLIGHT_DIR)" && \
		current_rev=$$(git rev-parse HEAD) && \
		if [ "$$current_rev" != "$(PENLIGHT_REVISION)" ]; then \
			echo "Updating Penlight from $${current_rev:0:7} to $${$(PENLIGHT_REVISION):0:7}..." && \
			git fetch --all --quiet && \
			git checkout -q $(PENLIGHT_REVISION); \
		else \
			echo "Penlight is already at revision $(PENLIGHT_REVISION)."; \
		fi; \
	fi

# Rule for generating documentation
generate-docs: setup-lua setup-lua-libs setup-ldoc
	@echo "Generating documentation..."
	@mkdir -p "$(MAKE_DIR)docs/reference"
	@if [ -f "$(MAKE_DIR)scripts/lua/ldoc/html/ldoc_md_ltp.lua" ]; then \
		mkdir -p "$(LDOC_DIR)/ldoc/html" && \
		cp "$(MAKE_DIR)scripts/lua/ldoc/html/ldoc_md_ltp.lua" "$(LDOC_DIR)/ldoc/html/ldoc_md_ltp.lua" && \
		echo "Using project markdown template: scripts/lua/ldoc/html/ldoc_md_ltp.lua"; \
	fi
	LUA_PATH="$(MAKE_DIR)scripts/lua/?.lua;$(MAKE_DIR)scripts/lua/?/?.lua;$(MAKE_DIR)scripts/lua/?/?/?.lua;$(PENLIGHT_DIR)/lua/?.lua;$(PENLIGHT_DIR)/lua/?/init.lua;$(LDOC_DIR)/?.lua;$(LDOC_DIR)/?/init.lua;;" \
	"$(LUA_FOR_LDOC_PATH)" "$(LDOC_DIR)/ldoc.lua" -c "$(MAKE_DIR)config.ld" "$(MAKE_DIR)src/consul/consul.lua"
	@mkdir -p "$(MAKE_DIR)docs/reference"
	@if [ -f "$(MAKE_DIR)consul.md" ]; then \
		mkdir -p "$(MAKE_DIR)docs/reference/parts"; \
		cp "$(MAKE_DIR)consul.md" "$(MAKE_DIR)docs/reference/parts/generated-internal-api.md"; \
		rm -f "$(MAKE_DIR)consul.md"; \
		echo "Generated docs/reference/parts/generated-internal-api.md from consul.md"; \
	elif [ -f "$(MAKE_DIR)docs/reference/modules/consul.md" ]; then \
		mkdir -p "$(MAKE_DIR)docs/reference/parts"; \
		cp "$(MAKE_DIR)docs/reference/modules/consul.md" "$(MAKE_DIR)docs/reference/parts/generated-internal-api.md"; \
		echo "Generated docs/reference/parts/generated-internal-api.md from modules/consul.md"; \
	elif [ -f "$(MAKE_DIR)docs/reference/index.html" ]; then \
		mkdir -p "$(MAKE_DIR)docs/reference/parts"; \
		printf "## API: consul\n\nLatest generated output is available in [LDoc HTML output](../index.html).\n" > "$(MAKE_DIR)docs/reference/parts/generated-internal-api.md"; \
		echo "Generated docs/reference/parts/generated-internal-api.md from index.html fallback"; \
	else \
		echo "Expected LDoc output not found at consul.md, docs/reference/modules/consul.md or docs/reference/index.html"; \
		exit 1; \
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
	@echo 'show_frontend_movies false;' >> $(INSTALL_USER_SCRIPT)/user.script.txt
ifneq ($(SAVE),)
	@echo 'game_startup_mode campaign_load "$(SAVE).save";' >> $(INSTALL_USER_SCRIPT)/user.script.txt
endif
	$(call install-to-dir,$(INSTALL_ALONE_DIR)/data)

# Install with DEI
install-dei: $(MOD_PACKAGE)
	@echo 'mod "$(MOD_PACKAGE)";' > $(INSTALL_USER_SCRIPT)/user.script.txt
	@echo 'mod "_divide_et_impera_release_12_Part1.pack";' >> $(INSTALL_USER_SCRIPT)/user.script.txt
	@echo 'mod "_divide_et_impera_release_12_Part2.pack";' >> $(INSTALL_USER_SCRIPT)/user.script.txt
ifneq ($(SAVE),)
	@echo 'game_startup_mode campaign_load "$(SAVE).save";' >> $(INSTALL_USER_SCRIPT)/user.script.txt
endif
	$(call install-to-dir,$(INSTALL_ALONE_DIR)/data)

copy_alone: $(MOD_PACKAGE)
	$(call install-to-dir,$(INSTALL_ALONE_DIR)/data)

copy_steam: $(MOD_PACKAGE)
	$(call install-to-dir,$(INSTALL_STEAM_DIR)/data)

# Function to install the mod package to a specified directory
install-to-dir = \
	@if [ ! -f "$1/$(MOD_PACKAGE)" ] || ! cmp -s "$<" "$1/$(MOD_PACKAGE)"; then \
		cp "$<" "$1/$(MOD_PACKAGE)" && \
		echo "Mod package installed successfully to $1"; \
	fi

# Attempt to find and terminate the game process by its name.
kill-game:
	-powershell -Command "Stop-Process -Name '$(GAME_EXE:.exe=)' -Force -ErrorAction SilentlyContinue; \
	while (Get-Process -Name '$(GAME_EXE:.exe=)' -ErrorAction SilentlyContinue) { Start-Sleep -Milliseconds 200 }"

define disable_outdated_mods_popup
	powershell -Command Start-Process ./scripts/disable_outdated_mods_popup.bat
endef

# Launch the standalone version of the game with the specified working directory
run-alone: \
	kill-game \
	install-alone
	@powershell -WindowStyle Hidden -Command "Start-Process '$(GAME_EXE)' -WorkingDirectory '$(INSTALL_ALONE_DIR)'"

# Launch the standalone without mods
run-standalone: kill-game
	@$(disable_outdated_mods_popup)
	@echo '' > $(INSTALL_USER_SCRIPT)/user.script.txt
	@powershell -Command Start-Process "$(GAME_EXE)" -WorkingDirectory '"$(INSTALL_ALONE_DIR)"'

# Launch the alone with DEI
run-alone-dei: \
	kill-game \
	install-dei
	@$(disable_outdated_mods_popup)
	@powershell -WindowStyle Hidden -Command "Start-Process '$(GAME_EXE)' -WorkingDirectory '$(INSTALL_ALONE_DIR)'"

# Launch the Steam version of the game using its Steam app ID
run-steam: \
	kill-game \
	install-steam
	@$(disable_outdated_mods_popup)
	@powershell -Command start steam://rungameid/$(STEAM_APP_ID)


# short aliases for the run targets
alone: run-alone

# Its strongly suggested to run steam in offline mode due to various bugs/
steam: run-steam

# Commands used to insert new Consul entry into the xml ui files
# We need to use XML2UI_BIN to convert the xml files to ui files and then back to xml files
# and then delete them
#make insert-consul-entry \
#  ARG1='consul_force_exchange_garrison' \
#  ARG2='To mobilize a garrison for field duty, first select your general'\''s army. Then, designate the settlement with which to exchange forces. Important: Your general must be outside of a settlement for this function to work correctly.' \
#  ARG3='Custodes Vocati'

insert-consul-entry:
	py ./scripts/insert_consul_entry.py $(GAME) $(ARG1) "$(ARG2)" "$(ARG3)"
ifeq ($(GAME),Rome2)
	$(XML2UI_BIN) ./src/ui/frontend\ ui/sp_frame.xml ./src/ui/frontend\ ui/sp_frame
	$(XML2UI_BIN) ./src/ui/common\ ui/menu_bar.xml ./src/ui/common\ ui/menu_bar
	$(UI2XML_BIN) ./src/ui/frontend\ ui/sp_frame ./src/ui/frontend\ ui/sp_frame.xml
	$(UI2XML_BIN) ./src/ui/common\ ui/menu_bar ./src/ui/common\ ui/menu_bar.xml
	rm ./src/ui/frontend\ ui/sp_frame
	rm ./src/ui/common\ ui/menu_bar
else
	$(XML2UI_BIN) ./src/ui/common\ ui/consul.xml ./src/ui/common\ ui/consul
	$(UI2XML_BIN) ./src/ui/common\ ui/consul ./src/ui/common\ ui/consul.xml
	rm ./src/ui/common\ ui/consul
endif

# ============================================================
# Documentation Targets
# ============================================================

docs-gen: generate-docs
	py scripts/generate_commands_docs.py
	py scripts/generate_consul_scripts_docs.py
	py scripts/generate_changelog_docs.py

docs-build: docs-gen
	cd docs && npm install && npm run docs:build

docs-deploy: docs-build
	@echo "Deploying to GitHub Pages..."
	rm -rf docs/.vitepress/dist/.git
	cd docs/.vitepress/dist && \
	git init && \
	git add . && \
	git commit -m "Deploy documentation" && \
	git push -f git@github.com:bukowa/ConsulScriptum.git master:gh-pages

# Declare phony targets to prevent conflicts with file names
.PHONY: setup \
			setup-7zip \
			setup-rpfm_cli \
			setup-rpfm_schema \
			setup-ruby \
			setup-gems \
			setup-lua \
			setup-lua-libs \
			setup-etwng \
		install \
			install-steam \
			install-alone \
		kill-game \
		run-alone \
		run-steam \
		steam \
		alone \
		clean \
		generate-docs \
		docs-gen \
		docs-build \
		docs-deploy
