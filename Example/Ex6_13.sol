contract Ex6_13{

    address public owner;
    modifier onlyOwner(){
        require(owner==msg.sender,"Error:caller is not the owner");
        _;
    }
    constructor(){
        owner=msg.sender;
    }
    function getBalance(address _address) public view onlyOwner() returns(uint){
        return _address.balance;
    }
    function getMsgValue() public payable onlyOwner returns(uint){
        return msg.value;
    }
}