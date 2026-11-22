'use strict';

const vscode = require('vscode');
const path = require('path');
const fs = require('fs');
const childProcess = require('child_process');
const kiln = require('./lib/kiln');
const manifest = require('./lib/manifest');
const imports = require('./data/imports.json');

const problems = vscode.languages.createDiagnosticCollection('basalt');
const manifestProblems = vscode.languages.createDiagnosticCollection('basalt-manifest');
const output = vscode.window.createOutputChannel('Basalt');
const verbs = ['build', 'check', 'pack'];

function setting(name) {
  return vscode.workspace.getConfiguration('basalt').get(name);
}

async function findKiln() {
  const found = kiln.locateKiln(setting('kilnPath'), process.env, (file) => fs.existsSync(file));
  if (found) return found;
  const choice = await vscode.window.showErrorMessage(
    'Kiln was not found. Put it on your PATH or set basalt.kilnPath. Releases are on GitHub.',
    'Open Releases',
    'Open Settings'
  );
  if (choice === 'Open Releases') vscode.env.openExternal(vscode.Uri.parse(kiln.releasesUrl));
  if (choice === 'Open Settings') vscode.commands.executeCommand('workbench.action.openSettings', 'basalt.kilnPath');
  return null;
}

async function pluginFolders() {
  const files = await vscode.workspace.findFiles('**/plugin.toml', '**/{node_modules,build,.git}/**', 50);
  return files.map((file) => vscode.Uri.file(path.dirname(file.fsPath)));
}

async function pickPlugin() {
  const folders = await pluginFolders();
  if (folders.length === 0) {
    vscode.window.showWarningMessage('No plugin.toml found in the workspace.');
    return undefined;
  }
  if (folders.length === 1) return folders[0];
  const picked = await vscode.window.showQuickPick(
    folders.map((uri) => ({ label: vscode.workspace.asRelativePath(uri), uri })),
    { placeHolder: 'Plugin folder' }
  );
  return picked && picked.uri;
}

function kilnTask(executable, verb, folder) {
  const definition = { type: 'kiln', command: verb, folder: folder.fsPath };
  const task = new vscode.Task(
    definition,
    vscode.workspace.getWorkspaceFolder(folder) || vscode.TaskScope.Workspace,
    `${verb} ${path.basename(folder.fsPath)}`,
    'kiln',
    new vscode.ShellExecution(executable, [verb, folder.fsPath]),
    ['$kiln', '$kiln-compiler']
  );
  if (verb === 'build') task.group = vscode.TaskGroup.Build;
  return task;
}

async function runVerb(verb) {
  const executable = await findKiln();
  if (!executable) return;
  const folder = await pickPlugin();
  if (folder) await vscode.tasks.executeTask(kilnTask(executable, verb, folder));
}

function execKiln(executable, args, cwd) {
  return new Promise((resolve) => {
    childProcess.execFile(executable, args, { cwd }, (error, stdout, stderr) => {
      output.appendLine(`kiln ${args.join(' ')}`);
      output.append(stdout + stderr);
      resolve({ ok: !error, text: stdout + '\n' + stderr });
    });
  });
}

function showReport(root, text) {
  problems.clear();
  const byFile = new Map();
  for (const entry of kiln.parseReport(text, root)) {
    const row = Math.max(entry.line - 1, 0);
    const severity =
      entry.severity === 'warning' ? vscode.DiagnosticSeverity.Warning : vscode.DiagnosticSeverity.Error;
    const diagnostic = new vscode.Diagnostic(
      new vscode.Range(row, Math.max(entry.column - 1, 0), row, Number.MAX_SAFE_INTEGER),
      entry.message,
      severity
    );
    diagnostic.source = 'kiln';
    byFile.set(entry.file, (byFile.get(entry.file) || []).concat(diagnostic));
  }
  for (const [file, list] of byFile) problems.set(vscode.Uri.file(file), list);
}

async function checkQuietly(folder) {
  const executable = kiln.locateKiln(setting('kilnPath'), process.env, (file) => fs.existsSync(file));
  if (!executable) return;
  const result = await execKiln(executable, ['check', folder.fsPath], folder.fsPath);
  showReport(folder.fsPath, result.text);
}

async function newPlugin() {
  const executable = await findKiln();
  if (!executable) return;
  const language = await vscode.window.showQuickPick(
    kiln.languages.map((entry) => ({ label: entry.title, description: entry.id, id: entry.id })),
    { placeHolder: 'Language' }
  );
  if (!language) return;
  const target = await vscode.window.showQuickPick(manifest.targets, {
    placeHolder: 'Target product',
  });
  if (!target) return;
  const id = await vscode.window.showInputBox({
    prompt: 'Plugin id',
    placeHolder: 'my_plugin',
    validateInput: (value) =>
      /^[a-z][a-z0-9_]*$/.test(value) ? undefined : 'Lowercase letters, digits and _, starting with a letter',
  });
  if (!id) return;
  const parent = await vscode.window.showOpenDialog({
    canSelectFolders: true,
    canSelectFiles: false,
    canSelectMany: false,
    openLabel: 'Create the plugin here',
    defaultUri: vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders[0].uri,
  });
  if (!parent) return;
  const result = await execKiln(executable, ['new', id, '--lang', language.id, '--target', target], parent[0].fsPath);
  if (!result.ok) {
    output.show(true);
    vscode.window.showErrorMessage(`kiln new failed: ${result.text.trim().split('\n').pop()}`);
    return;
  }
  const folder = vscode.Uri.joinPath(parent[0], id);
  const choice = await vscode.window.showInformationMessage(`Created ${id}.`, 'Open Folder');
  if (choice === 'Open Folder') vscode.commands.executeCommand('vscode.openFolder', folder, { forceNewWindow: true });
}

