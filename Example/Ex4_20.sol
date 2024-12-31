contract Ex4_20 {

    uint public a=3;

    function myFun1() external view returns(uint,uint){
        uint b=4;
        return (a,b);
    }

    /*
    function myFun2() external pure returns(uint) {
        return b;
    }
    */
}