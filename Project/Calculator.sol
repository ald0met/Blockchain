contract Calculator{

    function mul(uint _num1,uint _num2) public pure returns(uint){
        return _num1*_num2;
    }
    function mul(uint _num1,uint _num2,uint _num3) public pure returns(uint){
        return _num1*_num2*_num3;
    }
}

contract Ex6_1{

    Calculator internal calculator = new Calculator();
    function getNumbers() public view returns(uint,uint){
        return(calculator.mul(4,5),calculator.mul(4,5,6));
    }
}