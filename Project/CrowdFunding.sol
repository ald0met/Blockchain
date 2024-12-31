// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdFunding {
    // Info 구조체
    struct Investor {
        address addr;   
        uint amount;   
    }
    
    mapping (uint => Investor) public investors; 
    address public owner;                        
    uint public numInvestors;                    
    uint public deadline;                        
    string public status;                         
    bool public ended;                        
    uint public goalAmount;                     
    uint public totalAmount;                 

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    //초기값 설정
    constructor(uint _duration, uint _goalAmount) {
        owner = msg.sender;
        deadline = block.timestamp + _duration;
        goalAmount = _goalAmount * 1 ether;
        status = "Funding";
        ended = false;
        numInvestors = 0;
        totalAmount = 0;
    }

    //펀딩 기록 및 펀딩 계좌 잔액 수정
    function fund() public payable {
        require(ended==false, "Crowdfunding has ended");
        require(block.timestamp < deadline, "Deadline has passed");
        
        investors[numInvestors] = Investor(
            msg.sender, msg.value
        );
        
        numInvestors++;
        totalAmount += msg.value;
    }

    //펀딩 종료 및 결과 확인
    function checkGoalReached() public onlyOwner {
        require(ended==false, "Crowdfunding has already ended");
        require(block.timestamp >= deadline, "Deadline has not passed yet");

        if (totalAmount >= goalAmount) {
            payable(owner).transfer(address(this).balance);
            status = "Campaign Succeeded";
        } else {
            for(uint i = 0; i < numInvestors; i++) {
                payable(investors[i].addr).transfer(investors[i].amount);
            }
            status = "Campaign Failed";
        }
        
        ended = true;
    }
}