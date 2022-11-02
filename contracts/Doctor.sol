// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;

contract Doctor {

    struct  DoctorDetails {
        address accountAddress; //use this as doctor ID
        address contractAddress;
        string fullName;
        string department;

    }

    address private admin;
    address[] private listOfpatients;
    address private doctor;
    DoctorDetails doctor_details;

    constructor(address _doctor) {
        admin = msg.sender;
        doctor = _doctor;
    }

    function setDoctor(string memory _fullName, string memory _department) public {
        DoctorDetails memory newDoctor = DoctorDetails({
            accountAddress: doctor,
            contractAddress: address(this),
            fullName: _fullName,
            department: _department
        });

        doctor_details = newDoctor;
    }

    function addPatient(address _patientAddress) external {
        listOfpatients.push(_patientAddress);
    }

    function listPatients() onlyDoctor public view returns(address[] memory _patients) {
        return listOfpatients;
    }

    modifier onlyDoctor() {
        require(msg.sender == doctor);
        _;
    }
    
}
// edited with vim :)

// doctor 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
