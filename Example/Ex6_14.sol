contract Ex6_14 {

    function getBalance(address _address) public view returns(uint){
        return _address.balance;
    }
    function etherUnits() public pure returns(uint,uint,uint){
        return(1 ether,1 gwei, 1 wei);
    }
    function ethDelivery1(address payable _address) public payable{
        bool result=_address.send(10 ether);
        require(result, "Failed");
    }
    function ethDelivery2(address _address) public payable{
        payable(_address).transfer(msg.value);
    }
}