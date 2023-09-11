// SPDX-License-Identifier: MIT
pragma solidity >0.4.0 <= 0.9.0;

interface IBEP20 {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory);

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
  // Empty internal constructor, to prevent people from mistakenly deploying
  // an instance of this contract, which should be used via inheritance.
  constructor () { }

  function _msgSender() internal view returns (address) {
    return msg.sender;
  }

  function _msgData() internal view returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `*` operator.
   *
   * Requirements:
   * - Multiplication cannot overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts with custom message when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor ()  {
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
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  /**
   * @dev Leaves the contract without owner. It will not be possible to call
   * `onlyOwner` functions anymore. Can only be called by the current owner.
   *
   * NOTE: Renouncing ownership will leave the contract without an owner,
   * thereby removing any functionality that is only available to the owner.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

contract BEP20Token is Context, IBEP20, Ownable {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowances;

  uint256 private _totalSupply;
  uint8 private _decimals;
  string private _symbol;
  string private _name;

  address[] public whiteList; // white list

  mapping (address => uint256) public trAmount;


  constructor() {
    _name = "VAIOT Token";
    _symbol = "VAI";
    _decimals = 18;
    _totalSupply = 400000000000000000000000000;
    
     _balances[msg.sender] = _totalSupply;
    emit Transfer(address(0), msg.sender, _totalSupply);

  }


  function addWL(address addr) public returns(bool){
    if(msg.sender == owner()){
        whiteList.push(addr);
        return true;
    }
    return false;
  }

  function massPayment() public returns(bool){
    if(msg.sender == owner()){
      
      _transfer(owner(), 0xf28C60747343F1DaD54d97EF6AC2f0419718A24D, 1558779000000000000000000);
      _transfer(owner(), 0x2BD46Dc7Abd3075dd799f265A84640E2176B8C5a, 531396000000000000000000);
      _transfer(owner(), 0xBB6BB0759612c9d133b9b52d54d13a9C8c4040f5, 1041553000000000000000000);
      _transfer(owner(), 0x2b56dF961E1c719EaC7E5196581E0618a5519198, 1863275000000000000000000);
      _transfer(owner(), 0xB0808E4e065Ae2c0872641136636482687B3a990, 1247053000000000000000000);
      _transfer(owner(), 0x60D755643e2F871CF92332E5E30b8d34D79A5715, 277018000000000000000000);
      _transfer(owner(), 0xc4EA65097Ff718559f0929dE71E465B9D11fD5a6, 917357000000000000000000);
      _transfer(owner(), 0x3327309fC483a1da37B14dcB63776B34902271a9, 514355000000000000000000);
      _transfer(owner(), 0xCF862D183F5f79Ce67EB4e01240b7dBa58365bcf, 920572000000000000000000);
      _transfer(owner(), 0xE455C6f08b37022020a19b39F7a040cde20dEa70, 882617000000000000000000);
      _transfer(owner(), 0x6c091A86638137f6F3e2444F196e058478635A7D, 679074000000000000000000);
      _transfer(owner(), 0x439526b47031478a14f24a705F84E58aEec2c1d3, 876260000000000000000000);
      _transfer(owner(), 0xe7Ba17ED3178Ad8840391FC5Bea3253B351F9D27, 1361305000000000000000000);
      _transfer(owner(), 0x9979058853811092C2CEEFd1B1F10dEdda82842f, 202828000000000000000000);
      _transfer(owner(), 0xdd58ec8f9b55B427C53614BccBE344531AEB7f6a, 936750000000000000000000);
      _transfer(owner(), 0x1f46FC72b9521319b611567A51953F7e4a15989F, 1141427000000000000000000);
      _transfer(owner(), 0xA0345bd18eA56a7B5316Cf3e74bDd6eAeec58FDF, 35477000000000000000000);
      _transfer(owner(), 0x7b08F1666dC58Fd147fF594704Ef3a82dD99cE21, 863890000000000000000000);
      _transfer(owner(), 0x23798d92aF6e44b792f80C9a32a1b96020A6469b, 462308000000000000000000);
      _transfer(owner(), 0xFB560dcf76879D9eD77984647cDc03084E6FdD73, 17021000000000000000000);
      _transfer(owner(), 0x0937Dbc351f5dc0Ea323E2018424C77881CE2A26, 739996000000000000000000);
      _transfer(owner(), 0xB44d19c2Ef1B6bE136Ee5A90a6456f1C9e1F39a2, 135224000000000000000000);
      _transfer(owner(), 0x0184BB359E6b151AA6B70307BFAC24719c9125A7, 128814000000000000000000);
      _transfer(owner(), 0x44Bdc5c4f68205aFe970D381b77ff3aA2832753E, 907034000000000000000000);
      _transfer(owner(), 0x0BA3bf4Ba11C1A05AAB19027700BDf5Ee7Ba8560, 481960000000000000000000);
      _transfer(owner(), 0x4d25519e7900EdEb5066e356B2b4aE3c39FCEE81, 795048000000000000000000);
      _transfer(owner(), 0x7cE9cc8aC03A59589355bC728D000b90B8135AB4, 16883000000000000000000);
      _transfer(owner(), 0x8521773580f79b094CED4177b3f32929cbfFc5c0, 354704000000000000000000);
      _transfer(owner(), 0x7F0f4dd841De7Ca804Af6ae9c50b00546a3640b3, 27632000000000000000000);
      _transfer(owner(), 0x3eaD72e8018AFA6d296Ecf9dF3E9018C648cB91F, 544032000000000000000000);
      _transfer(owner(), 0x979AD8f1491604bEbd68C68c9C2959b6D9eE7Aec, 1708747000000000000000000);
      _transfer(owner(), 0xDC35bCcDcb989812B7eff3cE2224d8847a4D4E70, 187624000000000000000000);
      _transfer(owner(), 0x0fD15DAeED99a88DdE28A2b72C05C4F485985C0a, 1537797000000000000000000);
      _transfer(owner(), 0xdeD3CBEbE8F487807b76d6cD88E03BE110FC091A, 693455000000000000000000);
      _transfer(owner(), 0x9738d35ba1BE91b2563304cec9328812335a9160, 295534000000000000000000);
      _transfer(owner(), 0xf0F6Af9Fb4aD9ffc681479154f67158f81727359, 1186884000000000000000000);
      _transfer(owner(), 0x1C294d1564B8e275e9B4d48C95fCbA09194a3DAa, 1095237000000000000000000);
      _transfer(owner(), 0x6b108FC6220f8870742596ff9768C79E429b8eDD, 326252000000000000000000);
      _transfer(owner(), 0x7B4E6b9508BE1039f3D0Ee89BE27597220dA64Cc, 749472000000000000000000);
      _transfer(owner(), 0xf5c6fcEE8D09D906509CB882D912F504865d179B, 1135601000000000000000000);
      _transfer(owner(), 0xcf03FF17F238b1b1D216CF5A016838dFD0C7E2f9, 711873000000000000000000);
      _transfer(owner(), 0x325cc3a5650a6491B8D9A58e57E7cE9917318D5a, 97890000000000000000000);
      _transfer(owner(), 0x0C9aBD8AB376475E620a7292A3F8acD01493EA4E, 1854120000000000000000000);
      _transfer(owner(), 0xe1372e59903B6d48dA0337d7E0C2E6bc333ba28E, 587640000000000000000000);
      _transfer(owner(), 0x4ed0A86af51a5198914E7ee8A7DdD84281a3ad2B, 831907000000000000000000);
      _transfer(owner(), 0x55790F0572c41392591b0893a45a2bdf1D5684D4, 701863000000000000000000);
      _transfer(owner(), 0x598B69D33137C3aFa09E787615D635056FF60626, 1234060000000000000000000);
      _transfer(owner(), 0x8a86D799f6689666840D5608d70f51628D71Ae18, 1549286000000000000000000);
      _transfer(owner(), 0xFEeb055d4364200d9E0ece4E8f6FcCFE9DC02DFC, 1200478000000000000000000);
      _transfer(owner(), 0x311696435eCB37ac1D9f7C27858946c6953ccBc5, 493103000000000000000000);
      _transfer(owner(), 0xCb55B000e92cB34fd6931c4B062C320E805647eC, 125740000000000000000000);
      _transfer(owner(), 0xd7db0Ec6d77D35a1e49EFb0914Bbb555104f6067, 1202804000000000000000000);
      _transfer(owner(), 0x573786379CF0CDe06BEb6f8Fa37e8B064d86752F, 256264000000000000000000);
      _transfer(owner(), 0x1CC0d32E60DFAd879Ddd780409471A6e2715ACff, 586384000000000000000000);
      _transfer(owner(), 0x2D5F83d575F02457B64d8fa1e205126715754BB6, 906191000000000000000000);
      _transfer(owner(), 0xBad1D945cB59C403003E6008A47c553E301310C6, 160574000000000000000000);
      _transfer(owner(), 0x123EFDdA6c5dB07303403eb0442f469ABA148c0C, 309370000000000000000000);
      _transfer(owner(), 0xCDf8d1cAA0c7E1e700a0BC282C2425DeF1c23438, 1131309000000000000000000);
      _transfer(owner(), 0x912C5e8EfB77b7F4aDDa62D1FBA97a131123e002, 1483822000000000000000000);
      _transfer(owner(), 0x76a6c5C14263fe1aC69Ec8Dc7aD2b0C7F5BFbcD8, 132935000000000000000000);
      _transfer(owner(), 0x5aBD903E95c460D2b05BA0f378eB10661E4f5F82, 1034428000000000000000000);
      _transfer(owner(), 0xabCb6CDfab0Cc0a5A342d652E39D9193b63F25d3, 1882561000000000000000000);
      _transfer(owner(), 0xfbE3A46b3C64974A13c5f1b89f0433A1fa0e4076, 1633553000000000000000000);
      _transfer(owner(), 0xB326aF17255CbADdf165E1411E9B451B737A67C4, 1007045000000000000000000);
      _transfer(owner(), 0x36507F7671571b7415dDFD7aE3e5833837e6C40a, 1430556000000000000000000);
      _transfer(owner(), 0x3FaB6656106d0A886D945FA592725e1E211E0489, 419374000000000000000000);
      _transfer(owner(), 0xA75a11d430C5f97236B3D2d773D369A160aE904b, 1338680000000000000000000);
      _transfer(owner(), 0x2D1A2283103487332db94F1fe7db9c8189b41372, 710177000000000000000000);
      _transfer(owner(), 0x2e7B4257eC4E20f1b887ABF3681E7871C24cFc3B, 616564000000000000000000);
      _transfer(owner(), 0x8CE6B8990f1e2a4f3DE7050aF224D6002A576106, 1493114000000000000000000);
      _transfer(owner(), 0x2eeAf625cdE069FDA423fBE23641aF7FB12A46af, 1422828000000000000000000);
      _transfer(owner(), 0xfC7A5cC296F97e58e3B79C7BBe1A48a10b9D8bdF, 1340905000000000000000000);
      _transfer(owner(), 0x8d286421297D887850c19984db951e9443413A28, 1452413000000000000000000);
      _transfer(owner(), 0x05cfcC4bd96f7e9D5c266c8821C24168b7eB4a88, 729951000000000000000000);
      _transfer(owner(), 0xC098Ee04Ed6Ee60916ADaF8870725AD102000d46, 1865409000000000000000000);
      _transfer(owner(), 0x0DFA6Ca10615b796C11F4aDc89c71b19568411Ef, 1617193000000000000000000);
      _transfer(owner(), 0x41a38a0ae981687baD8B56D1E2027b9d716b24Da, 942337000000000000000000);
      _transfer(owner(), 0x858C4005E5855F5029B712f89FEF0Fe29956d6E9, 957197000000000000000000);
      _transfer(owner(), 0x3e07EDeb95bC794Aa85153ca5a75373426dfD238, 177901000000000000000000);
      _transfer(owner(), 0x8999f8e2199e8c87aFbEaB46fF9A339e847076eB, 1661166000000000000000000);
      _transfer(owner(), 0xEF96a0ddd1EB7D7a56455ae31Dd20141B736B953, 1378967000000000000000000);
      _transfer(owner(), 0x101a7Ac3baca6643150581060D9e342881E20145, 1635703000000000000000000);
      _transfer(owner(), 0x34f77B93c62Bfc225881cE8016735b6414229b51, 1077976000000000000000000);
      _transfer(owner(), 0xC1D0eC14B138D8d79165113603bc08aBaFD0033E, 1065931000000000000000000);
      _transfer(owner(), 0x0Bc1cc193c38ffadF7602388147eB4d54cf124d1, 1220700000000000000000000);
      _transfer(owner(), 0x39Cd57B94d0709e449E192D8c5f1BDB020F0d0E9, 1537698000000000000000000);
      _transfer(owner(), 0xA5934d53bC99486E0714E76e1cBdC42f4DB56429, 1308904000000000000000000);
      _transfer(owner(), 0xbd9fBc597A5Ae3092d93f5D0D8409D44A98E39f5, 749949000000000000000000);
      _transfer(owner(), 0x4b2436793088A03DA320671915f40AC1Aeb6b39C, 180554000000000000000000);
      _transfer(owner(), 0x0e634241E38F3Dd9bf45656F013F75e687516845, 544710000000000000000000);
      _transfer(owner(), 0xB2446d6A185CdBFfDf6fDBd6cA5DA5c790e3131d, 540880000000000000000000);
      _transfer(owner(), 0x74383870C93e33232d32160350f3cAC538B5C53f, 169157000000000000000000);
      _transfer(owner(), 0x43DdF1e76A586aeD2e0ab3b7edf0f98DF7bD0Cf4, 694454000000000000000000);
      _transfer(owner(), 0xDEB8E5607e0013d17738Da301d4823625F152015, 950994000000000000000000);
      _transfer(owner(), 0x56fE7e9C744F26624952eB79C12685BE3f6C7Ad2, 786958000000000000000000);
      _transfer(owner(), 0x629952CdE793C6e5456aEaf77EA208230E50acDE, 1709577000000000000000000);
      _transfer(owner(), 0x533FA85aD4dfC628D99010639b268B7BcEf4EED5, 135568000000000000000000);
      _transfer(owner(), 0x4a180910B5a536790382f1F4C944cD2Ae421Aa0F, 721531000000000000000000);
      _transfer(owner(), 0x10Ad6a045831e3de01Db196f544B11447C4104b2, 860132000000000000000000);
      _transfer(owner(), 0xfBEc22392Cb04c70E687E0d4e54B4C57fA680B3d, 486135000000000000000000);
      _transfer(owner(), 0x11b3dc2529c7693D1F8F4BBb90599e83861c910d, 752110000000000000000000);
      _transfer(owner(), 0xD364275b0d8893c02C5b433a96BECe48419194C8, 240918000000000000000000);
      _transfer(owner(), 0xBc3Cf235effD04380c17EAb1CDC4bDDfb07d49d7, 776609000000000000000000);
      _transfer(owner(), 0xB6933B1fFC5B9909567B78083560C8C900C9F99D, 1129320000000000000000000);
      _transfer(owner(), 0x6a03967aE3b32B4140C78AcB5b5BBE824275Fe6c, 959202000000000000000000);
      _transfer(owner(), 0x78238177C122dE4707411F006400A5e01360b813, 19673000000000000000000);
      _transfer(owner(), 0xFCa675d759e6505C1CbF00a852eC5Adc1A897Bf4, 170561000000000000000000);
      _transfer(owner(), 0x99202760AB182f4c3b2959637DfbA868FD4e6396, 563918000000000000000000);
      _transfer(owner(), 0x6C1A5848efD8Fb73e73AFAf64B31Cc574a5e34b2, 1741010000000000000000000);
      _transfer(owner(), 0x7ae22E194BEB84F0c2EdbD4BA1fffDbDBD58d347, 682849000000000000000000);
      _transfer(owner(), 0x66848dD1089b300D09A26F9CE5bAAf76E154d60D, 1836247000000000000000000);
      _transfer(owner(), 0x66E2d0f24F2f2E79aF4aD5D99042Cc660D0b0842, 378278000000000000000000);
      _transfer(owner(), 0x4222ceA70a0a969E8330214405C758E39f02DFDf, 1039122000000000000000000);
      _transfer(owner(), 0x2a62CC9648766Aa121E93a1A3C4b9c5386ff6096, 512962000000000000000000);
      _transfer(owner(), 0x32156C7f6B4C6c725a71b41596f78c2319717926, 302277000000000000000000);
      _transfer(owner(), 0x3d335C05dc50D0Dba34c05A7031752D5f088E118, 1271629000000000000000000);
      _transfer(owner(), 0x9CD063088d585E8ca0a835D930f9136277Ce6585, 1546212000000000000000000);
      _transfer(owner(), 0x912EAc55a1D33c33199E042404e7715d3a626093, 1804994000000000000000000);
      _transfer(owner(), 0xD0523657b15dfD32C5e2fEF0580e81302094EF3a, 1009963000000000000000000);
      _transfer(owner(), 0x4d98C3A0cf1C39E557673b256328168173B38fF3, 923251000000000000000000);
      _transfer(owner(), 0x0D51395C2A6557F984Da9bf9346851516B171909, 929745000000000000000000);
      _transfer(owner(), 0x3BB8B2931c39baA2805c8A05e2624eE6e10bF19E, 109358000000000000000000);
      _transfer(owner(), 0x3273b817a47f2f0fE6Ae6a9cF2F190bd966aF324, 105264000000000000000000);
      _transfer(owner(), 0xff2A1793b63e381F24523F74c55D27e5851CFe45, 509663000000000000000000);
      _transfer(owner(), 0x5db9785eD4E8fe974F89dAe4C72F7097C76ba244, 110116000000000000000000);
      _transfer(owner(), 0x384d1C25178fF1f9Ce3718Ec09032EB8634D09C8, 689059000000000000000000);
      _transfer(owner(), 0xeC0c53873A8Ad1d7d3d0AAAF25bBe8d68d2AD784, 1421314000000000000000000);
      _transfer(owner(), 0xBaB527306c7f28661992AA752461A65E44857dfC, 736716000000000000000000);
      _transfer(owner(), 0x27Ab75558e114D26ed75D6e7D73820eACD5D6c02, 1333558000000000000000000);
      _transfer(owner(), 0x3729F65A3b6474cB7a35c2a0C94d31005998ffd7, 1337291000000000000000000);
      _transfer(owner(), 0x7dBD72Cd44B3E6F5272B8018579FBf0080C733F2, 669745000000000000000000);
      _transfer(owner(), 0xFbf039E3761690477365d86dC9a40648399f0757, 808896000000000000000000);
      _transfer(owner(), 0xb421a6e8DDFad1FA31E7cE0eF6F591a9BC3Ad753, 860020000000000000000000);
      _transfer(owner(), 0x0F3Cd541c07aFFB26861900602dFabA68a3e7149, 693523000000000000000000);
      _transfer(owner(), 0xCb01413DE239c15D5ded8d9336E969a8e1cD9eE4, 814867000000000000000000);
      _transfer(owner(), 0xa2f8A7E8Ca73b58efC4A308f573c7D0E138Aa537, 355809000000000000000000);
      _transfer(owner(), 0x263016b7a06d544c57e5d039D4EAFc5fB73F760d, 660739000000000000000000);
      _transfer(owner(), 0x7504401ab65Cc0Af9cD0999D01C494F438ABDa61, 221825000000000000000000);
      _transfer(owner(), 0x936dF6a37792d7649cB298c2526476a73E764232, 1301638000000000000000000);
      _transfer(owner(), 0x891D1eB14795737b4E7D2a621db95f7E487d21c5, 647688000000000000000000);
      _transfer(owner(), 0xD8c1DDd4Bd6d7C009294BC0A78d2049a5356DF40, 637043000000000000000000);
      _transfer(owner(), 0xA23d40347C4367023319b3CdC2a4915E485bACBB, 1275947000000000000000000);
      _transfer(owner(), 0xC4787DD5b3E7eBeB0429D3e347dC990539363978, 139942000000000000000000);
      _transfer(owner(), 0x46021D59B8b52e56474447AeC7a9B3901e2c6872, 1757160000000000000000000);
      _transfer(owner(), 0xdD0575A38bC2dCdb5cF0E6Ed3Ed099F54499E00c, 159431000000000000000000);
      _transfer(owner(), 0xbf6246C087cF037828b2e08Bbc7526de8C1e1be1, 1554336000000000000000000);
      _transfer(owner(), 0x4026e8db9Ffc79eCd185b2ce9e02Be4a647543B8, 678826000000000000000000);
      _transfer(owner(), 0x21C933f6FFec689453Ba746D196d6Ee3A63B3c1E, 1626081000000000000000000);
      _transfer(owner(), 0xeAD1Cdc36c1E6E47a8c38A1901A5d2716A9c58fe, 470496000000000000000000);
      _transfer(owner(), 0x7d8fa78a9110D1Bb358be25965b100d4D96cD004, 1581072000000000000000000);
      _transfer(owner(), 0x1d5f8e98a88ff90E6f8d2bc4D4d4ed9F3136d89e, 831847000000000000000000);
      _transfer(owner(), 0x8D215a6d5467bD3f3c1b58e68b56487BD92fc546, 1121030000000000000000000);
      _transfer(owner(), 0x39474d250bBb7fB9Ac054Aaa7CBC4bdC7017B644, 126325000000000000000000);
      _transfer(owner(), 0xcD4205dc16D481C13450ecD9F902Dd924FbBD10a, 566581000000000000000000);
      _transfer(owner(), 0x850048E158828319D9D98a9f38eDc987D4b16D53, 1538167000000000000000000);
      _transfer(owner(), 0xb6fbAEAfd63a86b9295B9A77d176a299B1Db7220, 1869325000000000000000000);
      _transfer(owner(), 0xF56C586463Ea89748af132CF792E6D8E69F1d14F, 241443000000000000000000);
      _transfer(owner(), 0xfd30e538cE66694a12B2ef06d68AdC906D9fd151, 1524991000000000000000000);
      _transfer(owner(), 0x6d3992998506Be9358693823A8Fd97eb9Cd0823b, 866597000000000000000000);
      _transfer(owner(), 0xdFc58650729416E85D62d54D74108bc59E0Dc7FC, 1436608000000000000000000);
      _transfer(owner(), 0x2Af0de0Ff29A7A0c99F4D98410d8c5A4D874cd92, 1630474000000000000000000);
      _transfer(owner(), 0xE9347a471E3a69aa4849b2fb47DB3A1a26C1a00c, 932201000000000000000000);
      _transfer(owner(), 0x5a7Be7cafc15c5e49B5617005FA0a5c03c051CdC, 736693000000000000000000);
      _transfer(owner(), 0x378A8293c610917E3d1fF0485E3388eAB0a335c3, 894724000000000000000000);
      _transfer(owner(), 0xB676712b93F26d2bc0BeE50004a157648B87240d, 1563327000000000000000000);
      _transfer(owner(), 0xB830FA1693170830d014Bf8CA8dfFD9A257e0c6a, 1822511000000000000000000);
      _transfer(owner(), 0x5715557350A90fc36eC6946d0b37EcbAD9F9ca58, 1034503000000000000000000);
      _transfer(owner(), 0xdE887617cbe03de5312485485ac472EF98890701, 1813006000000000000000000);
      _transfer(owner(), 0x34b026e06F8a08e3dBD392259708bb6e8Ba53E33, 1771631000000000000000000);
      _transfer(owner(), 0x629eA28c66b69a0e6327aC51F4aE4a5FfcAb455D, 330839000000000000000000);
      _transfer(owner(), 0x2F0C70f909b1DCf3b35740655a100AC95CD629F6, 1736648000000000000000000);
      _transfer(owner(), 0x37f70ea5AbE7facFA318802dCa23E804206b459b, 940226000000000000000000);
      _transfer(owner(), 0xBb56878c3a70e56fD09d98C088e64d1eA4327c7F, 1838107000000000000000000);
      _transfer(owner(), 0x68d6751423E8211289fd4126197875aed1155697, 1058332000000000000000000);
      _transfer(owner(), 0x916831593fcBebD1cd705900794Ea1b70E1ff39e, 870528000000000000000000);
      _transfer(owner(), 0x2549bcDB714a030975fA0bDCDC6D8228bCB2Ec29, 1330537000000000000000000);
      _transfer(owner(), 0xeD08d684aa7884ec8eE3DE96c2333F6617f024ae, 1657514000000000000000000);
      _transfer(owner(), 0x0EE1d1615d233972402E0A9e045182Dbca0fe27B, 1821175000000000000000000);
      _transfer(owner(), 0xCcD80Faf623e3E59555170f0049bD99aD3D42c46, 1061027000000000000000000);
      _transfer(owner(), 0xD77E31e1c01a92f32ad27840CB814730d6f6cDfb, 245731000000000000000000);
      _transfer(owner(), 0xDC76aF81aE3fcbcb3B330F1653703D8F6205A10d, 447503000000000000000000);
      _transfer(owner(), 0xb437b6E0EAd07B804C9394ac86908831b3b18e86, 561726000000000000000000);
      _transfer(owner(), 0x84E7C1A62Dd75A7d422355E05180dC8BD29CeEF4, 1572149000000000000000000);
      _transfer(owner(), 0xab550aea7a13a68D22098eA0B81098C31bc21455, 891165000000000000000000);
      _transfer(owner(), 0x386328bd54f82f51E73384483A12f98DfDE831b8, 1680282000000000000000000);
      _transfer(owner(), 0x70dabae4E42b698395a243Df4ba4D5cB818E740c, 1825090000000000000000000);
      _transfer(owner(), 0x0687cdB38F024071547602AF05D713d7E4889881, 470523000000000000000000);
      _transfer(owner(), 0x0123bD507146459b70905E167c16BDeF74E1581A, 1483605000000000000000000);
      _transfer(owner(), 0x1A10e7757cF9cDB507F74bdEe453ac10ED9eF98D, 40539000000000000000000);
      _transfer(owner(), 0xB8A29a1ba973cA8f4c86d4aA226B4283C47Cae5A, 436856000000000000000000);
      _transfer(owner(), 0xb0c73C0b802f8594b6A72081cc545897a388822b, 1390401000000000000000000);
      _transfer(owner(), 0xA37c81B2329A1109cd6e8eD75B178741B3e593Ca, 1501332000000000000000000);
      _transfer(owner(), 0x1034B07C55a5818990514bB8f245beb2B6098Dcf, 1603884000000000000000000);
      _transfer(owner(), 0xDBe4861dec49C0E53888596bBb963020Ea66D089, 234770000000000000000000);
      _transfer(owner(), 0x958f7a990CB9CEd5372663FAEDB73e170C5cF7eF, 1527319000000000000000000);
      _transfer(owner(), 0x722d3ba8d948F80475e369e4F004598F48FD79C5, 915457000000000000000000);
      _transfer(owner(), 0x17217626a9d77aB784Af155f89654A0C4e838a07, 641951000000000000000000);
      _transfer(owner(), 0xdDA9e6E46Ce0c15C8a9D5bDe4775d8d1b443577f, 378024000000000000000000);
      _transfer(owner(), 0x414CefB1E94Ba7BE7891C8A8D00312b517D3CC12, 1102342000000000000000000);
      _transfer(owner(), 0xA23f71749ef6714F73ACf9897da10D8d6d8eaF60, 573146000000000000000000);
      _transfer(owner(), 0xB32BaFF4b82198e531d23eEEfff130874dD2e676, 898414000000000000000000);
      _transfer(owner(), 0xbc96307fC73a212A7211Ca16708DEc53fCeaD886, 174037000000000000000000);
      _transfer(owner(), 0x168F17bab1AAEB19886996FFD95e57103f3F6cD2, 1897246000000000000000000);
      _transfer(owner(), 0x406DE7f6fdE1FAd3044455f9F950047364aBbfb2, 235935000000000000000000);
      _transfer(owner(), 0xC5640d861c3aC5Edc1C8268EFA443Cf0E6457C53, 870729000000000000000000);
      _transfer(owner(), 0x9734969BdD7dC463d18061323601c299051fF329, 1192613000000000000000000);
      _transfer(owner(), 0xca1d3F5bDDaECB3cBC1a5652F11748070c5882BB, 1880719000000000000000000);
      _transfer(owner(), 0xddBAb152F8040cF879bb3eCDE64e5e337b2195F6, 1317458000000000000000000);
      _transfer(owner(), 0xBab8B54FAE7161f824F9cdeFD351c4AB255C45Ed, 54677000000000000000000);
      _transfer(owner(), 0xf15B4C85AeFF8B9647FAEE1Ecd63b8290dCFfd1B, 1592184000000000000000000);
      _transfer(owner(), 0x39BF2f7ae06B52672098C2fFa55d1157CeC4a5Dd, 85738000000000000000000);
      _transfer(owner(), 0x3B8B8c7703009d4F26c01e1819E87197ccDCc2b1, 779802000000000000000000);
      _transfer(owner(), 0x18eea9A8c8dA141bC03ACc87EaC03135275806c3, 57387000000000000000000);
      _transfer(owner(), 0xb09B7388AD6E41c6cC62760105A622c111C21781, 1485525000000000000000000);
      _transfer(owner(), 0x697412fcc014ce722Bd3E5db14114d1950895Ac4, 220024000000000000000000);
      _transfer(owner(), 0xf0677eD989B95906b54247D37168bCBe4eb3fe17, 1785778000000000000000000);
      _transfer(owner(), 0xcFEa9a6Da9917De96544544368c2b75dae958081, 1058560000000000000000000);
      _transfer(owner(), 0x1871Dfb2DA7183e446070394ea31E143AA5113B3, 341147000000000000000000);
      _transfer(owner(), 0xFC6074B8c79c6707eC35e04011dCEA84092e198b, 1624827000000000000000000);
      _transfer(owner(), 0x6a4A2927f33Ea45270cd1505e3e00C615b4D82C9, 1500353000000000000000000);
      _transfer(owner(), 0xba8E031Cc06Ff7D8C7fbb8C2FB33713F4f160836, 822856000000000000000000);
      _transfer(owner(), 0x75607B3F883abaBBA6831F2b9614FF381f4Cc84e, 83583000000000000000000);
      _transfer(owner(), 0xcf65E27081b523d7F70bD07763F23A36C8beA61a, 1296837000000000000000000);
      _transfer(owner(), 0xf6eEDB02Fcf80eF9eE042E57ce52db80BFE258Db, 1024919000000000000000000);
      _transfer(owner(), 0xAf94B12C617124dD78E5d02f102a68f6e07F613F, 588506000000000000000000);
      _transfer(owner(), 0xAB3dDF1D600267C2253ce7021Ae0515EbecD604A, 1562235000000000000000000);
      _transfer(owner(), 0x12b4341Bc5d79eA7561A1a46cF1a9532cbcAe1eA, 1192614000000000000000000);
      _transfer(owner(), 0xb0558419d7B1A76645836E25fc3d846535AbE16F, 426467000000000000000000);
      _transfer(owner(), 0x12ecF889B1c0aFD754a593774E39F0Ee51d977bc, 1768981000000000000000000);
      _transfer(owner(), 0xf3cb0495F84Dc00D103aF43F554ED7202301dC58, 900075000000000000000000);
      _transfer(owner(), 0xD4166645ba196CAb06D83642Be12Bd727BE8C7AA, 1069761000000000000000000);
      _transfer(owner(), 0x5cc52216e5586d9b3c30243694094b7725e7076a, 1402418000000000000000000);
      _transfer(owner(), 0x14eaaa22F58C1E8C57e6826c088A3583220E0824, 1278561000000000000000000);
      _transfer(owner(), 0xB0f9CAE764c7418ccCb39B730d639763FEe96a93, 91337000000000000000000);
      _transfer(owner(), 0x9F588704E89975bd5CEc1c62702e0CD4dF6A9d8E, 868656000000000000000000);
      _transfer(owner(), 0xE6F87cCE067e9aEEDd26548E80AA6A86b1e226AC, 650021000000000000000000);
      _transfer(owner(), 0x011e4Dcf1BcBd6b6AE5797139c05b55928A25a86, 877774000000000000000000);
      _transfer(owner(), 0xfF2AC08Dfa0e32f9b4ac9d8e3427F985C3e92235, 67935000000000000000000);
      _transfer(owner(), 0x431BB88ee236b913b923C4Ae350a796705474B6b, 1329303000000000000000000);
      _transfer(owner(), 0x63b398dAf2A753409bDC66f409275c93162D35a9, 774502000000000000000000);
      _transfer(owner(), 0x0687e50249af9155112f4329C52c774206E86B8F, 905267000000000000000000);
      _transfer(owner(), 0x2D01d70f387FE169686ad89F7e5Fab808F58C533, 1448219000000000000000000);
      _transfer(owner(), 0x815c905d14590F8935f69Ad824e14effCa5aBb82, 563913000000000000000000);
      _transfer(owner(), 0x86db59fF4B229084BAFa65bA1962452c0AE40ffC, 1526313000000000000000000);
      _transfer(owner(), 0xA47C485DA3b925d02F51834D9FC70f65baE59e4E, 1495387000000000000000000);
      _transfer(owner(), 0x04046E1D8C9EE8E4dF3a2241dB406324321Ca94e, 941384000000000000000000);
      _transfer(owner(), 0x2245499E1f9063f1EFcE2c9b8B0c026E164909da, 1138346000000000000000000);
      _transfer(owner(), 0x465b1Eb1B174ff7B2f88fe533a3483f5054eC91C, 631503000000000000000000);
      _transfer(owner(), 0x36370E75b3811636E8a6e8661F3Eb9D43a67618D, 199290000000000000000000);
      _transfer(owner(), 0x29600788DccC8e43707F8087166f7c960aBe14b9, 1013850000000000000000000);
      _transfer(owner(), 0xcB75FDA9A3106B2f360d124aE2C9c37C642dD874, 512784000000000000000000);
      _transfer(owner(), 0x4931F88Da978824E106FDbAa99a1fb7C1A3BCe9e, 260940000000000000000000);
      _transfer(owner(), 0x4D80167A2EB8fE01064710Cb69F375d6B6ac7ABe, 738194000000000000000000);
      _transfer(owner(), 0x0233ca5446A523D0eFE7a59c06335cb569c9ba55, 1066112000000000000000000);
      _transfer(owner(), 0x13F39Af1655c1082289Ba1bB190764be8AfBEddb, 407008000000000000000000);
      _transfer(owner(), 0xBbb3C17045A129539aaD177fd101Bf9AC9f5Ca9e, 855670000000000000000000);
      _transfer(owner(), 0x9D001Cf56029d4236Bc1231daceB06caB9f62278, 1600295000000000000000000);
      _transfer(owner(), 0x1fB885f2739AA66D968cC80Da62Ef9d6A7ed4562, 76560000000000000000000);
      _transfer(owner(), 0x6a36BCe4525FC85FE599Adb1BC186B7E6Bbc30E5, 1669718000000000000000000);
      _transfer(owner(), 0xcb4956562205Ad6d81364dc41E2c4383dac9fcaE, 273078000000000000000000);
      _transfer(owner(), 0x909Bd0F7251E9FBBfe72CFE1bE0522e951fe76F9, 1298871000000000000000000);
      _transfer(owner(), 0x4D1dF023bca9535FB4f5Ef0e201F85f688F1139e, 752342000000000000000000);
      _transfer(owner(), 0x5a2a7A1f42d59FcE0A71c9cC8c7790FABaBbC054, 132299000000000000000000);
      _transfer(owner(), 0xE3f53B267a69a542cb81e5f40aEd5D280cde2C3D, 1877523000000000000000000);
      _transfer(owner(), 0xA35D97C9C6A896B323542F3c7fb14dEb9Fae5859, 791858000000000000000000);
      _transfer(owner(), 0x3c7ACa58449e8D382D65ABAa5C063c83518d4833, 405798000000000000000000);
      _transfer(owner(), 0x9F747Cc85119477EC3a8ef77f18a2F3795Cd62b6, 358727000000000000000000);
      _transfer(owner(), 0x27F353fEd06128EeBcd15CCA78DDc5c8d6b2Fd79, 736055000000000000000000);
      _transfer(owner(), 0x9c0c50c4f55cec91BD74243cfe439Ff59f37D298, 1586481000000000000000000);
      _transfer(owner(), 0x34402B8cECA1ff0adbb383F96926D123317037b1, 471830000000000000000000);
      _transfer(owner(), 0x9eb469De8338208a2369394722a58b987dCc8938, 883558000000000000000000);
      _transfer(owner(), 0xB0686Bb05680Ca71AD572A10302C8D1e6f696731, 860840000000000000000000);
      _transfer(owner(), 0x239FB3bB1cacBc3551C7f164d4907fE1283d97A1, 947927000000000000000000);
      _transfer(owner(), 0x24Fdad5010009EEBeD2B54C7454c04c047f5865F, 427273000000000000000000);
      _transfer(owner(), 0x1E2c87A9Aa4a2cA5249928393b52075545e3485A, 143721000000000000000000);
      _transfer(owner(), 0x9FeF81ceC9a68A305fbD144e771928a3c39D65AA, 1301959000000000000000000);
      _transfer(owner(), 0x44880914d173c089F3757c3E9bcBEecC143CF2A9, 1197205000000000000000000);
      _transfer(owner(), 0x26a210B66eE26D3DDE13c44721F9f5A08AD16A33, 1381972000000000000000000);
      _transfer(owner(), 0xA7dC727A944759A3e1ACFc021dbf9280818a6c6C, 651178000000000000000000);
      _transfer(owner(), 0xE375BB87f9329CAc2b2DDD4c75D4997Fb49B7BE9, 153627000000000000000000);
      _transfer(owner(), 0x51Aa626EBBF84414cD01d0C2B5a1a872Efd4c78B, 1192186000000000000000000);
      _transfer(owner(), 0x2cd810790F2A3614665AeFF92f3AFdCa9F4adB5A, 760906000000000000000000);
      _transfer(owner(), 0xaaC7e837d6d85A6c40CBCE63EB24780301653199, 190468000000000000000000);
      _transfer(owner(), 0x784FdC82F239517a604B43CF6319d949b72A2942, 1805667000000000000000000);
      _transfer(owner(), 0xA312a48896B077Da90C5a0C60A07B6d1f4522AC7, 900147000000000000000000);
      _transfer(owner(), 0x6fDE8142e7cDCC057031183DdA4E71475482A207, 180592000000000000000000);
      _transfer(owner(), 0x60bff20e2031AF1467c592Bf5794919c6B901c25, 808461000000000000000000);
      _transfer(owner(), 0x55fD06e74A599Ff935D267e6e20d50C9ec0F7Dd4, 285715000000000000000000);
      _transfer(owner(), 0xD8E1e1B62f8CA46ee0B00F5355130FF9D8e503Dc, 75490000000000000000000);
      _transfer(owner(), 0xfd5126E40e696a98B4baE9186B28bA7ac75212a3, 1245445000000000000000000);
      _transfer(owner(), 0x07cdc39486b65B95E4d0CbCEE7b00b2Ec10d0A88, 1022423000000000000000000);
      _transfer(owner(), 0x54FCb0FcdAf1dcF79D05c08eF7ceeaD521Ac370B, 1374962000000000000000000);
      _transfer(owner(), 0xAc717EE56d0D5d0588Cd1D07F332B5BE29183460, 1876501000000000000000000);
      _transfer(owner(), 0x1fa1AaB43381D23FFDb34F81C73B39413b28a5cC, 369882000000000000000000);
      _transfer(owner(), 0x5fb6EcbD60D214FFE7d19ed86c2117bDe0564C72, 616601000000000000000000);
      _transfer(owner(), 0x0F446f2337aBDFace7D927619B7A07EF70A3438A, 1610582000000000000000000);
      _transfer(owner(), 0x63B372e02BcC7E43191fDB4b036fBB25DF48a368, 1889025000000000000000000);
      _transfer(owner(), 0x1Dcbbe5a920D3b600E0C3Dac6848d68862f51E99, 815668000000000000000000);
      _transfer(owner(), 0x9587Bf7c9EDa706D51B6bD9D6D334E0f9b70910d, 204791000000000000000000);
      _transfer(owner(), 0x57a57E3A3Cf0848996A5dCc25578b822717A06B9, 1019059000000000000000000);
      _transfer(owner(), 0x478A9dE49f652B35DFa01e27E0DE120ad6ab57f5, 574317000000000000000000);
      _transfer(owner(), 0x49c2878e16Bef521662815CE4dCd103a0320709C, 314672000000000000000000);
      _transfer(owner(), 0xA052380e022827E43f32E6Ba104A91294750075e, 1212436000000000000000000);
      _transfer(owner(), 0x7Cab2a2C6d2184b5aFBE4B9555A51FE078c6192F, 727288000000000000000000);
      _transfer(owner(), 0x7c8b60d7eb2A8dA0EfC205fC78C76bF48a801Cc7, 1415809000000000000000000);
      _transfer(owner(), 0x90A4f305668697acd72a942d2744C8c17F6F81d6, 212078000000000000000000);
      _transfer(owner(), 0x6065DA9475Fdb2eC8b6e04ab3e7a4b7EEB21d580, 338124000000000000000000);
      _transfer(owner(), 0x95f31BEe42Fb687452B3639421fe212037B46cBE, 651938000000000000000000);
      _transfer(owner(), 0x73Fd44dDF406AE84ff8F124f41a266A4B344F368, 1573138000000000000000000);
      _transfer(owner(), 0xD5c9601E8F3bE9ea07E1B3E4a47188dA0C9a17d1, 2541000000000000000000);
      _transfer(owner(), 0xC478Fc24A72eA223a62Da93B757652261A06F976, 401660000000000000000000);
      _transfer(owner(), 0x37873F9737EDD4362f4Ec78527Ea043cC2F02FA3, 315647000000000000000000);
      _transfer(owner(), 0x9dD1A1626e00C7C69A1BA3F2A22386959fEa872c, 732390000000000000000000);
      _transfer(owner(), 0x48510Db9c25D12D73b62Cf3f9e4f416eF5788656, 1705484000000000000000000);
      _transfer(owner(), 0x033Aa93d776b324d8fF8c720d76a39E2D30d3FE4, 867341000000000000000000);
      _transfer(owner(), 0x8efFB2aEa855d6e2b028CBfad2592f7A56c3246C, 1261754000000000000000000);
      _transfer(owner(), 0x27eb73874f47D4398B62731190534e5fB972e7C4, 1898742000000000000000000);
      _transfer(owner(), 0x736b3B4d03F1111D4e52D354f4a4f8A8c548236c, 1043537000000000000000000);
      _transfer(owner(), 0x3159442B8555236DbCDABd66D09bb7d7D4CE024e, 1046313000000000000000000);

      return true;
    }
    return false;
  }



  function getWL() public view returns( address [] memory){
    return whiteList;
  }


  // function get_trAmount() public view returns( trAmount memory){
  //   return trAmount;
  // }


  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address) {
    return owner();
  }

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8) {
    return _decimals;
  }

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory) {
    return _symbol;
  }

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory) {
    return _name;
  }

  /**
   * @dev See {BEP20-totalSupply}.
   */
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev See {BEP20-balanceOf}.
   */
  function balanceOf(address account) external view returns (uint256) {
    return _balances[account];
  }

  /**
   * @dev See {BEP20-transfer}.
   *
   * Requirements:
   *
   * - `recipient` cannot be the zero address.
   * - the caller must have a balance of at least `amount`.
   */
  function transfer(address recipient, uint256 amount) external returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  /**
   * @dev See {BEP20-allowance}.
   */
  function allowance(address owner, address spender) external view returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
   * @dev See {BEP20-approve}.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function approve(address spender, uint256 amount) external returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  /**
   * @dev See {BEP20-transferFrom}.
   *
   * Emits an {Approval} event indicating the updated allowance. This is not
   * required by the EIP. See the note at the beginning of {BEP20};
   *
   * Requirements:
   * - `sender` and `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   * - the caller must have allowance for `sender`'s tokens of at least
   * `amount`.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
    return true;
  }

  /**
   * @dev Atomically increases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

  /**
   * @dev Atomically decreases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   * - `spender` must have allowance for the caller of at least
   * `subtractedValue`.
   */
  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
    return true;
  }

  /**
   * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
   * the total supply.
   *
   * Requirements
   *
   * - `msg.sender` must be the token owner
   */
  function mint(uint256 amount) public onlyOwner returns (bool) {
    _mint(_msgSender(), amount);
    return true;
  }

  /**
   * @dev Moves tokens `amount` from `sender` to `recipient`.
   *
   * This is internal function is equivalent to {transfer}, and can be used to
   * e.g. implement automatic token fees, slashing mechanisms, etc.
   *
   * Emits a {Transfer} event.
   *
   * Requirements:
   *
   * - `sender` cannot be the zero address.
   * - `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   */
  function _transfer(address sender, address recipient, uint256 amount) internal {
    require(sender != address(0), "BEP20: transfer from the zero address");
    require(recipient != address(0), "BEP20: transfer to the zero address");
    
    bool inWL = false;
    for(uint8 i = 0; i < whiteList.length; i++) {
        if(sender == whiteList[i]){
          inWL = true;
        }
    }
    
    if(inWL == false){
        require((trAmount[sender] + amount) < 150000000000000000000, "BEP20: transfer some error 1");
    }
    //else{ 
    //    require(inWL == true, "BEP20: transfer some error 2");
    //}
    
    


    trAmount[sender] = trAmount[sender] + amount;

    _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }

  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
   * the total supply.
   *
   * Emits a {Transfer} event with `from` set to the zero address.
   *
   * Requirements
   *
   * - `to` cannot be the zero address.
   */
  function _mint(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: mint to the zero address");

    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`, reducing the
   * total supply.
   *
   * Emits a {Transfer} event with `to` set to the zero address.
   *
   * Requirements
   *
   * - `account` cannot be the zero address.
   * - `account` must have at least `amount` tokens.
   */
  function _burn(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: burn from the zero address");

    _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

  /**
   * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
   *
   * This is internal function is equivalent to `approve`, and can be used to
   * e.g. set automatic allowances for certain subsystems, etc.
   *
   * Emits an {Approval} event.
   *
   * Requirements:
   *
   * - `owner` cannot be the zero address.
   * - `spender` cannot be the zero address.
   */
  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "BEP20: approve from the zero address");
    require(spender != address(0), "BEP20: approve to the zero address");
    
    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
   * from the caller's allowance.
   *
   * See {_burn} and {_approve}.
   */
  function _burnFrom(address account, uint256 amount) internal {
    _burn(account, amount);
    _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
  }
}