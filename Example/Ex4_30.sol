contract Ex4_30{

    function fun1() public pure returns(uint){
        uint result =0;
        uint a=0;
        do{
            result=result+a;
            ++a;
        }while(a<3);

        return result;
    }
}