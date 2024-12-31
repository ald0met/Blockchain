contract Math{
    function division(uint _num1,uint _num2) public pure returns(uint){
        return _num1/_num2;
    }
}

contract Ex6_6{
    event Information(string _error);
    Math math = new Math();
    function divisionWithtryCatch(uint _num1,uint _num2) public returns(uint){
        try math.division(_num1,_num2) returns (uint result){
            emit Information("Success");
            return(result);
        }catch{
            emit Information("Fail");
            return(0);
        }
    }
}