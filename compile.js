// compile code will go here
// req some module
const solc = require("solc");

// The path module provides utilities for working with file and directory paths.
const path = require("path");

// The fs module enables interacting with the file system in a way modeled on standard POSIX functions.
const fs = require("fs");

const Patient_path = path.resolve(__dirname, "contracts", "Patient.sol");

const content = fs.readFileSync(Patient_path, "utf8");

var input = {
  language: "Solidity",
  sources: {
    "Patient.sol": {
      content: content,
    },
  },
  settings: {
    outputSelection: {
      "Patient.sol": {
        "*": ["*"],
      },
    },
  },
};

const output = JSON.parse(solc.compile(JSON.stringify(input))).contracts[
  "Patient.sol"
].Patient;

// console.log(output);

module.exports = output;
