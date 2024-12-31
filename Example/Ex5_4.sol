contract Ex5_4{
    uint[] public array1 =[97,98];
    string[5] public array2 = ["apple","banana","Coconut"];

    function addArray1(uint _value) public{
        array1.push(_value);
    }
    function changeArray1(uint _index,uint _value) public {
        array1[_index]=_value;
    }
    function changeArray2(uint _index,string memory _value) public {
        array2[_index]=_value;
    }
    function getLength() public view returns(uint){
        return array1.length;
    }
    function popArray() public{
        array1.pop();
    }
    function deleteArray(uint _index) public{
        delete array1[_index];
    }
}