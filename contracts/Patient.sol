// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;

contract Patient {
    struct PatientData {
        string nama_lengkap;
        uint256 umur;
        string tanggal_lahir;
        string tanggal_masuk;
        string tanggal_keluar;
        string anamnesis;
        string diagnosis;
    }

    PatientData private Patient_Data;
    address private admin;
    address private doctor;
    address private patient;

    //address private lastAccess;

    constructor(address _doctor, address _patient) {
        admin = msg.sender;
        doctor = _doctor;
        patient = _patient;
    }

    function setPatientData(
        string memory _nama_lengkap,
        uint256 _umur,
        string memory _tanggal_lahir,
        string memory _tanggal_masuk,
        string memory _tanggal_keluar,
        string memory _anamnesis,
        string memory _diagnosis
    ) public onlyDoctor {
        PatientData memory newPatientData = PatientData({
            nama_lengkap: _nama_lengkap,
            umur: _umur,
            tanggal_lahir: _tanggal_lahir,
            tanggal_masuk: _tanggal_masuk,
            tanggal_keluar: _tanggal_keluar,
            anamnesis: _anamnesis,
            diagnosis: _diagnosis
        });

        Patient_Data = newPatientData;
    }

    function getPatientData()
        public
        view
        onlyDoctorOrPatient
        returns (PatientData memory data)
    {
        //lastAccess = msg.sender;
        return Patient_Data;
    }

    function updatePatientData(
        string memory _nama_lengkap,
        uint256 _umur,
        string memory _tanggal_lahir,
        string memory _tanggal_masuk,
        string memory _tanggal_keluar,
        string memory _anamnesis,
        string memory _diagnosis
    ) public onlyDoctor {
        PatientData memory newData = PatientData({
            nama_lengkap: _nama_lengkap,
            umur: _umur,
            tanggal_lahir: _tanggal_lahir,
            tanggal_masuk: _tanggal_masuk,
            tanggal_keluar: _tanggal_keluar,
            anamnesis: _anamnesis,
            diagnosis: _diagnosis
        });

        Patient_Data = newData;
    }

    // function getLastAccess() public view returns(address) {
    //     return lastAccess;
    // }

    modifier onlyDoctor() {
        require(msg.sender == doctor);
        _;
    }

    modifier onlyDoctorOrPatient() {
        require(msg.sender == doctor || msg.sender == patient);
        _;
    }
}

// "Aghna Faiz Ruzain", 25, "18-06-1997", "01-01-2022 0:14:25", " ", "anamnesis", "diagnosis"

// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
