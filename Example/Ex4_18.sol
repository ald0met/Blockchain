contract Ex4_18{
    function myFun(string memory str)
        public
        pure 
        returns(
            uint,
            string memory,
            bytes memory
        )
    {
        uint num=99;
        bytes memory byt=hex"01";
        return(num,str,byt);
    }
}