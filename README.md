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
- **Tasks (VS Code):** `kiln` tasks for every folder with a `plugin.toml`, with problem matchers for Kiln and compiler errors.
- **plugin.toml (VS Code):** validation, completion and hover for the fields and the capability names.
- **Server and proxy:** pick the target when creating a plugin; Kiln reads it from `plugin.toml` afterwards.

DevTools is optional: every build command is also available through Kiln in the terminal. Code completion,
including the Basalt API, comes from the editor's support for your chosen language and the Basalt SDK, with the
project configured for that language. DevTools adds completion for `plugin.toml` in VS Code.

Extensions are available for VS Code and JetBrains IDEs based on IntelliJ Platform 2025.3+ (build 253+), including
IntelliJ IDEA, CLion, RustRover, GoLand, WebStorm, Rider, PyCharm and PhpStorm. The JetBrains plugin lives in
[`jetbrains/`](jetbrains/) and uses the shared platform API.

## Installing

Both extensions need [Kiln](https://github.com/BasaltProject/Kiln/releases) on the `PATH` or an explicit path in their
settings. Install the language support and configure the SDK separately for code completion.

### VS Code

Needs VS Code 1.90+. Set `basalt.kilnPath` if Kiln is not on the `PATH`.
Download `Basalt-DevTools-VSCode-<version>.vsix` from the
[releases page](https://github.com/BasaltProject/DevTools/releases) and install it with
`Extensions: Install from VSIX`. The extension turns on when the open folder contains a `plugin.toml`.

### JetBrains IDEs

Download `Basalt-DevTools-JetBrains-<version>.zip` from the
[releases page](https://github.com/BasaltProject/DevTools/releases). In your IDE, open **Settings > Plugins**, use the
gear menu and choose **Install Plugin from Disk**. Select the ZIP without extracting it.

Open the plugin project folder containing `plugin.toml`. Use **Tools > Basalt** to create, build, check or pack a
plugin. Configure the Kiln executable under **Settings > Tools > Basalt**; findings appear in the **Basalt** tool window.

## License

[GPL-3.0-only](LICENSE).
