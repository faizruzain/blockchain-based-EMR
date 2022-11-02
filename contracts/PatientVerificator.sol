// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;

contract PatientVerificator {

    address private admin;
    address[] private patients;

    mapping(address => bool) private patient; //boolean

    constructor() {
        admin = msg.sender;
    }

    function addPatient(address _address) onlyAdmin public returns(string memory notif) {
        if(!patient[_address]) {
            patient[_address] = true;
            patients.push(_address);
            return "Address added";
        } else {
            return "Cannot add same address";
        }
        
    }

    function verify(address _address) public view returns(bool _bool) {
        if(patient[_address]) {
            return true;
        } else {
            return false;
        }

    }

    function getAllPatients() onlyAdmin public view returns(address[] memory _address) {
        return patients;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }
}
