contract Ex6_7{

    modifier numMoreThan1(uint _num){
        require(_num>1,"_num must be more than 1");
        _;
    }
    function getValue1(uint _num) public pure numMoreThan1(_num)returns(uint){
        return _num;
    }
    function getValue2(uint _num) public pure numMoreThan1(_num)returns(uint){
        return _num*2;
    }
}