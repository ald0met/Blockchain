//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ex4_4 {
    uint public age=10;
    uint public weight=30;
    function myFun() public pure returns(uint age, uint weight) {
        age=31;
        weight=60;
    }
}