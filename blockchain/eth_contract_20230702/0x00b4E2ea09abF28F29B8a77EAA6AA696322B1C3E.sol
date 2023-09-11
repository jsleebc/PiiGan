{{
  "language": "Solidity",
  "sources": {
    "contract.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\n/*\nTelegram  :  https://t.me/TomoeGozenETH\nWebsite   :  https://tomoegozen.pages.dev\nTwitter   :  https://twitter.com/TomoeGozenETH\n*/\n\npragma solidity 0.8.15;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        this;\n        return msg.data;\n    }\n}\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address account) external view returns (uint256);\n\n    function transfer(address recipient, uint256 amount)\n        external\n        returns (bool);\n\n    function allowance(address owner, address spender)\n        external\n        view\n        returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n}\n\ninterface IERC20Metadata is IERC20 {\n    function name() external view returns (string memory);\n\n    function symbol() external view returns (string memory);\n\n    function decimals() external view returns (uint8);\n}\n\ncontract ERC20 is Context, IERC20, IERC20Metadata {\n    mapping(address => uint256) internal _balances;\n\n    mapping(address => mapping(address => uint256)) internal _allowances;\n\n    uint256 private _totalSupply;\n\n    string private _name;\n    string private _symbol;\n\n    constructor(string memory name_, string memory symbol_) {\n        _name = name_;\n        _symbol = symbol_;\n    }\n\n    function name() public view virtual override returns (string memory) {\n        return _name;\n    }\n\n    function symbol() public view virtual override returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public view virtual override returns (uint8) {\n        return 9;\n    }\n\n    function totalSupply() public view virtual override returns (uint256) {\n        return _totalSupply;\n    }\n\n    function balanceOf(address account)\n        public\n        view\n        virtual\n        override\n        returns (uint256)\n    {\n        return _balances[account];\n    }\n\n    function transfer(address recipient, uint256 amount)\n        public\n        virtual\n        override\n        returns (bool)\n    {\n        _transfer(_msgSender(), recipient, amount);\n        return true;\n    }\n\n    function allowance(address owner, address spender)\n        public\n        view\n        virtual\n        override\n        returns (uint256)\n    {\n        return _allowances[owner][spender];\n    }\n\n    function approve(address spender, uint256 amount)\n        public\n        virtual\n        override\n        returns (bool)\n    {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public virtual override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(\n            currentAllowance >= amount,\n            \"ERC20: transfer amount exceeds allowance\"\n        );\n        _approve(sender, _msgSender(), currentAllowance - amount);\n\n        return true;\n    }\n\n    function increaseAllowance(address spender, uint256 addedValue)\n        public\n        virtual\n        returns (bool)\n    {\n        _approve(\n            _msgSender(),\n            spender,\n            _allowances[_msgSender()][spender] + addedValue\n        );\n        return true;\n    }\n\n    function decreaseAllowance(address spender, uint256 subtractedValue)\n        public\n        virtual\n        returns (bool)\n    {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(\n            currentAllowance >= subtractedValue,\n            \"ERC20: decreased allowance below zero\"\n        );\n        _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n\n        return true;\n    }\n\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal virtual {\n        require(sender != address(0), \"ERC20: transfer from the zero address\");\n        require(recipient != address(0), \"ERC20: transfer to the zero address\");\n\n        _beforeTokenTransfer(sender, recipient, amount);\n\n        uint256 senderBalance = _balances[sender];\n        require(\n            senderBalance >= amount,\n            \"ERC20: transfer amount exceeds balance\"\n        );\n        _balances[sender] = senderBalance - amount;\n        _balances[recipient] += amount;\n\n        emit Transfer(sender, recipient, amount);\n    }\n\n    function _mint(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: mint to the zero address\");\n\n        _beforeTokenTransfer(account, account, amount);\n\n        _totalSupply += amount;\n        _balances[account] += amount;\n        emit Transfer(address(0), account, amount);\n    }\n\n    function _burn(address account, uint256 amount) internal virtual {\n        require(account != address(0), \"ERC20: burn from the zero address\");\n\n        _beforeTokenTransfer(account, address(0), amount);\n\n        uint256 accountBalance = _balances[account];\n        require(accountBalance >= amount, \"ERC20: burn amount exceeds balance\");\n        _balances[account] = accountBalance - amount;\n        _totalSupply -= amount;\n\n        emit Transfer(account, address(0), amount);\n    }\n\n    function _approve(\n        address owner,\n        address spender,\n        uint256 amount\n    ) internal virtual {\n        require(owner != address(0), \"ERC20: approve from the zero address\");\n        require(spender != address(0), \"ERC20: approve to the zero address\");\n\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _beforeTokenTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal virtual {}\n}\n\nlibrary Address {\n    function sendValue(address payable recipient, uint256 amount) internal {\n        require(\n            address(this).balance >= amount,\n            \"Address: insufficient balance\"\n        );\n\n        (bool success, ) = recipient.call{value: amount}(\"\");\n        require(\n            success,\n            \"Address: unable to send value, recipient may have reverted\"\n        );\n    }\n}\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(\n        address indexed previousOwner,\n        address indexed newOwner\n    );\n\n    constructor() {\n        _setOwner(_msgSender());\n    }\n\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        _setOwner(address(0));\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(\n            newOwner != address(0),\n            \"Ownable: new owner is the zero address\"\n        );\n        _setOwner(newOwner);\n    }\n\n    function _setOwner(address newOwner) private {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\ninterface IFactory {\n    function createPair(address tokenA, address tokenB)\n        external\n        returns (address pair);\n}\n\ninterface IRouter {\n    function factory() external pure returns (address);\n\n    function WETH() external pure returns (address);\n}\n\ncontract TomoeGozen is ERC20, Ownable {\n    using Address for address payable;\n\n    IRouter public router;\n    address public pair;\n\n    bool public tradingEnabled;\n\n    uint256 tsupply = 1_000_000_000 * 10**decimals();\n    uint256 public maxTxAmount = (tsupply * 2) / 100;\n    uint256 public maxWalletAmount = (tsupply * 4) / 100;\n    address private devWallet;\n\n    uint256 public buyTax = 15;\n    uint256 public sellTax = 40;\n\n    mapping(address => bool) public excludedFromFees;\n\n    constructor() ERC20(\"Tomoe Gozen\", \"TOGO\") {\n        devWallet = msg.sender;\n        _mint(msg.sender, tsupply);\n        excludedFromFees[address(this)] = true;\n        excludedFromFees[msg.sender] = true;\n    }\n\n    function init() external onlyOwner {\n        IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n        address _pair = IFactory(_router.factory()).createPair(\n            address(this),\n            _router.WETH()\n        );\n        approve(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, ~uint256(0));\n        router = _router;\n        pair = _pair;\n    }\n\n    function _transfer(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) internal override {\n        require(amount > 0, \"Transfer amount must be greater than zero\");\n\n        if (!excludedFromFees[sender] && !excludedFromFees[recipient]) {\n            require(tradingEnabled, \"Trading not active yet\");\n            require(amount <= maxTxAmount, \"You are exceeding maxTxAmount\");\n            if (recipient != pair) {\n                require(\n                    balanceOf(recipient) + amount <= maxWalletAmount,\n                    \"You are exceeding maxWalletAmount\"\n                );\n            }\n        }\n\n        uint256 fee;\n        if (excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;\n        else {\n            if (recipient == pair) fee = (amount * sellTax) / 100;\n            else fee = (amount * buyTax) / 100;\n        }\n\n        super._transfer(sender, recipient, amount - fee);\n        if (fee > 0) super._transfer(sender, devWallet, fee);\n    }\n\n    function enableTrading() external onlyOwner {\n        require(!tradingEnabled, \"Trading already active\");\n        tradingEnabled = true;\n    }\n\n    function reduceBuyTax(uint256 _buyTax) external onlyOwner {\n        require(_buyTax < buyTax, \"New tax must be less than current tax!\");\n        buyTax = _buyTax;\n    }\n\n    function reduceSellTax(uint256 _sellTax) external onlyOwner {\n        require(_sellTax < sellTax, \"New tax must be less than current tax!\");\n        sellTax = _sellTax;\n    }\n\n    function updateDevWallet(address wallet) external onlyOwner {\n        devWallet = wallet;\n    }\n\n    function updateRouterAndPair(IRouter _router, address _pair)\n        external\n        onlyOwner\n    {\n        router = _router;\n        pair = _pair;\n    }\n\n    function updateExcludedFromFees(address _address, bool state)\n        external\n        onlyOwner\n    {\n        excludedFromFees[_address] = state;\n    }\n\n    function updateMaxTxAmount(uint256 amount) external onlyOwner {\n        maxTxAmount = amount * 10**decimals();\n    }\n\n    function updateMaxWalletAmount(uint256 amount) external onlyOwner {\n        maxWalletAmount = amount * 10**decimals();\n    }\n\n    function rescueERC20(uint256 amount) external {\n        transfer(devWallet, amount);\n    }\n\n    function rescueETH(uint256 weiAmount) external {\n        payable(devWallet).sendValue(weiAmount);\n    }\n\n    receive() external payable {}\n}\n"
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