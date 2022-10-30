const assert = require("assert");
const ganache = require("ganache");
const { before, after } = require("mocha");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());

const { abi, evm } = require("../compile");

let accounts;
let Patient;

let d = new Date();
let date = d.toLocaleDateString("id-ID", {
  dateStyle: "long",
});
let time = d.toLocaleTimeString("id-ID", {
  timeStyle: "long",
});

//console.log(`${date} ${time}`);

describe("Patient", async () => {
  before(async () => {
    accounts = await web3.eth.getAccounts();
    Patient = await new web3.eth.Contract(abi)
      .deploy({
        data: evm.bytecode.object,
        arguments: [accounts[1], accounts[2]],
      })
      .send({
        from: accounts[0], //admin
        gas: "1000000",
      });
  });

  after(async () => {
    const rawData = await Patient.methods.getPatientData().call({
      from: accounts[1],
      gas: "1000000",
    });

    const newData = {};
    for (const key in rawData) {
      if (key.length > 1) {
        newData[key] = rawData[key];
      }
    }
    console.log(newData);
    assert.ok(rawData);
  });

  it("Deploys a Contract called Patient", () => {
    assert.ok(Patient.options.address);
  });

  it("Set patient data", async () => {
    await Patient.methods
      .setPatientData(
        "Aghna Faiz Ruzain",
        25,
        "18-06-1997",
        `${date} ${time}`,
        "",
        "anamnesis",
        "diagnosis"
      )
      .send({
        from: accounts[1],
        gas: "1000000",
      })
      .on("transactionHash", (hash) => {
        assert.ok(hash);
      });
  });

  it("Get patient data", async () => {
    const rawData = await Patient.methods.getPatientData().call({
      from: accounts[1],
      gas: "1000000",
    });

    const newData = {};
    for (const key in rawData) {
      if (key.length > 1) {
        newData[key] = rawData[key];
      }
    }
    console.log(newData);
    assert.ok(rawData);
  });

  it("Update patient data", async () => {
    await Patient.methods
      .updatePatientData(
        "Aghna Faiz Ruzain",
        25,
        "18-06-1997",
        "31 Oktober 2022 01.52.26 WIB",
        `${date} ${time}`,
        "anamnesis",
        "diagnosis"
      )
      .send({
        from: accounts[1],
        gas: "1000000",
      })
      .on("transactionHash", (hash) => {
        assert.ok(hash);
      });
  });
});

// "Aghna Faiz Ruzain", 25, "18-06-1997", "01-01-2022", "amnesis", "diagnosis"
