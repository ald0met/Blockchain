contract Ex6_8{

    uint public a;
    uint public b;

    modifier plusA(){
        a=a+1;
        _;
    }
    modifier plusB(){
        _;
        b=b+1;
    }
    function mulA() public plusA(){
        a=a*2;
    }
    function mulB() public plusB(){
        b=b*2;
    }
}