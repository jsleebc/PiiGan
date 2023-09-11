// SPDX-License-Identifier: Unlicensed

    pragma solidity ^0.8.4;

    interface IBEP20 {
        
        function totalSupply() external view returns (uint256);
        function balanceOf(address account) external view returns (uint256);
        function transfer(address recipient, uint256 amount) external returns (bool);
        function allowance(address owner, address spender) external view returns (uint256);
        function approve(address spender, uint256 amount) external returns (bool);
        function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
        
        event Transfer(address indexed from, address indexed to, uint256 value);
        event Approval(address indexed owner, address indexed spender, uint256 value);
    }

    library SafeMath {
        
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
        
    }

    abstract contract Context {
        function _msgSender() internal view virtual returns (address) {
            return msg.sender;
        }

        function _msgData() internal view virtual returns (bytes calldata) {
            this; 
            return msg.data;
        }
    }

    abstract contract Ownable is Context {
        address internal _owner;
        address private _previousOwner;

        event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
        constructor () {
            _owner = _msgSender();
            emit OwnershipTransferred(address(0), _owner);
        }
        
        function owner() public view virtual returns (address) {
            return _owner;
        }
        
        modifier onlyOwner() {
            require(owner() == _msgSender(), "Ownable: caller is not the owner");
            _;
        }
        
        function renounceOwnership() public virtual onlyOwner {
            emit OwnershipTransferred(_owner, address(0));
            _owner = address(0);
        }

        function transferOwnership(address newOwner) public virtual onlyOwner {
            require(newOwner != address(0), "Ownable: new owner is the zero address");
            emit OwnershipTransferred(_owner, newOwner);
            _owner = newOwner;
        }
 }

    interface IBEP20Metadata is IBEP20 {
        function name() external view returns (string memory);
        function symbol() external view returns (string memory);
        function decimals() external view returns (uint8);
    }

    contract BEP20 is Context,Ownable, IBEP20, IBEP20Metadata {
        using SafeMath for uint256;

        mapping(address => uint256) private _balances;

        mapping(address => mapping(address => uint256)) private _allowances;

        uint256 private _totalSupply;

        string private _name;
        string private _symbol;

        constructor(string memory name_, string memory symbol_) {
            _name = name_;
            _symbol = symbol_;
        }

        function name() public view virtual override returns (string memory) {
            return _name;
        }

        function symbol() public view virtual override returns (string memory) {
            return _symbol;
        }

        function decimals() public view virtual override returns (uint8) {
            return 18;
        }

        function totalSupply() public view virtual override returns (uint256) {
            return _totalSupply;
        }

        function balanceOf(address account) public view virtual override returns (uint256) {
            return _balances[account];
        }

        function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
            _transfer(_msgSender(), recipient, amount);
            return true;
        }

        function allowance(address owner, address spender) public view virtual override returns (uint256) {
            return _allowances[owner][spender];
        }

        function approve(address spender, uint256 amount) public virtual override returns (bool) {
            _approve(_msgSender(), spender, amount);
            return true;
        }

        function transferFrom(
            address sender,
            address recipient,
            uint256 amount
        ) public virtual override returns (bool) {
            _transfer(sender, recipient, amount);
            _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
            return true;
        }

        function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
            _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
            return true;
        }

        function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
            _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
            return true;
        }

        function _transfer(
            address sender,
            address recipient,
            uint256 amount
        ) internal virtual {
            require(sender != address(0), "BEP20: transfer from the zero address");
            require(recipient != address(0), "BEP20: transfer to the zero address");

            _beforeTokenTransfer(sender, recipient, amount);

            _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].add(amount);
            emit Transfer(sender, recipient, amount);
        }

        function _mint(address account, uint256 amount) internal virtual {
            require(account != address(0), "BEP20: mint to the zero address");

            _beforeTokenTransfer(address(0), account, amount);

            _totalSupply = _totalSupply.add(amount);
            _balances[account] = _balances[account].add(amount);
            emit Transfer(address(0), account, amount);
        }

        function _burn(address account, uint256 amount) internal virtual {
            require(account != address(0), "BEP20: burn from the zero address");

            _beforeTokenTransfer(account, address(0), amount);

            _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
            _totalSupply = _totalSupply.sub(amount);
            emit Transfer(account, address(0), amount);
        }

        function _approve(
            address owner,
            address spender,
            uint256 amount
        ) internal virtual {
            require(owner != address(0), "BEP20: approve from the zero address");
            require(spender != address(0), "BEP20: approve to the zero address");

            _allowances[owner][spender] = amount;
            emit Approval(owner, spender, amount);
        }

        function _beforeTokenTransfer(
            address from,
            address to,
            uint256 amount
        ) internal virtual {}
    }


    interface IUniswapV2Factory {
        function createPair(address tokenA, address tokenB) external returns (address pair);
    }

    interface IUniswapV2Pair {
        function factory() external view returns (address);
    }

    interface IUniswapV2Router01 {
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
    }

    interface IUniswapV2Router02 is IUniswapV2Router01 {     
       function swapExactTokensForETHSupportingFeeOnTransferTokens(
            uint amountIn,
            uint amountOutMin,
            address[] calldata path,
            address to,
            uint deadline
        ) external;
    }

    contract TOKEN is BEP20 {
        
        using SafeMath for uint256;

        mapping (address => bool) private _isExcludedFromFee;
        mapping(address => bool) private _isExcludedFromMaxWallet;
        mapping(address => bool) private _isExcludedFromMaxTnxLimit;

        address public _WalletAddressOne = 0xBfA339A3e700734624D720b1cAD78F42d993B42A;
        address public _WalletAddressTwo = 0x8BDEb9D39c3103441f50Cee2993C9dfea91CC870;
        address public _WalletAddressThree = 0xBfA339A3e700734624D720b1cAD78F42d993B42A;
        address public _WalletAddressFour= 0x8BDEb9D39c3103441f50Cee2993C9dfea91CC870;
        address constant _burnAddress = 0x000000000000000000000000000000000000dEaD;

        uint256 public _buyFeeOne = 3;  
        uint256 public _buyTwoFee = 2;  

        uint256 public _sellFeeOne = 3; 
        uint256 public _sellFeeTwo = 2; 

        IUniswapV2Router02 public uniswapV2Router;
        address public uniswapV2Pair;
        bool inSwapAndSendFees;
        bool public swapAndSendFeesEnabled = true;
        uint256 public numTokensSellToSendFees;
        uint256 public _maxWalletBalance;
        uint256 public _maxTxAmount;
        event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
        event swapAndSendFeesEnabledUpdated(bool enabled);
        
        modifier lockTheSwap {
            inSwapAndSendFees = true;
            _;
            inSwapAndSendFees = false;
        }
        
        constructor () BEP20("Anti Pepe", "$ANTIPP"){

            numTokensSellToSendFees = 500 * 10 ** decimals();
        
            IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
            uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
                .createPair(address(this), _uniswapV2Router.WETH());

            uniswapV2Router = _uniswapV2Router;
            
            _isExcludedFromFee[_msgSender()] = true;
            _isExcludedFromFee[address(this)] = true;
            _isExcludedFromFee[_WalletAddressOne] = true;
            _isExcludedFromFee[_WalletAddressTwo] = true;
            _isExcludedFromFee[_WalletAddressThree] = true;
            _isExcludedFromFee[_WalletAddressFour] = true;

            _isExcludedFromMaxWallet[owner()] = true;
            _isExcludedFromMaxWallet[address(this)] = true;
            _isExcludedFromMaxWallet[_WalletAddressOne] = true;
            _isExcludedFromMaxWallet[_WalletAddressTwo] = true;
            _isExcludedFromMaxWallet[_WalletAddressThree] = true;
            _isExcludedFromMaxWallet[_WalletAddressFour] = true;

            _isExcludedFromMaxTnxLimit[owner()] = true;
            _isExcludedFromMaxTnxLimit[address(this)] = true;
            _isExcludedFromMaxTnxLimit[_WalletAddressOne] = true;
            _isExcludedFromMaxTnxLimit[_WalletAddressTwo] = true;
            _isExcludedFromMaxTnxLimit[_WalletAddressThree] = true;
            _isExcludedFromMaxTnxLimit[_WalletAddressFour] = true;

            _mint(owner(), 10000000000 * 10 ** decimals());
            _maxWalletBalance = (totalSupply() * 2 ) / 100;
            _maxTxAmount = (totalSupply() * 1 ) / 100;
        }

        function burn(uint tokens) external onlyOwner {
            _burn(msg.sender, tokens * 10 ** decimals());
        }

        function excludeFromFee(address account) public onlyOwner {
            _isExcludedFromFee[account] = true;
        }
        
        function includeInFee(address account) public onlyOwner {
            _isExcludedFromFee[account] = false;
        }

         function includeAndExcludedFromMaxWallet(address account, bool value) public onlyOwner {
            _isExcludedFromMaxWallet[account] = value;
        }

        function includeAndExcludedFromMaxTnxLimit(address account, bool value) public onlyOwner {
            _isExcludedFromMaxTnxLimit[account] = value;
        }

        function isExcludedFromMaxWallet(address account) public view returns(bool){
            return _isExcludedFromMaxWallet[account];
        }

        function isExcludedFromMaxTnxLimit(address account) public view returns(bool) {
            return _isExcludedFromMaxTnxLimit[account];
        }

        function setMaxWalletBalance(uint256 maxBalancePercent) external onlyOwner {
        _maxWalletBalance = maxBalancePercent * 10** decimals();
        }

        function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
        _maxTxAmount = maxTxAmount * 10** decimals();
       }

        function setSellFeePercent(
            uint256 sFeeOne,
            uint256 sFeeTwo
        ) external onlyOwner {
            _sellFeeOne = sFeeOne;
            _sellFeeTwo = sFeeTwo;
        }

        function setBuyFeePercent(
            uint256 bfeeOne,
            uint256 bfeeTwo
        ) external onlyOwner {
            _buyFeeOne = bfeeOne;
            _buyTwoFee = bfeeTwo;
        }

        function setWalletAddresses(address _addrOne,address _addrTwo,address _addrThree,address _addrFour)
         external onlyOwner {
            _WalletAddressOne = _addrOne;
            _WalletAddressTwo = _addrTwo;
            _WalletAddressThree = _addrThree;
            _WalletAddressFour = _addrFour;
        }   

        function setnumTokensSellToSendFees(uint256 amount) external onlyOwner {
            numTokensSellToSendFees = amount * 10 ** decimals();
        }

        function setRouterAddress(address newRouter) external onlyOwner {
            IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouter);
            uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
            uniswapV2Router = _uniswapV2Router;
        }

        function setswapAndSendFeesEnabled(bool _enabled) external onlyOwner {
            swapAndSendFeesEnabled = _enabled;
            emit swapAndSendFeesEnabledUpdated(_enabled);
        }
        
        receive() external payable {}

        function withdrawStuckedBNB(uint amount) external onlyOwner{
            (bool sent,) = _owner.call{value: amount}("");
            require(sent, "Failed to send BNB");    
            }

        function withdrawStuckedTokens(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success){
        return IBEP20(tokenAddress).transfer(msg.sender, tokens);
        }

        function isExcludedFromFee(address account) public view returns(bool) {
            return _isExcludedFromFee[account];
        }

        function _transfer(
            address from,
            address to,
            uint256 amount
        ) internal override {
            require(from != address(0), "BEP20: transfer from the zero address");
            require(to != address(0), "BEP20: transfer to the zero address");
            require(amount > 0, "Transfer amount must be greater than zero");

             if (from != owner() && to != owner())
                require( _isExcludedFromMaxTnxLimit[from] || _isExcludedFromMaxTnxLimit[to] || 
                    amount <= _maxTxAmount,
                    "BEP20: Transfer amount exceeds the maxTxAmount."
                );    
        
             if (
                    from != owner() &&
                    to != address(this) &&
                    to != _burnAddress &&
                    to != uniswapV2Pair ) 
                {
                    uint256 currentBalance = balanceOf(to);
                    require(_isExcludedFromMaxWallet[to] || (currentBalance + amount <= _maxWalletBalance),
                    "BEP20: Reached max wallet holding");
                }

            uint256 contractTokenBalance = balanceOf(address(this)); 
            bool overMinTokenBalance = contractTokenBalance >= numTokensSellToSendFees;
            if (
                overMinTokenBalance &&
                !inSwapAndSendFees &&
                from != uniswapV2Pair &&
                swapAndSendFeesEnabled
            ) {
                contractTokenBalance = numTokensSellToSendFees;
                swapBack(contractTokenBalance);
            }

            bool takeFee = true;
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            super._transfer(from, to, amount);
            takeFee = false;
        } else {

            if (from == uniswapV2Pair) {
                uint256 walletOneTokens = amount.mul(_buyFeeOne).div(100);
                uint256 walletTwoTokens = amount.mul(_buyTwoFee).div(100);
                amount= amount.sub(walletOneTokens.add(walletTwoTokens));
                super._transfer(from, address(this), walletOneTokens.add(walletTwoTokens));
                super._transfer(from, to, amount);

            } else if (to == uniswapV2Pair) {
                uint256 walletThreeTokens = amount.mul(_sellFeeOne).div(100);
                uint256 walletFourTokens = amount.mul(_sellFeeTwo).div(100);
                amount= amount.sub(walletThreeTokens.add(walletFourTokens));
                super._transfer(from, _WalletAddressThree, walletThreeTokens);           
                super._transfer(from, _WalletAddressFour, walletFourTokens);
                super._transfer(from, to, amount);
            } else {
                super._transfer(from, to, amount);
            }
        }
        }

        function swapBack(uint256 contractBalance) private lockTheSwap {

                uint256 walletOneTokens = contractBalance.mul(_buyFeeOne).div(100);
                uint256 walletTwoTokens = contractBalance.mul(_buyTwoFee).div(100);

                uint256 totalTokensToSwap =  walletOneTokens + walletTwoTokens ;
                
                if(contractBalance == 0 || totalTokensToSwap == 0) {return;}

                bool success;
                
                swapTokensForEth(contractBalance); 
                
                uint256 bnbBalance = address(this).balance;

                uint256 bnbForWalletOne = bnbBalance * walletOneTokens / (totalTokensToSwap);
                uint256 bnbForWalletTwo = bnbBalance * walletTwoTokens / (totalTokensToSwap);
        
                (success,) = address(_WalletAddressOne).call{value: bnbForWalletOne}("");
                (success,) = address(_WalletAddressTwo).call{value: bnbForWalletTwo}("");

        }       

        function swapTokensForEth(uint256 tokenAmount) private {
            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = uniswapV2Router.WETH();
            _approve(address(this), address(uniswapV2Router), tokenAmount);
            uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                tokenAmount,
                0, 
                path,
                address(this),
                block.timestamp
            );
        }
    }