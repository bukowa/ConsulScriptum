# AGENTS.md — Consul Scriptum Engineering & Contribution Guide

**DO NOT BE OBSEQUIOUS**

This file defines mandatory architecture, coding, build, and documentation rules for AI coding agents and contributors working in **Consul Scriptum**.

---

## 1. Project Overview & Three-Pillar UX Boundary

Consul Scriptum is an in-game Lua scripting and debugging suite for **three Total War titles**:
- **Total War: Rome II** (`GAME=Rome2`, `consul_build == "Rome2"`, pack: `consulscriptum.pack`)
- **Total War: Attila** (`GAME=Attila`, `consul_build == "Attila"`, pack: `consulscriptum_attila.pack`)
- **Total War Saga: Thrones of Britannia** (`GAME=TOB`, `consul_build == "TOB"`, pack: `consulscriptum_tob.pack`)

Respect the strict UX boundary between the mod's three pillars:
1. **Console** (`consul.console`, `src/consul/consul_commands*.lua`): In-game Lua execution prompt, output window (`consul.console.write(...)`), and `/slash` commands for technical users and modders.
2. **Consul** (`consul.consul_scripts`, `consul.consul_scripts_v2`): Immersive, non-technical click-to-run / click-to-toggle script list with **Latin names**. Keep built-in Consul entries silent in the Console — **never** spam `consul.console.write(...)` when a user clicks or toggles a Consul entry; route diagnostics through `consul.new_log(...)` (`log:debug`, `log:warn`, `log:error`).
3. **Scriptum** (`consul.scriptum`): Dynamic loader for up to 40 user-authored `.lua` files from disk without restarting the game (user scripts and debug tools can freely print via `consul.console.write(...)`).

---

## 2. Multi-Game Parity Mandate

Never implement a feature for just one game (e.g., "Rome 2 only") unless the underlying C++ engine API genuinely does not exist in another title:
- **Default expectation:** Every Consul script, UI change, command, and database table must work across **`Rome2`**, **`Attila`**, and **`TOB`**.
- **UI XML split:**
  - `Rome2` compiles `src/ui/frontend ui/sp_frame.xml` and `src/ui/common ui/menu_bar.xml`.
  - `Attila` and `TOB` share `src/ui/common ui/consul.xml` (and `src/ui/common ui/consul_button_toggle.xml`).
- **Engine-unsupported exclusions:** If an engine method is absent in a specific title (e.g., ToB lacks growth-point, garrison-exchange, and public-order script methods), explicitly hide/disable the unsupported entries in `consul.consul_scripts.games.<GAME>.setup()` in `src/consul/consul.lua`, add the entry ID to `TOB_EXCLUDED` in `scripts/generate_consul_scripts_docs.py`, and note it in `docs/guide/game-compatibility.md`.
- **Scroll container layout:** Total War `list_box` / `clipview` containers cache scroll bounds on initialization. Whenever entries are added to the Consul list, call `consul.ui._UIComponent(last:Parent()):Layout()` on the last entry across **all** games (never gate `:Layout()` behind a single `consul_build`).

---

## 3. Lua 5.1, Engine Modes & Defensive Coding

### Runtime & Globals
- **Lua 5.1 VM only:** Total War embeds **Lua 5.1**. Do not use Lua 5.2+ features (`goto`, bitwise operators, `_ENV`, `table.pack`).
- **Build-injected globals:** Keep `consul_build = "Attila"` at the top of `src/consul/consul.lua` untouched — `Makefile` rewrites `consul_build` into `./build/$(GAME)/consul/consul.lua` via `sed` during build.
- **OS portability:** Respect `consul_os` (`"WINDOWS"` or `"MACOS"`) and resolve external file paths via `consul.io_resolve_path(...)` (`src/consul/consul_macos.lua`).

