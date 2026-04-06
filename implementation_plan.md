# ConsulScriptum Documentation and Extensibility Plan [Draft v5]

## Status

> [!IMPORTANT]
> **Section 1 (Custom Command Hook) is COMPLETE and SHIPPED** as of commits `cbe17f3` → `bc307d0`.
> The plan has been updated to reflect the finalized implementation. Sections 2 and 3 are still pending execution.

---

## 1. Custom Command Module Hook (Lua) — ✅ COMPLETE

The dynamic command loading system is fully implemented and non-invasive. The design is markedly richer than originally planned.

### How It Actually Works

Inside `consul.console.commands`, two key methods were added:

**`load_module(module_name)`** — The core generic loader:
1. Prepends `consul/?.lua` to `package.path` so both VFS (mod pack) and root-level files resolve correctly.
2. Clears `package.loaded[module_name]` to force a fresh `require` on every call (hot-reload support).
3. Tracks which keys each module registered using an internal `_module_keys` table, so a reload strips only *that module's* old commands — preventing cross-module key ghosting.
4. Merges `exact` and `starts_with` tables from the returned module into the live command registry.
5. Calls any `setup(cfg)` hooks on newly registered commands.

**`load_custom()`** — High-level orchestrator called at startup and by `/reload_custom_commands`:
- Tries to load **`consul_commands`** (inside a mod pack at `consul/consul_commands.lua`).
- Tries to load **`consul_custom_commands`** (placed directly in the game root folder, overrides mod pack commands).
- If `consul.compat.is_dei()` returns true, additionally loads **`consul_commands_dei`**.

### Three Installation Paths for Mod Authors

| File | Location | Use case |
|---|---|---|
| `consul/consul_commands.lua` | Inside a `.pack` file | Distribute a Steam Workshop command pack |
| `consul_custom_commands.lua` | Game root folder | Personal local overrides (highest priority) |
| `consul/consul_commands_dei.lua` | Auto-loaded | DEI-specific commands, loaded only when DEI is detected |

### Built-in `/reload_custom_commands`
A first-class console command ships with `consul.lua`, allowing modders to hot-reload any of the three sources from disk during a live campaign session — no game restart needed.

### Reference Files Shipped
- **`src/consul/consul_commands.lua`**: Canonical example/template. Demonstrates `setup()` hooks with global state guards, `exec` vs `returns` modes, and `consul._game()` engine calls.
- **`src/consul/consul_commands_dei.lua`**: Production DEI commands (auto-loaded when DEI detected). Pattern reference for parameter parsing and using external mod APIs via `require`.

### Command Module Return Shape
```lua
return {
    exact = {
        ['/my_cmd'] = {
            help    = function() return "Description shown in /help" end,
            func    = function() return "output string" end,
            exec    = false,  -- if true, returned string is executed as Lua
            returns = true,   -- if true, returned string is printed to console
            setup   = function(cfg) end,  -- optional: called once at load
        },
    },
    starts_with = {
        ['/my_cmd '] = {
            func = function(_cmd) ... end,  -- _cmd = full raw input string
            ...
        },
    },
}
```

---

## 2. Auto-Generation of Command Docs — ⏳ PENDING

To avoid documentation drift, Standard Commands and custom command reference pages will be generated from source via Python.

**Implementation**:
- Create `scripts/generate_docs.py`.
- Parse `src/consul/consul.lua` for `commands.exact` and `commands.starts_with` tables.
- Parse `src/consul/consul_commands.lua` and `src/consul/consul_commands_dei.lua` to produce `docs/api/custom-commands.md`.
- Output formatted Markdown to `docs/api/commands.md` and `docs/api/custom-commands.md`.

---

## 3. Documentation Architecture (VitePress) — ⏳ PENDING

VitePress is selected for speed, minimal configuration, and a Markdown-focused workflow. Built in `docs/`, deployed to GitHub Pages.

### 3.1 Directory & Content Structure
- **`docs/index.md`**: Landing page with hero section, feature highlights, and GitHub links.
- **`docs/guide/architecture.md`**: Breakdown of core component interactions.
- **`docs/guide/console.md`**: Standard console usage, Lua interpreter mode, and the custom command system (all 3 install paths, examples).
- **`docs/guide/scriptum.md`**: UI-driven files-based script runner.
- **`docs/guide/files.md`**: Local IO files (`consul.log`, `consul.output`, `consul.history`, `consul.scriptum`, `consul.config`).
- **`docs/guide/ui.md`**: UI component hierarchy and event handlers.
- **`docs/guide/deployment.md`**: Build process and Total War mod installation instructions.

### 3.2 Aesthetics (Total War Vibes)
Customized via `docs/.vitepress/theme/custom.css`:
- Dark rich palette: deep blacks, muted golds, dark crimson accents.
- Classic serif typography for headers (Roman/Attila era feel).
- Subtle parchment/marble texture and sleek UI elements.

### 3.3 Internal API Reference (`docs/api/internal-api.md`)

**1. Core Engine Wrappers**
- `consul._game()`: Safe retrieval of `scripting.game_interface`.
- `consul.game`: Shortcut methods — `region()`, `faction()`, `region_list()`, `faction_list()`, `force_rebellion()`.

**2. Object Printers (`consul.pprinter`)**
- `character_script_interface`, `faction_script_interface`, `region_script_interface`, `military_force_script_interface`, `garrison_script_interface`, `slot_list_interface`.

**3. State, Flow & Logging**
- `consul.new_log(name)`: Spawning child loggers for user mods.
- `consul.config.read()` / `process(func)`: Querying and mutating persistent config.
- `consul.debug`: Standard `character`, `settlement`, and `faction` debug pointers.

**4. Custom Command System**
- `consul.console.commands.load_module(module_name)`: Generic module loader (ghost-safe, hot-reloadable).
- `consul.console.commands.load_custom()`: Full orchestrator (startup + `/reload_custom_commands`).
- `consul.console.commands._module_keys`: Internal key-tracking table (ghost prevention).

**5. Interface & I/O**
- `consul.ui.find(key)`: Locating and wrapping `UIComponent` objects.
- `consul.console.write(msg)` / `execute(cmd)`: Programmatic console injection.
- `consul.history`: Console command history tracking.
- `consul.changelog`: Patch notes via `format_all()`.

---

## Verification Plan
1. Run `generate_docs.py` — verify output at `docs/api/commands.md` and `docs/api/custom-commands.md`.
2. Inspect VitePress site via live dev server.
3. In-game: verify `/reload_custom_commands` hot-reloads without ghosting old keys.
4. In-game: verify DEI commands only appear when DEI is active (`consul.compat.is_dei()`).
