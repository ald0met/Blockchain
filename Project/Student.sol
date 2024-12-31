contract Student{
    string public schoolName="The University of Solidity";
    string public major;
    constructor(string memory _major){
        major=_major;
    }
}

contract ArtStudent is Student("Art"){
}

contract MusicStudent is Student{
    constructor() Student("Music"){
    }
}

contract MathStudent is Student{
    constructor(string memory _major) Student(_major){

    }
}