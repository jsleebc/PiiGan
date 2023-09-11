{"EIP20.sol":{"content":"/*\r\nImplements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\r\n.*/\r\n\r\n\r\npragma solidity ^0.4.21;\r\n\r\nimport \"./EIP20Interface.sol\";\r\n\r\n\r\ncontract EIP20 is EIP20Interface {\r\n\r\n    uint256 constant private MAX_UINT256 = 2**256 - 1;\r\n    mapping (address =\u003e uint256) public balances;\r\n    mapping (address =\u003e mapping (address =\u003e uint256)) public allowed;\r\n    /*\r\n    NOTE:\r\n    The following variables are OPTIONAL vanities. One does not have to include them.\r\n    They allow one to customise the token contract \u0026 in no way influences the core functionality.\r\n    Some wallets/interfaces might not even bother to look at this information.\r\n    */\r\n    string public name;                   //fancy name: eg Simon Bucks\r\n    uint8 public decimals;                //How many decimals to show.\r\n    string public symbol;                 //An identifier: eg SBX\r\n\r\n    function EIP20(\r\n        uint256 _initialAmount,\r\n        string _tokenName,\r\n        uint8 _decimalUnits,\r\n        string _tokenSymbol\r\n    ) public {\r\n        balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens\r\n        totalSupply = _initialAmount;                        // Update total supply\r\n        name = _tokenName;                                   // Set the name for display purposes\r\n        decimals = _decimalUnits;                            // Amount of decimals for display purposes\r\n        symbol = _tokenSymbol;                               // Set the symbol for display purposes\r\n    }\r\n\r\n    function transfer(address _to, uint256 _value) public returns (bool success) {\r\n        require(balances[msg.sender] \u003e= _value);\r\n        balances[msg.sender] -= _value;\r\n        balances[_to] += _value;\r\n        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\r\n        uint256 allowance = allowed[_from][msg.sender];\r\n        require(balances[_from] \u003e= _value \u0026\u0026 allowance \u003e= _value);\r\n        balances[_to] += _value;\r\n        balances[_from] -= _value;\r\n        if (allowance \u003c MAX_UINT256) {\r\n            allowed[_from][msg.sender] -= _value;\r\n        }\r\n        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars\r\n        return true;\r\n    }\r\n\r\n    function balanceOf(address _owner) public view returns (uint256 balance) {\r\n        return balances[_owner];\r\n    }\r\n\r\n    function approve(address _spender, uint256 _value) public returns (bool success) {\r\n        allowed[msg.sender][_spender] = _value;\r\n        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars\r\n        return true;\r\n    }\r\n\r\n    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\r\n        return allowed[_owner][_spender];\r\n    }\r\n}\r\n"},"EIP20Interface.sol":{"content":"// Abstract contract for the full ERC 20 Token standard\r\n// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\r\npragma solidity ^0.4.21;\r\n\r\n\r\ncontract EIP20Interface {\r\n    /* This is a slight change to the ERC20 base standard.\r\n    function totalSupply() constant returns (uint256 supply);\r\n    is replaced with:\r\n    uint256 public totalSupply;\r\n    This automatically creates a getter function for the totalSupply.\r\n    This is moved to the base contract since public getter functions are not\r\n    currently recognised as an implementation of the matching abstract\r\n    function by the compiler.\r\n    */\r\n    /// total amount of tokens\r\n    uint256 public totalSupply;\r\n\r\n    /// @param _owner The address from which the balance will be retrieved\r\n    /// @return The balance\r\n    function balanceOf(address _owner) public view returns (uint256 balance);\r\n\r\n    /// @notice send `_value` token to `_to` from `msg.sender`\r\n    /// @param _to The address of the recipient\r\n    /// @param _value The amount of token to be transferred\r\n    /// @return Whether the transfer was successful or not\r\n    function transfer(address _to, uint256 _value) public returns (bool success);\r\n\r\n    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\r\n    /// @param _from The address of the sender\r\n    /// @param _to The address of the recipient\r\n    /// @param _value The amount of token to be transferred\r\n    /// @return Whether the transfer was successful or not\r\n    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\r\n\r\n    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\r\n    /// @param _spender The address of the account able to transfer the tokens\r\n    /// @param _value The amount of tokens to be approved for transfer\r\n    /// @return Whether the approval was successful or not\r\n    function approve(address _spender, uint256 _value) public returns (bool success);\r\n\r\n    /// @param _owner The address of the account owning tokens\r\n    /// @param _spender The address of the account able to transfer the tokens\r\n    /// @return Amount of remaining tokens allowed to spent\r\n    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\r\n\r\n    // solhint-disable-next-line no-simple-event-func-name\r\n    event Transfer(address indexed _from, address indexed _to, uint256 _value);\r\n    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\r\n}\r\n"}}