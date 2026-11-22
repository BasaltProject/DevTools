'use strict';

const path = require('path');

const languages = [
  { id: 'cpp', title: 'C++' },
  { id: 'c', title: 'C' },
  { id: 'zig', title: 'Zig' },
  { id: 'rust', title: 'Rust' },
  { id: 'assemblyscript', title: 'AssemblyScript' },
  { id: 'go', title: 'Go (TinyGo)' },
  { id: 'kotlin', title: 'Kotlin' },
  { id: 'csharp', title: 'C#' },
  { id: 'java', title: 'Java' },
];

// A compiler line is `file:line:col: error: text`; Kiln's own are `file[:line]: text`; both may start `kiln <verb>: `.
const compilerLine = /^(?:kiln \w+: )?(.+?):(\d+):(?:(\d+):)? (error|warning|fatal error): (.+)$/;
const kilnLine = /^(?:kiln \w+: )?([^\s:][^:]*?)(?::(\d+))?: (.+)$/;
const noise = /^(?:kiln \w+: [^/\\]*$|\d+ problem\(s\)|ok$)/;

function parseReport(report, root) {
  const found = [];
  for (const raw of report.split(/\r?\n/)) {
    const text = raw.trim();
    if (text === '' || noise.test(text)) continue;
    let match = compilerLine.exec(text);
    if (match) {
      found.push({
        file: resolve(match[1], root),
        line: Number(match[2]),
        column: match[3] ? Number(match[3]) : 1,
        severity: match[4] === 'warning' ? 'warning' : 'error',
        message: match[5],
      });
      continue;
    }
    match = kilnLine.exec(text);
    if (match && /[./\\]/.test(match[1])) {
      found.push({
        file: resolve(match[1], root),
        line: match[2] ? Number(match[2]) : 0,
        column: 1,
        severity: 'error',
        message: match[3],
      });
    }
  }
  return found;
}

function resolve(file, root) {
  return path.isAbsolute(file) ? file : path.join(root, file);
}

// Resolves the Kiln executable: the setting when it is a path or a name, else `kiln` on the PATH.
function locateKiln(setting, env, exists) {
  const names = process.platform === 'win32' ? ['kiln.exe', 'kiln.cmd', 'kiln'] : ['kiln'];
  const wanted = setting && setting.trim() !== '' ? setting.trim() : null;
  if (wanted && (path.isAbsolute(wanted) || /[\\/]/.test(wanted))) {
    return exists(wanted) ? wanted : null;
  }
  const candidates = wanted ? [wanted] : names;
  for (const folder of (env.PATH || '').split(path.delimiter).filter(Boolean)) {
    for (const name of candidates) {
      const full = path.join(folder, name);
      if (exists(full)) return full;
    }
  }
  return null;
}

const releasesUrl = 'https://github.com/BasaltProject/Kiln/releases';

module.exports = { languages, parseReport, locateKiln, releasesUrl };
