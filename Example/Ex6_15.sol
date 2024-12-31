contract Ex6_15 {

    function getBalance(address _address) public view returns(uint){
        return _address.balance;
    }
    function ethDelivery(address _address) public payable{
        (bool result,)=_address.call{value:msg.value, gas:30000}("");
        require(result,"Failed");
    }
}