contract Ex5_9{
    struct Human{
        string name;
        uint age;
    }

    Human[]public humanArray;
    mapping(address=>Human) public humanMapping;

    function addArray(string memory _name,uint _age) public{
        humanArray.push(Human(_name,_age));
    }
    function getArrayName(uint _index) public view returns(string memory){
        return humanArray[_index].name;
    }
    function getArrayAge(uint _index) public view returns(uint){
        return humanArray[_index].age;
    }
    function addMapping(address _key, string memory _name,uint _age) public {
        humanMapping[_key]=Human(_name,_age);
    }
    function getMappingName(address _key) public view returns(string memory){
        return humanMapping[_key].name;
    }
}