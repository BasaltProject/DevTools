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
  <img alt="Targets" src="https://img.shields.io/badge/targets-server_%7C_proxy-62B47A">
  <img alt="License" src="https://img.shields.io/badge/license-GPL--3.0-green">
</p>

## About

DevTools turns an editor into a place to write plugins for Basalt Server and Basalt Proxy. It builds on
[LuaLS](https://github.com/LuaLS/lua-language-server) for completion, hover and type checking, and on
[Kiln](https://github.com/BasaltProject/Kiln) for verifying the whole plugin.

- **Autocompletion and documentation** for the Basalt API of the product you target.
- **Problems panel:** Kiln runs on start and on every save of a Lua file or `plugin.toml`.
- **Commands and snippets:** `Basalt: Check Plugin`, `Basalt: Compile Plugin`, and snippets for events and commands.
- **Server and proxy:** the `basalt.target` setting switches the API and the checks.

VS Code is the main editor. A JetBrains plugin (IntelliJ IDEA 2025.3+) lives in [`intellij/`](intellij/).

## Installing

Needs VS Code 1.90+ and [Kiln](https://github.com/BasaltProject/Kiln/releases) on the `PATH` (or set `basalt.kilnPath`).
Download `Basalt-DevTools-VSCode-<version>.vsix` from the
[releases page](https://github.com/BasaltProject/DevTools/releases) and install it with
`Extensions: Install from VSIX`. The extension turns on when the open folder contains a `plugin.toml`.

## License

[GPL-3.0-only](LICENSE).
