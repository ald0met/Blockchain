// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        uint vote;
    }

    struct Proposal {
        uint voteCount;
    }

    address chairperson; // 의장 주소
    mapping(address => Voter) public voters; //투표자 정보 매핑
    Proposal[] public proposals; // 제안 배열

    // modifier: 의장만 호출 가능
    modifier onlyChair() {
        require(msg.sender == chairperson, "Only chairperson can call this function.");
        _;
    }

    // modifier: 등록된 투표자만 호출 가능
    modifier validVoter() {
        require(voters[msg.sender].weight > 0, "You are not a registered voter.");
        _;
    }

    // 생성자: 제안 개수 초기화
    constructor(uint numProposals) {
        for(uint i=0;i<numProposals;i++){
            proposals.push(Proposal(0));
        }
    }

   
 // 투표자 등록 함수
    function register(address voter) public onlyChair {
        require(voter==chairperson, "Only chairperson can call this function.");
        
    if (voter == chairperson) {
        voters[voter].weight = 2; // 의장 가중치
    } else {
        voters[voter].weight = 1; // 기본 가중치
    }
}
    // 투표 함수
    function vote(uint proposal) public validVoter {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You have already voted.");
        require(proposal < proposals.length, "Invalid proposal.");

        sender.voted = true; // 투표 완료
        sender.vote = proposal; // 투표한 제안 저장
        proposals[proposal].voteCount += sender.weight; // 제안의 투표 수 업데이트
    }

    // 승자 확인 함수
    function reqWinner() public view returns (uint winningProposal) {
        uint winningVoteCount = 0;

        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal = i; // 승리한 제안의 인덱스
            }
        }
    }
}