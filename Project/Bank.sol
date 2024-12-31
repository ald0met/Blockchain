// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Bank {
    // 계정별 잔고를 저장하는 매핑
    mapping(address => uint) private balances;
    
    // 컨트랙트 소유자
    address private owner;
    
    // 이벤트
    event Deposit(address indexed account, uint amount);
    event Withdrawal(address indexed account, uint amount);
    
    // 생성자
    constructor() {
        owner = msg.sender;
    }
    
    // 소유자만 접근 가능한 modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    // 이더 입금 함수
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    
    // 이더 출금 함수
    function withdraw(uint amount) public {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }
    
    // 계좌 잔고 확인
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
    
    // 컨트랙트 전체 잔고 확인 (소유자만 허용)
    function getContractBalance() public view onlyOwner returns (uint) {
        return address(this).balance;
    }
}