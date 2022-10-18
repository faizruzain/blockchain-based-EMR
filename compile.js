// compile code will go here
// req some module
const solc = require('solc')

// The path module provides utilities for working with file and directory paths.
const path = require('path');

// The fs module enables interacting with the file system in a way modeled on standard POSIX functions.
const fs = require('fs');

const EMR_path = path.resolve(__dirname, 'contracts', 'EMR.sol');

const content = fs.readFileSync(EMR_path, 'utf8');

var input = {
  language: 'Solidity',
  sources: {
    'EMR.sol': {
      content: content
    }
  },
  settings: {
    outputSelection: {
      'EMR.sol': {
        '*': ['*']
      }
    }
  }
};

var output = JSON.parse(solc.compile(JSON.stringify(input))).contracts['EMR.sol'].EMR;

module.exports = output;