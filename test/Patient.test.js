const assert = require("assert");
const ganache = require("ganache");
const { before, after } = require("mocha");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());

// const { abi, evm } = require("../compile");

const compiled_ContractDeployer = require("../build/ContractDeployer.json");
const compiled_DoctorVerificator = require("../build/DoctorVerificator.json");

// an array of accounts
let accounts;

// contracts instance
let ContractDeployer;
let DoctorVerificator;

// addresses
let patient;
let patientVerificator;
let doctorVerificator;
let doctorRelation;

let d = new Date();
let date = d.toLocaleDateString("id-ID", {
  dateStyle: "long",
});
let time = d.toLocaleTimeString("id-ID", {
  timeStyle: "long",
});

// //console.log(`${date} ${time}`);

describe("ContractDeployer", async () => {
  before(async () => {
    try {
      accounts = await web3.eth.getAccounts();
      ContractDeployer = await new web3.eth.Contract(
        compiled_ContractDeployer.abi
      )
        .deploy({
          data: compiled_ContractDeployer.evm.bytecode.object,
        })
        .send({
          from: accounts[0], //admin
          gas: "3000000",
        });
    } catch (err) {
      console.log(err);
    }
  });

  // after(async () => {
  //   const rawData = await Patient.methods.getPatientData().call({
  //     from: accounts[1],
  //     gas: "1000000",
  //   });

  //   const newData = {};
  //   for (const key in rawData) {
  //     if (key.length > 1) {
  //       newData[key] = rawData[key];
  //     }
  //   }
  //   console.log(newData);
  //   assert.ok(rawData);
  // });

  it("Deploys a Contract called ContractDepoyer", () => {
    assert.ok(ContractDeployer.options.address);
  });

  it("Returns address of deployed contract", async () => {
    try {
      const res = await ContractDeployer.methods
        .getAllContractAddress("pantek")
        .call({
          from: accounts[0],
        });
      [
        { contractAddress: patient },
        { contractAddress: patientVerificator },
        { contractAddress: doctorVerificator },
        { contractAddress: doctorRelation },
      ] = res;
      assert.equal(res.length, 4);
    } catch (err) {
      console.log(err);
    }
  });

  describe("DoctorVerificator", async () => {
    before(async () => {
      try {
        DoctorVerificator = await new web3.eth.Contract(
          compiled_DoctorVerificator.abi,
          doctorVerificator
        );
      } catch (err) {
        console.log(err);
      }
    });

    it("Adds doctor to list", async () => {
      try {
        const res = await DoctorVerificator.methods
          .addDoctor(accounts[1])
          .send({
            from: accounts[0],
            gas: "1000000",
          });
        console.log(res);
      } catch (err) {
        console.log(err);
      }
    });

    it("Verifies doctor", async () => {
      try {
        const res = await DoctorVerificator.methods.verify(accounts[1]).call();
        console.log(res);
      } catch (err) {
        console.log(err);
      }
    });

    it("Cannot add duplicated doctor to list", async () => {
      try {
        const res = await DoctorVerificator.methods
          .addDoctor(accounts[1])
          .send({
            from: accounts[0],
            gas: "1000000",
          });
        console.log(res);
        // assert.equal(res, false)
      } catch (err) {
        console.log(err);
      }
    });
  });

  // it("Set patient data", async () => {
  //   await Patient.methods
  //     .setPatientData(
  //       "Aghna Faiz Ruzain",
  //       25,
  //       "18-06-1997",
  //       `${date} ${time}`,
  //       "",
  //       "anamnesis",
  //       "diagnosis"
  //     )
  //     .send({
  //       from: accounts[1],
  //       gas: "1000000",
  //     })
  //     .on("transactionHash", (hash) => {
  //       assert.ok(hash);
  //     });
  // });

  // it("Get patient data", async () => {
  //   const rawData = await Patient.methods.getPatientData().call({
  //     from: accounts[1],
  //     gas: "1000000",
  //   });

  //   const newData = {};
  //   for (const key in rawData) {
  //     if (key.length > 1) {
  //       newData[key] = rawData[key];
  //     }
  //   }
  //   console.log(newData);
  //   assert.ok(rawData);
  // });

  // it("Update patient data", async () => {
  //   await Patient.methods
  //     .updatePatientData(
  //       "Aghna Faiz Ruzain",
  //       25,
  //       "18-06-1997",
  //       "31 Oktober 2022 01.52.26 WIB",
  //       `${date} ${time}`,
  //       "anamnesis",
  //       "diagnosis"
  //     )
  //     .send({
  //       from: accounts[1],
  //       gas: "1000000",
  //     })
  //     .on("transactionHash", (hash) => {
  //       assert.ok(hash);
  //     });
  // });
});

// "Aghna Faiz Ruzain", 25, "18-06-1997", "01-01-2022", "amnesis", "diagnosis"
