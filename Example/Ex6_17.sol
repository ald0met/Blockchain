contract Ex6_17{

    constructor() payable{

    }
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}