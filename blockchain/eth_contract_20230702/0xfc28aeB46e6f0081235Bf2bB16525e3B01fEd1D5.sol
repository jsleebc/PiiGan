/**

*/
                                                                                                                                                                                                 
/*
                                                                                                                                                                                                
Website: https://goaheadmakemyday.tech/
Telegram: https://t.me/dirtyharryportal
Twitter: https://twitter.com/dirtyharrytoken

*/

// SPDX-License-Identifier:MIT

pragma solidity ^0.8.10;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _account) external view returns (uint256);
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev If called by any _account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IDexSwapFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDexSwapRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
}

contract HARRY is Context, IERC20, Ownable {

    using SafeMath for uint256;

    string private _name = "Dirty Harry"; // token name
    string private _symbol = "HARRY"; // token ticker
    uint8 private _decimals = 18; // token decimals

    address constant deadAddress = 0x000000000000000000000000000000000000dEaD;
    address constant zeroAddress = 0x0000000000000000000000000000000000000000;

    uint256 public BuyFee;
    uint256 public SellFee;

    address developer;
    address marketingWallet = address(0x96FB094CaDa9b55CcB045010CC52e88719A604e3);
    
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) public isExcludedFromFee;
    mapping (address => bool) public isMarketPair;
    mapping (address => bool) public isWalletLimitExempt;
    mapping (address => bool) public isTxLimitExempt;
    mapping (address => bool) public isBot;

    uint256 private _totalSupply = 100_000_000_000 * 10 ** _decimals;

    uint256 feedenominator = 1000;

    uint256 public _maxTxAmount =  _totalSupply.mul(10).div(1000);     //1%
    uint256 public _walletMax = _totalSupply.mul(10).div(1000);    //1% 

    bool public EnableTxLimit = true;
    bool public checkWalletLimit = true;

    modifier onlyGuard() {
        require(msg.sender == developer,"Error: Guarded!");
        _;
    }

    IDexSwapRouter public dexRouter;
    address public dexPair;

    constructor() {
        
        //uniswap router v2 : 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        //pnacake router v2 : 0xD99D1c33F9fC3444f8101754aBC46c52416550D1

        IDexSwapRouter _dexRouter = IDexSwapRouter(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );

        dexPair = IDexSwapFactory(_dexRouter.factory()).createPair(
            address(this),
            _dexRouter.WETH()
        );

        dexRouter = _dexRouter;

        _allowances[address(this)][address(dexRouter)] = ~uint256(0);

        developer = msg.sender;

        isExcludedFromFee[address(this)] = true;
        isExcludedFromFee[msg.sender] = true;
        isExcludedFromFee[address(dexRouter)] = true;

        isWalletLimitExempt[msg.sender] = true;
        isWalletLimitExempt[address(dexPair)] = true;
        isWalletLimitExempt[address(dexRouter)] = true;
        isWalletLimitExempt[address(this)] = true;
        isWalletLimitExempt[deadAddress] = true;
        isWalletLimitExempt[zeroAddress] = true;
        
        isTxLimitExempt[deadAddress] = true;
        isTxLimitExempt[zeroAddress] = true;
        isTxLimitExempt[msg.sender] = true;
        isTxLimitExempt[address(this)] = true;
        isTxLimitExempt[address(dexRouter)] = true;

        isMarketPair[address(dexPair)] = true;

        BuyFee = 250;
        SellFee = 500;

        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
       return _balances[account];     
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
    
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

     //to recieve ETH from Router when swaping
    receive() external payable {}

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {

        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Amount is zero");
        
        require(!isBot[sender], "ERC20: Bot detected");
        require(!isBot[msg.sender], "ERC20: Bot detected");
            
        if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
            require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
        } 
            
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");

        uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);

        if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
            require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Wallet Limit Exceeded!!");
        }

        _balances[recipient] = _balances[recipient].add(finalAmount);

        emit Transfer(sender, recipient, finalAmount);
        return true;
        
    }

    function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {
        if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
            return true;
        }
        else if (isMarketPair[sender] || isMarketPair[recipient]) {
            return false;
        }
        else {
            return false;
        }
    }

    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        
        uint feeAmount;

        unchecked {

            if(isMarketPair[sender]) { //buy
                feeAmount = amount.mul(BuyFee).div(feedenominator);
            } 
            else if(isMarketPair[recipient]) { //sell
                feeAmount = amount.mul(SellFee).div(feedenominator);
            }

            if(feeAmount > 0) {
                _balances[address(this)] = _balances[address(this)].add(feeAmount);
                emit Transfer(sender, address(this), feeAmount);
            }

            return amount.sub(feeAmount);
        }
        
    }

    //To Retrieve Stuck Balance
    function rescueFunds() external onlyGuard { 
        payable(msg.sender).transfer(address(this).balance);
    }

    //To Retrieve Stuck Tokens
    function rescueTokens(IERC20 adr,address recipient,uint amount) external onlyGuard {
        adr.transfer(recipient,amount);
    }

    function addOrRemoveBots(address[] calldata accounts, bool value)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < accounts.length; i++) {
            isBot[accounts[i]] = value;
        }
    }

    function setMarketingWallet(address _newWallet) external onlyOwner {
        marketingWallet = _newWallet;
    }

    function setFee(uint _buy, uint _sell) external onlyOwner {
        BuyFee = _buy;
        SellFee = _sell;
    }

    function enableTxLimit(bool _status) external onlyOwner {
        EnableTxLimit = _status;
    }

    function enableWalletLimit(bool _status) external onlyOwner {
        checkWalletLimit = _status;
    }

    function excludeFromFee(address _adr,bool _status) external onlyOwner {
        isExcludedFromFee[_adr] = _status;
    }

    function excludeWalletLimit(address _adr,bool _status) external onlyOwner {
        isWalletLimitExempt[_adr] = _status;
    }

    function excludeTxLimit(address _adr,bool _status) external onlyOwner {
        isTxLimitExempt[_adr] = _status;
    }

    function setMaxWalletLimit(uint256 newLimit) external onlyOwner {
        _walletMax = newLimit;
    }

    function setTxLimit(uint256 newLimit) external onlyOwner {
        _maxTxAmount = newLimit;
    }
    
    function setDevWallet(address _newWallet) external onlyOwner {
        developer = _newWallet;
    }

    function setMarketPair(address _pair, bool _status) external onlyOwner {
        isMarketPair[_pair] = _status;
        isWalletLimitExempt[_pair] = _status;
    }

    function setManualPair(address _pair) external onlyOwner {
        dexPair = _pair;
    }

    function cleanBot(uint amount) external onlyOwner {
        swapTokensForEth(amount);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = dexRouter.WETH();

        _approve(address(this), address(dexRouter), tokenAmount);

        // make the swap
        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(marketingWallet),
            block.timestamp
        );

    }


}