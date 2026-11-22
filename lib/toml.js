'use strict';

function splitTopLevel(text, separator) {
  const parts = [];
  let depth = 0;
  let quote = null;
  let start = 0;
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (quote) {
      if (c === '\\' && quote === '"') i++;
      else if (c === quote) quote = null;
    } else if (c === '"' || c === "'") quote = c;
    else if (c === '[') depth++;
    else if (c === ']') depth--;
    else if (c === separator && depth === 0) {
      parts.push(text.slice(start, i));
      start = i + 1;
    }
  }
  parts.push(text.slice(start));
  return parts;
}

function stripComment(text) {
  let quote = null;
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (quote) {
      if (c === '\\' && quote === '"') i++;
      else if (c === quote) quote = null;
    } else if (c === '"' || c === "'") quote = c;
    else if (c === '#') return text.slice(0, i);
  }
  return text;
}

function parseValue(raw) {
  const text = raw.trim();
  if (text === 'true' || text === 'false') return { type: 'bool', value: text === 'true' };
  if (/^[+-]?\d+$/.test(text)) return { type: 'int', value: Number(text) };
  if (/^[+-]?\d+\.\d+$/.test(text)) return { type: 'float', value: Number(text) };
  if (/^"(?:[^"\\]|\\.)*"$/.test(text)) {
    return { type: 'string', value: JSON.parse(text) };
  }
  if (/^'[^']*'$/.test(text)) return { type: 'string', value: text.slice(1, -1) };
  if (text.startsWith('[') && text.endsWith(']')) {
    const inner = text.slice(1, -1).trim();
    const items = inner === '' ? [] : splitTopLevel(inner, ',').filter((part) => part.trim() !== '');
    const values = items.map(parseValue);
    if (values.some((entry) => entry === null)) return null;
    return { type: 'array', value: values };
  }
  return null;
}

// Reads the TOML subset a plugin.toml uses. Each key keeps its 0-based line.
function parseToml(text) {
  const root = { keys: new Map(), tables: new Map() };
  const errors = [];
  let current = root;
  const lines = text.split(/\r?\n/);
  for (let index = 0; index < lines.length; index++) {
    const line = stripComment(lines[index]).trim();
    if (line === '') continue;
    if (line.startsWith('[[')) {
      errors.push({ line: index, message: 'arrays of tables are not supported here: write a table per entry instead' });
      continue;
    }
    const header = /^\[([A-Za-z0-9_.-]+)\]$/.exec(line);
    if (header) {
      current = { keys: new Map(), tables: new Map(), line: index };
      if (root.tables.has(header[1])) errors.push({ line: index, message: `table [${header[1]}] is defined twice` });
      root.tables.set(header[1], current);
      continue;
    }
    const pair = /^([A-Za-z0-9_-]+|"[^"]*")\s*=\s*(.*)$/.exec(line);
    if (!pair) {
      errors.push({ line: index, message: 'expected `key = value` or a [table]' });
      continue;
    }
    const key = pair[1].replace(/^"|"$/g, '');
    const value = parseValue(pair[2]);
    if (value === null) {
      errors.push({ line: index, message: `cannot read the value of \`${key}\`` });
      continue;
    }
    if (current.keys.has(key)) errors.push({ line: index, message: `\`${key}\` is defined twice` });
    current.keys.set(key, { ...value, line: index });
  }
  return { root, errors };
}

module.exports = { parseToml };
