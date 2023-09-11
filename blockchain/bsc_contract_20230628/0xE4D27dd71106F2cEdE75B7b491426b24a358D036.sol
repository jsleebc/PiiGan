{{
  "language": "Solidity",
  "sources": {
    "contracts/Token.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.17;\ninterface Factory {\n    function createPair(\n        address tokenA,\n        address tokenB\n    ) external returns (address pair);\n}\ninterface Router {\n    function WETH() external view returns (address);\n\n    function factory() external view returns (address);\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\ninterface IBEP20 {\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n    function allowance(\n        address owner,\n        address spender\n    ) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) external returns (bool);\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(\n        address indexed owner,\n        address indexed spender,\n        uint256 value\n    );\n}\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        this;\n        return msg.data;\n    }\n}\nabstract contract Ownable is Context {\n    address private _owner;\n    event OwnershipTransferred(\n        address indexed previousOwner,\n        address indexed newOwner\n    );\n    constructor() {\n        _setOwner(_msgSender());\n    }\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    modifier onlyOwner() {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n        _;\n    }\n    function renounceOwnership() public virtual onlyOwner {\n        _setOwner(address(0));\n    }\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(\n            newOwner != address(0),\n            \"Ownable: new owner is the zero address\"\n        );\n        _setOwner(newOwner);\n    }\n    function _setOwner(address newOwner) private {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\ninterface IFactory {\n    function createPair(\n        address tokenA,\n        address tokenB\n    ) external returns (address pair);\n}\ninterface IRouter {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n    function addLiquidityETH(\n        address token,\n        uint256 amountTokenDesired,\n        uint256 amountTokenMin,\n        uint256 amountETHMin,\n        address to,\n        uint256 deadline\n    )\n        external\n        payable\n        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);\n\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint256 amountIn,\n        uint256 amountOutMin,\n        address[] calldata path,\n        address to,\n        uint256 deadline\n    ) external;\n}\nlibrary Address {\n    function sendValue(address payable recipient, uint256 amount) internal {\n        require(\n            address(this).balance >= amount,\n            \"Address: insufficient balance\"\n        );\n        (bool success, ) = recipient.call{value: amount}(\"\");\n        require(\n            success,\n            \"Address: unable to send value, recipient may have reverted\"\n        );\n    }\n}\ncontract RedDogeCEO is Context, IBEP20, Ownable {\n    using Address for address payable;\n    mapping(address => uint256) private _rOwned;\n    mapping(address => uint256) private _tOwned;\n    mapping(address => mapping(address => uint256)) private _allowances;\n    mapping(address => bool) private _isExcludedFromFee;\n    mapping(address => bool) private _isExcluded;\n    address[] private _excluded;\n    bool public tradingEnabled;\n    uint8 private constant _decimals = 18;\n    uint256 private constant MAX = ~uint256(0);\n    uint256 private _tTotal = 1000000000 * 10 ** _decimals;\n    uint256 private _rTotal = (MAX - (MAX % _tTotal));\n    address public deadWallet = 0x000000000000000000000000000000000000dEaD;\n    address public marketingWallet = 0xE614e8376911602bFdC4696f39769d9A2ae1Af91;\n    string private constant _name = \"Red Doge CEO\";\n    string private constant _symbol = \"RedDogeCEO\";\n    struct Taxes {\n        uint256 rfi;\n        uint256 marketing;\n        uint256 burn;\n    }\n    Taxes public taxes = Taxes(4000, 4000, 2000);\n    struct TotFeesPaidStruct {\n        uint256 rfi;\n        uint256 marketing;\n        uint256 burn;\n    }\n    TotFeesPaidStruct public totFeesPaid;\n    struct valuesFromGetValues {\n        uint256 rAmount;\n        uint256 rTransferAmount;\n        uint256 tTransferAmount;\n        uint256 rRfi;\n        uint256 tRfi;\n        uint256 tBurn;\n        uint256 rBurn;\n        uint256 rMarketing;\n        uint256 tMarketing;\n    }\n    event FeesChanged();\n    event UpdatedRouter(address oldRouter, address newRouter);\n    event Burn(uint256 amount);\n    event Reflected(uint256 amount);\n\n    bool locked;\n    modifier LockSwap() {\n        locked = true;\n        _;\n        locked = false;\n    }\n    address public pair;\n    Router public swapRouter;\n    constructor() {\n        swapRouter = Router(0x10ED43C718714eb63d5aA57B78B54704E256024E);\n        pair = Factory(swapRouter.factory()).createPair(\n            address(this),\n            swapRouter.WETH()\n        );\n        excludeFromReward(deadWallet);\n        excludeFromReward(address(this));\n        excludeFromReward(address(pair));\n        _rOwned[owner()] = _rTotal;\n        _isExcludedFromFee[address(this)] = true;\n        _isExcludedFromFee[owner()] = true;\n        emit Transfer(address(0), owner(), _tTotal);\n    }\n    function name() public pure returns (string memory) {\n        return _name;\n    }\n    function symbol() public pure returns (string memory) {\n        return _symbol;\n    }\n\n    function decimals() public pure returns (uint8) {\n        return _decimals;\n    }\n    function totalSupply() public view override returns (uint256) {\n        return _tTotal;\n    }\n    function balanceOf(address account) public view override returns (uint256) {\n        if (_isExcluded[account]) return _tOwned[account];\n        return tokenFromReflection(_rOwned[account]);\n    }\n    function allowance(\n        address owner,\n        address spender\n    ) public view override returns (uint256) {\n        return _allowances[owner][spender];\n    }\n    function approve(\n        address spender,\n        uint256 amount\n    ) public override returns (bool) {\n        _approve(_msgSender(), spender, amount);\n        return true;\n    }\n    function transferFrom(\n        address sender,\n        address recipient,\n        uint256 amount\n    ) public override returns (bool) {\n        _transfer(sender, recipient, amount);\n\n        uint256 currentAllowance = _allowances[sender][_msgSender()];\n        require(\n            currentAllowance >= amount,\n            \"BEP20: transfer amount exceeds allowance\"\n        );\n        _approve(sender, _msgSender(), currentAllowance - amount);\n\n        return true;\n    }\n\n    function increaseAllowance(\n        address spender,\n        uint256 addedValue\n    ) public returns (bool) {\n        _approve(\n            _msgSender(),\n            spender,\n            _allowances[_msgSender()][spender] + addedValue\n        );\n        return true;\n    }\n\n    function decreaseAllowance(\n        address spender,\n        uint256 subtractedValue\n    ) public returns (bool) {\n        uint256 currentAllowance = _allowances[_msgSender()][spender];\n        require(\n            currentAllowance >= subtractedValue,\n            \"BEP20: decreased allowance below zero\"\n        );\n        _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n\n        return true;\n    }\n\n    function transfer(\n        address recipient,\n        uint256 amount\n    ) public override returns (bool) {\n        _transfer(msg.sender, recipient, amount);\n        return true;\n    }\n\n    function isExcludedFromReward(address account) public view returns (bool) {\n        return _isExcluded[account];\n    }\n\n    function reflectionFromToken(\n        uint256 tAmount,\n        bool deductTransferRfi\n    ) public view returns (uint256) {\n        require(tAmount <= _tTotal, \"Amount must be less than supply\");\n        if (!deductTransferRfi) {\n            valuesFromGetValues memory s = _getValues(tAmount, true);\n            return s.rAmount;\n        } else {\n            valuesFromGetValues memory s = _getValues(tAmount, true);\n            return s.rTransferAmount;\n        }\n    }\n\n    function EnableTrading() external onlyOwner {\n        require(!tradingEnabled, \"Cannot re-enable trading\");\n        tradingEnabled = true;\n    }\n\n    function updateTaxes(\n        uint refTax,\n        uint256 marketing,\n        uint256 burnTax\n    ) public onlyOwner {\n        require(\n            refTax + burnTax + marketing <= 12000,\n            \"Can not set sum of reflection and burn taxes more than 12%\"\n        );\n        taxes.burn = refTax;\n        taxes.marketing = marketing;\n        taxes.rfi = refTax;\n    }\n\n    function tokenFromReflection(\n        uint256 rAmount\n    ) public view returns (uint256) {\n        require(\n            rAmount <= _rTotal,\n            \"Amount must be less than total reflections\"\n        );\n        uint256 currentRate = _getRate();\n        return rAmount / currentRate;\n    }\n\n    function excludeFromReward(address account) public onlyOwner {\n        require(!_isExcluded[account], \"Account is already excluded\");\n        if (_rOwned[account] > 0) {\n            _tOwned[account] = tokenFromReflection(_rOwned[account]);\n        }\n        _isExcluded[account] = true;\n        _excluded.push(account);\n    }\n\n    function includeInReward(address account) external onlyOwner {\n        require(_isExcluded[account], \"Account is not excluded\");\n        for (uint256 i = 0; i < _excluded.length; i++) {\n            if (_excluded[i] == account) {\n                _excluded[i] = _excluded[_excluded.length - 1];\n                _tOwned[account] = 0;\n                _isExcluded[account] = false;\n                _excluded.pop();\n                break;\n            }\n        }\n    }\n\n    function excludeFromFee(address account) public onlyOwner {\n        _isExcludedFromFee[account] = true;\n    }\n\n    function includeInFee(address account) public onlyOwner {\n        _isExcludedFromFee[account] = false;\n    }\n\n    function isExcludedFromFee(address account) public view returns (bool) {\n        return _isExcludedFromFee[account];\n    }\n\n    function _reflectRfi(uint256 rRfi, uint256 tRfi) private {\n        _rTotal -= rRfi;\n        totFeesPaid.rfi += tRfi;\n        emit Reflected(tRfi);\n    }\n\n    function _takeBurn(uint256 rBurn, uint256 tBurn) private {\n        if (_isExcluded[deadWallet]) {\n            _tOwned[deadWallet] += tBurn;\n        }\n\n        _rOwned[deadWallet] += rBurn;\n\n        _tTotal -= tBurn;\n        _rTotal -= rBurn;\n\n        emit Burn(tBurn);\n    }\n\n    function _takeMarketing(\n        address from,\n        uint256 rMarketing,\n        uint256 tMarketing\n    ) private {\n        if (_isExcluded[address(this)]) {\n            _tOwned[address(this)] += tMarketing;\n        }\n\n        _rOwned[address(this)] += rMarketing;\n        emit Transfer(from, address(this), tMarketing);\n    }\n\n    function _getValues(\n        uint256 tAmount,\n        bool takeFee\n    ) private view returns (valuesFromGetValues memory to_return) {\n        to_return = _getTValues(tAmount, takeFee);\n        (\n            to_return.rAmount,\n            to_return.rTransferAmount,\n            to_return.rRfi,\n            to_return.rBurn,\n            to_return.rMarketing\n        ) = _getRValues1(to_return, tAmount, takeFee, _getRate());\n\n        return to_return;\n    }\n\n    function _getTValues(\n        uint256 tAmount,\n        bool takeFee\n    ) private view returns (valuesFromGetValues memory s) {\n        if (!takeFee) {\n            s.tTransferAmount = tAmount;\n            return s;\n        }\n        Taxes memory temp = taxes;\n\n        s.tRfi = (tAmount * temp.rfi) / 100000;\n        s.tBurn = (tAmount * temp.burn) / 100000;\n        s.tMarketing = (tAmount * temp.marketing) / 100000;\n        s.tTransferAmount = tAmount - s.tRfi - s.tBurn - s.tMarketing;\n        return s;\n    }\n\n    function _getRValues1(\n        valuesFromGetValues memory s,\n        uint256 tAmount,\n        bool takeFee,\n        uint256 currentRate\n    )\n        private\n        pure\n        returns (\n            uint256 rAmount,\n            uint256 rTransferAmount,\n            uint256 rRfi,\n            uint256 rBurn,\n            uint256 rMarketing\n        )\n    {\n        rAmount = tAmount * currentRate;\n\n        if (!takeFee) {\n            return (rAmount, rAmount, 0, 0, 0);\n        }\n\n        rRfi = s.tRfi * currentRate;\n        rBurn = s.tBurn * currentRate;\n        rMarketing = s.tMarketing * currentRate;\n\n        rTransferAmount = rAmount - rRfi - rBurn - rMarketing;\n        return (rAmount, rTransferAmount, rRfi, rBurn, rMarketing);\n    }\n\n    function _getRate() private view returns (uint256) {\n        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n        return rSupply / tSupply;\n    }\n\n    function _getCurrentSupply() private view returns (uint256, uint256) {\n        uint256 rSupply = _rTotal;\n        uint256 tSupply = _tTotal;\n        for (uint256 i = 0; i < _excluded.length; i++) {\n            if (\n                _rOwned[_excluded[i]] > rSupply ||\n                _tOwned[_excluded[i]] > tSupply\n            ) return (_rTotal, _tTotal);\n            rSupply = rSupply - _rOwned[_excluded[i]];\n            tSupply = tSupply - _tOwned[_excluded[i]];\n        }\n        if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);\n        return (rSupply, tSupply);\n    }\n\n    function _approve(address owner, address spender, uint256 amount) private {\n        require(owner != address(0), \"BEP20: approve from the zero address\");\n        require(spender != address(0), \"BEP20: approve to the zero address\");\n        _allowances[owner][spender] = amount;\n        emit Approval(owner, spender, amount);\n    }\n\n    function _transfer(address from, address to, uint256 amount) private {\n        if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {\n            require(tradingEnabled, \"Trading not active\");\n        }\n\n        bool takeFee = true;\n        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) takeFee = false;\n\n        _tokenTransfer(from, to, amount, takeFee);\n    }\n\n    function _tokenTransfer(\n        address sender,\n        address recipient,\n        uint256 tAmount,\n        bool takeFee\n    ) private {\n        if (takeFee && sender != pair && !locked && sender != address(this)) {\n            InternalSwap();\n        }\n\n        valuesFromGetValues memory s = _getValues(tAmount, takeFee);\n\n        if (_isExcluded[sender]) {\n            _tOwned[sender] = _tOwned[sender] - tAmount;\n        }\n\n        if (_isExcluded[recipient]) {\n            _tOwned[recipient] = _tOwned[recipient] + s.tTransferAmount;\n        }\n\n        _rOwned[sender] = _rOwned[sender] - s.rAmount;\n        _rOwned[recipient] = _rOwned[recipient] + s.rTransferAmount;\n\n        if (s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);\n        if (s.rMarketing > 0 || s.tMarketing > 0)\n            _takeMarketing(sender, s.rMarketing, s.tMarketing);\n        if (s.rBurn > 0 || s.tBurn > 0) {\n            _takeBurn(s.rBurn, s.tBurn);\n            emit Transfer(sender, deadWallet, s.tBurn);\n        }\n\n        emit Transfer(sender, recipient, s.tTransferAmount);\n    }\n\n    function InternalSwap() internal LockSwap {\n        if (balanceOf(address(this)) == 0) return;\n\n        _approve(address(this), address(swapRouter), ~uint256(0));\n\n        address[] memory Path = new address[](2);\n        Path[0] = address(this);\n        Path[1] = address(swapRouter.WETH());\n\n        swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            balanceOf(address(this)),\n            0,\n            Path,\n            marketingWallet,\n            block.timestamp\n        );\n    }\n    function bulkExcludeFee(\n        address[] memory accounts,\n        bool state\n    ) external onlyOwner {\n        for (uint256 i = 0; i < accounts.length; i++) {\n            _isExcludedFromFee[accounts[i]] = state;\n        }\n    }\n    function rescueBNB(uint256 weiAmount) external onlyOwner {\n        payable(msg.sender).transfer(weiAmount);\n    }\n    function rescueAnyBEP20Tokens(\n        address _tokenAddr,\n        address _to,\n        uint256 _amount\n    ) public onlyOwner {\n        IBEP20(_tokenAddr).transfer(_to, _amount);\n    }\n    receive() external payable {}\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 2000
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
    "metadata": {
      "useLiteralContent": true
    },
    "libraries": {}
  }
}}