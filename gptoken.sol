// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed burner, uint256 value);
}


contract MyERC20 is IERC20 {

    string public constant name = "Gaurav";
    string public constant symbol = "GP";
    uint8 public constant decimals = 0;
    address public owner1;
    uint256 private totalSupply_ ;


    mapping(address => uint256) balances;
    
    mapping(address => bool) private minters;

    mapping(address => mapping (address => uint256)) allowed;

    


   constructor() {
    balances[msg.sender] = totalSupply_;
    owner1=msg.sender;
    minters[msg.sender] = true;
    }

    modifier onlyOwner(){
        require(msg.sender == owner1);
        _;
    }
    
    modifier onlyMinters(){
        require(minters[msg.sender]);
        _;
    }

    function totalSupply() public override view returns (uint256) {
    return totalSupply_;
    
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }


    function burn(uint256 _value) public {
        burnfrom(msg.sender, _value);
        }

   
    function mint(address account, uint256 amount) public onlyMinters returns (bool) {
        
        require(account != address(0), "ERC20: mint to the zero address");
        totalSupply_ = totalSupply_ + amount;
        balances[account] = balances[account] + amount;
        emit Transfer(account , address(0), amount);

        return true;
    }


    function burnfrom(address _who, uint256 _value) public
    {
        require(_who != address(0), "ERC20: burn to the zero address");
        require(_value <= balances[_who]);
        balances[_who] = balances[_who] - _value;
        totalSupply_ = totalSupply_ - _value;
        emit Burn(_who, _value);
        emit Transfer(_who, address(0), _value);
    }

    
}
