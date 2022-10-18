// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;

contract EMR {

    address private owner;
    address public doctor;
    address public patient;

    struct Patient_Data {
        string name;
        string DOB;
        string diagnosis;
    }

    Patient_Data[] public _Patient_Data;

    constructor() {
        owner = msg.sender;
    }

    function createPatientData(string memory _name, string memory _DOB, string memory _diagnosis) public onlyDoctor {
        _Patient_Data.push(Patient_Data(_name, _DOB, _diagnosis));

        _Patient_Data.push(Patient_Data({
            name: _name,
            DOB: _DOB,
            diagnosis: _diagnosis
        }));

        Patient_Data memory _Patient_Data_;
        _Patient_Data_.name = _name;
        _Patient_Data_.DOB = _DOB;
        _Patient_Data_.diagnosis = _diagnosis;

        _Patient_Data.push(_Patient_Data_);

        //getBlockHash();

    }

    function setDoctor(address doctor_address) public onlyOwner {
        doctor = doctor_address;
    }

    function setPatient(address patient_address) public onlyOwner {
        patient = patient_address;
    }

    function getBlockNumber() public view returns (uint) {
        return block.number; //blockhash(block.number);
    }

    // function updateEMR(struct Data) public onlyDoctor {
        
    // }


    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    modifier onlyDoctor() {
        require(doctor == msg.sender);
        _;
    }

    modifier onlyPatient() {
        require(patient == msg.sender);
        _;
    }



}

// string "faiz", string "18061997", string "berak2"