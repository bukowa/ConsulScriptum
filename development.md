# Release workflow

Run all `make` commands in **Git Bash**.

### 1. Update changelog
Add release notes to `src/consul/consul_changelog.lua`:
```lua
["1.0.1"] = {
    common = "...",
    silent = true,
},
```

### 2. Bump version & update docs
```bash
make bump-version VERSION=1.0.1
```
*(Automatically bumps version and runs `make docs-gen`)*

### 3. Build release packs
```bash
make GAME=Rome2 release
make GAME=Attila release
make GAME=TOB release
```
Generated `.pack` files are placed in `./release/`.

### 4. Commit and tag
```bash
git add -u
git commit -m "release: bump version to 1.0.1"
git tag v1.0.1
git push origin master --tags
```

---

## Documentation

- **Regenerate doc markdown files**:
  ```bash
  make docs-gen
  ```

- **Preview docs locally**:
  ```bash
  cd docs
  npm run docs:dev
  ```

- **Deploy docs to GitHub Pages**:
  ```bash
  make docs-deploy
  ```
