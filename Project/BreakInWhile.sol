//SPDX-License-Identifier:GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract BreakInWhile{
    function findNumber() public pure returns(uint){
        uint result;
        uint i=1;
        while (true){
            if(i==5){
                result=i;
                break;
            }
            ++i;
        }
        return result;
    }
}