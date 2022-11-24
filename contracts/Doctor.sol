// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;

contract Doctor {

    struct  DoctorDetails {
        address accountAddress; //use this as doctor ID
        string fullName;
        string department;
        address[] patientLists;

    }

    address private admin;
    mapping(address => DoctorDetails) private doctor_details;

    constructor() {
        admin = msg.sender;
    }

    function setDoctorDetails(
        address _accountAddress,
        string memory _fullName,
        string memory _department

        ) public {
        DoctorDetails storage newDoctorDetails = doctor_details[_accountAddress];
        newDoctorDetails.accountAddress = _accountAddress;
        newDoctorDetails.fullName = _fullName;
        newDoctorDetails.department = _department;
    }

    function getDoctorDetails(address _address) public view returns(DoctorDetails memory) {
        return doctor_details[_address];
    }

    function addPatientToThis(address _address, address _patientAddress) public {
        DoctorDetails storage doctorDetails = doctor_details[_address];
        doctorDetails.patientLists.push(_patientAddress);
    }

    function getThisPatientsLists(address _doctorAddress) public view returns(address[] memory _address) {
        DoctorDetails storage result = doctor_details[_doctorAddress];
        return result.patientLists;
    }



    
    
}

// 0x583031D1113aD414F02576BD6afaBfb302140225, "Dr. Puja Hadi Prabowski", "Penjaringan"