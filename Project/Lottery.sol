// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager; // 관리자(배포자)
    address[] public players; // 게임 참여자
    enum State { Init, Betting, Finished } // 게임 상태
    State public currentState; // 현재 게임 상태

    event PlayerEntered(address player); // 참가자 정보
    event WinnerPicked(address winner, uint amount); // 우승자 정보와 금액

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    modifier onlyPlayer() {
        require(msg.sender != manager, "Manager cannot enter the lottery");
        _;
    }

    modifier inState(State state) {
        require(currentState == state, "Function not allowed in current state");
        _;
    }

    constructor() {
        manager = msg.sender; // 계약 배포자
        currentState = State.Init; // 초기 상태로 Betting 설정
    }

    function getPlayers() public view returns (address[] memory) {
        return players; // 참여자 목록 반환
    }

    function enter() public payable onlyPlayer inState(State.Betting) {
        require(msg.value == 1 ether, "You must send exactly 1 Ether");
        require(hasEntered(msg.sender)==false, "You have already entered the lottery");

        players.push(msg.sender); // 참여자 주소 추가
        emit PlayerEntered(msg.sender); // 이벤트 발생
    }

    function hasEntered(address player) private view returns (bool) {
        for (uint i = 0; i < players.length; i++) {
            if (players[i] == player) {
                return true; // 이미 참여한 경우(1회만 lottery를 구매할 수 있다고 가정)
            }
        }
        return false; // 참여하지 않은 경우
    }

    function pickWinner() public onlyManager inState(State.Finished) {
        require(players.length > 0, "No players in the lottery");

        uint index = uint(keccak256(abi.encodePacked(block.number, block.timestamp, players.length))) % players.length; // 무작위 인덱스 선택
        address winner = players[index]; // 당첨자 주소
        uint amount = address(this).balance; // 계약 잔액

        payable(winner).transfer(amount); // 당첨자에게 송금
        emit WinnerPicked(winner, amount); // 이벤트 발생

        players = new address[](0); // 참여자 배열 초기화
        currentState = State.Finished; // 상태 변경
    }

    function changeState() public onlyManager {
        if (currentState == State.Init) {
            currentState = State.Betting; // 상태를 Finished로 변경
        } 
        else if (currentState == State.Betting) {
            currentState = State.Finished; // 상태를 Betting으로 변경
        } 
        else if (currentState == State.Finished){
            currentState = State.Init; // 상태를 Init으로 변경
        }
    }
}