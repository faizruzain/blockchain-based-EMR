// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;

contract DoctorVerificator {

    address private admin;
    address[] private doctors;

    mapping(address => bool) private doctor; //boolean

    constructor() {
        admin = msg.sender;
    }

    function addDoctor(address _address) onlyAdmin public returns(string memory notif) {
        if(!doctor[_address]) {
            doctor[_address] = true;
            doctors.push(_address);
            return "Address added";
        } else {
            return "Cannot add same address";
        }
        
    }

    function verify(address _address) public view returns(bool _bool) {
        if(doctor[_address]) {
            return true;
        } else {
            return false;
        }

    }

    function getAllDoctors() onlyAdmin public view returns(address[] memory _address) {
        return doctors;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }
}
