pragma solidity ^0.8.18;
// SPDX-License-Identifier: Unlicensed
interface IEternalStorage {
    function getUint(bytes32 _key) external view returns(uint);
    function setUint(bytes32 _key, uint _value) external;
}

interface IPancakeFactory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IPancakeRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
   function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract BudLiteCoin {
    error Invalid();
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed sender, address indexed spender, uint value);
    string constant _name = "Bud LiteCoin";
    string constant _symbol = "BLTC";
    address immutable liquidityPair;
    uint immutable numTokensSellToAddToLiquidity;    
    address _owner;
    IPancakeRouter immutable pancakeSwapRouter;
    IEternalStorage immutable s;
    bool inSwapAndLiquify;
     
    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor (address eternalStorageContractAddress) {
        _owner = msg.sender;
        inSwapAndLiquify = false;
        numTokensSellToAddToLiquidity = totalSupply()/200;
        s = IEternalStorage(eternalStorageContractAddress);
        IPancakeRouter _router = IPancakeRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        liquidityPair = IPancakeFactory(_router.factory()).createPair(address(this), _router.WETH());
        pancakeSwapRouter = _router;
    }
    
    function init() public {
        if( msg.sender != _owner ) revert Invalid();
        SetBalance(msg.sender, totalSupply());
        _approve(address(this), address(pancakeSwapRouter), 2**256 - 1);
        _owner = address(0); //make sure init can only be called once
        emit Transfer(address(0), msg.sender, totalSupply());
    }
   
    
    /* Calculate lookup keys for data in EternalStorage */
    function key_balance(address account) internal pure returns (bytes32 key) {
        return keccak256(abi.encode(symbol(), "Balance", account));
    }
    function key_allowance(address sender, address spender) internal pure returns (bytes32 key) {
        return keccak256(abi.encode(symbol(), "Allowance", sender, spender));
    }
    
    function GetBalance(address account) internal view returns (uint balance) {
        return s.getUint(key_balance(account));
    }

    function SetBalance(address account, uint amount) internal {
        s.setUint(key_balance(account), amount);
    }

    function GetAllowance(address sender, address spender) internal view returns (uint) {
        return s.getUint(key_allowance(sender, spender));
    }

    function SetAllowance(address sender, address spender, uint amount) internal {
        s.setUint(key_allowance(sender, spender), amount);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 9;
    }

    function totalSupply() public pure returns (uint) {
        return 1000000000*(10**9);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function balanceOf(address account) public view returns (uint) {
        return GetBalance(account);
    }

    function transfer(address recipient, uint amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address sender, address spender) public view returns (uint) {
        return GetAllowance(sender, spender);
    }

    function approve(address spender, uint amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    function _approve(address sender, address spender, uint amount) private {
        if( sender == address(0) || spender == address(0) ) revert Invalid();
        SetAllowance(sender, spender, amount);
        emit Approval(sender, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
        address spender = msg.sender;  
        uint updatedAllowance = GetAllowance(sender, spender) - amount;
        _transfer(sender, recipient, amount);
        SetAllowance(sender, spender, updatedAllowance);        
        return true;
    }

    receive() external payable {}

    function _transfer(
        address from,
        address to,
        uint amount
    ) private {
        if( from == address(0) || to == address(0) ) revert Invalid();          
        if ( from != liquidityPair &&            
             !inSwapAndLiquify &&
             balanceOf(address(this)) >= numTokensSellToAddToLiquidity) 
        {
            //add liquidity
            swapAndLiquify(numTokensSellToAddToLiquidity);
        }
        //don't take fee when adding liquidity
        uint liquidityFee = (from == address(this) || to == address(this)) ? 0 : (amount/100);
        uint senderNewBalance = GetBalance(from) - amount;
        uint recipientNewBalance = GetBalance(to) + (amount - liquidityFee);
        SetBalance(from, senderNewBalance);
        SetBalance(to, recipientNewBalance);
        if( liquidityFee > 0 ) {
            SetBalance(address(this), GetBalance(address(this))+liquidityFee);
        }
        emit Transfer(from, to, amount);
    }

    function swapAndLiquify(uint contractTokenBalance) private lockTheSwap {
        uint half = contractTokenBalance/2;
        uint otherHalf = contractTokenBalance - half;
        uint initialBalance = address(this).balance;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = pancakeSwapRouter.WETH();
        pancakeSwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
                            half, 0, path, address(this), block.timestamp);
        uint newBalance = address(this).balance - initialBalance;
        //LP token gets sent to 0 address (burned)
        pancakeSwapRouter.addLiquidityETH{value: newBalance}(
            address(this), otherHalf, 0, 0, address(0), block.timestamp);
    }
}