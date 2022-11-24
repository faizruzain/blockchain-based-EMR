// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;

import "./DoctorVerificator.sol";
import "./PatientVerificator.sol";

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

    mapping(address => PatientData) private Patient_Data;
    address private admin; 
    DoctorVerificator doctor_verificator;
    PatientVerificator patient_verificator;

    constructor() {
        admin = msg.sender;
    }

    function setDoctorVerificatorAddress(address _DoctorVerificatorAddress) public {
        doctor_verificator = DoctorVerificator(_DoctorVerificatorAddress);
    }

    function setPatientVerificatorAddress(address _PatientVerificatorAddress) public {
        patient_verificator = PatientVerificator(_PatientVerificatorAddress);

    }

    // function sendThisToDoctor() onlyDoctor public {
    //     DoctorVerificator scdoctor = DoctorVerificator(scdoctorAddress);
    //     scdoctor.addPatient(address(this));
    // }

    function setPatientData(
        address _patient,
        string memory _nama_lengkap,
        uint256 _umur,
        string memory _tanggal_lahir,
        string memory _tanggal_masuk,
        string memory _tanggal_keluar,
        string memory _anamnesis,
        string memory _diagnosis

    ) public onlyDoctor {
        PatientData storage newPatientData = Patient_Data[_patient];
        newPatientData.nama_lengkap = _nama_lengkap;
        newPatientData.umur = _umur;
        newPatientData.tanggal_lahir = _tanggal_lahir;
        newPatientData.tanggal_masuk = _tanggal_masuk;
        newPatientData.tanggal_keluar = _tanggal_keluar;
        newPatientData.anamnesis = _anamnesis;
        newPatientData.diagnosis = _diagnosis;

        patient_verificator.addPatient(_patient);

    }

    function getPatientData(address _address)
        public
        view
        onlyDoctorOrPatient
        returns (PatientData memory data)
    {
        return Patient_Data[_address];
    }

    function updatePatientData(
        address _patient,
        string memory _nama_lengkap,
        uint256 _umur,
        string memory _tanggal_lahir,
        string memory _tanggal_masuk,
        string memory _tanggal_keluar,
        string memory _anamnesis,
        string memory _diagnosis

    ) public onlyDoctor {
        PatientData storage existingPatientData = Patient_Data[_patient];
        existingPatientData.nama_lengkap = _nama_lengkap;
        existingPatientData.umur = _umur;
        existingPatientData.tanggal_lahir = _tanggal_lahir;
        existingPatientData.tanggal_masuk = _tanggal_masuk;
        existingPatientData.tanggal_keluar = _tanggal_keluar;
        existingPatientData.anamnesis = _anamnesis;
        existingPatientData.diagnosis = _diagnosis;
    }

    modifier onlyDoctor() {
        require(doctor_verificator.verify(msg.sender));
        _;
    }

    modifier onlyDoctorOrPatient() {
        require(doctor_verificator.verify(msg.sender) || patient_verificator.verify(msg.sender));
        _;
    }




}

// 0xdD870fA1b7C4700F2BD7f44238821C26f7392148, "Aghna Faiz Ruzain", 25, "18-06-1997", "01-01-2022 0:14:25", " ", "anamnesis", "diagnosis"

// 0xdD870fA1b7C4700F2BD7f44238821C26f7392148, "Aghna Faiz Ruzain", 25, "18-06-1997", "01-01-2022 0:14:25", "01-01-2022 2:14:25", "asdfasdfa asdfasdf", "ghjkghjkghj ghjkghjkghjk"

// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db