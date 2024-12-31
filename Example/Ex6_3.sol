contract Ex6_3{
    function runRevert(uint _num) public pure returns(uint){
        if(_num<=3){
            revert("Revert error : input must be greater than 3");
        }
        return _num;
    }
    function runRequire(uint _num) public pure returns(uint){
        require(_num>3,"Require error : input must be greater than 3");
        return _num;
    }
}