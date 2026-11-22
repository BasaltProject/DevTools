'use strict';

// Runs the editor logic under plain node. KILN and EXAMPLE (a plugin folder) turn on the checks against real files.
const assert = require('assert');
const fs = require('fs');
const os = require('os');
const path = require('path');
const childProcess = require('child_process');
const kiln = require('../lib/kiln');
const manifest = require('../lib/manifest');
const imports = require('../data/imports.json');

const fixed = '/work/demo';
const parsed = kiln.parseReport(
  [
    'plugin.toml: `abi` is 9 but this Kiln builds ABI 1',
    'plugin.toml:1: arrays of tables are not supported here',
    'build/plugin.wasm: import basalt.player_sendd is not part of ABI 1',
    'kiln build: /work/demo/src/main.c:1:9: error: expected expression',
    '    1 | int x = ;',
    '2 problem(s)',
    'kiln check: the module is not built yet; run `kiln build` to check it too',
  ].join('\n'),
  fixed
);
assert.deepStrictEqual(
  parsed.map((entry) => [path.relative(fixed, entry.file), entry.line, entry.column, entry.severity]),
  [
    ['plugin.toml', 0, 1, 'error'],
    ['plugin.toml', 1, 1, 'error'],
    ['build/plugin.wasm', 0, 1, 'error'],
    ['src/main.c', 1, 9, 'error'],
  ]
);

const good = 'id = "demo"\nversion = "1.0.0"\napi = 1\nabi = 1\nmain = "plugin.wasm"\n[capabilities]\nstorage = true\n';
assert.deepStrictEqual(manifest.validate(good), []);
const bad = manifest.validate(good.replace('abi = 1', 'abi = 9') + 'sparkle = true\nnetwork = true\n');
assert.ok(bad.some((entry) => entry.message.includes('`abi` is 9')));
assert.ok(bad.some((entry) => entry.message.includes("unknown capability 'sparkle'")));
assert.ok(bad.some((entry) => entry.message.includes('takes a list')));

const counts = {};
for (const entry of imports) counts[entry.area] = (counts[entry.area] || 0) + 1;
assert.strictEqual(imports.length, Object.values(counts).reduce((a, b) => a + b, 0));

if (process.env.EXAMPLE) {
  const text = fs.readFileSync(path.join(process.env.EXAMPLE, 'plugin.toml'), 'utf8');
  assert.deepStrictEqual(manifest.validate(text), [], 'the example manifest validates');
  assert.ok(manifest.validate(text.replace('main = "plugin.wasm"', 'main = "plugin.bin"')).length > 0);
}

if (process.env.KILN) {
  const dir = fs.mkdtempSync(path.join(process.env.KILN_SCRATCH || os.tmpdir(), 'devtools-'));
  const run = (args, cwd) => childProcess.spawnSync(process.env.KILN, args, { cwd, encoding: 'utf8' });
  assert.strictEqual(run(['new', 'demo', '--lang', 'c', '--offline'], dir).status, 0);
  const root = path.join(dir, 'demo');
  const created = fs.readFileSync(path.join(root, 'plugin.toml'), 'utf8');
  assert.deepStrictEqual(manifest.validate(created), [], 'kiln new writes a valid manifest');
  const broken = created.replace('abi = 1', 'abi = 9').replace('id = "demo"', 'id = "Demo"');
  fs.writeFileSync(path.join(root, 'plugin.toml'), broken);
  const report = run(['check', root], root);
  assert.strictEqual(report.status, 1);
  const found = kiln.parseReport(report.stdout + report.stderr, root);
  assert.strictEqual(found.length, 2);
  assert.ok(found.every((entry) => entry.file === path.join(root, 'plugin.toml')));
  assert.strictEqual(manifest.validate(broken).length, 2, 'the validator agrees with kiln check');
  fs.writeFileSync(path.join(root, 'plugin.toml'), created);
  fs.writeFileSync(path.join(root, 'src/main.c'), 'int x = ;\n');
  const build = run(['build', root, '--offline'], root);
  const compiled = kiln.parseReport(build.stdout + build.stderr, root);
  assert.ok(compiled.some((entry) => entry.file === path.join(root, 'src/main.c') && entry.line === 1 && entry.column === 9));
  fs.rmSync(dir, { recursive: true, force: true });
}

console.log('ok');
