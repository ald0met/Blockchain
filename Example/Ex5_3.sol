contract Ex5_3{

    uint[] public array1;
    string[5] public array2 = ["apple","banana","Coconut"];

    function getLength1() public view returns(uint){
        return array1.length;
    }
    function getLength2() public view returns(uint){
        return array2.length;
    }
    function getArray1(uint _index) public view returns(uint){
        if(_index>= array1.length){
            return 0;
    }else{
        return array1[_index];
    }
}
    function getArray2(uint _index) public view returns(string memory){
        if(_index>=array2.length){
            return "Out of bound";
    }else{
        return array2[_index];
    }
}
}