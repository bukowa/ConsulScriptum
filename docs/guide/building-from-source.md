# Build from source

This page explains how to use the project `Makefile` to set up dependencies, build the mod package, and run/install it for Rome II or Attila.

## Windows Setup (Step by Step)

The build pipeline is designed for Windows with GNU Make running in Git Bash.

Important: run every `make` command in **Git Bash**.<br>
Do not run `make` from CMD or PowerShell.

### 1) Install Git for Windows

Download and run:

- [Git for Windows 64-bit installer](https://github.com/git-for-windows/git/releases/download/v2.53.0.windows.2/Git-2.53.0.2-64-bit.exe)

After install, open **Git Bash** and verify:

```bash
git --version
```

### 2) Install GNU Make

Download and run:

- [GNU Make 3.81 installer](https://sourceforge.net/projects/gnuwin32/files/make/3.81/make-3.81.exe/download)

During installation, ensure `make.exe` is added to your `PATH` environment variable (or add it manually after install).

Then in **Git Bash**, verify:

```bash
make --version
```

### 3) Confirm PowerShell is available

Some `Makefile` targets use PowerShell. Verify from either Git Bash or PowerShell:

```bash
powershell -Command "$PSVersionTable.PSVersion"
```

### 4) Clone the repository

```bash
git clone https://github.com/bukowa/ConsulScriptum.git
cd ConsulScriptum
```

### 5) Bootstrap project dependencies

Run from **Git Bash**:

```bash
make setup
```

This prepares `./.deps` and initializes build directories.

## What `make setup` installs

The `setup` target downloads and configures these tool dependencies into `./.deps`:

- `rpfm_cli` (pack creation and schema operations)
- `rpfm_schema`
- `etwng` (`xml2ui`, `ui2xml`)
- `7zip`
- `Ruby` + required gems for etwng
- `ldoc` (for Lua docs generation)

## Core Variables

Useful variables exposed by the `Makefile`:

- `GAME`: `Attila` (default) or `Rome2`
- `DEV`: `1` enables extra dev UI target for Attila (`layout.xml`)
- `SAVE`: optional save name used by install/run targets

Examples:

```bash
make GAME=Attila
make GAME=Rome2 DEV=1
```

## Build Workflow

Run all commands in this section from **Git Bash**.

### 1) Build package

```bash
make GAME=Attila
```

or:

```bash
make GAME=Rome2
```

This creates `consulscriptum.pack` from files staged in `./build`.

### 2) Install and run

Common targets:

- `make GAME=Attila install-alone`
- `make GAME=Attila install-steam`
- `make GAME=Attila run-alone`
- `make GAME=Attila run-steam`
- `make GAME=Attila run-alone-dei`

Short aliases:

- `make alone` -> `run-alone`
- `make steam` -> `run-steam`

## Useful Targets

- `clean`: remove `build` artifacts and built pack
- `kill-game`: force close currently running game process
- `generate-docs`: generate Lua API docs via `ldoc`
- `insert-consul-entry`: add a new Consul entry to the relevant UI XML (game-aware)

## Game-Specific Build Notes

- **Attila**
  - Uses `src/ui/common ui/consul.xml`
  - Uses `src/lua_scripts/all_scripted_attila.lua`

- **Rome2**
  - Uses `src/ui/common ui/menu_bar.xml` and `src/ui/frontend ui/sp_frame.xml`
  - Uses `src/lua_scripts/all_scripted_rome2.lua`

## Troubleshooting

- If `make` commands fail on Windows, run from **Git Bash** (not plain CMD).
- If setup tools are missing/corrupted, run:

```bash
make clean
make setup
```

- If XML conversion commands fail, confirm `setup-etwng` succeeded and binaries exist under `./.deps/etwng/ui/bin/`.
