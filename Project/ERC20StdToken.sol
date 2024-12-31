// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20StdToken {
    mapping (address => uint256) balances; // 각 계정이 소유한 토큰 수 저장
    mapping (address => mapping (address => uint256)) allowed; // 각 계정이 다른 계정들이 대리 전송할 수 있도록 허용한 토큰 수 저장
    uint256 private total; // 총 발행 토큰 수
    string public name; // 토큰 이름
    string public symbol; // 토큰 심볼
    uint8 public decimals; // 토큰의 소수점 자리수

    event Transfer(address indexed from, address indexed to, uint256 value); // Transfer 이벤트
    event Approval(address indexed owner, address indexed spender, uint256 value); // Approval 이벤트

    constructor (string memory _name, string memory _symbol, uint256 _totalSupply) {
        total = _totalSupply;
        name = _name;
        symbol = _symbol;
        decimals = 0; // 소수점 자리수 설정
        balances[msg.sender] = _totalSupply; // 발신자에게 총 발행량 할당
        emit Transfer(address(0x0), msg.sender, _totalSupply); // 초기 발행 이벤트 발생
    }

    function totalSupply() public view returns (uint256) {
        return total; // 총 발행량 반환
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner]; // 소유자의 잔액 반환
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender]; // 대리 인출 가능 토큰 수 반환
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value, "Insufficient balance"); // 잔액 확인
        balances[msg.sender] -= _value; // 발신자 잔액 차감
        balances[_to] += _value; // 수신자 잔액 증가
        emit Transfer(msg.sender, _to, _value); // Transfer 이벤트 발생
        return true; // 성공 반환
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value, "Insufficient balance"); // 잔액 확인
        require(allowed[_from][msg.sender] >= _value, "Allowance exceeded"); // 허용량 확인
        balances[_from] -= _value; // 발신자 잔액 차감
        balances[_to] += _value; // 수신자 잔액 증가
        allowed[_from][msg.sender] -= _value; // 허용량 차감
        emit Transfer(_from, _to, _value); // Transfer 이벤트 발생
        return true; // 성공 반환
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value; // 대리 인출자에게 허용량 설정
        emit Approval(msg.sender, _spender, _value); // Approval 이벤트 발생
        return true; // 성공 반환
    }
}