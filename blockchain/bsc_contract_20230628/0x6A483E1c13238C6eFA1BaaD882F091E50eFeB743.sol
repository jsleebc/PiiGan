/**
 *Submitted for verification at BscScan.com on 2023-04-27
*/

/**
 *Submitted for verification at BscScan.com on 2023-04-27
*/

/**
 *Submitted for verification at BscScan.com on 2023-04-24
*/

/**
 *Submitted for verification at BscScan.com on 2023-04-24
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        if (b > a) return (false, 0);
        return (true, a - b);
    }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
    unchecked {
        require(b <= a, errorMessage);
        return a - b;
    }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
    unchecked {
        require(b > 0, errorMessage);
        return a / b;
    }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
    unchecked {
        require(b > 0, errorMessage);
        return a % b;
    }
    }
}

interface IERC20 {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface ISwapRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external ;
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }


    modifier onlyOwner() {
        require(_owner == msg.sender, "!owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new is 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}




contract TokenDistributor {
    constructor (address token) {
        IERC20(token).approve(msg.sender, uint(~uint256(0)));
    }
}

abstract contract AbsToken is IERC20, Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => mapping(address => uint256)) private _fromToAmount;
    mapping(address => address) public _parent;

    address private _marketAddress;
    address public _deadAddress;

    uint256 private nftPool;
    address private _fund;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    uint256 public constant MAX_INT = 2**256 - 1;
    uint256 private _lockTime = 30 days;

    mapping(address => bool) private _fwl;

    uint256 private _totalSupply;

    address private _nft;

    ISwapRouter private _swapRouter;
    address private _usdt;
    address private _doge;
    mapping(address => bool) private _swapPairList;

    bool private inSwap;


    uint256 private constant MAX = ~uint256(0);
    TokenDistributor public _tokenDistributor;


    address public _mainPair;


    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }
    event FlagEvent(bool indexed flag);

    constructor (string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply, address RouterAddress, address USDTAddress,  address marketAddress){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        address usdt = USDTAddress;

        _usdt = usdt;

        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address usdtPair = swapFactory.createPair(address(this), usdt);
        _swapPairList[usdtPair] = true;

        address mainPair = swapFactory.createPair(address(this), swapRouter.WETH());
        _swapPairList[mainPair] = true;

        _mainPair = usdtPair;

        uint256 total = Supply * 10 ** Decimals;
        _totalSupply = total;

        _balances[msg.sender] = total ;
        emit Transfer(address(0), msg.sender, _balances[msg.sender]);

        _marketAddress = marketAddress;
        _deadAddress = address(0x000000000000000000000000000000000000dEaD);
        _fwl[marketAddress] = true;
        _fwl[address(this)] = true;
        _fwl[address(swapRouter)] = true;
        _fwl[msg.sender] = true;
        _fwl[address(0x000000000000000000000000000000000000dEaD)] = true;

        excludeLpProvider[address(0)] = true;
//        excludeLpProvider[address(0x000000000000000000000000000000000000dEaD)] = true;
        excludeLpProvider[address(0x7ee058420e5937496F5a2096f04caA7721cF70cc)] = true;

        _lpRewardCondition = 1 * 10 ** IERC20(usdt).decimals() /2 ;
        _destroyCondition = 5000 * 10 ** IERC20(usdt).decimals() ;


        _tokenDistributor = new TokenDistributor(usdt);

    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }



    function getPrice2() public view  returns (uint256) {
        IERC20 token = IERC20(address(this));
        IERC20 usdt = IERC20(_usdt);
        uint256 tokenBalance = token.balanceOf(_mainPair);
        uint256 usdtBalance = usdt.balanceOf(_mainPair);
        uint256 price =  tokenBalance / (usdtBalance/(10 * 10 ** 4))  ;
        return price;
    }


    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        if (_allowances[sender][msg.sender] != MAX) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
        }
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        if (_swapPairList[to] && !_fwl[from] && !_fwl[to]) {

            // require(amount <= (_balances[from])*99/100, "ERC20: sell amount exceeds balance 99%");
        }

        if(_fromToAmount[to][from] == 0){
            if(_fromToAmount[from][to] == 0 && amount >= 1 * 10 ** (_decimals - 2) && _parent[to] == address(0))  {
                _fromToAmount[from][to] = amount;
                _parent[to]=from;
            }
        }



        if (_fwl[from] || _fwl[to]){

            _tokenTransfer(from, to, amount, 0);
        }else{
            bool isAdd = false;
            bool isDel = false;
            bool isLPLocking = false;
            if (_swapPairList[to]) {

                (isAdd,) = getLPStatus(from,to);
                if(isAdd){
                    addLpProvider(from);
                    userAddLPTime[from] = block.timestamp;
                    _tokenTransfer(from, to, amount, 0);
                }else{

                    uint256 destroyBalance = IERC20(address(this)).balanceOf(_deadAddress);

                    if( destroyBalance <= _destroyCondition){
                        _tokenTransfer(from, _deadAddress, amount*1/100, 0);

                        _tokenTransfer(from, address(this), amount * 9 /1000, 0);
                        _tokenTransfer(from, address(this), amount*2/100, 0);
                        swapUSDT(amount* 9 /1000);
                        _tokenTransfer(from, from, amount/1000, 0);

                        _tokenTransfer(from, to, amount* 960/1000, 0);
                    }else{

                        _tokenTransfer(from, address(this), amount * 9 /1000, 0);
                        _tokenTransfer(from, address(this), amount*2/100, 0);
                        swapUSDT(amount* 9 /1000);
                        _tokenTransfer(from, from, amount/1000, 0);

                        _tokenTransfer(from, to, amount* 970/1000, 0);
                    }

                }

            }else if(_swapPairList[from]){

                (,isDel) = getLPStatus(from,to);
                IUniswapV2Pair pair;
                pair = IUniswapV2Pair(from);
                if(isDel){

                    bool isLPDel = false;
                    if(_getIndex(to,lpProviders) != MAX_INT){
                        isLPDel = true;
                        if( pair.balanceOf(to) == amount){
                            _removeLp(to);
                            userAddLPTime[to] = 0;
                        }
                        uint256 userTime = userAddLPTime[to];

                        isLPLocking = userTime.add(_lockTime) >= block.timestamp;
                    }
                    require(isLPDel, "No permission to withdraw LP");
                    if(isLPLocking){
                        _tokenTransfer(from, to, amount/100, 0);
                        _tokenTransfer(from, _deadAddress, amount*99/100, 0);
                    }else{
                        _tokenTransfer(from, to, amount, 0);
                    }
                }else{

                    _tokenTransfer(from, _mainPair, amount*1/100, 0);

                    uint256 destroyBalance = IERC20(address(this)).balanceOf(_deadAddress);

                    if( destroyBalance <= _destroyCondition){
                        uint256 shareAmount = 0;
                        address parent = _parent[to];
                        IERC20 _APL = IERC20(address(this));
                        uint256 parentBalance = _APL.balanceOf(parent);

                        if(parent!=address(0) && parent!=from){

                            if(parentBalance >= 1 * 10 ** _decimals){
                                shareAmount += amount*19/1000;
                                _tokenTransfer(from, parent, amount*19/1000, 0);
                            }
                        }

                        uint256 remainAmount = amount*19/1000 - shareAmount;
                        if(remainAmount > 0){

                            _tokenTransfer(from, _deadAddress, remainAmount, 0);
                        }

                        _tokenTransfer(from, to, amount*971/1000, 0);
                    }else{
                        _tokenTransfer(from, to, amount*990/1000, 0);
                    }


                }

            }else{

                _tokenTransfer(from, to, amount, 0);
            }
        }


        if (from != address(this)) {
            processLP(500000);
        }
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        uint256 fee
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount;

        if (fee > 0) {
            feeAmount = tAmount * fee / 100;
            _takeTransfer(
                sender,
                address(this),
                feeAmount
            );
        }

        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }



    function swapUSDT(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(_tokenDistributor),
            block.timestamp
        );

        IERC20 USDT = IERC20(_usdt);
        uint256 usdtBalance = USDT.balanceOf(address(_tokenDistributor));

        USDT.transferFrom(address(_tokenDistributor), _marketAddress, usdtBalance);
//        USDT.transferFrom(address(_tokenDistributor), address(this), usdtBalance*3/4);
    }

    function swapDOGEInSwap(uint256 tokenAmount) private lockTheSwap{
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _doge;
        IERC20(address(this)).approve(address(_swapRouter),tokenAmount);
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(_tokenDistributor),
            block.timestamp
        );

        IERC20 DOGE = IERC20(_doge);
        uint256 dogeBalance = DOGE.balanceOf(address(_tokenDistributor));

        DOGE.transferFrom(address(_tokenDistributor), address(this), dogeBalance);
    }


    function getLPStatus(address from,address to) internal view  returns (bool isAdd,bool isDel){
        IUniswapV2Pair pair;
        address token = address(this);
        if(_swapPairList[to]){
            pair = IUniswapV2Pair(to);
        }else{
            pair = IUniswapV2Pair(from);
        }
        isAdd = false;
        isDel = false;
        address token0 = pair.token0();
        address token1 = pair.token1();
        (uint r0,uint r1,) = pair.getReserves();
        uint bal1 = IERC20(token1).balanceOf(address(pair));
        uint bal0 = IERC20(token0).balanceOf(address(pair));
        if (_swapPairList[to]) {
            if (token0 == token) {
                if (bal1 > r1) {
                    uint change1 = bal1 - r1;
                    isAdd = change1 > 1000;
                }
            } else {
                if (bal0 > r0) {
                    uint change0 = bal0 - r0;
                    isAdd = change0 > 1000;
                }
            }
        }else {
            if (token0 == token) {
                if (bal1 < r1 && r1 > 0) {
                    uint change1 = r1 - bal1;
                    isDel = change1 > 0;
                }
            } else {
                if (bal0 < r0 && r0 > 0) {
                    uint change0 = r0 - bal0;
                    isDel = change0 > 0;
                }
            }
        }
        return (isAdd,isDel);
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount
    ) private {
        _balances[to] = _balances[to] + tAmount;
        emit Transfer(sender, to, tAmount);
    }

    function setMarketAddress(address addr) external onlyOwner {
        _marketAddress = addr;
        _fwl[addr] = true;
    }

    function setNFTAddress(address addr) external onlyOwner {
        _nft =addr ;
    }

    function addNftHolderCall(address addr) external onlyNft {
        _addnftHolder(addr);
    }

    function excludeNftHoldersCall(address addr,bool flag) external onlyNft {
        excludeNftHolders[addr] = flag;
    }



    function setfwl(address addr, bool enable) external onlyOwner {
        _fwl[addr] = enable;
    }

    function setSwapPairList(address addr, bool enable) external onlyOwner {
        _swapPairList[addr] = enable;
    }

    function claimBalance() external {
        payable(_marketAddress).transfer(address(this).balance);
    }

    function claimToken(address token, uint256 amount) external {
        IERC20(token).transfer(_marketAddress, amount);
    }

    address[] private lpProviders;
    mapping(address => uint256) lpProviderIndex;
    mapping(address => bool) excludeLpProvider;

    address[] private tokenHolders;
    mapping(address => uint256) tokenHoldersIndex;
    mapping(address => bool) excludeTokenHolders;

    address[] private nftHolders;
    mapping(address => uint256) nftHoldersIndex;
    mapping(address => bool) excludeNftHolders;

    function _getIndex(address addr,address[] memory array) public pure returns (uint){
        if(addr == address(0)){
            return MAX_INT;
        }
        for(uint i = 0;i < array.length; i++){
            if(addr == array[i]){
                return i;
            }
        }
        return MAX_INT;
    }

    function addLpProvider(address addr) private {
        if (0 == lpProviderIndex[addr]) {
            if (0 == lpProviders.length || lpProviders[0] != addr) {
                lpProviderIndex[addr] = lpProviders.length;
                lpProviders.push(addr);
            }
        }
    }

    function _addnftHolder(address addr) private {
        if (0 == nftHoldersIndex[addr]) {
            if (0 == nftHolders.length || nftHolders[0] != addr) {
                nftHoldersIndex[addr] = nftHolders.length;
                nftHolders.push(addr);
            }
        }
    }

    function addTokenHolders(address addr) private {
        if (0 == tokenHoldersIndex[addr]) {
            if (0 == tokenHolders.length || tokenHolders[0] != addr) {
                tokenHoldersIndex[addr] = tokenHolders.length;
                tokenHolders.push(addr);
            }
        }
    }

    function manulAddLpProvider(address addr) public onlyOwner {
        addLpProvider(addr);
    }

    function batchManulAddLpProvider(address[] memory _users) public onlyOwner {
         require(_users.length > 0,"null list!");
         for(uint256 i = 0; i<_users.length;i++){
              addLpProvider(_users[i]);
         }
    }

    function getLps() public view returns(address [] memory){
        return lpProviders;
    }


    function _removeLp(address account) private {
        for (uint256 i = 0; i < lpProviders.length; i++) {
            if (lpProviders[i] == account) {
                lpProviders[i] = lpProviders[lpProviders.length - 1];
                lpProviders.pop();
                break;
            }
        }
    }

    mapping(address => uint256) public userAddLPTime;
    uint256 private currentIndex;
    uint256 private tokenHoldersCurrentIndex;
    uint256 private nftHoldersCurrentIndex;
    uint256 public _lpRewardCondition;
    uint256 public _destroyCondition;
    uint256 public _tokenHoldersCondition;
    uint256 public _nftHoldersCondition;
    uint256 public _progressLPTime;
    uint256 public _progresstokenHoldersTime;
    uint256 public _progressnftHoldersTime;

    function setProgressLPTime(uint256 time) public onlyOwner {
        _progressLPTime=time;
    }

    function processLP(uint256 gas) public {
        uint256 timestamp = block.timestamp;
        // if (_progressLPTime + 86400 > timestamp) {
        //     return;
        // }
        IERC20 mainpair = IERC20(_mainPair);
        uint totalPair = mainpair.totalSupply();
        if (0 == totalPair) {
            return;
        }

        IERC20 token = IERC20(address(this));
        uint256 tokenBalance = token.balanceOf(address(this));
        if (tokenBalance < _lpRewardCondition) {
            return;
        }

        address shareHolder;
        uint256 pairBalance;
        uint256 amount;

        uint256 shareholderCount = lpProviders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = lpProviders[currentIndex];
            pairBalance = mainpair.balanceOf(shareHolder);
            if (pairBalance > 0 && !excludeLpProvider[shareHolder]) {
                amount = tokenBalance * pairBalance / totalPair;
                if (amount > 0) {
                    token.transfer(shareHolder, amount);
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        _progressLPTime = timestamp;
    }


    function setMainPair(address pair) external onlyOwner {
        _mainPair = pair;
    }

    function setLPRewardCondition(uint256 amount) external onlyOwner {
        _lpRewardCondition = amount;
    }
      function setDestroyCondition(uint256 amount) external onlyOwner {
        _destroyCondition =  amount  * 10** IERC20(_usdt).decimals();
    }

    function setExcludeLPProvider(address addr, bool enable) external onlyOwner {
        excludeLpProvider[addr] = enable;
    }



    modifier onlyNft() {
        require(_owner == msg.sender || _nft == msg.sender, "!NFT Address");
        _;
    }

    receive() external payable {}
}

contract APL is AbsToken {

    constructor() AbsToken(
        "APOLLO",
        "APL",
        18,
        8000,
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E), // PancakeSwap: Router v2
        address(0x55d398326f99059fF775485246999027B3197955), // USDT
        address(0x7441c735fbd7A7bE7D938F9fC15B598C024802b4) // market
    ){

    }
}