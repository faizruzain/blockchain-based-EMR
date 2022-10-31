// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;

contract Doctor {

    address admin;
    address[] patients;
    address doctor;

    constructor(address _doctor) {
        admin = msg.sender;
        doctor = _doctor;

    }

    function addPatient(address _patient) onlyDoctor public {
        patients.push(_patient);
    }

    function listPatients() onlyDoctor public view returns(address[] memory _patients) {
        return patients;
    }

    modifier onlyDoctor() {
        require(msg.sender == doctor);
        _;
    }
    
}
// edited with vim :)