### Execution Modes (`Frontend`, `Campaign`, `Battle`)
Code runs across three modes (`consul.env.mode`: `2` = Frontend, `1` = Campaign, `0` = Battle):
- **Campaign (`consul._game()`):** Never `require("lua_scripts.EpisodicScripting")` at file load — it breaks campaign script initialization. Access `scripting.game_interface` via `consul._game()` (or `consul.game.*` helpers), which returns `nil` outside Campaign.
- **Battle (`consul.is_in_battle_script == true`):** Campaign interfaces do not exist; use `consul.bm` (`battle_manager`). Defer any UI-triggered Lua execution in Battle via `consul.bm:register_singleshot_timer("<global_fn>", 0)`. Battle bootstrap differs by title (`src/consul/consul_battle.lua` in Rome II/Attila vs `src/script/default_battle/battle_start.lua` in ToB).

### Nil-Safety, Crash Landmines & Lua API Differences
- **Guard nullable engine lookups:** Functions such as `scripts2.played_faction()`, `consul._game()`, and `consul.ui.find(...)` can return `nil` during spectator mode, autorun tests, frontend screens, or early UI initialization. Always check for `nil`, log a warning (`log:warn(...)`), and return cleanly instead of indexing `nil`.
- **`serpent.dump` in Rome II:** Always pass `{ maxlevel = 10000 }` — Rome II's Lua VM lacks `math.huge` and crashes without it.
- **C++ desktop crash methods:** Never call rebel-unsafe faction queries (`research_queue_idle`, `trade_route_limit_reached`, `unused_international_trade_route`, `factions_at_war_with`, `factions_trading_with`) when `faction:name() == "rebels"`. Avoid campaign-crashing character methods (`is_carrying_troops`, `routed_in_battle`, `body_guard_casulties` — see `consul.pprinter`), and never cache `UNIT_SCRIPT_INTERFACE` userdata across mouseovers in Rome II.
- **UI component pointers:** Always query via `consul.ui.find(key)` (non-string keys passed to `UIRoot:Find` corrupt game UI) and wrap raw pointers from `:Parent()` / `:Find(i)` with `consul.ui._UIComponent(ptr)`.
- **Per-game Lua differences:** Check null interfaces via `consul.pprinter._is_null` (`"NULL_SCRIPT_INTERFACE"` prefix), as `:is_null_interface()` is absent in Rome II. Guard Attila/ToB-only methods (`region:has_governor()`) and differing strategic map UI hierarchies (`Rome2` vs `Attila`/`TOB`, see `/debug` `game_mappings`).

