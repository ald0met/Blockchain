// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Khash {
    function hashMe(uint value, bytes32 password) 
        public pure returns (bytes32) {
            return keccak256(abi.encodePacked(value, password));
    }
} //해시 함수

contract BlindAuction {
    Khash public khashContract;

    struct Bid {
        bytes32 blindedBid;
        uint deposit;
    } //입찰 정보

    enum Phase {
        Init, Bidding, Reveal, Done
    } //경매 단계

    address payable public beneficiary;
    Phase public currentPhase = Phase.Init; //초기 단계 설정

    mapping(address => Bid) public bids; //입찰 정보
    mapping(address => uint) pendingReturns; // 돌려줄 금액

    address public highestBidder; //최고 입찰자
    uint public highestBid; //최고 입찰금
    uint public minimumBidIncrement = 10 ether; // 최소 입찰 증가 금액

    event AuctionEnded(address winner, uint highestBid);
    event BiddingStarted();
    event RevealStarted();
    event AuctionInit();
    event BidCancelled(address bidder, uint refundAmount);

    modifier onlyBeneficiary() {
        require(msg.sender == beneficiary, "Only beneficiary can call this");
        _;
    } //주최자 한정

    modifier inPhase(Phase _phase) {
        require(currentPhase == _phase, "Invalid phase");
        _;
    } //단계 한정

    constructor() {
        beneficiary = payable(msg.sender);
        khashContract = new Khash(); // Khash 인스턴스 생성
    } //주최자 정보, Khash 추가

    function advancePhase() public onlyBeneficiary() {
        if (currentPhase == Phase.Done) {
            revert("Auction already ended");
        }
        if (currentPhase == Phase.Init) {
            currentPhase = Phase.Bidding;
            emit BiddingStarted();
        } else if (currentPhase == Phase.Bidding) {
            currentPhase = Phase.Reveal;
            emit RevealStarted();
        } else if (currentPhase == Phase.Reveal) {
            currentPhase = Phase.Done;
            emit AuctionEnded(highestBidder, highestBid);
        }
    } //단계 전개 함수

    function bid(bytes32 _blindedBid) 
        public payable inPhase(Phase.Bidding) {
        
        bids[msg.sender] = Bid({
            blindedBid: _blindedBid,
            deposit: msg.value
        });
    } //예치금 함수 with 최소 입찰 증가금

    function cancelBid() public inPhase(Phase.Bidding) {
        Bid storage myBid = bids[msg.sender];
        require(myBid.deposit > 0, "No bid to cancel");

        uint refundAmount = myBid.deposit;
        myBid.deposit = 0;
        myBid.blindedBid = bytes32(0);

        pendingReturns[msg.sender] = refundAmount;

        emit BidCancelled(msg.sender, refundAmount);
    } //반환금 지정

    function reveal(uint _value, bytes32 _password) public payable inPhase(Phase.Reveal) {
        Bid storage bidToCheck = bids[msg.sender];
        bytes32 hashedBid = khashContract.hashMe(_value, _password);
        require(_value >= highestBid + minimumBidIncrement, "Bid must be higher than the current highest bid plus minimum increment");

        if (bidToCheck.blindedBid == hashedBid) {
            uint refund = bidToCheck.deposit;
            if (_value * 1 ether > highestBid) {
                if (highestBidder != address(0)) {
                    pendingReturns[highestBidder] += highestBid;
                }
                highestBidder = msg.sender;
                highestBid = _value * 1 ether;
                refund -= _value * 1 ether;
            }
            if (refund > 0) {
                pendingReturns[msg.sender] = refund;
            }
        } else {
            pendingReturns[msg.sender] = bidToCheck.deposit;
        }
        bidToCheck.blindedBid = bytes32(0);
    } //입찰금 지정
    
    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
        }
    } //인출 함수

    function checkRefund() public view returns(uint) {
        return pendingReturns[msg.sender];
    } //반환금 확인

    function auctionEnd() public onlyBeneficiary() inPhase(Phase.Done) {
        if (highestBidder != address(0)) {
            beneficiary.transfer(highestBid);
        }
        emit AuctionEnded(highestBidder, highestBid);
    } //경매 종료
}