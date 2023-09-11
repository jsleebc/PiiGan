{{
  "language": "Solidity",
  "sources": {
    "src/PPAPTokenV2.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity ^0.8.17;\n\nimport {ERC20} from \"solmate/tokens/ERC20.sol\";\nimport {Owned} from \"solmate/auth/Owned.sol\";\n\nimport {IsContract} from \"./libraries/isContract.sol\";\n\nimport \"./interfaces/univ2.sol\";\n\nerror NotStartedYet();\nerror Blocked();\n\ncontract PPAPToken is ERC20(\"PPAP Token\", \"$PPAP\", 18), Owned(msg.sender) {\n    using IsContract for address;\n\n    mapping(address => bool) public whitelisted;\n    mapping(address => bool) public blocked;\n\n    IUniswapV2Pair public pair;\n    IUniswapV2Router02 public router;\n    uint256 public startedIn = 0;\n    uint256 public startedAt = 0;\n\n    address public treasury;\n\n    uint256 public feeCollected = 0;\n    uint256 public feeSwapBps = 100; // 1.00% liquidity increase\n    uint256 public feeSwapTrigger = 10e18;\n\n    uint256 maxBps = 10000; // 10000 is 100.00%\n    // 0-1 blocks\n    uint256 public initialBuyBPS = 9000; // 90.00%\n    uint256 public initialSellBPS = 9000; // 90.00%\n    // 24 hours\n    uint256 public earlyBuyBPS = 200; // 2.00%\n    uint256 public earlySellBPS = 2000; // 20.00%\n    // after\n    uint256 public buyBPS = 200; // 2.00%\n    uint256 public sellBPS = 400; // 4.00%\n\n    constructor() {\n        treasury = address(0xC5cAd10E496D0F3dBd3b73742B8b3a9A92cA4DcA);\n        uint256 expectedTotalSupply = 369_000_000_000 ether;\n        whitelisted[treasury] = true;\n        whitelisted[address(this)] = true;\n        _mint(treasury, expectedTotalSupply);\n    }\n\n    // getters\n    function isLiqudityPool(address account) public view returns (bool) {\n        if (!account.isContract()) return false;\n        (bool success0, bytes memory result0) = account.staticcall(\n            abi.encodeWithSignature(\"token0()\")\n        );\n        if (!success0) return false;\n        (bool success1, bytes memory result1) = account.staticcall(\n            abi.encodeWithSignature(\"token1()\")\n        );\n        if (!success1) return false;\n        address token0 = abi.decode(result0, (address));\n        address token1 = abi.decode(result1, (address));\n        if (token0 == address(this) || token1 == address(this)) return true;\n        return false;\n    }\n\n    // public functions\n\n    function burn(uint256 amount) public {\n        _burn(msg.sender, amount);\n    }\n\n    // transfer functions\n    function _onTransfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal returns (uint256) {\n        if (blocked[to] || blocked[from]) {\n            revert Blocked();\n        }\n        if(whitelisted[from] || whitelisted[to]) {\n            return amount;\n        }\n\n        if (startedIn == 0) {\n            revert NotStartedYet();\n        }\n\n        if (isLiqudityPool(to) || isLiqudityPool(from)) {\n            return _transferFee(from, to, amount);\n        }\n\n        if (feeCollected > feeSwapTrigger) {\n            _swapFee();\n        }\n\n        return amount;\n    }\n\n    function _swapFee() internal {\n        uint256 feeAmount = feeCollected;\n        feeCollected = 0;\n        if(address(pair) == address(0)) return;\n\n\n        (address token0, address token1) = (pair.token0(), pair.token1());\n        (uint112 reserve0, uint112 reserve1, ) = pair.getReserves();\n\n        if (token1 == address(this)) {\n            (token0, token1) = (token1, token0);\n            (reserve0, reserve1) = (reserve1, reserve0);\n        }\n\n        uint256 maxFee = reserve0 * feeSwapBps / maxBps;\n        if (maxFee < feeAmount) {\n            feeCollected = feeAmount - maxFee;\n            feeAmount = maxFee;\n        }\n\n        if(feeAmount == 0) return;\n\n        address[] memory path = new address[](2);\n        path[0] = token0;\n        path[1] = token1;\n\n        this.approve(address(router), feeAmount);\n        router.swapExactTokensForTokens(\n            feeAmount,\n            0,\n            path,\n            treasury,\n            block.timestamp + 1000\n        );\n    }\n\n    function _transferFee(\n        address from,\n        address to,\n        uint256 amount\n    ) internal returns (uint256) {\n        uint256 taxBps = 0;\n\n        if (isLiqudityPool(from)) {\n            if (block.number <= startedIn + 1) {\n                taxBps = initialBuyBPS;\n            } else if (block.timestamp <= startedAt + 24 hours) {\n                taxBps = earlyBuyBPS;\n            } else {\n                taxBps = buyBPS;\n            }\n        } else if (isLiqudityPool(to)) {\n            if (block.number <= startedIn + 1) {\n                taxBps = initialSellBPS;\n            } else if (block.timestamp <= startedAt + 24 hours) {\n                taxBps = earlySellBPS;\n            } else {\n                taxBps = sellBPS;\n            }\n        }\n\n        uint256 feeAmount = (amount * taxBps) / maxBps;\n        if (feeAmount == 0) return amount;\n\n        feeCollected += feeAmount;\n        amount -= feeAmount;\n\n        _transfer(from, address(this), feeAmount);\n\n        return amount;\n    }\n\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public override returns (bool) {\n        if (from != address(this) && to != address(this)) {\n            amount = _onTransfer(from, to, amount);\n        }\n\n        return super.transferFrom(from, to, amount);\n    }\n\n    function transfer(address to, uint256 amount)\n        public\n        override\n        returns (bool)\n    {\n        if (msg.sender != address(this) && to != address(this)) {\n            amount = _onTransfer(msg.sender, to, amount);\n        }\n        return super.transfer(to, amount);\n    }\n\n    function _transfer(\n        address from,\n        address to,\n        uint256 amount\n    ) internal returns (bool) {\n        balanceOf[from] -= amount;\n        unchecked {\n            balanceOf[to] += amount;\n        }\n        emit Transfer(from, to, amount);\n        return true;\n    }\n\n    // Only owner functions\n    function start() public onlyOwner {\n        require(startedIn == 0, \"PPAP: already started\");\n        startedIn = block.number;\n        startedAt = block.timestamp;\n    }\n\n    function setUni(address _router, address _pair) public onlyOwner {\n        router = IUniswapV2Router02(_router);\n        pair = IUniswapV2Pair(_pair);\n        (address token0, address token1) = (pair.token0(), pair.token1());\n        require(token0 == address(this) || token1 == address(this), \"PPAP: wrong pair\");\n        require(pair.factory() == router.factory(), \"PPAP: wrong pair\");\n    }\n\n    function setFeeSwapConfig(uint256 _feeSwapTrigger, uint256 _feeSwapBps) public onlyOwner {\n        feeSwapTrigger = _feeSwapTrigger;\n        feeSwapBps = _feeSwapBps;\n    }\n\n    function setBps(uint256 _buyBPS, uint256 _sellBPS) public onlyOwner {\n        require(_buyBPS <= 200, \"PPAP: wrong buyBPS\");\n        require(_sellBPS <= 400, \"PPAP: wrong sellBPS\");\n        buyBPS = _buyBPS;\n        sellBPS = _sellBPS;\n    }\n\n    function setTreasury(address _treasury) public onlyOwner {\n        treasury = _treasury;\n    }\n\n    function whitelist(address account, bool _whitelisted) public onlyOwner {\n        whitelisted[account] = _whitelisted;\n    }\n\n    function blocklist(address account, bool _blocked) public onlyOwner {\n        require(startedAt > 0, \"PPAP: too early\");\n        require(startedAt + 7 days > block.timestamp, \"PPAP: too late\");\n        blocked[account] = _blocked;\n    }\n\n    // meme\n    function penPineappleApplePen() public pure returns (string memory) {\n        return meme(\"pen\", \"apple\");\n    }\n\n    function meme(string memory _what, string memory _with)\n        public\n        pure\n        returns (string memory)\n    {\n        return\n            string(\n                abi.encodePacked(\n                    \"I have a \",\n                    _what,\n                    \", I have a \",\n                    _with,\n                    \", UH, \",\n                    _what,\n                    \"-\",\n                    _with,\n                    \"!\"\n                )\n            );\n    }\n\n    function link() public pure returns (string memory) {\n        return \"https://www.youtube.com/watch?v=0E00Zuayv9Q\";\n    }\n}\n"
    },
    "lib/solmate/src/tokens/ERC20.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-only\npragma solidity >=0.8.0;\n\n/// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.\n/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)\n/// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)\n/// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.\nabstract contract ERC20 {\n    /*//////////////////////////////////////////////////////////////\n                                 EVENTS\n    //////////////////////////////////////////////////////////////*/\n\n    event Transfer(address indexed from, address indexed to, uint256 amount);\n\n    event Approval(address indexed owner, address indexed spender, uint256 amount);\n\n    /*//////////////////////////////////////////////////////////////\n                            METADATA STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    string public name;\n\n    string public symbol;\n\n    uint8 public immutable decimals;\n\n    /*//////////////////////////////////////////////////////////////\n                              ERC20 STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    uint256 public totalSupply;\n\n    mapping(address => uint256) public balanceOf;\n\n    mapping(address => mapping(address => uint256)) public allowance;\n\n    /*//////////////////////////////////////////////////////////////\n                            EIP-2612 STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    uint256 internal immutable INITIAL_CHAIN_ID;\n\n    bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;\n\n    mapping(address => uint256) public nonces;\n\n    /*//////////////////////////////////////////////////////////////\n                               CONSTRUCTOR\n    //////////////////////////////////////////////////////////////*/\n\n    constructor(\n        string memory _name,\n        string memory _symbol,\n        uint8 _decimals\n    ) {\n        name = _name;\n        symbol = _symbol;\n        decimals = _decimals;\n\n        INITIAL_CHAIN_ID = block.chainid;\n        INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                               ERC20 LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function approve(address spender, uint256 amount) public virtual returns (bool) {\n        allowance[msg.sender][spender] = amount;\n\n        emit Approval(msg.sender, spender, amount);\n\n        return true;\n    }\n\n    function transfer(address to, uint256 amount) public virtual returns (bool) {\n        balanceOf[msg.sender] -= amount;\n\n        // Cannot overflow because the sum of all user\n        // balances can't exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        emit Transfer(msg.sender, to, amount);\n\n        return true;\n    }\n\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public virtual returns (bool) {\n        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.\n\n        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;\n\n        balanceOf[from] -= amount;\n\n        // Cannot overflow because the sum of all user\n        // balances can't exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        emit Transfer(from, to, amount);\n\n        return true;\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                             EIP-2612 LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function permit(\n        address owner,\n        address spender,\n        uint256 value,\n        uint256 deadline,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) public virtual {\n        require(deadline >= block.timestamp, \"PERMIT_DEADLINE_EXPIRED\");\n\n        // Unchecked because the only math done is incrementing\n        // the owner's nonce which cannot realistically overflow.\n        unchecked {\n            address recoveredAddress = ecrecover(\n                keccak256(\n                    abi.encodePacked(\n                        \"\\x19\\x01\",\n                        DOMAIN_SEPARATOR(),\n                        keccak256(\n                            abi.encode(\n                                keccak256(\n                                    \"Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)\"\n                                ),\n                                owner,\n                                spender,\n                                value,\n                                nonces[owner]++,\n                                deadline\n                            )\n                        )\n                    )\n                ),\n                v,\n                r,\n                s\n            );\n\n            require(recoveredAddress != address(0) && recoveredAddress == owner, \"INVALID_SIGNER\");\n\n            allowance[recoveredAddress][spender] = value;\n        }\n\n        emit Approval(owner, spender, value);\n    }\n\n    function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {\n        return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();\n    }\n\n    function computeDomainSeparator() internal view virtual returns (bytes32) {\n        return\n            keccak256(\n                abi.encode(\n                    keccak256(\"EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)\"),\n                    keccak256(bytes(name)),\n                    keccak256(\"1\"),\n                    block.chainid,\n                    address(this)\n                )\n            );\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                        INTERNAL MINT/BURN LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function _mint(address to, uint256 amount) internal virtual {\n        totalSupply += amount;\n\n        // Cannot overflow because the sum of all user\n        // balances can't exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        emit Transfer(address(0), to, amount);\n    }\n\n    function _burn(address from, uint256 amount) internal virtual {\n        balanceOf[from] -= amount;\n\n        // Cannot underflow because a user's balance\n        // will never be larger than the total supply.\n        unchecked {\n            totalSupply -= amount;\n        }\n\n        emit Transfer(from, address(0), amount);\n    }\n}\n"
    },
    "lib/solmate/src/auth/Owned.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-only\npragma solidity >=0.8.0;\n\n/// @notice Simple single owner authorization mixin.\n/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)\nabstract contract Owned {\n    /*//////////////////////////////////////////////////////////////\n                                 EVENTS\n    //////////////////////////////////////////////////////////////*/\n\n    event OwnershipTransferred(address indexed user, address indexed newOwner);\n\n    /*//////////////////////////////////////////////////////////////\n                            OWNERSHIP STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    address public owner;\n\n    modifier onlyOwner() virtual {\n        require(msg.sender == owner, \"UNAUTHORIZED\");\n\n        _;\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                               CONSTRUCTOR\n    //////////////////////////////////////////////////////////////*/\n\n    constructor(address _owner) {\n        owner = _owner;\n\n        emit OwnershipTransferred(address(0), _owner);\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                             OWNERSHIP LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        owner = newOwner;\n\n        emit OwnershipTransferred(msg.sender, newOwner);\n    }\n}\n"
    },
    "src/libraries/isContract.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// Taken from Address.sol from OpenZeppelin.\npragma solidity ^0.8.0;\n\n\nlibrary IsContract {\n  /// @dev Returns true if `account` is a contract.\n  function isContract(address account) internal view returns (bool) {\n      // This method relies on extcodesize, which returns 0 for contracts in\n      // construction, since the code is only stored at the end of the\n      // constructor execution.\n\n      uint256 size;\n      assembly { size := extcodesize(account) }\n      return size > 0;\n  }\n}\n"
    },
    "src/interfaces/univ2.sol": {
      "content": "// SPDX-License-Identifier: UNLICENSED\npragma solidity >0.5.16;\n\n\ninterface IUniswapV2Factory {\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n\n    function feeTo() external view returns (address);\n    function feeToSetter() external view returns (address);\n\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\n    function allPairs(uint) external view returns (address pair);\n    function allPairsLength() external view returns (uint);\n\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n\n    function setFeeTo(address) external;\n    function setFeeToSetter(address) external;\n}\n\ninterface IUniswapV2Pair {\n    event Approval(address indexed owner, address indexed spender, uint value);\n    event Transfer(address indexed from, address indexed to, uint value);\n\n    function name() external pure returns (string memory);\n    function symbol() external pure returns (string memory);\n    function decimals() external pure returns (uint8);\n    function totalSupply() external view returns (uint);\n    function balanceOf(address owner) external view returns (uint);\n    function allowance(address owner, address spender) external view returns (uint);\n\n    function approve(address spender, uint value) external returns (bool);\n    function transfer(address to, uint value) external returns (bool);\n    function transferFrom(address from, address to, uint value) external returns (bool);\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\n    function nonces(address owner) external view returns (uint);\n\n    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n\n    event Mint(address indexed sender, uint amount0, uint amount1);\n    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n    event Swap(\n        address indexed sender,\n        uint amount0In,\n        uint amount1In,\n        uint amount0Out,\n        uint amount1Out,\n        address indexed to\n    );\n    event Sync(uint112 reserve0, uint112 reserve1);\n\n    function MINIMUM_LIQUIDITY() external pure returns (uint);\n    function factory() external view returns (address);\n    function token0() external view returns (address);\n    function token1() external view returns (address);\n    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n    function price0CumulativeLast() external view returns (uint);\n    function price1CumulativeLast() external view returns (uint);\n    function kLast() external view returns (uint);\n\n    function mint(address to) external returns (uint liquidity);\n    function burn(address to) external returns (uint amount0, uint amount1);\n    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n    function skim(address to) external;\n    function sync() external;\n\n    function initialize(address, address) external;\n}\n\ninterface IUniswapV2ERC20 {\n    event Approval(address indexed owner, address indexed spender, uint value);\n    event Transfer(address indexed from, address indexed to, uint value);\n\n    function name() external pure returns (string memory);\n    function symbol() external pure returns (string memory);\n    function decimals() external pure returns (uint8);\n    function totalSupply() external view returns (uint);\n    function balanceOf(address owner) external view returns (uint);\n    function allowance(address owner, address spender) external view returns (uint);\n\n    function approve(address spender, uint value) external returns (bool);\n    function transfer(address to, uint value) external returns (bool);\n    function transferFrom(address from, address to, uint value) external returns (bool);\n\n    function DOMAIN_SEPARATOR() external view returns (bytes32);\n    function PERMIT_TYPEHASH() external pure returns (bytes32);\n    function nonces(address owner) external view returns (uint);\n\n    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n}\n\n\ninterface IUniswapV2Router01 {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint amountADesired,\n        uint amountBDesired,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB, uint liquidity);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n    function removeLiquidity(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETH(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountToken, uint amountETH);\n    function removeLiquidityWithPermit(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETHWithPermit(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountToken, uint amountETH);\n    function swapExactTokensForTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapTokensForExactTokens(\n        uint amountOut,\n        uint amountInMax,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n        external\n        payable\n        returns (uint[] memory amounts);\n    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n        external\n        returns (uint[] memory amounts);\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n        external\n        returns (uint[] memory amounts);\n    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n        external\n        payable\n        returns (uint[] memory amounts);\n\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n}\n\n\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountETH);\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountETH);\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n\n"
    }
  },
  "settings": {
    "remappings": [
      "ds-test/=lib/solmate/lib/ds-test/src/",
      "forge-std/=lib/forge-std/src/",
      "solmate/=lib/solmate/src/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 1337
    },
    "metadata": {
      "bytecodeHash": "ipfs",
      "appendCBOR": true
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    },
    "evmVersion": "paris",
    "libraries": {}
  }
}}