contract Ex5_7{

    string[] public fruitArray = ["apple","banana","coconut","durian","pear"];
    function linearSearch(string memory _word) public view returns(uint256,string memory){

        for(uint index=0;index<fruitArray.length;++index){
            if(keccak256(bytes(fruitArray[index]))==keccak256(bytes(_word))){
                return(index,fruitArray[index]);
            }
        }
        return (0,"Nothing");
    }
}