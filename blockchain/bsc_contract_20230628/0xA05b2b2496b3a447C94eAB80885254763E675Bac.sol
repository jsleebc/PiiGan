{{
  "language": "Solidity",
  "sources": {
    "contracts/interfaces/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity 0.8.13;\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function transfer(address recipient, uint amount) external returns (bool);\r\n    function decimals() external view returns (uint8);\r\n    function symbol() external view returns (string memory);\r\n    function balanceOf(address) external view returns (uint);\r\n    function transferFrom(address sender, address recipient, uint amount) external returns (bool);\r\n    function allowance(address owner, address spender) external view returns (uint);\r\n    function approve(address spender, uint value) external returns (bool);\r\n\r\n    event Transfer(address indexed from, address indexed to, uint value);\r\n    event Approval(address indexed owner, address indexed spender, uint value);\r\n}\r\n"
    },
    "contracts/mocks/SEC.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.9;\r\n\r\n\r\nimport '../interfaces/IERC20.sol';\r\nimport './SecurityAndExchangeCommissionTreasury.sol';\r\n\r\n\r\ninterface IDEXFactory {\r\n    function createPair(address tokenA, address tokenB, bool stable) external returns (address pair);\r\n}\r\n\r\ninterface ITreasury {\r\n    function setWallets(address _donation_wallet_binance, address _donation_wallet_coinbase) external;\r\n    function distributeTax() external;\r\n}\r\n\r\ninterface IPair {\r\n    function fees() external returns(address);\r\n}\r\n\r\n\r\ninterface IRouter01 {\r\n\r\n    struct route {\r\n        address from;\r\n        address to;\r\n        bool stable;\r\n    }\r\n\r\n    function addLiquidity(address tokenA,address tokenB,bool stable,uint amountADesired,uint amountBDesired,uint amountAMin,uint amountBMin,address to,uint deadline) external returns (uint amountA, uint amountB, uint liquidity);\r\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        route[] calldata routes,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n    function factory() external view returns (address);\r\n}\r\n\r\n\r\ncontract SecurityAndExchangeCommission {\r\n\r\n    uint constant TAX = 4000;                       //  4%\r\n    uint constant PRECISION = 100000; \r\n    uint public taxToDistribute = 0;\r\n\r\n\r\n    address public donation_wallet_binance;\r\n    address public donation_wallet_coinbase;\r\n    address constant usdt = address(0x55d398326f99059fF775485246999027B3197955);\r\n    address public donation_wallet_setter = address(0xD6A5dDed2dfdfcCB3f7D66b0A68F3244F0c24b93);\r\n\r\n    address public pairContract;\r\n\r\n    string public constant name = \"SecurityAndExchangeCommission\";\r\n    string public constant symbol = \"SEC\";\r\n    uint8 public constant decimals = 18;\r\n    uint public totalSupply = 0;\r\n\r\n    mapping(address => uint) public balanceOf;\r\n    mapping(address => mapping(address => uint)) public allowance;\r\n    mapping(address => bool) public isBuying;\r\n\r\n    IRouter01 public router = IRouter01(address(0xd4ae6eCA985340Dd434D38F470aCCce4DC78D109));\r\n    address public factory = address(0xAFD89d21BdB66d00817d4153E055830B1c2B3970);\r\n    address public treasury;\r\n\r\n    \r\n    event Transfer(address indexed from, address indexed to, uint value);\r\n    event Approval(address indexed owner, address indexed spender, uint value);\r\n\r\n    constructor() {\r\n        balanceOf[donation_wallet_setter] = 69420 * 1e6 * 1e18;\r\n        totalSupply = 69420 * 1e6 * 1e18;\r\n        treasury = address(new SecurityAndExchangeCommissionTreasury());\r\n        ITreasury(treasury).setWallets(address(0), address(0));        \r\n    }\r\n\r\n\r\n    // create the pair\r\n    bool _pairCreated = false;\r\n    function createPair() external {\r\n        require(!_pairCreated);\r\n        pairContract = IDEXFactory(factory).createPair(address(this), usdt, false);\r\n        _pairCreated = true;\r\n        isBuying[pairContract] = true;\r\n    }\r\n\r\n\r\n    // Hey\r\n    function informationForSEC() public pure returns(string memory) {\r\n        return \"Elliptic Curves Matter\";\r\n    }\r\n\r\n    // Hey pt 2\r\n    function informationForSEC_2() public pure returns(string memory) {\r\n        return \"I BOUGHT $ALGO BECAUSE OF GARY: https://cointelegraph.com/news/video-of-sec-chair-praising-algorand-resurfaces-after-recently-deeming-it-a-security\";\r\n    }\r\n\r\n\r\n    // transfer an amount\r\n    function transfer(address _to, uint _value) external returns (bool) {\r\n        return _transfer(msg.sender, _to, _value);\r\n    }\r\n\r\n    // transfer an amount FROM someone\r\n    function transferFrom(address _from, address _to, uint _value) external returns (bool) {\r\n        uint allowed_from = allowance[_from][msg.sender];\r\n        if (allowed_from != type(uint).max) {\r\n            allowance[_from][msg.sender] -= _value;\r\n        }\r\n        return _transfer(_from, _to, _value);\r\n    }\r\n\r\n    // transfer internal. Apply tax and update balances\r\n    function _transfer(address from, address to, uint256 amount) internal returns(bool) {\r\n        require(from != address(0), \"ERC20: transfer from the zero address\");\r\n        require(to != address(0), \"ERC20: transfer to the zero address\");\r\n        uint256 fromBalance = balanceOf[from];\r\n        require(fromBalance >= amount, \"ERC20: transfer amount exceeds balance\");\r\n     \r\n        uint tax = 0;\r\n        if(msg.sender == donation_wallet_binance || msg.sender == donation_wallet_coinbase || msg.sender == IPair(pairContract).fees()) tax = 0;\r\n        else tax = amount * TAX / PRECISION;\r\n        \r\n        uint new_amount = amount - tax;\r\n        taxToDistribute += tax;\r\n        balanceOf[address(this)] = taxToDistribute;\r\n        \r\n        unchecked {\r\n            balanceOf[from] = fromBalance - amount;\r\n            balanceOf[to] += new_amount;\r\n        }\r\n\r\n        emit Transfer(from, to, amount);\r\n        return true;\r\n    \r\n    }\r\n\r\n    // approve spending for _spender\r\n    function approve(address _spender, uint _value) external returns (bool) {\r\n        allowance[msg.sender][_spender] = _value;\r\n        emit Approval(msg.sender, _spender, _value);\r\n        return true;\r\n    }\r\n\r\n    // set the donation wallets\r\n    function setWallets(address _donation_wallet_binance, address _donation_wallet_coinbase) public {\r\n        require(msg.sender == donation_wallet_setter, 'not allowed');\r\n        ITreasury(treasury).setWallets(_donation_wallet_binance, _donation_wallet_coinbase);\r\n        donation_wallet_binance = _donation_wallet_binance;\r\n        donation_wallet_coinbase = _donation_wallet_coinbase;\r\n    }\r\n\r\n    function setNewDonationWalletSetter(address new_setter) external {\r\n        require(msg.sender ==  donation_wallet_setter);\r\n        donation_wallet_setter = new_setter;\r\n    }\r\n\r\n    // distributeTax\r\n    function distributeTax() public {\r\n        if(donation_wallet_binance != address(0) && donation_wallet_coinbase != address(0)){\r\n            if(taxToDistribute > 0){\r\n                IRouter01.route[] memory _route = new IRouter01.route[](1);\r\n                _route[0].from = address(this);\r\n                _route[0].to = usdt;\r\n                _route[0].stable = false;\r\n                allowance[address(this)][address(router)] = taxToDistribute;\r\n                // just dump it\r\n                router.swapExactTokensForTokensSupportingFeeOnTransferTokens(taxToDistribute, 0, _route, treasury, block.timestamp + 20);\r\n                taxToDistribute = 0;   \r\n                balanceOf[address(this)] = taxToDistribute;\r\n                ITreasury(treasury).distributeTax();\r\n            }\r\n        }     \r\n\r\n    }\r\n\r\n\r\n}\r\n"
    },
    "contracts/mocks/SecurityAndExchangeCommissionTreasury.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.9;\r\n\r\n\r\nimport '../interfaces/IERC20.sol';\r\n\r\ncontract SecurityAndExchangeCommissionTreasury {\r\n\r\n\r\n    address public donation_wallet_binance;\r\n    address public donation_wallet_coinbase;\r\n    address constant usdt = address(0x55d398326f99059fF775485246999027B3197955);\r\n    address public owner;\r\n\r\n    constructor() {\r\n        owner = msg.sender;\r\n    }\r\n\r\n    function setWallets(address _donation_wallet_binance, address _donation_wallet_coinbase) external {\r\n        require(msg.sender == owner);\r\n        if(_donation_wallet_binance != address(0) && _donation_wallet_coinbase != address(0)){\r\n            donation_wallet_binance = _donation_wallet_binance;\r\n            donation_wallet_coinbase = _donation_wallet_coinbase;\r\n        }\r\n    }\r\n\r\n    function distributeTax() public {\r\n        if(donation_wallet_binance != address(0) && donation_wallet_coinbase != address(0)){\r\n            uint usdt_balance = IERC20(usdt).balanceOf(address(this));\r\n            IERC20(usdt).transfer(donation_wallet_binance, usdt_balance / 2);\r\n            IERC20(usdt).transfer(donation_wallet_coinbase, usdt_balance / 2);\r\n        }     \r\n    }\r\n\r\n\r\n}\r\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 200
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
    "libraries": {}
  }
}}