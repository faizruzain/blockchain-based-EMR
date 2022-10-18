const assert = require('assert');
const ganache = require('ganache');
const { beforeEach } = require('mocha');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider());

const { abi, evm } = require('../compile');

let accounts;
let EMR;

beforeEach(async() => {
  accounts = await web3.eth.getAccounts();
  EMR = await new web3.eth.Contract(abi)
    .deploy({
      data: evm.bytecode.object
    })
    .send({
      from: accounts[0],
      gas: '1000000'
    })
});

describe('EMR', () => {
  it('Deploys a Contract called EMR', () => {
    assert.ok(EMR.options.address)
  })

  it('can assign a doctor', async() => {
    await EMR.methods.setDoctor(accounts[1]).send({ from: accounts[0] })
    const doctor = await EMR.methods.doctor().call()
    assert.equal(doctor, accounts[1])
  })


})