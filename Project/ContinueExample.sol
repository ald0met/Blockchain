//SPDX-License-Identifier:GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ContinueExample {

    function sumOnlyEvenNumbers() public pure returns(uint){
        uint sumEven=0;

        for(uint i=1;i<=10;i++){
            if(i%2!=0){
                continue;
            }
            sumEven+=i;
        }
        return sumEven;
    }
}