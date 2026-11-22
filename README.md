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
  <img alt="Quartz" src="https://img.shields.io/badge/Quartz-0.2-C71A36">
  <img alt="Targets" src="https://img.shields.io/badge/targets-server_%7C_proxy-62B47A">
  <img alt="License" src="https://img.shields.io/badge/license-GPL--3.0-green">
</p>

## About

DevTools turns VS Code into a place to write [Quartz](https://github.com/QuartzProject/Quartz) plugins for Basalt Server
and Basalt Proxy. It runs the Quartz language server (`quartz-lsp`) and debugger, and builds with
[Qiln](https://github.com/QuartzProject/Qiln) and the Facet plugin.

- **Autocompletion and diagnostics** against the host interface of the product you target.
- **Commands and snippets:** `Basalt: Verify Plugin`, `Basalt: Bundle Plugin`, and snippets for events, commands and tasks.
- **Server and proxy:** the `basalt.target` setting switches the interface and the package type.

`scripts/generate-definitions.py` regenerates the committed interfaces from a built server or proxy.

## Installing

Needs VS Code 1.90+, plus `quartz-lsp` and `qiln` on the `PATH` (or the `basalt.quartz.*` and `basalt.qiln.path`
settings). Download `Basalt-DevTools-VSCode-<version>.vsix` from the
[releases page](https://github.com/BasaltProject/DevTools/releases) and install it with
`Extensions: Install from VSIX`. The extension turns on when the open folder contains a `plugin.toml`.

## License

[GPL-3.0-only](LICENSE).
