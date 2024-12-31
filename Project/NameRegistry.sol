// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NameRegistry {
    // Info 구조체
    struct ContractInfo {
        address contractOwner;
        address contractAddress;
        string description;
    }

    // 변수 정의
    uint public numContracts;
    mapping(string => ContractInfo) public registeredContracts;

    // 소유자 검증
    modifier onlyOwner(string memory _name) {
        require(registeredContracts[_name].contractOwner == msg.sender, 
                "Only contract owner can modify");
        _;
    }

    constructor() {
        numContracts = 0;
    }

    // 컨트랙트 등록
    function registerContract(
        string memory _name,
        address _contractAddress,
        string memory _description
    ) public {
        require(registeredContracts[_name].contractAddress == address(0), 
                "Contract name already exists");
        
        registeredContracts[_name] = ContractInfo(
            msg.sender, _contractAddress, _description
        );
        
        numContracts++;
    }

    // 컨트랙트 삭제
    function unregisterContract(string memory _name) public onlyOwner(_name) {
        delete registeredContracts[_name];
        numContracts--;
    }

    // 소유자 관련 함수
    function changeOwner(string memory _name, address _newOwner) public onlyOwner(_name) {
        registeredContracts[_name].contractOwner = _newOwner;
    }

    function getOwner(string memory _name) public view returns (address) {
        return registeredContracts[_name].contractOwner;
    }

    // 주소 관련 함수
    function setAddr(string memory _name, address _addr) public onlyOwner(_name) {
        registeredContracts[_name].contractAddress = _addr;
    }

    function getAddr(string memory _name) public view returns (address) {
        return registeredContracts[_name].contractAddress;
    }

    // 설명 관련 함수
    function setDescription(string memory _name, string memory _description) public onlyOwner(_name) {
        registeredContracts[_name].description = _description;
    }

    function getDescription(string memory _name) public view returns (string memory) {
        return registeredContracts[_name].description;
    }
}