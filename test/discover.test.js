'use strict';

const test = require('node:test');
const assert = require('node:assert');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { findTool } = require('../lib/discover');

test('findTool prefers the configured path, then PATH, then the home bin folders', () => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'basalt-devtools-'));
  const bin = path.join(root, '.quartz', 'bin');
  fs.mkdirSync(bin, { recursive: true });
  const tool = path.join(bin, 'quartz-lsp');
  fs.writeFileSync(tool, '#!/bin/sh\n', { mode: 0o755 });
  assert.strictEqual(findTool('quartz-lsp', '', { PATH: '' }, root), tool);
  assert.strictEqual(findTool('quartz-lsp', tool, { PATH: '' }, '/nowhere'), tool);
  assert.strictEqual(findTool('quartz-lsp', '', { PATH: '' }, '/nowhere'), undefined);
  assert.strictEqual(findTool('quartz-lsp', path.join(root, 'missing'), { PATH: '' }, root), undefined);
  fs.rmSync(root, { recursive: true });
});
