contract Ex4_26_1{

    function func1(uint a)public pure returns(uint){
        if(a>=1){
            a=1;
        }if(a>=2){
            a=2;
        }if(a>=3){
            a=3;
        }else{
            a=4;
        }
        return a;
    }
}