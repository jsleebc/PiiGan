// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.8.2 <0.9.0;

// website: https://farmgrid.org

contract Owned {
  
    address payable owner;
    
    uint public adminCount = 0; // Admin struct is used to store array of public address of
                               // other admins such that they can perform some actions like withdraw wrongly sent tokens
    address payable newOwner;  // When contract creator wish to make another address the creator(handover)
                             // its stored here for the new guy to accept to become creator
   
    event Received(address, uint); // this contract can/has receive ETH

    event OwnerSet(address indexed oldOwner, address indexed newOwner); // contract owner can be changed by the owner

    event AdminAdded(uint id, string _id, string name, address admin, address father, bool isActive);

    event AdminRevoked(uint id, string _id, string name, address admin, address father, bool isActive);
    
    event TokenTransfer(
        address contractAddress,
        address indexed recipient,
        uint amount,
        uint indexed adminId,
        uint indexed date
    );

    mapping (uint => Admin) public admins;

    struct Admin {      // to store admins details
        uint id;        // created id on blockchain
        string _id;     // local admin id, mongodb
        string name;
        address admin;
        address father;
        bool isActive;
    }
       
    modifier restricted() {
        require(msg.sender==owner);
        _;
    }
    
    modifier onlyAdmins(uint _id) {

        Admin memory _admin = admins[_id];

        if(msg.sender != owner){ // if  its the contract owner we allow instantly else, validate admin

                require(
                msg.sender == _admin.admin,
                "This action can only be performed by an admin"
                );

                require(
                _admin.isActive,
                "This action can only be performed by active admin"
                );
            }
         _; // proceed to the function where we called it...

    }
     
    function getBalance() public view returns (uint) { // return the ETH balance of the contract
        return address(this).balance;
        }
        
        function withdrawEther(address payable recipient, uint amount) external restricted returns (bool) {
        // transfer Ether to the recipient address

        // make sure we have the balance

        //---

        recipient.transfer(amount);

        return true;

    }
    
    function createAdmin(string memory _id, string memory _name, address payable _admin_address) restricted public {
        // admins can approve fund withdrawals
        require (bytes(_name).length > 0, 'Name should be surname and required');
        //require (_admin_address != ' ', 'Admin public key is required');
        adminCount++;

        // create the admin
        admins[adminCount] = Admin(adminCount, _id, _name, _admin_address, msg.sender, true);
        // Admin[adminCount] = Admin(adminCount, _name, _admin_address, msg.sender, msg.sender, true);

        // fire event
        emit AdminAdded(adminCount, _id, _name, _admin_address, msg.sender, true);
    }
    
    function revokeAdmin(uint _id, bool _status) restricted public {
        // change admin status to active or not active

        Admin memory _admin = admins[_id]; // instance of admin from Admins storage: _id = serial id on blockchain

        require (_admin.id > 0 && _admin.id <= adminCount, "Provide valid admin ID");

        _admin.isActive = _status;

        // update the admin in array
        admins[_id] = _admin;

        // admin revoked event
        emit AdminRevoked(_admin.id, _admin._id, _admin.name, _admin.admin, _admin.father, _status);

    }
    
      function transferToken(
        address payable contract_address,
        address payable recipient,
        uint amount,
        uint _admin_id
        ) external onlyAdmins(_admin_id) returns (bool) {
        // Transfers any ERC20 token found in this contract given the token contract address:
        //only owner/admins can perform this action

        // check if contract_address is actually a contract
        /*   uint256 tokenCode;
           assembly { tokenCode := extcodesize(contract_address) } // contract code size
           require(tokenCode > 0 && contract_address.call(bytes4(0x70a08231), recipient),
            "transfer Token fails: pass token contract address only");
        */

        Token token = Token(contract_address); // ERC20 token contract
        require(token.transfer(recipient, amount), "transfer Token fails");
        emit TokenTransfer(contract_address, recipient, amount,_admin_id, block.timestamp);
        return true;
    
    }


    function changeOwner(address payable _newOwner) public restricted {
        require(_newOwner!=address(0));
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        if (msg.sender==newOwner) {
            owner = payable(newOwner);
        }
    }
}

abstract contract ERC20 {
    uint256 public totalSupply;
    function balanceOf(address _owner) view public virtual returns (uint256 balance);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Token is Owned,  ERC20 {
    string public symbol;
    string public name;
    uint8 public decimals;
    mapping (address=>uint256) balances;
    mapping (address=>mapping (address=>uint256)) allowed;

    function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}

    function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {
        require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
        balances[msg.sender]-=_amount;
        balances[_to]+=_amount;
        emit Transfer(msg.sender,_to,_amount);
        return true;
    }

    function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {
        require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
        balances[_from]-=_amount;
        allowed[_from][msg.sender]-=_amount;
        balances[_to]+=_amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {
        allowed[msg.sender][_spender]=_amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
      function burn(address from, uint256 amount) external restricted returns (bool) {
        require(from != address(0), " not address(0x0)");
        _burn(from, amount);
        return true;
    }
    
      function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        balances[account] -= amount;
        totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }
    
    
}

contract FarmGrid is Token{

    constructor() {  
        symbol = "GRID"; 
        name = "FarmGrid";
        decimals = 18;
        totalSupply = 100000000000000000000000000000000000;
        owner = payable(msg.sender);
        balances[owner] = totalSupply;
    }

receive () payable external {
require(msg.value>0);
owner.transfer(msg.value);
}
}