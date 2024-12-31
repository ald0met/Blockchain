// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract HotelRoom {
    enum Status { Vacant, Occupied }
    Status public currentStatus; // 방의 상태
    address payable public owner; // 소유자 주소

    // 이벤트 선언
    event RoomBooked(address indexed guest, uint amount);

    // 생성자
    constructor() {
        owner = payable(msg.sender); // 계약 배포자를 소유자로 설정
        currentStatus = Status.Vacant; // 초기 상태를 빈 방으로 설정
    }

    // modifier: 빈 방인지 확인
    modifier onlyWhileVacant() {
        require(currentStatus == Status.Vacant, "Room is not vacant");
        _;
    }

    // modifier: 일정 금액 이상인지 확인
    modifier costs(uint _amount) {
        require(msg.value >= _amount, "Not enough Ether sent");
        _;
    }

    // modifier: 소유자만 접근 가능
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // 예약 함수
    function book() public payable onlyWhileVacant costs(10 ether) {
        currentStatus = Status.Occupied; // 방 상태 변경
        owner.transfer(msg.value); // 소유자에게 예약금 송금
        emit RoomBooked(msg.sender, msg.value); // 이벤트 발생
    }

    // 빈 방으로 초기화하는 함수
    function reset() public onlyOwner {
        currentStatus = Status.Vacant; // 방 상태를 빈 방으로 변경
    }
}