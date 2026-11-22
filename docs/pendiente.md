# Pending

- JetBrains: the IntelliJ plugin was built on Kiln and the Lua definitions and was removed with them (it is in git
  history before the Quartz switch). Its replacement should be a small LSP4IJ-based plugin that starts `quartz-lsp` and
  runs `qiln verify` and `qiln bundle`. Not started.
- Language server and the products' interfaces overlap on `print`, `Delay` and `int.ticks`, so the editor shows an
  ambiguity error at line 1 of each file. Needs Quartz to skip its standard interface when a host interface declares it.
- Qiln is not installed locally, so the verify and bundle tasks were not run end to end.
