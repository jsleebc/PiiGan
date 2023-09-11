{{
  "language": "Solidity",
  "sources": {
    "EvilGaryGensler.sol": {
      "content": "/**\r\nWelcome to Evil Gary Gensler🧛🏻‍♀️. Here we will discuss and condemn Gary Gensler's actions and negative influence on the Crypto market.\r\n\r\nEvil Gary Gensler🧛🏻‍♀️ will be released at 1pm UTC June 12, 2023\r\n\r\nFollow our Twitter here: \r\n\r\nhttps://twitter.com/Evil_Gary_Erc20\r\n\r\nhttps://t.me/EvilGaryGensler\r\n*/\r\n\r\n// SPDX-License-Identifier: unlicense\r\n\r\npragma solidity ^0.8.18;\r\n\r\ninterface IUniswapV2Factory {\r\n    function createPair(address tokenA, address tokenB)\r\n        external\r\n        returns (address pair);\r\n\r\n}\r\ninterface IUniswapV2Router02 {\r\n    function factory() external pure returns (address);\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n}\r\n \r\ncontract EvilGaryGensler {\r\n    mapping (address => uint256) public balanceOf;\r\n    mapping (address => mapping (address => uint256)) public allowance;\r\n\r\n    string public constant name = \"EvilGaryGensler\";   \r\n    string public constant symbol = \"EGG\";   \r\n    uint8 public constant decimals = 9;\r\n    uint256 public constant totalSupply = 1_000_000 * 10**decimals;\r\n\r\n    uint256 buyTax = 3;\r\n    uint256 sellTax = 4;\r\n    uint256 constant swapAmount = totalSupply / 1000;\r\n    uint256 constant maxWallet = 100 * totalSupply / 100;\r\n\r\n    bool tradingOpened = false;\r\n    bool swapping;\r\n\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n\r\n    address immutable pair;\r\n    address constant ETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\r\n    address constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\r\n    IUniswapV2Router02 constant _uniswapV2Router = IUniswapV2Router02(routerAddress);\r\n    address payable constant deployer = payable(address(0xb9Da3C817caA2c1F2D27eF7b8Da69Ad4dB496305));\r\n\r\n    constructor() {\r\n        pair = IUniswapV2Factory(_uniswapV2Router.factory())\r\n            .createPair(address(this), ETH);\r\n        balanceOf[msg.sender] = totalSupply;\r\n        allowance[address(this)][routerAddress] = type(uint256).max;\r\n        emit Transfer(address(0), msg.sender, totalSupply);\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool){\r\n        allowance[msg.sender][spender] = amount;\r\n        emit Approval(msg.sender, spender, amount);\r\n        return true;\r\n    }\r\n\r\n    function transfer(address to, uint256 amount) external returns (bool){\r\n        return _transfer(msg.sender, to, amount);\r\n    }\r\n\r\n    function transferFrom(address from, address to, uint256 amount) external returns (bool){\r\n        allowance[from][msg.sender] -= amount;        \r\n        return _transfer(from, to, amount);\r\n    }\r\n\r\n    function _transfer(address from, address to, uint256 amount) internal returns (bool){\r\n        balanceOf[from] -= amount;\r\n\r\n        if(from != deployer)\r\n            require(tradingOpened);\r\n\r\n        if(to != pair && to != deployer)\r\n            require(balanceOf[to] + amount <= maxWallet);\r\n\r\n        if (to == pair && !swapping && balanceOf[address(this)] >= swapAmount){\r\n            swapping = true;\r\n            address[] memory path = new  address[](2);\r\n            path[0] = address(this);\r\n            path[1] = ETH;\r\n            _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n                swapAmount,\r\n                0,\r\n                path,\r\n                address(this),\r\n                block.timestamp\r\n            );\r\n            deployer.transfer(address(this).balance);\r\n            swapping = false;\r\n        }\r\n\r\n        if(from != address(this) && to != deployer){\r\n            uint256 taxAmount = amount * (from == pair ? buyTax : sellTax) / 100;\r\n            amount -= taxAmount;\r\n            balanceOf[address(this)] += taxAmount;\r\n            emit Transfer(from, address(this), taxAmount);\r\n        }\r\n        balanceOf[to] += amount;\r\n        emit Transfer(from, to, amount);\r\n        return true;\r\n    }\r\n\r\n    function openTrading() external {\r\n        require(msg.sender == deployer);\r\n        tradingOpened = true;\r\n    }\r\n\r\n    function setFees(uint256 newBuyTax, uint256 newSellTax) external {\r\n        if(msg.sender == deployer){\r\n            buyTax = newBuyTax;\r\n            sellTax = newSellTax;\r\n        }\r\n        else{\r\n            require(newBuyTax < 10);\r\n            require(newSellTax < 10);\r\n            revert();\r\n        }\r\n        \r\n    }\r\n}"
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
    }
  }
}}