async function installToolchain() {
  const executable = await findKiln();
  if (!executable) return;
  const language = await vscode.window.showQuickPick(
    kiln.languages.map((entry) => ({ label: entry.title, description: entry.id, id: entry.id })),
    { placeHolder: 'Install the compiler for' }
  );
  if (!language) return;
  const terminal = vscode.window.createTerminal('Basalt toolchain');
  terminal.show();
  terminal.sendText(`"${executable}" toolchain install ${language.id}`);
}

async function searchImport() {
  const picked = await vscode.window.showQuickPick(
    imports.map((entry) => ({
      label: `${entry.module === 'basalt_proxy' ? 'basalt_proxy.' : 'basalt.'}${entry.name}`,
      description: `${entry.area}, ${entry.profile}`,
      detail: entry.signature,
      entry,
    })),
    { placeHolder: 'Search an ABI import', matchOnDescription: true, matchOnDetail: true }
  );
  if (!picked) return;
  const entry = picked.entry;
  const body = `# ${picked.label}\n\n\`\`\`c\n${entry.signature};\n\`\`\`\n\nArea \`${entry.area}\`, profile \`${entry.profile}\`.\n\n${entry.doc || 'No documentation in the header.'}\n`;
  const document = await vscode.workspace.openTextDocument({ language: 'markdown', content: body });
  await vscode.window.showTextDocument(document, { preview: true });
}

function toDiagnostics(document) {
  return manifest.validate(document.getText()).map((entry) => {
    const line = document.lineAt(Math.min(entry.line, document.lineCount - 1));
    return new vscode.Diagnostic(
      line.range,
      entry.message,
      entry.severity === 'warning' ? vscode.DiagnosticSeverity.Warning : vscode.DiagnosticSeverity.Error
    );
  });
}

function isManifest(document) {
  return path.basename(document.fileName) === 'plugin.toml';
}

function refreshManifest(document) {
  if (isManifest(document)) manifestProblems.set(document.uri, toDiagnostics(document));
}

const completionKinds = {
  field: vscode.CompletionItemKind.Property,
  value: vscode.CompletionItemKind.Value,
  table: vscode.CompletionItemKind.Module,
};

const manifestSelector = { pattern: '**/plugin.toml' };

function registerManifestSupport(context) {
  context.subscriptions.push(
    manifestProblems,
    vscode.languages.registerCompletionItemProvider(manifestSelector, {
      provideCompletionItems(document, position) {
        const lines = document.getText().split(/\r?\n/);
        const column = position.character;
        let found = manifest.completions(lines, position.line, column);
        if (found.length > 0 && /^\s*\[?\w*$/.test(lines[position.line].slice(0, column)) && !/^\s*\w/.test(lines[position.line])) {
          found = found.concat(manifest.tableCompletions());
        }
        return found.map((entry) => {
          const item = new vscode.CompletionItem(entry.label, completionKinds[entry.kind]);
          item.detail = entry.detail;
          if (entry.insert) item.insertText = entry.insert;
          return item;
        });
      },
    }),
    vscode.languages.registerHoverProvider(manifestSelector, {
      provideHover(document, position) {
        const range = document.getWordRangeAtPosition(position, /[A-Za-z0-9_-]+/);
        if (!range) return undefined;
        const word = document.getText(range);
        const capability = manifest.capabilityDocs()[word];
        const doc = manifest.fieldDocs[word] || capability;
        return doc ? new vscode.Hover(new vscode.MarkdownString(doc), range) : undefined;
      },
    }),
    vscode.workspace.onDidOpenTextDocument(refreshManifest),
    vscode.workspace.onDidChangeTextDocument((change) => refreshManifest(change.document)),
    vscode.workspace.onDidCloseTextDocument((document) => manifestProblems.delete(document.uri))
  );
  vscode.workspace.textDocuments.forEach(refreshManifest);
}

function registerTasks(context) {
  context.subscriptions.push(
    vscode.tasks.registerTaskProvider('kiln', {
      async provideTasks() {
        const executable = kiln.locateKiln(setting('kilnPath'), process.env, (file) => fs.existsSync(file)) || 'kiln';
        const folders = await pluginFolders();
        return folders.flatMap((folder) => verbs.map((verb) => kilnTask(executable, verb, folder)));
      },
      resolveTask(task) {
        const { command, folder } = task.definition;
        if (!verbs.includes(command) || !folder) return undefined;
        const executable = kiln.locateKiln(setting('kilnPath'), process.env, (file) => fs.existsSync(file)) || 'kiln';
        return kilnTask(executable, command, vscode.Uri.file(folder));
      },
    })
  );
}

function activate(context) {
  context.subscriptions.push(
    problems,
    output,
    vscode.commands.registerCommand('basalt.newPlugin', newPlugin),
    vscode.commands.registerCommand('basalt.build', () => runVerb('build')),
    vscode.commands.registerCommand('basalt.check', () => runVerb('check')),
    vscode.commands.registerCommand('basalt.pack', () => runVerb('pack')),
    vscode.commands.registerCommand('basalt.installToolchain', installToolchain),
    vscode.commands.registerCommand('basalt.searchImport', searchImport),
    vscode.workspace.onDidSaveTextDocument(async (document) => {
      if (!setting('checkOnSave') || !isManifest(document)) return;
      await checkQuietly(vscode.Uri.file(path.dirname(document.fileName)));
    })
  );
  registerManifestSupport(context);
  registerTasks(context);
  pluginFolders().then((folders) => folders.forEach(checkQuietly));
}

function deactivate() {}

module.exports = { activate, deactivate };
