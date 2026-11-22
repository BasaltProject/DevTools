'use strict';

const vscode = require('vscode');
const fs = require('fs');
const path = require('path');
const { LanguageClient } = require('vscode-languageclient/node');
const { findTool } = require('./lib/discover');

let client;
let output;

function setting(name) {
  return vscode.workspace.getConfiguration('basalt').get(name);
}

function pluginRoot() {
  const folder = vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders[0];
  return folder ? folder.uri.fsPath : undefined;
}

function tool(name, key) {
  const found = findTool(name, setting(key));
  if (!found) {
    vscode.window.showErrorMessage(`Basalt: ${name} was not found. Set basalt.${key} or put it on the PATH.`);
  }
  return found;
}

// Qiln and the language server both read <target>.qzi from the plugin folder.
function syncHostApi(context) {
  const root = pluginRoot();
  if (!root) {
    return;
  }
  const source = path.join(context.extensionPath, 'definitions', setting('target'), 'basalt.qzi');
  if (!fs.existsSync(source)) {
    vscode.window.showWarningMessage(`Basalt: there is no host API for the target ${setting('target')} yet.`);
    return;
  }
  const wanted = fs.readFileSync(source);
  const target = path.join(root, `${setting('target')}.qzi`);
  if (!fs.existsSync(target) || !fs.readFileSync(target).equals(wanted)) {
    fs.writeFileSync(target, wanted);
  }
}

async function startServer() {
  if (client || !pluginRoot()) {
    return;
  }
  const command = tool('quartz-lsp', 'quartz.lspPath');
  if (!command) {
    return;
  }
  client = new LanguageClient(
    'basalt-quartz',
    'Quartz Language Server',
    { command, args: [] },
    { documentSelector: [{ scheme: 'file', language: 'quartz' }], outputChannel: output }
  );
  try {
    await client.start();
  } catch (error) {
    client = undefined;
    vscode.window.showWarningMessage(`Basalt: could not start ${command} (${error.message}).`);
  }
}

async function stopServer() {
  const old = client;
  client = undefined;
  if (old) {
    await old.stop();
  }
}

async function restartServer() {
  await stopServer();
  await startServer();
}

function runQiln(verb) {
  const qiln = tool('qiln', 'qiln.path');
  const root = vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders[0];
  if (!qiln || !root) {
    return;
  }
  const execution = new vscode.ShellExecution(qiln, [verb], { cwd: root.uri.fsPath });
  const task = new vscode.Task({ type: 'basalt', command: verb }, root, `qiln ${verb}`, 'basalt', execution, '$basalt');
  task.group = verb === 'bundle' ? vscode.TaskGroup.Build : vscode.TaskGroup.Test;
  return vscode.tasks.executeTask(task);
}

class QilnTaskProvider {
  provideTasks() {
    return [];
  }

  resolveTask(task) {
    const verb = task.definition.command;
    const qiln = findTool('qiln', setting('qiln.path')) || 'qiln';
    const execution = new vscode.ShellExecution(qiln, [verb]);
    return new vscode.Task(task.definition, task.scope || vscode.TaskScope.Workspace, `qiln ${verb}`, 'basalt', execution, '$basalt');
  }
}

class QuartzDebugAdapterFactory {
  createDebugAdapterDescriptor() {
    const command = tool('quartz', 'quartz.path');
    return command ? new vscode.DebugAdapterExecutable(command, ['debug', '--dap']) : undefined;
  }
}

class QuartzDebugConfigurationProvider {
  resolveDebugConfiguration(folder, config) {
    const editor = vscode.window.activeTextEditor;
    if (!config.type && !config.request && !config.name && editor && editor.document.languageId === 'quartz') {
      return { type: 'quartz', request: 'launch', name: 'Run current file', program: '${file}' };
    }
    return config;
  }
}

function activate(context) {
  output = vscode.window.createOutputChannel('Basalt');
  syncHostApi(context);
  context.subscriptions.push(
    output,
    vscode.commands.registerCommand('basalt.check', () => runQiln('verify')),
    vscode.commands.registerCommand('basalt.build', () => runQiln('bundle')),
    vscode.commands.registerCommand('basalt.restartServer', restartServer),
    vscode.commands.registerCommand('basalt.syncHostApi', () => syncHostApi(context)),
    vscode.tasks.registerTaskProvider('basalt', new QilnTaskProvider()),
    vscode.debug.registerDebugAdapterDescriptorFactory('quartz', new QuartzDebugAdapterFactory()),
    vscode.debug.registerDebugConfigurationProvider('quartz', new QuartzDebugConfigurationProvider()),
    vscode.workspace.onDidChangeConfiguration((change) => {
      if (change.affectsConfiguration('basalt.target')) {
        syncHostApi(context);
      }
      if (change.affectsConfiguration('basalt.quartz.lspPath')) {
        restartServer();
      }
    }),
    vscode.workspace.onDidSaveTextDocument((document) => {
      if (setting('checkOnSave') && path.basename(document.fileName) === 'plugin.toml') {
        runQiln('verify');
      }
    })
  );
  return startServer();
}

function deactivate() {
  return stopServer();
}

module.exports = { activate, deactivate };
