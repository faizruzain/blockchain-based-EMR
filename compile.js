// compile code will go here
// req some module
const solc = require("solc");

// The path module provides utilities for working with file and directory paths.
const path = require("path");

// The fs module enables interacting with the file system in a way modeled on standard POSIX functions.
const fs = require("fs");

const fse = require("fs-extra");

const buildPath = path.resolve(__dirname, "build");

fse.removeSync(buildPath);

const contracts_path = path.resolve(__dirname, "contracts", "ElectronicMedicalRecords.sol");

const content = fs.readFileSync(contracts_path, "utf8");

var input = {
  language: "Solidity",
  sources: {
    "ElectronicMedicalRecords.sol": {
      content: content,
    },
  },
  settings: {
    outputSelection: {
      "*": {
        "*": ["*"],
      },
    },
  },
};

var output = JSON.parse(solc.compile(JSON.stringify(input)));

fse.ensureDirSync(buildPath);

for (let contractName in output.contracts["ElectronicMedicalRecords.sol"]) {
  fse.outputJSONSync(
    path.resolve(buildPath, `${contractName}.json`),
    output.contracts["ElectronicMedicalRecords.sol"][contractName]
  );
}

console.log(output);
