// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FeedbackToken {
    string public name = "FeedbackToken";
    string public symbol = "FBT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply * (10 ** uint256(decimals));
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function mint(address _to, uint256 _amount) public onlyOwner returns (bool success) {
        uint256 amount = _amount * (10 ** uint256(decimals));
        totalSupply += amount;
        balanceOf[_to] += amount;
        emit Transfer(address(0), _to, amount);
        return true;
    }

    function burn(uint256 _amount) public onlyOwner returns (bool success) {
        uint256 amount = _amount * (10 ** uint256(decimals));
        require(balanceOf[owner] >= amount, "Insufficient balance to burn");
        totalSupply -= amount;
        balanceOf[owner] -= amount;
        emit Transfer(owner, address(0), amount);
        return true;
    }
}
