contract Khash{
    bytes32 public hashedValue;

    function hashMe(uint value,bytes32 password)public{
        hashedValue=keccak256(abi.encodePacked(value,password));
    }
}