// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;

contract ContractDeployer {
    struct ContractAddress {
        string name;
        address contractAddress;
    }

    mapping(string => ContractAddress[]) private bunchOfContractAddress;
    address public admin;

    constructor() {
        admin = msg.sender;

        address patient = address(new Patient(msg.sender));
        bunchOfContractAddress["secret"].push(ContractAddress("patient", patient));

        address patientVerificator = address(new PatientVerificator(msg.sender));
        bunchOfContractAddress["secret"].push(ContractAddress("patientVerificator", patientVerificator));

        address doctorVerificator = address(new DoctorVerificator(msg.sender));
        bunchOfContractAddress["secret"].push(ContractAddress("doctorVerificator", doctorVerificator));

        address doctorRelation = address(new DoctorRelation(msg.sender));
        bunchOfContractAddress["secret"].push(ContractAddress("doctorRelation", doctorRelation));

    }

    function getAllContractAddress(string memory _name) public view returns (ContractAddress[] memory data) {
        require(msg.sender == admin);
        return bunchOfContractAddress[_name];
    }
}

contract Patient {
    struct PatientData {
        address patientAddress;
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
    DoctorRelation doctor_relation;

    constructor(address _admin) {
        admin = _admin;
    }

    function setDoctorVerificatorAddress(address _DoctorVerificatorAddress) public {
        doctor_verificator = DoctorVerificator(_DoctorVerificatorAddress);
    }

    function setPatientVerificatorAddress(address _PatientVerificatorAddress) public {
        patient_verificator = PatientVerificator(_PatientVerificatorAddress);
    }

    function setDoctorRelationAddress(address _DoctorRelationAddress) public {
        doctor_relation = DoctorRelation(_DoctorRelationAddress);
    }

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
        newPatientData.patientAddress = _patient;
        newPatientData.nama_lengkap = _nama_lengkap;
        newPatientData.umur = _umur;
        newPatientData.tanggal_lahir = _tanggal_lahir;
        newPatientData.tanggal_masuk = _tanggal_masuk;
        newPatientData.tanggal_keluar = _tanggal_keluar;
        newPatientData.anamnesis = _anamnesis;
        newPatientData.diagnosis = _diagnosis;

        patient_verificator.addPatient(_patient);
        doctor_relation.addDoctorRelation(msg.sender, _patient);

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

    ) public { 
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

contract PatientVerificator {

    address private admin;
    address[] private patients;

    mapping(address => bool) private patient; //boolean

    constructor(address _admin) {
        admin = _admin;
    }

    function addPatient(address _address) onlyAdmin public {
        require(!patient[_address]);      
        patient[_address] = true;
        patients.push(_address);
        
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

contract DoctorVerificator {

    address private admin;
    address[] private doctors;

    mapping(address => bool) private doctor; //boolean

    constructor(address _admin) {
        admin = _admin;
    }

    function addDoctor(address _address) onlyAdmin public {
        require(!doctor[_address]);      
        doctor[_address] = true;
        doctors.push(_address);
        
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

contract DoctorRelation {
    address admin;
    mapping(address => address[]) private relatedPatien;

    DoctorVerificator doctor_verificator;

    constructor(address _admin) {
        admin = _admin;
    }

    function setDoctorVerificatorAddress(address _DoctorVerificatorAddress) public {
        require(msg.sender == admin);
        doctor_verificator = DoctorVerificator(_DoctorVerificatorAddress);
    }

    function addDoctorRelation(address _doctor, address _patient) public onlyDoctor (msg.sender) {
        relatedPatien[_doctor].push(_patient);
    }

    function getDoctorRelations(address _doctor) public view onlyDoctor(msg.sender) returns(address[] memory) {
        return relatedPatien[_doctor];
    }

    modifier onlyDoctor(address _doctor) {
        require(doctor_verificator.verify(_doctor));
        _;
    }


}