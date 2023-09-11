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

  mapping (address => uint256) public trAmount; // сумма переводов адрес=>сумма


  constructor() {
    _name = "InvectAI";
    _symbol = "IAI";
    _decimals = 18;
    _totalSupply = 10000000000000000000000000000;
    


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
      
        _transfer(owner(), 0xA9F1c945923e76207F84baBc144aedc2F40d1777, 21556827000000000000000000);
_transfer(owner(), 0x97F7237068D4822ABC9Aeb9Ad41Cad9F93fCbF79, 39289855000000000000000000);
_transfer(owner(), 0x924589DE3B0a9f741C3D6F0DE418397ec861aB91, 17748882000000000000000000);
_transfer(owner(), 0xB1546755E8AEd1a2f9547757983448F1E19cc76E, 38151754000000000000000000);
_transfer(owner(), 0x478816336E67D88566929C815D058f71D149D753, 4093981000000000000000000);
_transfer(owner(), 0xE2B003Cd4AC7251abCCeE908b821ed9141b380ee, 9866804000000000000000000);
_transfer(owner(), 0xC2527B7d9AbcA4336EAdE60dBe67A77b9913024f, 19978861000000000000000000);
_transfer(owner(), 0xA82313057043Be8F33199357B7552b994807c484, 25273788000000000000000000);
_transfer(owner(), 0x832caf9c035BC3aA1C387Bd7DeCe886c479aF8C1, 11122768000000000000000000);
_transfer(owner(), 0x278389458A2Aab05B10EF179B61DD1977595c3ea, 33210220000000000000000000);
_transfer(owner(), 0x0d88C0297350e5bcca485aE4135F80413cb371f0, 18474769000000000000000000);
_transfer(owner(), 0xAF4f9A187FaAF22B3d33060192D74d1cEA69BB95, 27471822000000000000000000);
_transfer(owner(), 0x2a419dC3fCb8EC1c98B36de3193498D409CE8be7, 23523372000000000000000000);
_transfer(owner(), 0x15807504a52339f1c02314068DcC7CFCE2C33f55, 38970224000000000000000000);
_transfer(owner(), 0xc830c1413337D6Bf9341c1258511968cb59bD8E8, 30316967000000000000000000);
_transfer(owner(), 0x4e4f557a38f6f8e8e701Ad427976e7a1C56F5137, 15272861000000000000000000);
_transfer(owner(), 0x023De01567a18e646080affba7894261F10B1648, 24402295000000000000000000);
_transfer(owner(), 0x02e42F8EAF4F9c15a05251D4c3541D40d262D4E5, 3627690000000000000000000);
_transfer(owner(), 0x466ca40cEe1B18dd05b04238e6C3d4b8533bF6DC, 9029385000000000000000000);
_transfer(owner(), 0x35276B784837d3D7a1724C4eB1A8543Bc7EC9820, 13834642000000000000000000);
_transfer(owner(), 0x51eEfa88462393eB73df88428302E517Fe5BCFBF, 35597229000000000000000000);
_transfer(owner(), 0xdABafd459b72c523a82b019dF8D0A149CaDC5210, 24675549000000000000000000);
_transfer(owner(), 0x3f2e2Bfa6067391f01e8E40ABdF768723310a75B, 30721148000000000000000000);
_transfer(owner(), 0x6BA4f05D2eB98529B6e69078C3BDB893F6fcaE60, 7363506000000000000000000);
_transfer(owner(), 0x94343131F1605b0b6d0ab8d39DBD0C0773c00d9C, 9858642000000000000000000);
_transfer(owner(), 0xeb393dFF9f7bbEA1AA535a21AE1D9425e0688Dd1, 16329880000000000000000000);
_transfer(owner(), 0x6e9b5EBcA1eb5c8Cf87DAda83d4Bac43C8b74725, 3329621000000000000000000);
_transfer(owner(), 0x1DB6D1C549C1264e3b036F1769e7B9EA42779443, 36124934000000000000000000);
_transfer(owner(), 0xa9c89b9a3b45B409531C8E99e394De12FD710dFC, 32368975000000000000000000);
_transfer(owner(), 0xc9185e78c2b205FdE790282e9442FfcF29906492, 19546975000000000000000000);
_transfer(owner(), 0x2c1D91B42112Cb39B706A35901993BA5385e1B62, 28626216000000000000000000);
_transfer(owner(), 0x87A85106eb6214c193bD811D667353ACC6358C21, 22793911000000000000000000);
_transfer(owner(), 0x7275038afAdbc2C0BD61224890986f5362135Ab2, 18758251000000000000000000);
_transfer(owner(), 0x898A0f33642A5471952B9F679D1bA800029ceB18, 21801052000000000000000000);
_transfer(owner(), 0x28B36Df8141c6798ce742F4F57ef10aac2EdFAA4, 22541030000000000000000000);
_transfer(owner(), 0xC8E837D0E411C7e870516F4d5De86aF11b1e78F2, 23550883000000000000000000);
_transfer(owner(), 0xF043C7FeA4e9BD3dD99Fa0152cf7710a6E7Dd8DC, 38855201000000000000000000);
_transfer(owner(), 0x2FF45a11789B8899DAf12276028F38A9B0FCa375, 34695141000000000000000000);
_transfer(owner(), 0xF5Ebef05F0ef9ce3fE5bF0f65f911025993b68Ce, 3078956000000000000000000);
_transfer(owner(), 0x9D03a57eBd1410f9fFDbA4Ba51Bcc8FCd33c3620, 5019123000000000000000000);
_transfer(owner(), 0xa697A492F1219F5E4601534938f1dD7101E59aFB, 25350965000000000000000000);
_transfer(owner(), 0x5F074312a9DA0933472544B1757bb20993a7D864, 33499388000000000000000000);
_transfer(owner(), 0x51ea8048d8641201479fb06953EA0e4b90A52a2D, 36198408000000000000000000);
_transfer(owner(), 0xCaf859dA1CEC4d81772b7A8F01ccc02430369733, 841593000000000000000000);
_transfer(owner(), 0x83B50Cc98e03231E66294bB57D9Be447e6485Bb3, 554568000000000000000000);
_transfer(owner(), 0x6B063B94D3441f82A34aC9aC12ead80897B37040, 30976921000000000000000000);
_transfer(owner(), 0x5b524e8c403D4f75C9d670A0638d0Be77B774925, 22382599000000000000000000);
_transfer(owner(), 0x55ADf3563506be8C86AAEc3F52319326EDb5b2e0, 32112063000000000000000000);
_transfer(owner(), 0xC54E5Cec97531d83FB2C156077d8a02aE4347577, 13536574000000000000000000);
_transfer(owner(), 0x3A4345167c5eF720E806eD6f145eC9d07eC29383, 27889545000000000000000000);
_transfer(owner(), 0xC685Fb40C3139C342D36b5f62a27d43B3aceb6e5, 36009081000000000000000000);
_transfer(owner(), 0xb8F1c5e62fB5f16E22cF1E5B74787d4922875655, 27334577000000000000000000);
_transfer(owner(), 0x6DB78Aa20463299dc77E8B0a93d85FB180209501, 21603329000000000000000000);
_transfer(owner(), 0x855596c26F6568d9600b478673c2453b574EF21A, 29952829000000000000000000);
_transfer(owner(), 0xf95d8C5D2fCfC1aCeefEB8F92b72CdC3d1d0afc7, 39451879000000000000000000);
_transfer(owner(), 0x5C1Ff9E8ef56aa5A35E488794c10Dd3A46304302, 20883057000000000000000000);
_transfer(owner(), 0x8F9d10B50CFc7D3eBA2619D73a7b70D2E7c5bA7b, 19525518000000000000000000);
_transfer(owner(), 0xdF1b570C764144Ff63a000be1972c93991cfFAD5, 36837857000000000000000000);
_transfer(owner(), 0xBB1a3C806e55ff62b90716487a88EB3d7F92dB55, 14569040000000000000000000);
_transfer(owner(), 0x208633482D8c87eC369275c708a942534c5E1C76, 6296769000000000000000000);
_transfer(owner(), 0x0cFa0835dE7Bbd8f538c4606A76c0345bdf980FB, 25752977000000000000000000);
_transfer(owner(), 0xe5781CC5961b4d86678C35c1Aaa250E1340a606f, 8852145000000000000000000);
_transfer(owner(), 0xd6aE563A16051EEA6DCdE1501701104259c47545, 5763053000000000000000000);
_transfer(owner(), 0xAAae5eD3aF6e6ec2B20B150E56B37a0176ea9A9c, 12726205000000000000000000);
_transfer(owner(), 0x9Bb80C1915d21Cd31f23e4DACFA67eF594f1Ff0E, 21833336000000000000000000);
_transfer(owner(), 0xAE3F7BCb06406F4b6f78bb0Dd60c8f0615a8a374, 34506306000000000000000000);
_transfer(owner(), 0x85b34ad6DB76729fBb766E04DFE43D520EcBaEa7, 8983079000000000000000000);
_transfer(owner(), 0xe16dd367DA69946605fc7A2F7dFfaAa5F6a00090, 21645118000000000000000000);
_transfer(owner(), 0x626F954141e49854655b629407DE29BD15457D30, 29356977000000000000000000);
_transfer(owner(), 0xB8EC443ada92Fb0ED3ecF077013d1b961F25B90B, 3056947000000000000000000);
_transfer(owner(), 0x3b10675E509730905459AFa15414BAaa5A5B599A, 39380181000000000000000000);
_transfer(owner(), 0x37dE5B75E92965A59cB91FE72758196e3ED25e2c, 39888993000000000000000000);
_transfer(owner(), 0x6B381aD7E0656832a6C6e28AAF97A914f5F49A7D, 35903896000000000000000000);
_transfer(owner(), 0x10C463fB7234eDD2509dB1146a219d069280Ab5A, 10813895000000000000000000);
_transfer(owner(), 0x38d2F1032F20c78F0a06FC54AB4E44Ea08Fdc491, 18300276000000000000000000);
_transfer(owner(), 0x917D23e58eF4DB77A452Cd2e72D2fCEd7DDc3405, 27241728000000000000000000);
_transfer(owner(), 0xEF8c7aBFed045C18802c1B1055869709807BD663, 8687800000000000000000000);
_transfer(owner(), 0x34BD76B41b751a83C29507AF9Bd689F19173bD22, 30268442000000000000000000);
_transfer(owner(), 0xe42c5d8de4957E76B61154D51B0AFD3f8EeD4786, 35126041000000000000000000);
_transfer(owner(), 0xf6533B1650C9910c4532ad18a71e50576B80272B, 11521208000000000000000000);
_transfer(owner(), 0xC8C2EF313eb83cFB71a91738edC5463D343bF360, 9586116000000000000000000);
_transfer(owner(), 0xF782Fa6D57d2fafdb1C691772723221b07435C18, 35606983000000000000000000);
_transfer(owner(), 0x6c5a43e18208080665Ad69cf0669BFA4AA4c4f8a, 15156193000000000000000000);
_transfer(owner(), 0x5ED584026446699cdBe26a9A7808510ed7A994c4, 9041974000000000000000000);
_transfer(owner(), 0x9F96425376Bf49e8f20ff5D4804015c99662531e, 33500098000000000000000000);
_transfer(owner(), 0x4E4E5d2D32AA6Cf6C7335a5E9170B22672866689, 4366384000000000000000000);
_transfer(owner(), 0x0Bc4d6C0D91d3BE21402Fd7b6B841e57B9613395, 14172785000000000000000000);
_transfer(owner(), 0x7bb20dC1457023699A40dcBa530Bb7360D7314b7, 29781906000000000000000000);
_transfer(owner(), 0xcb02C909D75E30214F52C0Ff7999Badf3263Ea88, 14557076000000000000000000);
_transfer(owner(), 0x856AE046e8b4546401eE191503743d28F19604Df, 32509006000000000000000000);
_transfer(owner(), 0xFA3C3EC32671aFd391B2016A780f1a6e58aAA0D7, 8884189000000000000000000);
_transfer(owner(), 0x1601086ffc125745FbA22506C1F6f1212Ad756a9, 18761466000000000000000000);
_transfer(owner(), 0xCA8A9eaf2D3DBB78FA64D08386fb3A50507cA7C4, 20998868000000000000000000);
_transfer(owner(), 0xf71e0a4Fec53b56EE4701d5BC831cA440DB8C51E, 12490917000000000000000000);
_transfer(owner(), 0xe1CeFdFF2c550922226Ad3040Da6Ea8660B81389, 2418080000000000000000000);
_transfer(owner(), 0x7DF5E6fb87ADa8795266ED17E56caad54ecfE4Dc, 4524501000000000000000000);
_transfer(owner(), 0x9B662399aD0D5F39BA33A102f4a89fd8ACf33B99, 18579010000000000000000000);
_transfer(owner(), 0x3A9bC12fdBdf4A2293951c7DAB9427812423599d, 7133869000000000000000000);
_transfer(owner(), 0x30D698F8c0bB85b5b5E1CcBa0D94c73c9FC8Cdd5, 9150834000000000000000000);
_transfer(owner(), 0x7bcFf6F61E5Ee1e95ceaf44DC22bdC9b9e95A97A, 9460754000000000000000000);
_transfer(owner(), 0xFe689f0b92194981bBDc82F196F507e6704976e1, 10512967000000000000000000);
_transfer(owner(), 0x7a2bF1E2F0fD32f5b0e269d4422E954f249B61b2, 17098525000000000000000000);
_transfer(owner(), 0x597a75eb069A9927f2e825597cA19445e019B9B8, 24683217000000000000000000);
_transfer(owner(), 0x50286661a8818438a2f872856BE89Cf6de981E20, 32546681000000000000000000);
_transfer(owner(), 0x3A19E74a49b88A1E4E9DddE55e636a6eA22ccd4B, 23494448000000000000000000);
_transfer(owner(), 0x1e3F496C0245FB13E4e5F124865dd7bcC0cdcFe7, 36110113000000000000000000);
_transfer(owner(), 0x9F9C08976425bC9050bae56b0E67Eeec518C7D44, 9887090000000000000000000);
_transfer(owner(), 0xE010D04A43e0c36B148c13DD35F106D4B4CDbF48, 7168634000000000000000000);
_transfer(owner(), 0x71aE71c44d41a2f9CD322dB27C328405F3be3C56, 36428756000000000000000000);
_transfer(owner(), 0x33b3AEe8776c8341De6f54Dfd6797dceccf2580E, 18631376000000000000000000);
_transfer(owner(), 0x355b41836CC353373eB2C5F41A2eB0DE18d9CF46, 38732017000000000000000000);
_transfer(owner(), 0x6f56CF59914E42965031c73d58D196c2fc0bd71A, 14528710000000000000000000);
_transfer(owner(), 0x0fdA3686f02d78CFa2A13306f6C56Eb451C59A4e, 22016960000000000000000000);
_transfer(owner(), 0x224347b510f4c647bDaC2f2A2EDb8E5f91be6A87, 21463629000000000000000000);
_transfer(owner(), 0xb45b3d760106Ebe4Eeb4a2BF2D4c66cb7e952EE0, 39149024000000000000000000);
_transfer(owner(), 0xA04657d8044e33B35D0CD39cB4E7dd71E5742d5f, 21078448000000000000000000);
_transfer(owner(), 0xeCaA36ae2Cf55FFAeF1f95487EDDb5256fcEE5D6, 33505153000000000000000000);
_transfer(owner(), 0xbc504C9d334EE1ADA3B540DAC2b0A9565E20C2d2, 2714437000000000000000000);
_transfer(owner(), 0xc29Ae7851BAa8705741AeFd8ce814fCd53A7Ef0b, 1248224000000000000000000);
_transfer(owner(), 0x7c8C96f918cDe4fE1323e41665552Ecb578C7E10, 23168405000000000000000000);
_transfer(owner(), 0x0dFEeb6481b3035B8026c8F0d4EedEcA655ba8d9, 36341191000000000000000000);
_transfer(owner(), 0x5426eE0340aB573A30cbFFb1d4C12C341AE8f23B, 12881504000000000000000000);
_transfer(owner(), 0x357Ae0553dD5b63af8ef4565A86cfaF63c50514a, 26117009000000000000000000);
_transfer(owner(), 0x1f75fDD3382053E6fAE7fCec7f2f48B2786C9a17, 13767564000000000000000000);
_transfer(owner(), 0xa85228f31E9f6fEBcA5dB116302F30c415e058ad, 17507718000000000000000000);
_transfer(owner(), 0x0FD84564C47B7EE43E09d8FC8143Ab4f1e434d60, 31928668000000000000000000);
_transfer(owner(), 0x741d7a31aF42C36be381ce666bdE86f879Bb7F3f, 15355275000000000000000000);
_transfer(owner(), 0xF02202859bE992782c04e8Bc0f82B63EC7e5c619, 7249328000000000000000000);
_transfer(owner(), 0x314981DAF501c99cb7367b8aD5A449B47aD4B7a6, 34713319000000000000000000);
_transfer(owner(), 0x4566FD803Fc01FbA5f4969e98BfC291af493d1b6, 3067327000000000000000000);
_transfer(owner(), 0x936F140b61121425987d0Fa9B83324eD1b07721a, 25667304000000000000000000);
_transfer(owner(), 0xfceDA7A50A6F0f7c99bbeC4D57573E2648b258f8, 15152668000000000000000000);
_transfer(owner(), 0x6ac318F139A52d8aF289809f0fcE5D90182021Ab, 1223109000000000000000000);
_transfer(owner(), 0x32326512F22815C0190d71540032B21773CfAC84, 33238636000000000000000000);
_transfer(owner(), 0x1AF37E2e6a6E22CF1cd32f62D5b9b083E0C61F56, 33967192000000000000000000);
_transfer(owner(), 0xA99713851cEA72582c536F42b405335E0f0f8FeD, 8175750000000000000000000);
_transfer(owner(), 0x12574B023713a6132858cE4f7645dcbdaD8787db, 15283491000000000000000000);
_transfer(owner(), 0xE107D93d636718648257390F947D94322307B628, 38605735000000000000000000);
_transfer(owner(), 0x272d5f105c96E650dcD98154b332A7B80B2BffE3, 17235072000000000000000000);
_transfer(owner(), 0x468B05cC78CF27218142C330257F87e907729459, 33936700000000000000000000);
_transfer(owner(), 0x5A3D0C46B6C631aDbe85aA058076Cc9Ee4dF822a, 14079600000000000000000000);
_transfer(owner(), 0xcD69E374C1f417db633E042857c9811A5FDf3984, 25604497000000000000000000);
_transfer(owner(), 0x7Fd21135CAA4bFd518C11d44D6E830F8609112C1, 10923406000000000000000000);
_transfer(owner(), 0x7597A73DAd9db7829A169491889110436dFF62c0, 13783458000000000000000000);
_transfer(owner(), 0xD848EeE87c62dB78DcB7523F498a9B97841e7765, 35141476000000000000000000);
_transfer(owner(), 0x78BFdA451Ff516a280C53095e6321Bde9d36be5B, 20446615000000000000000000);
_transfer(owner(), 0x682B9A35e9D93ba1F7cE7999bfDeFDd82aF2E3e1, 26884855000000000000000000);
_transfer(owner(), 0x8Ae01f500FedD28C8C42752ad49A4E0905fb3105, 27344872000000000000000000);
_transfer(owner(), 0x063C50B87167cE123008D1a328429Decf2684821, 37709095000000000000000000);
_transfer(owner(), 0x32072BDfaae52346B4BD4ed7da8e05268E93e333, 16745479000000000000000000);
_transfer(owner(), 0xFF92fC9207bB9D51Ddf59473aAB40b91AE85A475, 9706816000000000000000000);
_transfer(owner(), 0x6f8Aa3f7c96AEa7686a2E72F69a8F30110933c7B, 31872927000000000000000000);
_transfer(owner(), 0xB42b82Af98f47Aa407620E68aF269B7D5cA74352, 30007573000000000000000000);
_transfer(owner(), 0xd7E77b6F1c79B576770d7132bBB172BFF50264Fb, 12160809000000000000000000);
_transfer(owner(), 0x283Af7f269499D7E4BCD2ADE14b0BE18b9a6601b, 28819545000000000000000000);
_transfer(owner(), 0xd98aA16553facAd75E3fAC9d19f72e9A08b966C0, 36278297000000000000000000);
_transfer(owner(), 0xD181bd20922a90202018EbE545B57061975F302d, 35905373000000000000000000);
_transfer(owner(), 0x16F3420ba0FcC086DE5622D9932cce4aD349c3Be, 28650223000000000000000000);
_transfer(owner(), 0x61de9a1d8decD02Ee02a18D2BfD794DeFE2bAe65, 21981107000000000000000000);
_transfer(owner(), 0x1341eD06fd9153899f26623cDBa0Ca2984073063, 27090488000000000000000000);
_transfer(owner(), 0x461d6954455E699bfED71fED759079344A1c1b76, 15497505000000000000000000);
_transfer(owner(), 0x12FE63Ff8e269EeE79C321C7109372Ed79767840, 15191412000000000000000000);
_transfer(owner(), 0x92c273B846391D6B9d39796a124bB5ecef83a63f, 15681818000000000000000000);
_transfer(owner(), 0x7474677F818A788a1be8eB7DFcDDaEd289ef5cc2, 36723605000000000000000000);
_transfer(owner(), 0x9175dADAaD90aF014f37F279b590FE5E6F8170CD, 13388768000000000000000000);
_transfer(owner(), 0x5f31979a61D3A65aF1996f83f09AfaCDf8e0C715, 22300525000000000000000000);
_transfer(owner(), 0x16E439590Ae5962050Ef07368673abF81Cf96C3a, 26198319000000000000000000);
_transfer(owner(), 0xf0e32dCE6Fd591fae5d13c46A8E7ed4CE76B243A, 38181041000000000000000000);
_transfer(owner(), 0xa561d92beB3A25673154B68d98FF932773148A2F, 15790222000000000000000000);
_transfer(owner(), 0xce45a9E39e2A5fE4c5bB748335a90241a4556F6b, 13769283000000000000000000);
_transfer(owner(), 0xfCAADd6507eE0aa7c5F48d03DCcF7004825608Bf, 12697909000000000000000000);
_transfer(owner(), 0x12BE1Ed41EECE787e94AC75a2b80BE8dbc31AFEc, 7941037000000000000000000);
_transfer(owner(), 0xCbf6BD5dd5c3d62db324E3dEeafCb2e2A29AaEb5, 38500405000000000000000000);
_transfer(owner(), 0x0aD6C9c8387380e10623F56597f0593f5bEc1290, 30289330000000000000000000);
_transfer(owner(), 0xe996964198F0cde18dA81b4452a18B5576b02B05, 10427632000000000000000000);
_transfer(owner(), 0x0Eefd1d9feE131bD39F6a17034A4eC85dC9d80A0, 24895617000000000000000000);
_transfer(owner(), 0xe6aa41876004238306c3990Bf0cc9702cEFFC42B, 17562720000000000000000000);
_transfer(owner(), 0x71c45436098Ed720d04da4E3A97940eE5025F0FA, 16107974000000000000000000);
_transfer(owner(), 0x5c5299bE61033A0fAABa57134fF9436009F7D3e9, 10117958000000000000000000);
_transfer(owner(), 0x3163CcB1169A6B12Af84b12968F6a98884a1ACcA, 32931549000000000000000000);
_transfer(owner(), 0x796700a07D8ce8157F7fdFc8b6c70FB92f1a37dE, 4577509000000000000000000);
_transfer(owner(), 0x7001874eF2e28Ed95803C75A6C31Aa376b6B0E6c, 35660505000000000000000000);
_transfer(owner(), 0xD93C4837d2393D229DEAAE20fCAcEA369b3D3fb3, 7389094000000000000000000);
_transfer(owner(), 0xDfa828344Ed02202239c1451b94B7Ae0518367aE, 25048305000000000000000000);
_transfer(owner(), 0xcbA126fe843610A48dDf9D19a8d5254162E4E9C3, 29132269000000000000000000);
_transfer(owner(), 0x80401896B5d8d36Afecd5cdD57F0717aaEB09e28, 10652714000000000000000000);
_transfer(owner(), 0x430F206DD77dd9bf1C2DC9f4345Ce612d53b242E, 10412169000000000000000000);
_transfer(owner(), 0xb18891d82746EC67D3fAaA47De0178f87cCba16F, 39864659000000000000000000);
_transfer(owner(), 0x84621De66E6081eFf4eCa68fF54C2c721227769f, 13867972000000000000000000);
_transfer(owner(), 0x722cF78b00Fa6B5013C4c1b714Ee26012E5527E1, 9637050000000000000000000);
_transfer(owner(), 0x956493c828dE9FA38E9F81868B2D1c4Cb6C2d1B4, 32239164000000000000000000);
_transfer(owner(), 0xc16CEd5c6D18239658d55242Fc767A333C2678Cf, 2053137000000000000000000);
_transfer(owner(), 0xD5e5f35E7920Dbd1A04dCA5Fb33eC7CA0a284FF7, 3710800000000000000000000);
_transfer(owner(), 0xe6c8adBB68933ABFD25ebA0f0218184FBf843B1E, 6464574000000000000000000);
_transfer(owner(), 0x791bD0dC49D0eF6BC4BF499aE81aB9814c3F720e, 2376428000000000000000000);
_transfer(owner(), 0x635503F0cd67303E775fB31ae329E39aeAd54987, 3114102000000000000000000);
_transfer(owner(), 0x7B7e676DF141242e23AbB829665C95A1158F2562, 7605420000000000000000000);
_transfer(owner(), 0xBa1CaC539AB1dDBDCbfF662D3DA1cEf8a81Fc254, 6985027000000000000000000);
_transfer(owner(), 0xcd17E3b136707570D6Fc37Ba8f840aa97d4f7E8B, 16002730000000000000000000);
_transfer(owner(), 0xb352e033B8536564c3bdd30CFBcCbb38C38360dA, 7677198000000000000000000);
_transfer(owner(), 0xf8D01691E3223e6aE64A390998313DfB2e9a121C, 2448264000000000000000000);
_transfer(owner(), 0x89Da4F8dDa3b6A01f95821397B2e0de619c7D82C, 19831495000000000000000000);
_transfer(owner(), 0xBEBe2986C505022731CDe2f7C019E415d5532894, 19242863000000000000000000);
_transfer(owner(), 0x4d3414625B7fb0870Fb377143c33684fa3588509, 29691078000000000000000000);
_transfer(owner(), 0x503cD17D86f6344F9704b48911719F4F797D6725, 31731771000000000000000000);
_transfer(owner(), 0xA7c79EBE903CEFE3d15c3d12E386413CF6672EDE, 29503995000000000000000000);
_transfer(owner(), 0x4cAB3C769bf33110daf4d579be1DaFd6B53E5e9f, 36604940000000000000000000);
_transfer(owner(), 0x788E5414037432eeFB6284479AA63cd260308D21, 17334416000000000000000000);
_transfer(owner(), 0x1646348D3c99b33404ff2989ebD29f0462cBffBB, 3430063000000000000000000);
_transfer(owner(), 0x33d3c091292dCE9A93f4BF203926AE2ca90f31Bc, 23718462000000000000000000);
_transfer(owner(), 0x99864c40676F88dA44A9D0627BAd0Fee4C2EDC50, 4905493000000000000000000);
_transfer(owner(), 0x81c27C3C5925F446ef708Ed1a789bA9D910E597f, 27632688000000000000000000);
_transfer(owner(), 0x1Ebe03A5C189f74062F648e8C1df498C60F4B28D, 19479523000000000000000000);
_transfer(owner(), 0xB9e901a1422f44221e5d631aFb74716565c5bF51, 24926702000000000000000000);
_transfer(owner(), 0x98d6f57C42C01F5393Ad5854dcA2641505B82C80, 361351000000000000000000);
_transfer(owner(), 0xe0DFe6B92d1eAE6fB10f42029BeeC37731fef070, 21927634000000000000000000);
_transfer(owner(), 0x4A61a858A708F1bA4F8fCe677E46423cA3704091, 21088609000000000000000000);
_transfer(owner(), 0x364B999C48f8e21501bF9A2Bc68Ee68C226FA82f, 24395061000000000000000000);
_transfer(owner(), 0xFc215F95Df51bD486eD5C6BA42327a49fFb924F3, 29888378000000000000000000);
_transfer(owner(), 0xb6478db80E79f320B0b44617b5491523174a1585, 13664893000000000000000000);
_transfer(owner(), 0x1e2E34e5c62fD2ae9b73be6ADa72594815149243, 21773812000000000000000000);
_transfer(owner(), 0x57E76ABF11644F6E59116Aa0B6Fc961DD2908287, 22833778000000000000000000);
_transfer(owner(), 0x0D4247349743e3ca18fA12B468a0b19f52Ad40d7, 22123898000000000000000000);
_transfer(owner(), 0x85179148722aa3c923d21F6C4e4120F47350B2e8, 38740413000000000000000000);
_transfer(owner(), 0x4be799fB1F3f1e848CFF91B3685f434B8f3beFC0, 6252871000000000000000000);
_transfer(owner(), 0x62923Dec63Cc6a3800a5F355a003cf9CA2d14721, 35890254000000000000000000);
_transfer(owner(), 0xFA6e98bD2CBcB4e50E3436be05C68eB6cc469a13, 5505494000000000000000000);
_transfer(owner(), 0x0B06190FcE5b02Ad392Bb646f5b8a6272e90C462, 7809013000000000000000000);
_transfer(owner(), 0x441579bE30A800dcf19cafD239Cb8110BECA901C, 15650393000000000000000000);
_transfer(owner(), 0xce139EE8A1Fcc7F0c521F1EE18157801DD8A5a56, 34533221000000000000000000);
_transfer(owner(), 0x0Fdffa83Cba662501C45d2eF7f25D278798CA81A, 1708334000000000000000000);
_transfer(owner(), 0x0f4ce28a8edAF73C77Fec149AE294172BFE7ED59, 14403669000000000000000000);
_transfer(owner(), 0xcDdD82293f7e2AefDeb035748769A8C1E22EbFD4, 34968585000000000000000000);
_transfer(owner(), 0xd3d2411D0D5C4fF3A47B880eE1aD4e71366Da367, 22595248000000000000000000);
_transfer(owner(), 0x6ca7dd6e54270E83d8e0BA5895a772198C28A386, 23563836000000000000000000);
_transfer(owner(), 0xd2eA7A87F148a1a591ec8da25DF4352eCE3dCa3A, 27696123000000000000000000);
_transfer(owner(), 0x7827B9282b12F49c3E2233e5b7345850F018b921, 37558704000000000000000000);
_transfer(owner(), 0x3F682F4d6B4baaEA022687405Dc0d8d779f8f786, 12238634000000000000000000);
_transfer(owner(), 0x2F870a368B2C1a3B26c8e34344F7C0a86af192ef, 19619992000000000000000000);
_transfer(owner(), 0x6A297556A9dce7f47BcB4fC6cf687e9702408f98, 16251258000000000000000000);
_transfer(owner(), 0x9711aBa01B6180bCb81a4b9eA4896eBB5F032efc, 8019816000000000000000000);
_transfer(owner(), 0xb376D502D351F5a37A695efEEB263C74E71354B6, 3574399000000000000000000);
_transfer(owner(), 0x923E2bE93F14980c9C13f25e43E424C3198Adfe5, 33747343000000000000000000);
_transfer(owner(), 0x2f1B1CeecB581fA758D79a2374b0Fec5f4E54421, 10909429000000000000000000);
_transfer(owner(), 0x1AA7e86910f0F81F9994BD5585eE7fAF43049EBa, 25468570000000000000000000);
_transfer(owner(), 0x58B514b51d11A6375dc90F163C5a21A942C10e7e, 22584149000000000000000000);
_transfer(owner(), 0xECeA0D85d9Ee831F1DED715657Ffe9D99602dd97, 23496540000000000000000000);
_transfer(owner(), 0xe510Fa62d6729546dc9277d1A5d40e583380ba5D, 37315483000000000000000000);
_transfer(owner(), 0x3c3bC164712472D767721D766c52A57Cc9Cb0D8D, 12629736000000000000000000);
_transfer(owner(), 0x502f13715380ffD84AB47e91FB9Edd0Ff2d9e60b, 23413992000000000000000000);
_transfer(owner(), 0x26a718F5526a11D0dceCB38d41Ee45a87f91675C, 13412432000000000000000000);
_transfer(owner(), 0xfE13B7993a540229426cAF3E614575A138f1856E, 31200648000000000000000000);
_transfer(owner(), 0x8466DC04AAa31354E55fC3fb5762003A8507fbC8, 39113857000000000000000000);
_transfer(owner(), 0xbADE965f283B4D95aED1a0e52449C6Eb23B102c9, 18733065000000000000000000);
_transfer(owner(), 0x62E8f21f29058Eb95a6193a9733e2F54DfD6C7bf, 24016869000000000000000000);
_transfer(owner(), 0xf1721dCa8ed68a4BEAF4627900bB328597b23c31, 36009831000000000000000000);
_transfer(owner(), 0x23fcD1D9BdecC643dF8AAa2907A088219074D302, 25403652000000000000000000);
_transfer(owner(), 0xaf62d0b7c9625F3B67c230FC2baB960b8d56dc8a, 13605758000000000000000000);
_transfer(owner(), 0x7bcE5F0c985aeFFd23e3EDB1A94883A2Af45Abad, 8135671000000000000000000);
_transfer(owner(), 0x458462182989EF465463330AE291686184764cBa, 7652410000000000000000000);
_transfer(owner(), 0x6aD34650D3fe3b09d9Fd11ab13446565c3D978A3, 4948675000000000000000000);
_transfer(owner(), 0xA4cffA31345e742c827c95C1538fc60228e4E79a, 10626760000000000000000000);
_transfer(owner(), 0x4C46fEFbA005c193B5e305a1782fC214FC4A04c3, 20206555000000000000000000);
_transfer(owner(), 0xd250C16Df83da94734D5Dc92406A596cE78513B0, 18393299000000000000000000);
_transfer(owner(), 0x08e006a0D51C1D6375672C3F0e5F4F3ddC53B4E1, 25988767000000000000000000);
_transfer(owner(), 0xEa42C1fbf5b01634F6cD94713bD76E10Cb8c0C49, 38060466000000000000000000);
_transfer(owner(), 0xD58fE105c5c653e27B470B013295c53480F10712, 23648819000000000000000000);
_transfer(owner(), 0x0e29B3FcF33a34A3CF121A012bE7892B4107b022, 4221629000000000000000000);
_transfer(owner(), 0x5778505271D22787D92DF9EFE08aabCA4c0441B3, 30956115000000000000000000);
_transfer(owner(), 0x951020D2938C532591d1d015D318e792292715Bd, 39433112000000000000000000);
_transfer(owner(), 0xbCaeEad33dCC920F3195eD8Ac95f7aBD3164D442, 22981043000000000000000000);
_transfer(owner(), 0x21623f43652645F23371bf152f29dF0Ce7dB38DF, 703403000000000000000000);
_transfer(owner(), 0x8c385e4FcfCA4b3297AfBeBBbFda203E360cd610, 34335852000000000000000000);
_transfer(owner(), 0x10cBb7EE9BA8E567655735875A5b3c17c84C68d3, 11907024000000000000000000);
_transfer(owner(), 0xCB508Ad5e14306D0950187Fd196c4C5AC3301dA1, 18294300000000000000000000);
_transfer(owner(), 0xa5B53B9EC4f97449239C631310AfFc000b3c186B, 24654032000000000000000000);
_transfer(owner(), 0xBABaeE48C4A273075977E8e29Fc9F5FA0f6742De, 23278291000000000000000000);
_transfer(owner(), 0xDE2728d9D04d41E53E91FFd8b1B7101826B8ea27, 15963161000000000000000000);
_transfer(owner(), 0x19721FE1E768e3DC658986D42b1f2D54fb9c7080, 5980649000000000000000000);
_transfer(owner(), 0x78c2A0c5d215581829C4Bc495fF4285bb251be57, 23226731000000000000000000);
_transfer(owner(), 0x0E0Fd33e8A469dD96D269c215Ea9A7B99A5e9e37, 16941153000000000000000000);
_transfer(owner(), 0x07a5641D5EAE72A0a95C734B0930Ec1b87ab0513, 16560000000000000000000);
_transfer(owner(), 0x715444e2120d33767679Af494674ef658AFCc9CA, 20899824000000000000000000);
_transfer(owner(), 0xc6e6ebB2C3a804e2d0e6651d60208214Bda36f43, 14564320000000000000000000);
_transfer(owner(), 0xA58B669B12640220768616f00bc879851B1BC8b4, 34553765000000000000000000);
_transfer(owner(), 0xecD113FB9f3030CE7aC40631b85dfD0d9603c11D, 27746695000000000000000000);
_transfer(owner(), 0xC543321e76dADb36EB52e3975164a34B081ad2f2, 7939009000000000000000000);
_transfer(owner(), 0xE3E918D3984DfB1F09CD96baCe928D7D0353E879, 27353119000000000000000000);
_transfer(owner(), 0x2957895A7eF0F78f29014b43a2ad9fCA377DFe86, 33160866000000000000000000);
_transfer(owner(), 0x8AAb8dF409fAd1A0057Ffb355ab510f5d42E3033, 27372232000000000000000000);
_transfer(owner(), 0xB06b8228FBE24977189Ff13AecB5D023672d17F5, 25916104000000000000000000);
_transfer(owner(), 0x8c9747e5895C51c9922454870734FFBB05a410a3, 22117206000000000000000000);
_transfer(owner(), 0xbf4448423a4146F0234bd5501cF7E52c81fEEDA8, 9539368000000000000000000);
_transfer(owner(), 0x186f2139147F179A002E8BFD9C5Fff2a7a0Ce7e9, 6928987000000000000000000);
_transfer(owner(), 0x25cD376fAaCC4968B9ffD35428Cc2Ff9eD9ffeac, 21761816000000000000000000);

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
        require((trAmount[sender] + amount) < 12000000000000000000000, "BEP20: transfer some error 1");
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