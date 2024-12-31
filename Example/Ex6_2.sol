contract Ex6_2{
    
    function runAssert(bool _bool) public pure returns(bool){
        assert(_bool);
        return _bool;
    }
    function divisionByzero(uint _num1,uint _num2) public pure returns(uint){
        return _num1/_num2;
    }
}