'use strict';

const vscode = require('vscode');
const path = require('path');
const childProcess = require('child_process');

const problems = vscode.languages.createDiagnosticCollection('basalt');
const output = vscode.window.createOutputChannel('Basalt');

function setting(name) {
  return vscode.workspace.getConfiguration('basalt').get(name);
}

function pluginRoot() {
  const folder = vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders[0];
  return folder ? folder.uri : undefined;
}

async function pointLuaServerAtTheApi(context) {
  const root = pluginRoot();
  if (!root) {
    return;
  }
  const definitions = path.join(context.extensionPath, 'definitions');
  const wanted = path.join(definitions, setting('target'));
  const lua = vscode.workspace.getConfiguration('Lua', root);
  const library = (lua.get('workspace.library') || []).filter((entry) => !String(entry).startsWith(definitions));
  library.push(wanted);
  await lua.update('workspace.library', library, vscode.ConfigurationTarget.Workspace);
  if (!lua.inspect('runtime.version').workspaceValue) {
    await lua.update('runtime.version', 'Lua 5.4', vscode.ConfigurationTarget.Workspace);
  }
}

function runKiln(verb) {
  const root = pluginRoot();
  if (!root) {
    return Promise.resolve();
  }
  return new Promise((resolve) => {
    const args = [verb, root.fsPath, '--target', setting('target')];
    childProcess.execFile(setting('kilnPath'), args, (error, stdout, stderr) => {
      output.appendLine(`kiln ${args.join(' ')}`);
      output.append(stdout + stderr);
      if (error && error.code === 'ENOENT') {
        vscode.window.showErrorMessage('Kiln was not found. Set basalt.kilnPath to its location.');
      }
      show(root, stderr);
      resolve(!error);
    });
  });
}

function show(root, report) {
  problems.clear();
  const byFile = new Map();
  for (const line of report.split('\n')) {
    const found = /^(.+?)(?::(\d+))?: (.+)$/.exec(line.trim());
    if (!found) {
      continue;
    }
    const uri = vscode.Uri.joinPath(root, found[1]);
    const row = Math.max(Number(found[2] || 1) - 1, 0);
    const diagnostic = new vscode.Diagnostic(
      new vscode.Range(row, 0, row, Number.MAX_SAFE_INTEGER),
      found[3],
      vscode.DiagnosticSeverity.Error
    );
    diagnostic.source = 'kiln';
    byFile.set(uri.toString(), (byFile.get(uri.toString()) || []).concat(diagnostic));
  }
  for (const [uri, list] of byFile) {
    problems.set(vscode.Uri.parse(uri), list);
  }
}

function activate(context) {
  pointLuaServerAtTheApi(context);
  context.subscriptions.push(
    problems,
    output,
    vscode.commands.registerCommand('basalt.check', () => runKiln('check')),
    vscode.commands.registerCommand('basalt.compile', async () => {
      if (await runKiln('compile')) {
        vscode.window.showInformationMessage('Basalt: the plugin was compiled.');
      }
    }),
    vscode.workspace.onDidChangeConfiguration((change) => {
      if (change.affectsConfiguration('basalt.target')) {
        pointLuaServerAtTheApi(context);
      }
    }),
    vscode.workspace.onDidSaveTextDocument((document) => {
      const name = path.basename(document.fileName);
      if (setting('checkOnSave') && (name.endsWith('.lua') || name === 'plugin.toml')) {
        runKiln('check');
      }
    })
  );
  runKiln('check');
}

function deactivate() {}

module.exports = { activate, deactivate };
