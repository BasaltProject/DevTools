<p align="center">
  <a href="https://raw.githubusercontent.com/BasaltProject/.github/main/assets/basalt-logo-white.svg#gh-dark-mode-only">
    <img src="https://raw.githubusercontent.com/BasaltProject/.github/main/assets/basalt-logo-white.svg" alt="Basalt" width="360">
  </a>
  <a href="https://raw.githubusercontent.com/BasaltProject/.github/main/assets/basalt-logo-black.svg#gh-light-mode-only">
    <img src="https://raw.githubusercontent.com/BasaltProject/.github/main/assets/basalt-logo-black.svg" alt="Basalt" width="360">
  </a>
</p>

<h2 align="center">Basalt DevTools</h2>

<p align="center">
  <strong>Editor support for Basalt plugins: autocompletion, diagnostics and builds.</strong>
</p>

<p align="center">
  <img alt="VS Code" src="https://img.shields.io/badge/VS_Code-1.90%2B-007ACC?logo=visualstudiocode&logoColor=white">
  <img alt="Lua" src="https://img.shields.io/badge/Lua-5.5.1-000080?logo=lua&logoColor=white">
  <img alt="Language server" src="https://img.shields.io/badge/engine-LuaLS-000080">
  <img alt="Targets" src="https://img.shields.io/badge/targets-server_%7C_proxy-62B47A">
  <img alt="License" src="https://img.shields.io/badge/license-GPL--3.0-green">
</p>

## Overview

Basalt DevTools is part of the Basalt Project. It turns an editor into a place to write plugins for Basalt Server and
Basalt Proxy, and builds on two other pieces instead of reimplementing them:

- **[LuaLS](https://github.com/LuaLS/lua-language-server)** (the `sumneko.lua` extension) is the engine. It does the
  completion, hover documentation, go to definition and type checking.
- **[Kiln](https://github.com/BasaltProject/Kiln)** is the verifier. It reads the whole plugin and reports what is wrong
  with its manifest, its `require`s and its use of the Basalt API.

DevTools is what connects them to Basalt: it gives LuaLS the API of the product you target, and shows Kiln's findings
in the Problems panel.

VS Code is the main editor. A JetBrains plugin (IntelliJ IDEA 2025.3 and newer) lives in [`intellij/`](intellij/).

## Features

- **Autocompletion and documentation** for the Basalt API (`log`, `players`, `worlds`, `on`, `cmd` and the rest), from
  definitions that LuaLS loads for the target you picked.
- **Problems panel**: Kiln runs when the extension starts and on every save of a Lua file or `plugin.toml`.
- **Commands**: `Basalt: Check Plugin` and `Basalt: Compile Plugin`.
- **Snippets**: `on` for an event handler and `cmd` for a command.
- **Server and proxy**: the `basalt.target` setting switches the API that is completed and the checks that are run.

## Requirements

- VS Code 1.90 or newer. The Lua language server extension installs with it.
- `kiln` on the `PATH`, or its location in `basalt.kilnPath`.

The extension turns on when the open folder contains a `plugin.toml`.

## Settings

| Setting | Default | Meaning |
|---|---|---|
| `basalt.target` | `server` | The product the plugin is for: `server` or `proxy` |
| `basalt.kilnPath` | `kiln` | The Kiln executable |
| `basalt.checkOnSave` | `true` | Run Kiln when a Lua file or `plugin.toml` is saved |

## How the API reaches the editor

The names of an API live in Kiln, in `api/<target>.api`. DevTools turns that file into LuaLS annotations:

```bash
python3 scripts/generate-definitions.py ../Kiln/api/server.api server \
    --events ../Server/server-plugins/src/PluginEventTypes.cpp
```

A name with a hand-written signature in `types/<target>.lua` (players, worlds, menus, forms, positions, items and the
rest of the objects a plugin touches) keeps it; `--events` adds one class per event and the `on` and `watch` overloads
that go with it; any other name is declared with `...`. This writes `definitions/server/basalt.lua`. The extension adds `definitions/<target>/` to `Lua.workspace.library` in
the workspace settings, so what the editor completes and what Kiln accepts come from the same list.

### Adding a target

1. Add `api/<target>.api` to Kiln and a row for the target there.
2. Run the generator for it, as above, and commit the new `definitions/<target>/basalt.lua`.
3. Add the target to the `basalt.target` values in `package.json`.

## Building

```bash
npm install -g @vscode/vsce
vsce package
```

This produces `basalt-devtools-<version>.vsix`, which VS Code installs from `Extensions: Install from VSIX`.

## JetBrains

`intellij/` holds the IDE plugin: `Tools | Basalt | Check Plugin` and `Compile Plugin` run Kiln, its findings appear in a
Basalt tool window (double click opens the line), Kiln runs again when a Lua file or `plugin.toml` is saved, and
`Sync API Definitions` copies the `---@meta` definitions of the target into `.basalt/api/` so a Lua plugin for the IDE
completes them. The target, the Kiln path and the save check are under `Settings | Tools | Basalt`.

```bash
cd intellij && ./gradlew buildPlugin   # build/distributions/basalt-devtools-intellij-<version>.zip
```

Install the zip with `Settings | Plugins | Install Plugin from Disk`.

## License

GPL-3.0-only. See [LICENSE](LICENSE).
