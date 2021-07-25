pragma solidity ^0.4.24;

import './interfaces/erc-20.sol';
import './lib/safemath.sol';
import './callback/callback.sol';

contract DREAMToken is ERC20Interface, SafeMath {
    string public symbol; //state varibles store in the blockchain
    string public  name;   // name of Token
    uint8 public decimals; // number of decimal points to represent token value
    uint public _totalSupply; // total number of tokens

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public {
        symbol = "DRMTKN";          //enter your token symbol here
        name = "Dream Token";       // give a name to your token
        decimals = 2;               //setting a decimal points
        _totalSupply = 1000000;     //creating 1 million token
        balances[0x87159283507aBE8543a943d74447247e1d8396a0] = _totalSupply; //setting total supply balances to 
        emit Transfer(address(0), 0x87159283507aBE8543a943d74447247e1d8396a0, _totalSupply);  
    }

    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    function () public payable {}
}