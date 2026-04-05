# Installation

## Steam Workshop

Subscribe to the mod on the Steam Workshop and enable it in the mod manager. No manual steps required.

---

## Manual installation

Download `consulscriptum.pack` from [GitHub Releases](https://github.com/bukowa/ConsulScriptum/releases).

**Rome II** — copy to:
```
...\Total War Rome II\data\consulscriptum.pack
```

**Attila** — copy to:
```
...\Total War Attila\data\consulscriptum.pack
```

Add the mod to your `user.script.txt` (found in `%AppData%\The Creative Assembly\<Game>\scripts\`):

```
mod "consulscriptum.pack";
```

---

## Building from source

Prerequisites: [GNU Make](https://sourceforge.net/projects/gnuwin32/files/make/3.81/), [Git for Windows](https://git-scm.com/downloads/win). Run in Git Bash.

```bash
# First time only
make setup

# Build for Attila (default)
make

# Build for Rome II
make GAME=Rome2
```

Output: `consulscriptum.pack` in the project root.

### Common targets

| Target | Description |
|--------|-------------|
| `make` | Build pack file |
| `make setup` | Download all dependencies |
| `make alone` | Build + install + launch (standalone) |
| `make steam` | Build + install + launch (Steam) |
| `make clean` | Remove build artifacts |
| `make GAME=Rome2` | Target Rome II |
| `make DEV=1` | Include dev UI components |
