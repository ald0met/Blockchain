//SPDX-License-Identifier:GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ex4_32{
    function fun1() public pure returns(uint){
        uint result=0;
        for(uint a=0;a<10;++a){
            result=result+a;
        }
        return result;
    }
}