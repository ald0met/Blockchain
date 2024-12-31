// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract Ex4_7{

    uint a=5+2;
    uint b=5-2;
    uint c=5*2;
    uint d=5/5;  //나눗셈
    uint e=5%2;  //나머지
    uint f=5**2;

    function arithmetic() public view returns(uint,uint,uint,uint,uint,uint){
        return(a,b,c,d,e,f);
    }
}