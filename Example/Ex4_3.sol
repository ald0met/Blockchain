//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ex4_3 {

    uint public a=3;
    uint public b=5;
    function myFun() public returns(uint, uint){
        a=10;
        b=0;
        return(a,b);
    }
}