### Campaign Save/Load Persistence (`consul.state`)
- Even when Rome II and Attila cannot query active effect bundles from C++ (`has_effect_bundle` is ToB-only), **do not leave persistent buff toggle UI states session-only**.
- Persist active buff toggle states in campaign `.save` files through `consul.state` (`events.SavingGame` and `events.LoadingGame` calling `consul._game():save_named_value` / `load_named_value` directly — **do not** depend on CA's `cm` campaign manager wrapper).
- Note on lifecycle: `load_named_value` requires the active `LoadingGame` event `context` while the save stream is open (`on_loading_game` caches values into `consul.state._values`), and `setup()` reads `consul.state.get(key, false)` later when `events.UICreated` fires to restore `comp:SetState("active")`.

---

## 4. Database Tables, Naming & Mod Compatibility

Database TSVs live under `src/tables/{rome2,attila,tob}/db/<table_dir>/` and localization TSVs under `src/tables/{rome2,attila,tob}/text/db/`, compiled into binary pack tables by `rpfm_cli` via `Makefile` (`TABLE_TARGETS`).

1. **File naming (`_consul.tsv` / `_consul.loc.tsv`):** Name mod table files `_consul.tsv` and loc files `_consul.loc.tsv`. The leading underscore guarantees clean alphabetical load priority and avoids overwriting vanilla or overhaul tables.
2. **Collision-proof Latin keys (`consul_scriptum_*`):** Prefix every custom effect bundle and effect key with `consul_scriptum_<latin_name>` (e.g., `consul_scriptum_aedificatio`, `consul_scriptum_scientia`, `consul_scriptum_virtus`, `consul_scriptum_virtus_strong`) so keys never collide with overhaul mods such as **Divide et Impera (DeI)**.
3. **Single source of truth in Lua:** Register effect bundle keys in `consul.consul_scripts_v2.bundles` in `src/consul/consul.lua` rather than duplicating raw key strings across functions and `consul.state`.
4. **Immersive copy & sane gameplay modifiers:**
   - Use Latin Consul entry labels (`Aerarium`, `Aedificatio`, `Scientia`, `Virtus`), bundle titles formatted as `Consul <LatinName>`, and thematic in-world descriptions — never raw debug strings (`Fast building`, `Super soldiers`).
   - Avoid modifiers that break battle animations or physics (such as extreme battle movement speed multipliers) and verify exact numerical thresholds (`-100` for 1-turn build time, etc.).
5. **Per-game schema fidelity & RPFM table extraction:** Rome II (`schema_rom2.ron`), Attila (`schema_att.ron`), and ToB (`schema_tob.ron`) differ in table versions, columns (`is_hidden`), valid vanilla `effect_key` / `bonus_value_id` names, icon paths (`data/ui/...` vs filename), effect scopes (`in_all_your_regions` vs `faction_to_region_own`), and required bonus junction tables (e.g., Attila's `effect_bonus_value_building_set_junctions_tables`).
   - **Scope names:** Rome II requires `in_all_your_regions`; Attila and ToB require `faction_to_region_own`.
   - **Attila building junctions:** Effect bundles affecting building values in Attila require entries in `effect_bonus_value_building_set_junctions_tables` linked to building sets (e.g., `att_building_set_all_buildings`), otherwise the game silently ignores the modifier.
   - **Recommended workflow:** Extract and inspect vanilla DB tables from all three games via RPFM or `rpfm_cli` (`./.deps/rpfm_cli/rpfm_cli --game <rome_2|attila|thrones_of_britannia> pack extract --pack-path <game_pack> -t ./.deps/rpfm_schema/<schema>.ron -F 'db/<table_dir>;<tmp_dir>'`) to compare real schemas, foreign keys, and vanilla examples before drawing conclusions and authoring TSVs. Never guess keys or blindly copy-paste Rome II TSV headers into Attila or ToB.

---

## 5. Consul Archetypes, Subsystems & Checklists

### Consul Script Archetypes (`consul_scripts` & `consul_scripts_v2`)
Most Consul entries are pure Lua and need **no DB tables**. Pick the matching pattern:
1. **Instant one-shot (`once = true`):** Runs `start()` per click without staying green or saving state (e.g., `Aerarium` via `treasury_mod`).
2. **Event-driven selection toggle:** Stays green while armed and acts on map clicks (single-target like `Impetus` / `Sedatio`, or two-step pickers like `Pax Aeterna` / `Adice Provinciam`).
   - **Never** call `table.insert(events.*)` or `AddEventCallBack` inside `start()` (leaks duplicate listeners on re-toggle). Attach callbacks to `consul.consul_scripts.event_handlers["<Event>"]["<key>"]` in `start()`, and clear them to `nil` (plus reset selection state) in `setup()` and `stop()`.
   - **Never** persist selection toggles in `consul.state` — loading a save must not leave destructive tools like `Exterminare` armed.
3. **Persistent faction buff toggle:** Applies/removes a DB effect bundle (`apply_effect_bundle` / `remove_effect_bundle`) and saves active UI state via `consul.state` (e.g., `Aedificatio`, `Scientia`, `Virtus`).

### Config, Scriptum, UI Debugger & LDoc
- **`consul.config` schema:** `consul.config.validate(cfg)` checks every field type on startup. When adding a key to `config.new()`, update `config.validate()` and migrate existing `consul.config` files in `config.read()`, or user settings will reset to defaults.
- **Scriptum UI slots (`consul.scriptum`):** All 40 `scriptum_entry` items must stay **visible by default** in UI XML and be hidden in Lua (`scriptum.setup()`); marking list items invisible in XML breaks Total War's list rendering.
- **HTML UI Debugger:** Edit `tools/consul_uidebug.html` (compiled into `consul_uidebug_template.lua` by `Makefile`), never generated build files.
- **Public API docs (LDoc):** Annotate public `consul.*` functions in `src/consul/consul.lua` with `--- @function` / `@tparam` / `@return` comments (`config.ld`) so `make docs-gen` updates `docs/reference/parts/generated-internal-api.md`.

### Checklist A: Adding a New Consul Script
1. **Insert UI entries via Make (never hand-copy XML blocks):** Run `make insert-consul-entry` in **Git Bash** for **both** UI pipelines so entries sort alphabetically and pass `xml2ui` -> `ui2xml` canonical normalization without noisy XML diffs:
   ```bash
   make GAME=Rome2 insert-consul-entry ARG1='consul_<name>' ARG2='<Tooltip text>' ARG3='<Latin Title>'
   make GAME=Attila insert-consul-entry ARG1='consul_<name>' ARG2='<Tooltip text>' ARG3='<Latin Title>'
   ```
   *(Attila updates `consul.xml`, which is shared by `TOB`.)*
2. **Wire `src/consul/consul.lua`:**
   - Add `consul_<name>_entry` and `consul_<name>_script` to `consul.ui`.
   - Add key to `consul_scripts_v2.bundles` (only if backed by an effect bundle / saved toggle) and `consul_scripts_v2.instances`.
   - Implement the script in `consul_scripts_v2` matching its archetype (`once = true`, `event_handlers` selection toggle, or `consul.state` buff toggle), with nil guards and `log` diagnostics.
   - Call `.setup()` in `consul.consul_scripts.setup()`, add the entry to `click_map` in `OnComponentLClickUp`, and update the final entry reference for `:Layout()` if the new entry sorts last alphabetically.
3. **Add DB & Loc tables (if needed):** Create/update `_consul.tsv` and `_consul.loc.tsv` across `src/tables/rome2/`, `src/tables/attila/`, and `src/tables/tob/`.
4. **Update docs & changelog:**
   - Add the entry's short summary to `SHORT_SUMMARIES` (and `TOB_EXCLUDED` if excluded in ToB) in `scripts/generate_consul_scripts_docs.py`.
   - Update `docs/guide/consul-manual.md` and `docs/guide/game-compatibility.md` if behavior or supported counts changed.
   - Add a user-facing note under `["unreleased"]` in `src/consul/consul_changelog.lua`.
   - Run `make docs-gen` in Git Bash.

### Checklist B: Adding a Console `/command`
1. Place core commands in `src/consul/consul.lua`, general custom commands in `src/consul/consul_commands.lua`, or DeI-only commands in `src/consul/consul_commands_dei.lua`.
2. Follow the `exact` / `starts_with` table schema (`help`, `func`, `exec`, `returns`, optional `setup`).
3. Ensure `help = function() return "..." end` uses plain string literals so `scripts/generate_commands_docs.py` extracts it cleanly.
4. If `setup(cfg)` hooks `events.*`, guard registration with a flag so `/reload_custom_commands` never registers duplicate listeners.
5. Run `make docs-gen` in Git Bash to update `docs/reference/parts/generated-commands.md`.

### Checklist C: Pre-PR & Feature Completion Workflow
Before declaring any feature, fix, or refactor complete and opening a PR, execute these steps in order:
1. **User-facing changelog:** Add a player-facing bullet under `["unreleased"] = { common = "..." }` in `src/consul/consul_changelog.lua`. Never bump versions in a PR.
2. **Lua 5.1 syntax check:** Validate all modified `.lua` files:
   ```bash
   ./.deps/lua/lua5.1.exe -e 'assert(loadfile("src/consul/consul.lua"))'
   ```
3. **Multi-game pack compilation:** Build all three game packs in Git Bash:
   ```bash
   make GAME=Rome2
   make GAME=Attila
   make GAME=TOB
   ```
4. **RPFM asset inspection:** If database TSVs or table files were added/modified, list pack contents to verify binary tables are present:
   ```bash
   ./.deps/rpfm_cli/rpfm_cli --game rome_2 pack list --pack-path=consulscriptum.pack
   ./.deps/rpfm_cli/rpfm_cli --game attila pack list --pack-path=consulscriptum_attila.pack
   ./.deps/rpfm_cli/rpfm_cli --game thrones_of_britannia pack list --pack-path=consulscriptum_tob.pack
   ```
5. **Regenerate reference docs & test site build:**
   ```bash
   make docs-gen
   cd docs && npm run docs:build
   ```
6. **Git cleanliness audit:** Stage modified source, changelog, and auto-generated doc markdown files (`docs/reference/parts/*.md`) together. Ensure no scratch files, test dumps, or temporary release downloads are tracked. Verify `git status` is clean before submitting. Never run `git push` or `git tag`.

---

## 6. Build, Verification & Documentation Commands

> **CRITICAL:** Run all `make` targets inside **Git Bash** on Windows (`C:/Program Files/Git/bin/bash.exe`), never from PowerShell or `cmd.exe`. Ensure GNU Make (`make.exe`) is on `PATH` (run `make setup` once if `.deps/` is missing).

### Required Verification Before Completing Code / UI / Table Changes
1. **Validate Lua 5.1 syntax:**
   ```bash
   ./.deps/lua/lua5.1.exe -e 'assert(loadfile("src/consul/consul.lua"))'
   ```
2. **Build all three game `.pack` files (verifies XML->UI compilation & RPFM table schemas):**
   ```bash
   make GAME=Rome2
   make GAME=Attila
   make GAME=TOB
   ```
3. **Inspect packed binary tables/files when adding new assets or TSVs:**
   ```bash
   ./.deps/rpfm_cli/rpfm_cli --game rome_2 pack list --pack-path=consulscriptum.pack
   ./.deps/rpfm_cli/rpfm_cli --game attila pack list --pack-path=consulscriptum_attila.pack
   ./.deps/rpfm_cli/rpfm_cli --game thrones_of_britannia pack list --pack-path=consulscriptum_tob.pack
   ```
4. **Regenerate documentation & verify VitePress site build (when docs/scripts/commands/changelog change):**
   ```bash
   make docs-gen
   cd docs && npm run docs:build
   ```

---

## 7. Changelog, Versioning & Git Rules

- **User-facing changelog only (`src/consul/consul_changelog.lua`):**
  - Place pending notes under `["unreleased"] = { common = "..." }` (use `Rome2` or `Attila` subkeys only for strictly single-game notes).
  - Write concise, player-facing `Added:` / `Fixed:` / `Changed:` lines. Credit external PR authors (`(thanks to Author Name)`).
  - **Do not** clutter the changelog with internal refactors, nil checks, helper renames, or technical plumbing.
- **Never bump versions in feature or bugfix PRs:**
  - Leave `MOD_VERSION` (`Makefile`), `VERSION` (`src/consul/consul.lua`), `docs/.vitepress/config.mts`, and the `["unreleased"]` key untouched during regular development.
  - Version bumps happen **only** when cutting an explicit release (see `development.md`):
    ```bash
    make bump-version VERSION=X.Y.Z
    make GAME=Rome2 release
    make GAME=Attila release
    make GAME=TOB release
    ```
- **Git hygiene:** Never commit temporary scratch files, and never run `git push`, `git tag`, or `make docs-deploy` unless explicitly instructed by the maintainer.
- **Windows sandbox Git permissions:** Commands that write to `.git/` (such as `git add` or `git commit`) on Windows may require running outside the standard sandbox if the `.git` folder is write-protected in the local agent environment. Always verify working tree status with `git status` after committing.

---

## 8. Anti-AI Slop & Clean Code Discipline

- **No AI-slop comments or pompous docstrings:** Never write pretentious file headers (e.g., `"""Consul Scriptum - Steam Workshop Automated Publisher Key Features: ..."""`), promotional feature bullet lists, or decorative ASCII divider lines (`# =====================`).
- **No obvious play-by-play commentary:** Do not annotate self-explanatory code with mundane commentary (`# Base repository root`, `# Get current version`, `# Copy pack to staging`, `# Cryptographic Verification`). Write clean, self-documenting code.
- **Terse CLI output:** Scripts and CLI tools must print minimal, functional log lines (`Downloading...`, `[OK]`, `[ERROR]`). Never print marketing slogans, theatrical greeting banners (`=== Consul Scriptum Steam Workshop Publisher ===`), or unnecessary visual noise.
- **Explain 'why', not 'what':** Comments are strictly reserved for non-obvious engine bugs, workaround rationale, or hardware/OS quirks. If the code is clear, leave it uncommented.
