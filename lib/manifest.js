'use strict';

const { parseToml } = require('./toml');
const data = require('../data/manifest.json');

const languages = ['cpp', 'c', 'zig', 'rust', 'assemblyscript', 'go', 'kotlin', 'csharp', 'java'];
const languageAliases = ['c++', 'ts', 'typescript', 'golang', 'tinygo', 'kt', 'c#', 'cs'];
const targets = ['server', 'proxy'];
const capabilityNames = data.capabilities.map((entry) => entry.name);

const topLevel = ['id', 'name', 'version', 'authors', 'api', 'abi', 'lang', 'main', 'target'];
const tables = ['capabilities', 'exports', 'depends', 'soft-depends', 'resources'];
const tableKeys = {
  capabilities: capabilityNames,
  exports: ['modules', 'services'],
  resources: ['private'],
};

const fieldDocs = {
  id: 'Lowercase letters, digits and `_`, starting with a letter.',
  name: 'Display name.',
  version: 'The plugin version.',
  authors: 'List of author names.',
  api: `The plugin API version (${data.api}).`,
  abi: `The WebAssembly ABI version the module was built against (${data.abi}).`,
  lang: `The language: ${languages.join(', ')}.`,
  main: 'The compiled module, a `.wasm` file.',
  target: 'The product the plugin is for: `server` or `proxy`.',
};

function validate(text) {
  const { root, errors } = parseToml(text);
  const found = errors.map((entry) => ({ line: entry.line, message: entry.message, severity: 'error' }));
  if (errors.length > 0) return found;
  const problem = (line, message, severity = 'error') => found.push({ line, message, severity });
  const field = (name) => root.keys.get(name);
  const expect = (name, type) => {
    const value = field(name);
    if (!value) {
      problem(0, `missing \`${name}\``);
    } else if (value.type !== type) {
      problem(value.line, `\`${name}\` must be ${type === 'int' ? 'an integer' : 'a ' + type}`);
      return null;
    }
    return value || null;
  };

  const id = expect('id', 'string');
  if (id && !/^[a-z][a-z0-9_]*$/.test(id.value)) {
    problem(id.line, '`id` takes lowercase letters, digits and `_`, and starts with a letter');
  }
  expect('version', 'string');
  const api = expect('api', 'int');
  if (api && api.value !== data.api) problem(api.line, `\`api\` is ${api.value} but the current API is ${data.api}`);
  const abi = expect('abi', 'int');
  if (abi && abi.value !== data.abi) problem(abi.line, `\`abi\` is ${abi.value} but the current ABI is ${data.abi}`);
  const main = expect('main', 'string');
  if (main && !main.value.endsWith('.wasm')) problem(main.line, '`main` must name a .wasm module');
  const lang = field('lang');
  if (lang && (lang.type !== 'string' || ![...languages, ...languageAliases].includes(lang.value))) {
    problem(lang.line, `\`lang\` is not one of ${languages.join(', ')}`);
  }
  const target = field('target');
  if (target && (target.type !== 'string' || !targets.includes(target.value))) {
    problem(target.line, '`target` must be `server` or `proxy`');
  }
  const authors = field('authors');
  if (authors && (authors.type !== 'array' || authors.value.some((entry) => entry.type !== 'string'))) {
    problem(authors.line, '`authors` must be a list of strings');
  }
  for (const [key, value] of root.keys) {
    if (!topLevel.includes(key)) problem(value.line, `unknown field \`${key}\``, 'warning');
  }

  for (const [name, table] of root.tables) {
    const base = name.split('.')[0];
    if (!tables.includes(base)) {
      problem(table.line, `unknown table [${name}]`, 'warning');
      continue;
    }
    if (name === 'capabilities') checkCapabilities(table, problem);
    else if (tableKeys[name]) {
      for (const [key, value] of table.keys) {
        if (!tableKeys[name].includes(key)) problem(value.line, `unknown key \`${key}\` in [${name}]`, 'warning');
        else if (value.type !== 'array') problem(value.line, `\`${key}\` must be a list of strings`);
      }
    }
  }
  return found;
}

function checkCapabilities(table, problem) {
  for (const [key, value] of table.keys) {
    const known = data.capabilities.find((entry) => entry.name === key);
    if (!known) {
      problem(value.line, `unknown capability '${key}' in [capabilities]; known: ${capabilityNames.join(', ')}`);
    } else if (known.form === 'list' && value.type !== 'array') {
      problem(value.line, `capability \`${key}\` takes a list of strings`);
    } else if (known.form === 'bool' && value.type !== 'bool') {
      problem(value.line, `capability \`${key}\` takes true or false`);
    }
  }
}

// Where the cursor sits in plugin.toml: the table it is inside and whether it is on a key or after `=`.
function contextAt(lines, row, column) {
  let table = '';
  for (let i = row; i >= 0; i--) {
    const header = /^\s*\[([^\]]+)\]\s*$/.exec(lines[i]);
    if (header) {
      table = header[1];
      break;
    }
  }
  const before = lines[row].slice(0, column);
  const afterEquals = /^\s*([A-Za-z0-9_-]+)\s*=\s*(.*)$/.exec(before);
  return afterEquals ? { table, key: afterEquals[1], value: afterEquals[2] } : { table, key: null, value: null };
}

function completions(lines, row, column) {
  const context = contextAt(lines, row, column);
  if (context.key !== null) {
    if (context.table === '' && context.key === 'lang') return languages.map((label) => ({ label, kind: 'value' }));
    if (context.table === '' && context.key === 'target') return targets.map((label) => ({ label, kind: 'value' }));
    if (context.table === '' && context.key === 'abi') return [{ label: String(data.abi), kind: 'value' }];
    if (context.table === '' && context.key === 'api') return [{ label: String(data.api), kind: 'value' }];
    if (context.table === 'capabilities') {
      const known = data.capabilities.find((entry) => entry.name === context.key);
      if (known && known.form === 'bool') return [{ label: 'true', kind: 'value' }];
    }
    return [];
  }
  if (context.table === '') {
    return topLevel.map((label) => ({ label, kind: 'field', detail: fieldDocs[label], insert: `${label} = ` }));
  }
  if (context.table === 'capabilities') {
    return data.capabilities.map((entry) => ({
      label: entry.name,
      kind: 'field',
      detail: entry.doc,
      insert: `${entry.name} = ${entry.form === 'list' ? '[""]' : 'true'}`,
    }));
  }
  if (tableKeys[context.table]) {
    return tableKeys[context.table].map((label) => ({ label, kind: 'field', insert: `${label} = [""]` }));
  }
  return [];
}

function capabilityDocs() {
  return Object.fromEntries(data.capabilities.map((entry) => [entry.name, entry.doc]));
}

function tableCompletions() {
  return tables.map((label) => ({ label: `[${label}]`, kind: 'table' }));
}

module.exports = { validate, completions, capabilityDocs, tableCompletions, languages, targets, capabilityNames, fieldDocs };
