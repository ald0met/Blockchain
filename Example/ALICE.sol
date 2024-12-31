contract ArtStudent{
    string public schoolName="The Solidity University";
    uint public schoolHours=5;
}
contract PartTimer{
    string public workPlace="A pizza shop";
    uint public workingHours=6;
}
contract Alice is ArtStudent,PartTimer{
    uint public totalHours=schoolHours+workingHours;
}