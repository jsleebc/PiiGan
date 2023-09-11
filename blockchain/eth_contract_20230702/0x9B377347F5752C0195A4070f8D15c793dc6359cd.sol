{{
  "language": "Solidity",
  "sources": {
    "contracts/BigMac.sol": {
      "content": "//         ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n//         ⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣶⣿⣿⣿⣿⣿⣿⠿⠷⣶⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀\n//         ⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣯⣀⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀\n//         ⠀⠀⠀⢠⣿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣁⣈⣽⣿⣷⡀⠀⠀⠀\n//         ⠀⠀⠀⣿⣿⣶⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⣧⠀⠀⠀\n//         ⠀⠀⠀⠛⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠧⠤⠾⠿⠿⠿⠿⠿⠷⠶⠾⠟⠀⠀⠀\n//         ⠀⠀⠀⢶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⠶⠶⠀⠀⠀\n//         ⠀⠀⣠⣤⣤⣤⣤⣤⣤⣄⣀⣀⣈⣉⣉⣉⣀⣀⣀⣀⣀⣠⣤⣤⣤⣤⣤⣄⠀⠀\n//         ⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀\n//         ⠀⠀⢀⣤⣭⠉⠉⠉⢉⣉⡉⠉⠉⠉⣉⣉⠉⠉⠉⢉⣉⠉⠉⠉⢉⣭⣄⠀⠀⠀\n//         ⠀⠰⡟⠁⠈⢷⣤⣴⠟⠉⠻⣄⣠⡾⠋⠙⠳⣤⣴⠟⠉⠳⣦⣠⡾⠃⠙⢷⡄⠀\n//         ⠀⠀⠀⢀⣀⣀⣉⡀⠀⠀⠀⠈⠉⠀⠀⠀⣀⣈⣁⣀⣀⣀⣀⣉⣀⣀⠀⠀⠀⠀\n//         ⠀⠀⠀⠛⠛⠛⠛⠛⠛⠻⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠛⠛⠛⠛⠛⠛⠛⠃⠀⠀\n//         ⠀⠀⠀⢸⣿⣿⣿⣿⣷⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀\n//         ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n//\n//     BIG MAC PROTOCOL\n//\n//  OUR SOCIALS\n//    Telegram: https://t.me/bigmacprotocol\n//    Website: https://bigmac.kitchen\n//    Twitter: https://twitter.com/bigmacprotocol\n//\n//  A MESSAGE FROM THE DEVELOPERS\n//    Now, you can dip into liquidity pools with your $BIGMAC Tokens, \n//    earning mouth-watering rewards faster than you can say \"I'm lovin' it.\" ❤️\n//\n// SPDX-License-Identifier: MIT\npragma solidity ^0.8.7;\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address account) external view returns (uint256);\n\n    function transfer(\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    function allowance(\n        address owner,\n        address spender\n    ) external view returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n}\n\ninterface IDEXRouter {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint256 amountIn,\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external;\n}\n\ninterface IDEXFactory {\n    function createPair(\n        address tokenA,\n        address tokenB\n    ) external returns (address pair);\n}\n\nabstract contract Context {\n    function _msgSender() internal view returns (address payable) {\n        return payable(msg.sender);\n    }\n\n    function _msgData() internal view returns (bytes memory) {\n        this;\n        return msg.data;\n    }\n}\n\ncontract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(\n        address indexed previousOwner,\n        address indexed newOwner\n    );\n\n    constructor() {\n        address msgSender = _msgSender();\n        _owner = msgSender;\n        emit OwnershipTransferred(address(0), msgSender);\n    }\n\n    function owner() public view returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        emit OwnershipTransferred(_owner, address(0));\n        _owner = address(0);\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(\n            newOwner != address(0),\n            \"Ownable: new owner is the zero address\"\n        );\n        emit OwnershipTransferred(_owner, newOwner);\n        _owner = newOwner;\n    }\n}\n\ncontract BigMacToken is IERC20, Ownable {\n    mapping(address => uint256) _bellySizes;\n    mapping(address => mapping(address => uint256)) _lunchMoneyAllowed;\n\n    IDEXRouter public cashRegister;\n    address constant cashRegisterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n\n    string constant _burgerName = \"Big Mac\";\n    string constant _burgerCode = \"BIGMAC\";\n    uint8 constant _sesameSeeds = 18;\n    uint256 constant _howManyBurgers = 1_968_000_000 * (10 ** _sesameSeeds);\n\n    uint256 constant cookingFee = 300;\n    uint256 constant cookingFeeBottomBun = 10000;\n\n    uint256 public cookedAt;\n    bool orderingAllowed = false;\n\n    mapping(address => bool) _oilProof;\n    mapping(address => bool) _veggieSuppliers;\n    mapping(address => bool) _veggieStorage;\n    address public driveThrough;\n\n    address cookWallet;\n    modifier onlyCook() {\n        require(\n            _msgSender() == cookWallet,\n            \"BigMac: Caller is not a cook\"\n        );\n        _;\n    }\n\n    bool inSwap;\n    modifier swapping() {\n        inSwap = true;\n        _;\n        inSwap = false;\n    }\n\n    event DistributedFee(uint256 fee);\n\n    constructor() {\n        cashRegister = IDEXRouter(cashRegisterAddress);\n        driveThrough = IDEXFactory(cashRegister.factory()).createPair(\n            cashRegister.WETH(),\n            address(this)\n        );\n        _veggieStorage[driveThrough] = true;\n        _lunchMoneyAllowed[owner()][cashRegisterAddress] = type(uint256).max;\n        _lunchMoneyAllowed[address(this)][cashRegisterAddress] = type(uint256).max;\n\n        _oilProof[owner()] = true;\n        _oilProof[address(this)] = true;\n        _veggieSuppliers[owner()] = true;\n\n        _bellySizes[owner()] = _howManyBurgers;\n\n        emit Transfer(address(0), owner(), _howManyBurgers);\n    }\n\n    receive() external payable {}\n\n    function totalSupply() external pure override returns (uint256) {\n        return _howManyBurgers;\n    }\n\n    function decimals() external pure returns (uint8) {\n        return _sesameSeeds;\n    }\n\n    function symbol() external pure returns (string memory) {\n        return _burgerCode;\n    }\n\n    function name() external pure returns (string memory) {\n        return _burgerName;\n    }\n\n    function balanceOf(address account) public view override returns (uint256) {\n        return _bellySizes[account];\n    }\n\n    function allowance(\n        address holder,\n        address spender\n    ) external view override returns (uint256) {\n        return _lunchMoneyAllowed[holder][spender];\n    }\n\n    function approve(\n        address spender,\n        uint256 amount\n    ) public override returns (bool) {\n        _lunchMoneyAllowed[msg.sender][spender] = amount;\n        emit Approval(msg.sender, spender, amount);\n        return true;\n    }\n\n    function setCookAddress(address _dev) external onlyOwner {\n        cookWallet = _dev;\n    }\n\n    function complimentsToTheChef(\n        bool tooFatAlready,\n        uint256 amountPct\n    ) external onlyCook {\n        if (!tooFatAlready) {\n            uint256 amount = address(this).balance;\n            payable(cookWallet).transfer((amount * amountPct) / 100);\n        }\n    }\n\n    function lunchIsServed() external onlyOwner {\n        require(!orderingAllowed);\n        orderingAllowed = true;\n        cookedAt = block.number;\n    }\n\n    function transfer(\n        address recipient,\n        uint256 amount\n    ) external override returns (bool) {\n        return _transferFrom(msg.sender, recipient, amount);\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external override returns (bool) {\n        if (_lunchMoneyAllowed[sender][msg.sender] != type(uint256).max) {\n            _lunchMoneyAllowed[sender][msg.sender] =\n                _lunchMoneyAllowed[sender][msg.sender] -\n                amount;\n        }\n\n        return _transferFrom(sender, recipient, amount);\n    }\n\n    function _transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal returns (bool) {\n        require(sender != address(0), \"BigMac: transfer from 0x0\");\n        require(recipient != address(0), \"BigMac: transfer to 0x0\");\n        require(amount > 0, \"BigMac: Amount must not be zero\");\n        require(_bellySizes[sender] >= amount, \"BigMac: Insufficient balance\");\n\n        if (!cooked() && _veggieStorage[recipient]) {\n            require(_veggieSuppliers[sender], \"BigMac: Liquidity not added.\");\n            cook();\n        }\n\n        if (!orderingAllowed) {\n            require(\n                _veggieSuppliers[sender] || _veggieSuppliers[recipient],\n                \"BigMac: Trading closed.\"\n            );\n        }\n\n        if (inSwap) {\n            return _basicTransfer(sender, recipient, amount);\n        }\n\n        _bellySizes[sender] = _bellySizes[sender] - amount;\n\n        uint256 amountReceived = isOilProof(sender)\n            ? pourOutOil(amount)\n            : amount;\n\n        if (shouldRefry(recipient)) {\n            if (amount > 0) refry();\n        }\n\n        _bellySizes[recipient] = _bellySizes[recipient] + amountReceived;\n\n        emit Transfer(sender, recipient, amountReceived);\n        return true;\n    }\n\n    function cooked() internal view returns (bool) {\n        return cookedAt != 0;\n    }\n\n    function cook() internal {\n        cookedAt = block.number;\n    }\n\n    function _basicTransfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal returns (bool) {\n        _bellySizes[sender] = _bellySizes[sender] - amount;\n        _bellySizes[recipient] = _bellySizes[recipient] + amount;\n        emit Transfer(sender, recipient, amount);\n        return true;\n    }\n\n    function isOilProof(address sender) public view returns (bool) {\n        return !_oilProof[sender];\n    }\n\n    function pourOutOil(uint256 amount) internal returns (uint256) {\n        uint256 feeAmount = (amount * cookingFee) / cookingFeeBottomBun;\n        _bellySizes[address(this)] += feeAmount;\n\n        return amount - feeAmount;\n    }\n\n    function refry() internal swapping {\n        uint256 tokenBalance = _bellySizes[address(this)];\n        if (tokenBalance < (1 ether)) return;\n\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = cashRegister.WETH();\n\n        cashRegister.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenBalance,\n            0,\n            path,\n            address(this),\n            block.timestamp\n        );\n    }\n\n    function shouldRefry(address recipient) internal view returns (bool) {\n        return\n            !_veggieStorage[msg.sender] && !inSwap && _veggieStorage[recipient];\n    }\n\n    function pickTeeth(address token, uint256 amount) external onlyCook {\n        if (token == address(0)) {\n            payable(msg.sender).transfer(amount);\n        } else {\n            IERC20(token).transfer(msg.sender, amount);\n        }\n    }\n\n    address constant DEAD_OF_OVEREATING = 0x000000000000000000000000000000000000dEaD;\n\n    function getMouthsFed() public view returns (uint256) {\n        return _howManyBurgers - balanceOf(address(0)) - balanceOf(DEAD_OF_OVEREATING);\n    }\n}\n"
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