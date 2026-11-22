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
  <strong>Editor support for Basalt plugins: create, build, check and pack WebAssembly plugins.</strong>
</p>

<p align="center">
  <img alt="VS Code" src="https://img.shields.io/badge/VS_Code-1.90%2B-007ACC?logo=visualstudiocode&logoColor=white">
  <img alt="WebAssembly" src="https://img.shields.io/badge/WebAssembly-654FF0?logo=webassembly&logoColor=white">
  <img alt="Targets" src="https://img.shields.io/badge/targets-server_%7C_proxy-62B47A">
  <img alt="License" src="https://img.shields.io/badge/license-GPL--3.0-green">
</p>

## About

DevTools turns an editor into a place to write plugins for Basalt Server and Basalt Proxy in C, C++, Zig, Rust,
AssemblyScript, Go, Kotlin, Java or C#. It drives [Kiln](https://github.com/BasaltProject/Kiln), which compiles and
verifies the plugin.

- **Commands:** `Basalt: New Plugin`, `Build`, `Check`, `Pack`, `Install Toolchain` and `Search ABI import`.
- **Tasks:** `kiln` tasks for every folder with a `plugin.toml`, with problem matchers for Kiln and compiler errors.
- **plugin.toml:** validation, completion and hover for the fields and the capability names.
- **Server and proxy:** pick the target when creating a plugin; Kiln reads it from `plugin.toml` afterwards.

VS Code is the main editor. A JetBrains plugin (IntelliJ IDEA 2025.3+) lives in [`intellij/`](intellij/).

## Installing

Needs VS Code 1.90+ and [Kiln](https://github.com/BasaltProject/Kiln/releases) on the `PATH` (or set `basalt.kilnPath`).
Download `Basalt-DevTools-VSCode-<version>.vsix` from the
[releases page](https://github.com/BasaltProject/DevTools/releases) and install it with
`Extensions: Install from VSIX`. The extension turns on when the open folder contains a `plugin.toml`.

## License

[GPL-3.0-only](LICENSE).
