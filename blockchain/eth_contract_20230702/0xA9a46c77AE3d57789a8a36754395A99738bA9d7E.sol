/**
 *Submitted for verification at Etherscan.io on 2023-05-07
*/

// SPDX-License-Identifier: MIT

pragma solidity =0.8.4;


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode 
        return msg.data;
    }
}

pragma solidity =0.8.4;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
   
    function totalSupply() external view returns (uint256);

   
    function balanceOf(address account) external view returns (uint256);


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

pragma solidity =0.8.4;


contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

   
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

  
    function owner() public view returns (address) {
        return _owner;
    }

  
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

  
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

   
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

pragma solidity =0.8.4;

contract AntiWhale is Ownable {
    uint256 public startDate;
    uint256 public endDate;
    uint256 public limitWhale;
    bool public antiWhaleActivated;

    function activateAntiWhale() public onlyOwner {
        require(antiWhaleActivated == false);
        antiWhaleActivated = true;
    }

    function deActivateAntiWhale() public onlyOwner {
        require(antiWhaleActivated == true);
        antiWhaleActivated = false;
    }

    function setAntiWhale(uint256 _startDate, uint256 _endDate, uint256 _limitWhale) public onlyOwner {
        startDate = _startDate;
        endDate = _endDate;
        limitWhale = _limitWhale;
        antiWhaleActivated = true;
    }

    function isWhale(uint256 amount) public view returns (bool) {
        if (
            msg.sender == owner() ||
            antiWhaleActivated == false ||
            amount <= limitWhale
        ) return false;

        if (block.timestamp >= startDate && block.timestamp <= endDate)
            return true;

        return false;
    }
}

pragma solidity =0.8.4;


contract Fronk is Context, IERC20, Ownable, AntiWhale {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    string private _name = "Fronk Coin";
    string private _symbol = "FRONK";
    uint8 private _decimals = 18;

    uint256 constant maxCap = 10000000000000 * (10**18);
    uint256 private _totalSupply = maxCap;


    constructor() {
        _balances[msg.sender] = maxCap; //At the moment of creation all tokens will go to the owner.
    }

  
    function name() public view virtual returns (string memory) {
        return _name;
    }

   
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

  
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

 
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

  
    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

 
    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

  
    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

 
    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

 
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

 
    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }


    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }

  
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from zero address");

        if (recipient == address(0)) {
            _burn(sender, amount);
        } else {
            require(!isWhale(amount), "Error: Whale detected");

            uint256 senderBalance = _balances[sender];
            require(
                senderBalance >= amount,
                "ERC20: transfer amount exceeds balance"
            );
            _balances[sender] = senderBalance - amount;
            _balances[recipient] += amount;

            emit Transfer(sender, recipient, amount);
        }
    }

 
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

   
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}