'use strict';

const fs = require('fs');
const os = require('os');
const path = require('path');

function candidateDirs(env, home) {
  const dirs = [];
  for (const entry of (env.PATH || '').split(path.delimiter)) {
    if (entry) {
      dirs.push(entry);
    }
  }
  dirs.push(path.join(home, '.quartz', 'bin'), path.join(home, '.local', 'bin'), path.join(home, '.cargo', 'bin'));
  return dirs;
}

function isExecutable(file) {
  try {
    fs.accessSync(file, fs.constants.X_OK);
    return fs.statSync(file).isFile();
  } catch {
    return false;
  }
}

// A configured path with a separator is used as is; a bare name is searched for.
function findTool(name, configured, env = process.env, home = os.homedir()) {
  const wanted = configured || name;
  if (path.isAbsolute(wanted) || wanted.includes('/') || wanted.includes('\\')) {
    return isExecutable(wanted) ? wanted : undefined;
  }
  const suffixes = process.platform === 'win32' ? ['.exe', '.cmd', ''] : [''];
  for (const dir of candidateDirs(env, home)) {
    for (const suffix of suffixes) {
      const file = path.join(dir, wanted + suffix);
      if (isExecutable(file)) {
        return file;
      }
    }
  }
  return undefined;
}

module.exports = { findTool };
