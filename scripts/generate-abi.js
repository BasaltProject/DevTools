'use strict';

// Usage: node scripts/generate-abi.js <wire>/wire-wasm <wire>/wire-plugins [outDir]
const fs = require('fs');
const path = require('path');

const profiles = { BASALT_IMPORT: 'server', BASALT_IMPORT_SHARED: 'shared', BASALT_PROXY_IMPORT: 'proxy' };
const scan = /\/\*[\s\S]*?\*\/|BASALT_(?:IMPORT_SHARED|IMPORT|PROXY_IMPORT)\((\w+)\)([^;]*);([ \t]*\/\*.*?\*\/)?/g;

function cleanComment(text) {
  return text
    .replace(/^\/\*+|\*+\/$/g, '')
    .split('\n')
    .map((line) => line.replace(/^\s*\*? ?/, '').trimEnd())
    .join('\n')
    .replace(/\n{2,}/g, '\n\n')
    .trim();
}

function parseHeader(file, area) {
  const text = fs.readFileSync(file, 'utf8').replace(/^[ \t]*#.*$/gm, (line) => ' '.repeat(line.length));
  const found = [];
  let comment = null;
  let commentEnd = 0;
  scan.lastIndex = 0;
  for (let match; (match = scan.exec(text)); ) {
    if (match[0].startsWith('/*')) {
      comment = match[0];
      commentEnd = scan.lastIndex;
      continue;
    }
    const macro = /^BASALT_\w+/.exec(match[0])[0];
    const adjacent = comment !== null && /^\s*$/.test(text.slice(commentEnd, match.index));
    const parts = [];
    if (adjacent && !/^\/\*\s*-{3,}/.test(comment)) {
      parts.push(cleanComment(comment));
    }
    if (match[3]) {
      parts.push(cleanComment(match[3]));
    }
    comment = null;
    const prototype = match[2].replace(/\s+/g, ' ').trim();
    found.push({
      name: match[1],
      module: macro === 'BASALT_PROXY_IMPORT' ? 'basalt_proxy' : 'basalt',
      profile: profiles[macro],
      area,
      signature: prototype,
      doc: parts.join('\n\n'),
    });
  }
  return found;
}

function generateImports(abiDir) {
  const imports = parseHeader(path.join(abiDir, 'basalt_abi.h'), 'core');
  const areas = path.join(abiDir, 'areas');
  for (const name of fs.readdirSync(areas).filter((entry) => entry.endsWith('.h')).sort()) {
    imports.push(...parseHeader(path.join(areas, name), name.slice(0, -2)));
  }
  imports.push(...parseHeader(path.join(abiDir, 'basalt_proxy_abi.h'), 'proxy'));
  return imports;
}

function generateManifest(wirePlugins, abiDoc) {
  const header = fs.readFileSync(
    path.join(wirePlugins, 'include/basalt/wire/plugins/PluginManifest.hpp'),
    'utf8'
  );
  const list = /kKnownCapabilities\{([^}]*)\}/.exec(header);
  if (!list) {
    throw new Error('kKnownCapabilities not found in PluginManifest.hpp');
  }
  const names = [...list[1].matchAll(/"(\w+)"/g)].map((entry) => entry[1]);
  const section = /## Capabilities[\s\S]*?\n(?=## )/.exec(fs.readFileSync(abiDoc, 'utf8'));
  const rows = new Map();
  for (const row of (section ? section[0] : '').matchAll(/^\|\s*`(\w+)`\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|$/gm)) {
    rows.set(row[1], { form: row[2].startsWith('list') ? 'list' : 'bool', gates: row[3] });
  }
  const capabilities = names.map((name) => {
    const row = rows.get(name);
    return { name, form: row ? row.form : 'bool', doc: row ? row.gates : '' };
  });
  const apiVersion = /kApi = (\d+)/.exec(header);
  const abiVersion = /kWasmAbi = (\d+)/.exec(header);
  return {
    api: Number(apiVersion[1]),
    abi: Number(abiVersion[1]),
    capabilities,
  };
}

function main(argv) {
  const [wasmDir, pluginsDir, outDir = path.join(__dirname, '..', 'data')] = argv;
  if (!wasmDir || !pluginsDir) {
    console.error('usage: generate-abi.js <wire-wasm dir> <wire-plugins dir> [out dir]');
    process.exit(2);
  }
  fs.mkdirSync(outDir, { recursive: true });
  const imports = generateImports(path.join(wasmDir, 'abi'));
  fs.writeFileSync(path.join(outDir, 'imports.json'), JSON.stringify(imports, null, 1) + '\n');
  const manifest = generateManifest(pluginsDir, path.join(wasmDir, 'ABI.md'));
  fs.writeFileSync(path.join(outDir, 'manifest.json'), JSON.stringify(manifest, null, 1) + '\n');
  console.log(`${imports.length} imports, ${manifest.capabilities.length} capabilities`);
}

if (require.main === module) {
  main(process.argv.slice(2));
}

module.exports = { generateImports, generateManifest };
