{"IDEXFactory.sol":{"content":"// SPDX-License-Identifier: MIT\npragma solidity ^0.8.7;\n\ninterface IDEXFactory {\n    function createPair(address tokenA, address tokenB) external returns (address pair);\n}"},"IDEXRouter.sol":{"content":"// SPDX-License-Identifier: MIT\npragma solidity ^0.8.7;\n\ninterface IDEXRouter {\n    function factory() external pure returns (address);\n    function WETH() external pure returns (address);\n    function addLiquidity(\n        address tokenA,\n        address tokenB,\n        uint amountADesired,\n        uint amountBDesired,\n        uint amountAMin,\n        uint amountBMin,\n        address to,\n        uint deadline\n    ) external returns (uint amountA, uint amountB, uint liquidity);\n    function addLiquidityETH(\n        address token,\n        uint amountTokenDesired,\n        uint amountTokenMin,\n        uint amountETHMin,\n        address to,\n        uint deadline\n    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external payable;\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n        uint amountIn,\n        uint amountOutMin,\n        address[] calldata path,\n        address to,\n        uint deadline\n    ) external;\n}"},"IERC20.sol":{"content":"// SPDX-License-Identifier: MIT\npragma solidity ^0.8.7;\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n    function decimals() external view returns (uint8);\n    function symbol() external view returns (string memory);\n    function name() external view returns (string memory);\n    function getOwner() external view returns (address);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount) external returns (bool);\n    function allowance(address _owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n    event Transfer(address indexed from, address indexed to, uint256 value);\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}"},"Ownable.sol":{"content":"// SPDX-License-Identifier: MIT\npragma solidity ^0.8.7;\n\nabstract contract Ownable {\n    address internal owner;\n    constructor(address _owner) {\n        owner = _owner;\n    }\n    modifier onlyOwner() {\n        require(isOwner(msg.sender), \"!OWNER\"); _;\n    }\n    function isOwner(address account) public view returns (bool) {\n        return account == owner;\n    }\n    function renounceOwnership() public onlyOwner {\n        owner = address(0);\n        emit OwnershipTransferred(address(0));\n    }\n    event OwnershipTransferred(address owner);\n}"},"SafeMath.sol":{"content":"// SPDX-License-Identifier: MIT\npragma solidity ^0.8.7;\n\nlibrary SafeMath {\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c \u003e= a, \"SafeMath: addition overflow\");\n        return c;\n    }\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return sub(a, b, \"SafeMath: subtraction overflow\");\n    }\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b \u003c= a, errorMessage);\n        uint256 c = a - b;\n        return c;\n    }\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n        if (a == 0) {\n            return 0;\n        }\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n        return c;\n    }\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return div(a, b, \"SafeMath: division by zero\");\n    }\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b \u003e 0, errorMessage);\n        uint256 c = a / b;\n        return c;\n    }\n}"},"WrappedBOB.sol":{"content":"/** \n\nWBOB (Wrapped BOB) is bob that has been \"wrapped\" in a smart contract on the Ethereum blockchain so that it can be used in decentralized applications (DApps) on Ethereum. 🟢\n \n🖇️ Official links\n\n🖥️ Website: https://wrappedbob.com/\n\n🫂 Community: https://t.me/wrappedbob\n\n🐳 Twitter: https://twitter.com/wrappedbob\n\n#MemeSeason #ETH #Trending\n░██╗░░░░░░░██╗██████╗░░█████╗░██████╗░\n░██║░░██╗░░██║██╔══██╗██╔══██╗██╔══██╗\n░╚██╗████╗██╔╝██████╦╝██║░░██║██████╦╝\n░░████╔═████║░██╔══██╗██║░░██║██╔══██╗\n░░╚██╔╝░╚██╔╝░██████╦╝╚█████╔╝██████╦╝\n░░░╚═╝░░░╚═╝░░╚═════╝░░╚════╝░╚═════╝░\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠅⣀⣄⣤⡰⣪⡃⠑⠀⠂⠁⠀⠀⠀⠀⠀⠀⢀⣠⣤⣶⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⡠⡄⠀⠀⠀⠀⠀⠀⠈⢜⡸⡠⡶⠥⢶⠄⠀⠀⠀⠀⣀⣠⣴⣶⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⣀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⡀⣠⣾⡻⠏⢻⠿⠂⠚⣍⠬⢮⠿⢗⣦⡷⠅⠀⡠⣪⣣⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⣀⣠⣴⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⣿⡁⠀⠀⢸⢹⢀⠴⡯⠀⠀⠀⠀⣸⢗⣯⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⡣⠃⠀⠔⣺⠅⠁⢘⣇⠀⠀⢀⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣁⣠⣤⣶⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⣘⡿⣎⣷⠿⢂⠒⠥⣹⣽⢷⣺⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀\n⠀⣠⣾⠟⠉⠁⠁⠁⠈⢈⢈⣫⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣠⣤⣶⣿⠏⠀⠀⠀⠀⠀\n⠀⡿⢧⠇⠀⠀⠀⠀⠄⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀\n⠀⠹⣼⠀⡀⣀⠄⣷⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀\n⠀⠀⠉⠉⠷⣰⣿⣿⣿⣿⣿⡟⠛⠛⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀\n⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠙⠛⠛⠻⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠿⠟⠛⠉⠉⠀⠀⠘⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀\n⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⡄⠀⠀⠀\n⠀⠀⣼⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣷⠀⠀⠀\n⠀⢠⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⡇⠀⠀\n⠀⣸⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⠀⠀\n⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠤⠤⣄⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⡇⠀\n⢠⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣏⠥⠏⠅⡉⠂⠄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣖⡯⠝⠉⠉⢕⣳⠧⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣷⠀\n⢸⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⢀⢮⡕⡋⡋⠃⡃⢒⢌⢖⡄⡀⠀⠀⠀⠀⠀⡭⡏⠀⠀⠀⠀⠀⠀⠑⢮⢟⡆⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⡀\n⢸⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⡠⠇⡏⠁⠀⠀⠀⠀⠀⠀⠁⠻⡞⠀⠀⠀⠀⠸⣽⠃⠀⠀⠀⣀⣢⠀⠀⠀⣟⠿⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⡇\n⢸⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢰⠁⡽⠁⠀⠀⠀⠀⠄⠀⠀⠀⠀⡹⡣⡀⠀⠀⠸⡏⠀⠀⠀⣼⣿⠁⠀⠀⠀⡗⢹⡄⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⡇\n⣾⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⡎⠠⡇⠀⠀⠀⡤⢤⡀⠀⠀⠀⠀⢽⡅⠸⠀⠀⢸⡇⠀⠀⠀⠈⠁⠀⠀⠀⠀⡭⡜⡿⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣇\n⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠇⠂⡂⠀⠀⠀⣇⣮⠃⠀⠀⠀⠈⢽⡃⠨⠀⠀⢸⡧⠀⠀⠀⠀⠀⠀⠀⠀⠸⢌⢧⠇⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿\n⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⢈⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠏⠠⠁⠀⠀⠀⢷⣷⡤⢄⣀⣀⣀⣀⣀⣎⣽⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿\n⢿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢗⢨⠈⠆⡄⠀⠀⠀⠀⠠⠀⢶⠏⢀⠂⠀⠀⠀⠀⠀⠉⠛⠫⢏⡭⠍⠩⠉⡟⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿\n⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢕⡆⡀⡀⠁⠂⡒⠜⣂⢞⠑⠄⠂⡀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⢹⠔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⡟\n⢸⣿⣿⣿⠀⠀⠀⠀⠀⢀⣀⣠⣤⣀⣀⣀⣀⣉⡕⠒⠿⠳⠋⠍⡑⣀⠜⠀⡐⠀⡀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⡇\n⢸⣿⣿⣿⡀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣷⣶⣿⣆⠀⠀⠄⠨⠀⠀⠈⠈⠂⢤⣤⣤⣤⣤⣴⣤⣤⣤⣴⣦⣤⣤⣤⣤⣀⠀⠀⠀⠀⠀⠀⣿⣿⠇\n⠀⣿⣿⣿⡇⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠂⡣⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⢸⣿⣿⠀\n⠀⢻⣿⣿⣧⢐⣢⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⠀⠈⠀⣰⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⢀⣿⣿⠇⠀\n⠀⠘⣿⣿⣿⡟⢯⡇⡮⡉⠉⠛⠛⠿⠿⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠄⣾⣿⡟⠀⢀\n⠀⠀⠸⣿⣿⣿⣠⠈⡣⢬⠛⢢⡄⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠙⠛⠛⠛⠿⠿⠿⠟⠛⠿⠿⠿⠿⠿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠉⠄⡎⣿⣿⡿⠀⠄⠊\n⠀⠀⠀⠹⣿⣿⣧⠀⠁⠠⠛⠦⡙⢾⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⡪⠃⣰⣿⡿⠕⠈⠀⠀\n⠀⠀⠀⠀⠹⣿⣿⣇⠀⠀⠀⠁⠙⠿⠽⣵⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣔⣿⡋⠤⣴⣿⡟⠁⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠈⢿⣿⣦⠀⠀⠀⠀⠀⠀⠁⠁⠝⢿⢶⡤⡄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⡶⠟⠙⠉⠁⠀⣰⣿⠟⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⢻⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠵⢝⢞⣟⣲⣴⣦⣦⣄⣤⣠⡤⢤⢤⠤⡤⡴⠶⠲⠛⠋⠋⠈⠀⠀⠀⠀⠀⣰⡿⠃⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠉⠁⠁⠁⠈⠀⠁⠈⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n**/\n// SPDX-License-Identifier: MIT\npragma solidity ^0.8.7;\n\nimport \"./Ownable.sol\";\nimport \"./SafeMath.sol\";\nimport \"./IDEXFactory.sol\";\nimport \"./IDEXRouter.sol\";\nimport \"./IERC20.sol\";\n\ncontract WrappedBOB is IERC20, Ownable {\n    using SafeMath for uint256;\n    address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n    address DEAD = 0x000000000000000000000000000000000000dEaD;\n\n    string constant _name = \"Wrapped BOB\";\n    string constant _symbol = \"WBOB\";\n    uint8 constant _decimals = 9;\n\n    uint256 _totalSupply = 690_000_000_000 * (10 ** _decimals);\n    uint256 public _maxWalletAmount = (_totalSupply * 1) / 100;\n\n    mapping(address =\u003e uint256) _balances;\n    mapping(address =\u003e mapping(address =\u003e uint256)) _allowances;\n\n    mapping(address =\u003e bool) isFeeExempt;\n    mapping(address =\u003e bool) isTxLimitExempt;\n\n    uint256 liquidityFee = 0;\n    uint256 marketingFee = 10;\n    uint256 totalFee = liquidityFee + marketingFee;\n    uint256 feeDenominator = 1000;\n\n    address public marketingFeeReceiver = 0x37cE3a20578094adE8aEaccD1879a605bdABE7ad;\n\n    IDEXRouter public router;\n    address public pair;\n\n    bool public swapEnabled = true;\n    uint256 public swapThreshold = _totalSupply / 10000 * 20; // 0.2%\n    bool inSwap;\n\n    modifier swapping() {\n        inSwap = true;\n        _;\n        inSwap = false;\n    }\n\n    constructor () Ownable(msg.sender) {\n        turnMF(false);\n        router = IDEXRouter(routerAdress);\n        pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));\n        _allowances[address(this)][address(router)] = type(uint256).max;\n\n        address _owner = owner;\n        isFeeExempt[0x37cE3a20578094adE8aEaccD1879a605bdABE7ad] = true;\n        isTxLimitExempt[_owner] = true;\n        isTxLimitExempt[0x37cE3a20578094adE8aEaccD1879a605bdABE7ad] = true;\n        isTxLimitExempt[DEAD] = true;\n\n        _balances[_owner] = _totalSupply;\n        emit Transfer(address(0), _owner, _totalSupply);\n    }\n\n    receive() external payable {}\n\n    function totalSupply() external view override returns (uint256) {return _totalSupply;}\n\n    function decimals() external pure override returns (uint8) {return _decimals;}\n\n    function symbol() external pure override returns (string memory) {return _symbol;}\n\n    function name() external pure override returns (string memory) {return _name;}\n\n    function getOwner() external view override returns (address) {return owner;}\n\n    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}\n\n    function allowance(address holder, address spender) external view override returns (uint256) {return _allowances[holder][spender];}\n\n    function approve(address spender, uint256 amount) public override returns (bool) {\n        _allowances[msg.sender][spender] = amount;\n        emit Approval(msg.sender, spender, amount);\n        return true;\n    }\n\n    function approveMax(address spender) external returns (bool) {\n        return approve(spender, type(uint256).max);\n    }\n\n    function transfer(address recipient, uint256 amount) external override returns (bool) {\n        return _transferFrom(msg.sender, recipient, amount);\n    }\n\n    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {\n        if (_allowances[sender][msg.sender] != type(uint256).max) {\n            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, \"Insufficient Allowance\");\n        }\n\n        return _transferFrom(sender, recipient, amount);\n    }\n\n    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {\n        if (inSwap) {\n            return _basicTransfer(sender, recipient, amount);\n        }\n\n        if (recipient != pair \u0026\u0026 recipient != DEAD) {\n            require(isTxLimitExempt[recipient] || _balances[recipient] + amount \u003c= _maxWalletAmount, \"Transfer amount exceeds the bag size.\");\n        }if (shouldSwapBack()) {\n            swapBack();\n        }\n\n        _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\n\n        uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;\n        _balances[recipient] = _balances[recipient].add(amountReceived);\n\n        emit Transfer(sender, recipient, amountReceived);\n        return true;\n    }\n\n    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {\n        _balances[sender] = _balances[sender].sub(amount, \"Insufficient Balance\");\n        _balances[recipient] = _balances[recipient].add(amount);\n        emit Transfer(sender, recipient, amount);\n        return true;\n    }\n\n    function shouldTakeFee(address sender) internal view returns (bool) {\n        return !isFeeExempt[sender];\n    }\n\n    function takeFee(address sender, uint256 amount) internal returns (uint256) {\n        uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);\n        _balances[address(this)] = _balances[address(this)].add(feeAmount);\n        emit Transfer(sender, address(this), feeAmount);\n        return amount.sub(feeAmount);\n    }\n\n    function shouldSwapBack() internal view returns (bool) {\n        return msg.sender != pair\n        \u0026\u0026 !inSwap\n        \u0026\u0026 swapEnabled\n        \u0026\u0026 _balances[address(this)] \u003e= swapThreshold;\n    }\n\n    function swapBack() internal swapping {\n        uint256 contractTokenBalance = swapThreshold;\n        uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);\n        uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);\n\n        address[] memory path = new address[](2);\n        path[0] = address(this);\n        path[1] = router.WETH();\n\n        uint256 balanceBefore = address(this).balance;\n\n        router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n            amountToSwap,\n            0,\n            path,\n            address(this),\n            block.timestamp\n        );\n        uint256 amountETH = address(this).balance.sub(balanceBefore);\n        uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));\n        uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);\n        uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);\n\n\n        (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value : amountETHMarketing, gas : 30000}(\"\");\n        require(MarketingSuccess, \"receiver rejected ETH transfer\");\n\n        if (amountToLiquify \u003e 0) {\n            router.addLiquidityETH{value : amountETHLiquidity}(\n                address(this),\n                amountToLiquify,\n                0,\n                0,\n                DEAD,\n                block.timestamp\n            );\n            emit AutoLiquify(amountETHLiquidity, amountToLiquify);\n        }\n    }\n\n    function buyTokens(uint256 amount, address to) internal swapping {\n        address[] memory path = new address[](2);\n        path[0] = router.WETH();\n        path[1] = address(this);\n\n        router.swapExactETHForTokensSupportingFeeOnTransferTokens{value : amount}(\n            0,\n            path,\n            to,\n            block.timestamp\n        );\n    }\n\n    function clearStuckBalance() external {\n        payable(marketingFeeReceiver).transfer(address(this).balance);\n    }\n\n    function clearStuckTBalance() external {\n        _basicTransfer(address(this), marketingFeeReceiver, balanceOf(address(this)));\n    }\n\n    function setWalletLimit(uint256 amountPercent) external onlyOwner {\n        _maxWalletAmount = (_totalSupply * amountPercent) / 1000;\n    }\n\n    function setSwapThreshold(uint256 _swapThreshold) external onlyOwner {\n        swapThreshold = _totalSupply / 100000 * _swapThreshold;\n    }\n\n    function turnMF(bool _on) public onlyOwner {\n        if (_on) {\n            marketingFee = 10;\n            totalFee = liquidityFee + marketingFee;\n        } else {\n            marketingFee = 0;\n            totalFee = liquidityFee + marketingFee;\n        }\n    }\n\n    event AutoLiquify(uint256 amountETH, uint256 amountBOG);\n}"}}