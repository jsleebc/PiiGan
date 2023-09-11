{{
  "language": "Solidity",
  "sources": {
    "/contracts/begETH.sol": {
      "content": "/*\r\n .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. \r\n| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |\r\n| |   ______     | || |      __      | || |    ______    | || |  _________   | || |  _________   | || |  ____  ____  | |\r\n| |  |_   _ \\    | || |     /  \\     | || |  .' ___  |   | || | |_   ___  |  | || | |  _   _  |  | || | |_   ||   _| | |\r\n| |    | |_) |   | || |    / /\\ \\    | || | / .'   \\_|   | || |   | |_  \\_|  | || | |_/ | | \\_|  | || |   | |__| |   | |\r\n| |    |  __'.   | || |   / ____ \\   | || | | |    ____  | || |   |  _|  _   | || |     | |      | || |   |  __  |   | |\r\n| |   _| |__) |  | || | _/ /    \\ \\_ | || | \\ `.___]  _| | || |  _| |___/ |  | || |    _| |_     | || |  _| |  | |_  | |\r\n| |  |_______/   | || ||____|  |____|| || |  `._____.'   | || | |_________|  | || |   |_____|    | || | |____||____| | |\r\n| |              | || |              | || |              | || |              | || |              | || |              | |\r\n| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |\r\n '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' \r\n*/\r\n// SPDX-License-Identifier: MIT\r\npragma solidity ^0.8.10;\r\n\r\n// interface IUniFactory   : Interface of Uniswap Router\r\n\r\ninterface IUniFactory {\r\n    function createPair(\r\n        address tokenA,\r\n        address tokenB\r\n    ) external returns (address pair);\r\n}\r\n\r\n// interface IUniRouter  : Interface of Uniswap\r\n\r\ninterface IUniRouter {\r\n    function factory() external pure returns (address);\r\n\r\n    function WETH() external pure returns (address);\r\n\r\n    function addLiquidityETH(\r\n        address token,\r\n        uint256 amountTokenDesired,\r\n        uint256 amountTokenMin,\r\n        uint256 amountETHMin,\r\n        address to,\r\n        uint256 deadline\r\n    )\r\n        external\r\n        payable\r\n        returns (uint256 amountToken, uint256 amountETH, uint256 _liquedity);\r\n\r\n    function swapExactETHForTokensSupportingFeeOnTransferTokens(\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external payable;\r\n\r\n    function swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n        uint256 amountIn,\r\n        uint256 amountOutMin,\r\n        address[] calldata path,\r\n        address to,\r\n        uint256 deadline\r\n    ) external;\r\n}\r\n\r\n// interface IERC20 : IERC20 Token Interface which would be used in calling token contract\r\ninterface IERC20 {\r\n    function totalSupply() external view returns (uint256); //Total Supply of Token\r\n\r\n    function decimals() external view returns (uint8); // Decimal of TOken\r\n\r\n    function symbol() external view returns (string memory); // Symbol of Token\r\n\r\n    function name() external view returns (string memory); // Name of Token\r\n\r\n    function balanceOf(address account) external view returns (uint256); // Balance of TOken\r\n\r\n    //Transfer token from one address to another\r\n\r\n    function transfer(\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    // Get allowance to the spacific users\r\n\r\n    function allowance(\r\n        address _owner,\r\n        address spender\r\n    ) external view returns (uint256);\r\n\r\n    // Give approval to spend token to another addresses\r\n\r\n    function approve(address spender, uint256 amount) external returns (bool);\r\n\r\n    // Transfer token from one address to another\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external returns (bool);\r\n\r\n    //Trasfer Event\r\n    event Transfer(address indexed from, address indexed to, uint256 value);\r\n\r\n    //Approval Event\r\n    event Approval(\r\n        address indexed owner,\r\n        address indexed spender,\r\n        uint256 value\r\n    );\r\n}\r\n\r\n// This contract helps to add Owners\r\n/**\r\n * @dev Contract module which provides a basic access control mechanism, where\r\n * there is an account (an owner) that can be granted exclusive access to\r\n * specific functions.\r\n \r\n */\r\nabstract contract Ownable {\r\n    address private _owner;\r\n\r\n    event OwnershipTransferred(\r\n        address indexed previousOwner,\r\n        address indexed newOwner\r\n    );\r\n\r\n    /**\r\n     * @dev Initializes the contract setting the deployer as the initial owner.\r\n     */\r\n    constructor() {\r\n        _transferOwnership(msg.sender);\r\n    }\r\n\r\n    /**\r\n     * @dev Throws if called by any account other than the owner.\r\n     */\r\n    modifier onlyOwner() {\r\n        _checkOwner();\r\n        _;\r\n    }\r\n\r\n    /**\r\n     * @dev Returns the address of the current owner.\r\n     */\r\n    function owner() public view virtual returns (address) {\r\n        return _owner;\r\n    }\r\n\r\n    /**\r\n     * @dev Throws if the sender is not the owner.\r\n     */\r\n    function _checkOwner() internal view virtual {\r\n        require(owner() == msg.sender, \"Ownable: caller is not the owner\");\r\n    }\r\n\r\n    /**\r\n     * @dev Leaves the contract without owner. It will not be possible to call\r\n     * `onlyOwner` functions anymore. Can only be called by the current owner.\r\n     *\r\n     * NOTE: Renouncing ownership will leave the contract without an owner,\r\n     * thereby removing any functionality that is only available to the owner.\r\n     */\r\n    function renounceOwnership() public virtual onlyOwner {\r\n        _transferOwnership(address(0));\r\n    }\r\n\r\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Can only be called by the current owner.\r\n     */\r\n    function transferOwnership(address newOwner) public virtual onlyOwner {\r\n        require(\r\n            newOwner != address(0),\r\n            \"Ownable: new owner is the zero address\"\r\n        );\r\n        _transferOwnership(newOwner);\r\n    }\r\n\r\n    /**\r\n     * @dev Transfers ownership of the contract to a new account (`newOwner`).\r\n     * Internal function without access restriction.\r\n     */\r\n    function _transferOwnership(address newOwner) internal virtual {\r\n        address oldOwner = _owner;\r\n        _owner = newOwner;\r\n        emit OwnershipTransferred(oldOwner, newOwner);\r\n    }\r\n}\r\n\r\n// Interface IRewardDistributor : Interface that is used by  Reward Distributor\r\n\r\ninterface IRewardDistributor {\r\n    function setDistributionStandard(\r\n        uint256 _minPeriod,\r\n        uint256 _minDistribution\r\n    ) external;\r\n\r\n    function setShare(address shareholder, uint256 amount) external;\r\n\r\n    // function depositEth() external payable;\r\n\r\n    function process(uint256 gas) external;\r\n\r\n    function claimReward(address _user) external;\r\n\r\n    function getPaidEarnings(\r\n        address shareholder\r\n    ) external view returns (uint256);\r\n\r\n    function getUnpaidEarnings(\r\n        address shareholder\r\n    ) external view returns (uint256);\r\n\r\n    function totalDistributed() external view returns (uint256);\r\n\r\n    function minEth() external view returns (uint256);\r\n}\r\n\r\n// RewardDistributor : It distributes reward amoung holders\r\n\r\ncontract RewardDistributor is IRewardDistributor {\r\n    using SafeMath for uint256;\r\n\r\n    address public _token;\r\n\r\n    struct Share {\r\n        uint256 amount;\r\n        uint256 totalExcluded;\r\n        uint256 totalRealised;\r\n    }\r\n\r\n    IUniRouter public router;\r\n\r\n    address[] public shareholders;\r\n    mapping(address => uint256) public shareholderIndexes;\r\n    mapping(address => uint256) public shareholderClaims;\r\n\r\n    mapping(address => Share) public shares;\r\n\r\n    uint256 public totalShares;\r\n    uint256 public totalRewards;\r\n    uint256 public totalDistributed;\r\n    uint256 public rewardsPerShare;\r\n    uint256 public rewardsPerShareAccuracyFactor = 10 ** 36;\r\n\r\n    uint256 public minPeriod = 1 days;\r\n    uint256 public _minEth = 56000000000000000;\r\n    uint256 public minDistribution;\r\n\r\n    uint256 currentIndex;\r\n\r\n    bool initialized;\r\n    modifier initializer() {\r\n        require(!initialized);\r\n        _;\r\n        initialized = true;\r\n    }\r\n\r\n    modifier onlyToken() {\r\n        require(msg.sender == _token);\r\n        _;\r\n    }\r\n\r\n    constructor(address _router) {\r\n        _token = msg.sender;\r\n        router = IUniRouter(_router);\r\n    }\r\n\r\n    receive() external payable {\r\n        depositEth(msg.value);\r\n    }\r\n\r\n    function setDistributionStandard(\r\n        uint256 _minPeriod,\r\n        uint256 _minDistribution\r\n    ) external override onlyToken {\r\n        minPeriod = _minPeriod;\r\n        minDistribution = _minDistribution;\r\n    }\r\n\r\n    function setShare(\r\n        address shareholder,\r\n        uint256 amount\r\n    ) external override onlyToken {\r\n        if (shares[shareholder].amount > 0) {\r\n            distributeReward(shareholder);\r\n        }\r\n\r\n        if (amount > 0 && shares[shareholder].amount == 0) {\r\n            addShareholder(shareholder);\r\n        } else if (amount == 0 && shares[shareholder].amount > 0) {\r\n            removeShareholder(shareholder);\r\n        }\r\n\r\n        totalShares = totalShares.sub(shares[shareholder].amount).add(amount);\r\n        shares[shareholder].amount = amount;\r\n        shares[shareholder].totalExcluded = getCumulativeRewards(\r\n            shares[shareholder].amount\r\n        );\r\n    }\r\n\r\n    function depositEth(uint256 amount) internal {\r\n        totalRewards = totalRewards.add(amount);\r\n        rewardsPerShare = rewardsPerShare.add(\r\n            rewardsPerShareAccuracyFactor.mul(amount).div(totalShares)\r\n        );\r\n    }\r\n\r\n    // function for chaniging the eth|Contract balance to claim reward\r\n    function _setMinEThContractBalance(uint256 _ethAmount) public onlyToken {\r\n        _minEth = _ethAmount;\r\n    }\r\n\r\n    function minEth() public view returns (uint256) {\r\n        return _minEth;\r\n    }\r\n\r\n    function process(uint256 gas) external override onlyToken {\r\n        uint256 shareholderCount = shareholders.length;\r\n\r\n        if (shareholderCount == 0) {\r\n            return;\r\n        }\r\n\r\n        uint256 gasUsed = 0;\r\n        uint256 gasLeft = gasleft();\r\n\r\n        uint256 iterations = 0;\r\n\r\n        while (gasUsed < gas && iterations < shareholderCount) {\r\n            if (currentIndex >= shareholderCount) {\r\n                currentIndex = 0;\r\n            }\r\n\r\n            if (shouldDistribute(shareholders[currentIndex])) {\r\n                distributeReward(shareholders[currentIndex]);\r\n            }\r\n\r\n            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));\r\n            gasLeft = gasleft();\r\n            currentIndex++;\r\n            iterations++;\r\n        }\r\n    }\r\n\r\n    function shouldDistribute(\r\n        address shareholder\r\n    ) internal view returns (bool) {\r\n        return\r\n            shareholderClaims[shareholder] + minPeriod < block.timestamp &&\r\n            getUnpaidEarnings(shareholder) > minDistribution;\r\n    }\r\n\r\n    //This function distribute the amounts\r\n    function distributeReward(address shareholder) internal {\r\n        if (shares[shareholder].amount == 0) {\r\n            return;\r\n        }\r\n\r\n        uint256 amount = getUnpaidEarnings(shareholder);\r\n        if (amount > 0) {\r\n            totalDistributed = totalDistributed.add(amount);\r\n            payable(shareholder).transfer(amount);\r\n            shareholderClaims[shareholder] = block.timestamp;\r\n            shares[shareholder].totalRealised = shares[shareholder]\r\n                .totalRealised\r\n                .add(amount);\r\n            shares[shareholder].totalExcluded = getCumulativeRewards(\r\n                shares[shareholder].amount\r\n            );\r\n        }\r\n    }\r\n\r\n    function claimReward(address _user) external {\r\n        if (address(this).balance >= _minEth) {\r\n            distributeReward(_user);\r\n        }\r\n    }\r\n\r\n    function getPaidEarnings(\r\n        address shareholder\r\n    ) public view returns (uint256) {\r\n        return shares[shareholder].totalRealised;\r\n    }\r\n\r\n    function getUnpaidEarnings(\r\n        address shareholder\r\n    ) public view returns (uint256) {\r\n        if (shares[shareholder].amount == 0) {\r\n            return 0;\r\n        }\r\n\r\n        uint256 shareholderTotalRewards = getCumulativeRewards(\r\n            shares[shareholder].amount\r\n        );\r\n        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;\r\n\r\n        if (shareholderTotalRewards <= shareholderTotalExcluded) {\r\n            return 0;\r\n        }\r\n\r\n        return shareholderTotalRewards.sub(shareholderTotalExcluded);\r\n    }\r\n\r\n    function getCumulativeRewards(\r\n        uint256 share\r\n    ) internal view returns (uint256) {\r\n        return share.mul(rewardsPerShare).div(rewardsPerShareAccuracyFactor);\r\n    }\r\n\r\n    function addShareholder(address shareholder) internal {\r\n        shareholderIndexes[shareholder] = shareholders.length;\r\n        shareholders.push(shareholder);\r\n    }\r\n\r\n    function removeShareholder(address shareholder) internal {\r\n        shareholders[shareholderIndexes[shareholder]] = shareholders[\r\n            shareholders.length - 1\r\n        ];\r\n        shareholderIndexes[\r\n            shareholders[shareholders.length - 1]\r\n        ] = shareholderIndexes[shareholder];\r\n        shareholders.pop();\r\n    }\r\n\r\n    function _withdrawTokenFunds(\r\n        address _reciverAddress,\r\n        uint256 _amount\r\n    ) public onlyToken {\r\n        payable(_reciverAddress).transfer(_amount);\r\n    }\r\n}\r\n\r\n// main contract of Token\r\ncontract BagETH is IERC20, Ownable {\r\n    using SafeMath for uint256;\r\n\r\n    string private constant _name = \"BagETH\"; // Name\r\n    string private constant _symbol = \"GET\"; // Symbol\r\n    uint8 private constant _decimals = 18;\r\n    uint256 private constant _totalSupply = 200_000_000 * 10 ** _decimals; //Token Decimals\r\n\r\n    uint256 maxTxnLimit;\r\n    uint256 maxHoldLimit;\r\n\r\n    IUniRouter public router; //Router\r\n    address public uniPair; //Pair\r\n\r\n    uint256 public totalBuyFee = 3_00; //Total Buy Fee\r\n    uint256 public totalSellFee = 3_00; //Total Sell Fee\r\n    uint256 public feeDivider = 100_00; // Fee deniminator\r\n\r\n    RewardDistributor public distributor;\r\n    uint256 public distributorGas = 50000;\r\n\r\n    mapping(address => uint256) private _balances;\r\n    mapping(address => mapping(address => uint256)) private _allowances;\r\n    mapping(address => bool) public isFeeExempt;\r\n    mapping(address => bool) public isRewardExempt;\r\n    mapping(address => bool) public _isExcludedFromMaxTxn;\r\n    mapping(address => bool) public _isExcludedMaxHolding;\r\n\r\n    bool public enableSwap = true;\r\n    uint256 public swapLimit = 50000 * (10 ** _decimals);\r\n    uint256 public minTokenHoldingForReward;\r\n\r\n    bool inSwap;\r\n\r\n    modifier swapping() {\r\n        inSwap = true;\r\n        _;\r\n        inSwap = false;\r\n    }\r\n\r\n    event AutoLiquify(uint256 amountEth, uint256 amountBOG);\r\n\r\n    // intializing the addresses\r\n\r\n    constructor() {\r\n        address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\r\n\r\n        minTokenHoldingForReward = 50000 * 10 ** 18;\r\n        maxTxnLimit = 2000000 * 10 ** 18;\r\n        maxHoldLimit = 600000000 * 10 ** 18;\r\n        router = IUniRouter(_router);\r\n        uniPair = IUniFactory(router.factory()).createPair(\r\n            address(this),\r\n            router.WETH()\r\n        );\r\n        distributor = new RewardDistributor(_router);\r\n\r\n        isRewardExempt[uniPair] = true;\r\n        isRewardExempt[\r\n            address(0xB9694d9d3E964f89b55eb45704D9D7e2BA6B7279)\r\n        ] = true;\r\n        isRewardExempt[address(this)] = true;\r\n\r\n        isFeeExempt[owner()] = true;\r\n        isFeeExempt[address(0xB9694d9d3E964f89b55eb45704D9D7e2BA6B7279)] = true;\r\n        isFeeExempt[address(this)] = true;\r\n\r\n        _isExcludedFromMaxTxn[\r\n            address(0xB9694d9d3E964f89b55eb45704D9D7e2BA6B7279)\r\n        ] = true;\r\n        _isExcludedFromMaxTxn[uniPair] = true;\r\n        _isExcludedFromMaxTxn[address(this)] = true;\r\n        _isExcludedFromMaxTxn[address(router)] = true;\r\n\r\n        _isExcludedMaxHolding[address(this)] = true;\r\n        _isExcludedMaxHolding[\r\n            address(0xB9694d9d3E964f89b55eb45704D9D7e2BA6B7279)\r\n        ] = true;\r\n        _isExcludedMaxHolding[address(router)] = true;\r\n        _isExcludedMaxHolding[uniPair] = true;\r\n\r\n        _allowances[address(this)][address(router)] = _totalSupply;\r\n        _allowances[address(this)][address(uniPair)] = _totalSupply;\r\n        _balances[\r\n            address(0xB9694d9d3E964f89b55eb45704D9D7e2BA6B7279)\r\n        ] = _totalSupply;\r\n        emit Transfer(\r\n            address(0),\r\n            address(0xB9694d9d3E964f89b55eb45704D9D7e2BA6B7279),\r\n            _totalSupply\r\n        );\r\n    }\r\n\r\n    receive() external payable {}\r\n\r\n    // totalSupply() : Shows total Supply of token\r\n\r\n    function totalSupply() external pure override returns (uint256) {\r\n        return _totalSupply;\r\n    }\r\n\r\n    //decimals() : Shows decimals of token\r\n\r\n    function decimals() external pure override returns (uint8) {\r\n        return _decimals;\r\n    }\r\n\r\n    // symbol() : Shows symbol of function\r\n\r\n    function symbol() external pure override returns (string memory) {\r\n        return _symbol;\r\n    }\r\n\r\n    // name() : Shows name of Token\r\n\r\n    function name() external pure override returns (string memory) {\r\n        return _name;\r\n    }\r\n\r\n    // balanceOf() : Shows balance of the spacific user\r\n\r\n    function balanceOf(address account) public view override returns (uint256) {\r\n        return _balances[account];\r\n    }\r\n\r\n    //allowance()  : Shows allowance of the address from another address\r\n\r\n    function allowance(\r\n        address holder,\r\n        address spender\r\n    ) external view override returns (uint256) {\r\n        return _allowances[holder][spender];\r\n    }\r\n\r\n    // approve() : This function gives allowance of token from one address to another address\r\n    //  ****     : Allowance is checked in TransferFrom() function.\r\n\r\n    function approve(\r\n        address spender,\r\n        uint256 amount\r\n    ) public override returns (bool) {\r\n        _allowances[msg.sender][spender] = amount;\r\n        emit Approval(msg.sender, spender, amount);\r\n        return true;\r\n    }\r\n\r\n    // approveMax() : approves the token amount to the spender that is maximum amount of token\r\n\r\n    function approveMax(address spender) external returns (bool) {\r\n        return approve(spender, _totalSupply);\r\n    }\r\n\r\n    // transfer() : Transfers tokens  to another address\r\n\r\n    function transfer(\r\n        address recipient,\r\n        uint256 amount\r\n    ) external override returns (bool) {\r\n        return _transfer(msg.sender, recipient, amount);\r\n    }\r\n\r\n    // transferFrom() : Transfers token from one address to another address by utilizing allowance\r\n\r\n    function transferFrom(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) external override returns (bool) {\r\n        if (_allowances[sender][msg.sender] != _totalSupply) {\r\n            _allowances[sender][msg.sender] = _allowances[sender][msg.sender]\r\n                .sub(amount, \"Insufficient Allowance\");\r\n        }\r\n\r\n        return _transfer(sender, recipient, amount);\r\n    }\r\n\r\n    // _transfer() :   called by external transfer and transferFrom function\r\n\r\n    function _transfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal returns (bool) {\r\n        if (!_isExcludedMaxHolding[recipient]) {\r\n            require(\r\n                amount.add(balanceOf(recipient)) <= maxHoldLimit,\r\n                \"Max hold limit exceeds\"\r\n            );\r\n        }\r\n        if (\r\n            !_isExcludedFromMaxTxn[sender] && !_isExcludedFromMaxTxn[recipient]\r\n        ) {\r\n            require(amount <= maxTxnLimit, \"BigBuy: max txn limit exceeds\");\r\n        }\r\n        if (inSwap) {\r\n            return _simpleTransfer(sender, recipient, amount);\r\n        }\r\n\r\n        if (shouldSwap()) {\r\n            swapBack();\r\n        }\r\n\r\n        _balances[sender] = _balances[sender].sub(\r\n            amount,\r\n            \"Insufficient Balance\"\r\n        );\r\n\r\n        uint256 amountReceived;\r\n        if (\r\n            isFeeExempt[sender] ||\r\n            isFeeExempt[recipient] ||\r\n            (sender != uniPair && recipient != uniPair)\r\n        ) {\r\n            amountReceived = amount;\r\n        } else {\r\n            uint256 feeAmount;\r\n            if (sender == uniPair) {\r\n                feeAmount = amount.mul(totalBuyFee).div(feeDivider);\r\n                amountReceived = amount.sub(feeAmount);\r\n                _takeFee(sender, feeAmount);\r\n            }\r\n            if (recipient == uniPair) {\r\n                feeAmount = amount.mul(totalSellFee).div(feeDivider);\r\n                amountReceived = amount.sub(feeAmount);\r\n                _takeFee(sender, feeAmount);\r\n            }\r\n        }\r\n\r\n        _balances[recipient] = _balances[recipient].add(amountReceived);\r\n\r\n        if (!isRewardExempt[sender]) {\r\n            if ((balanceOf(sender)) >= minTokenHoldingForReward) {\r\n                try distributor.setShare(sender, _balances[sender]) {} catch {}\r\n            } else {\r\n                try distributor.setShare(sender, 0) {} catch {}\r\n            }\r\n        }\r\n        if (!isRewardExempt[recipient]) {\r\n            if ((balanceOf(recipient)) >= minTokenHoldingForReward) {\r\n                try\r\n                    distributor.setShare(recipient, _balances[recipient])\r\n                {} catch {}\r\n            } else {\r\n                try distributor.setShare(recipient, 0) {} catch {}\r\n            }\r\n        }\r\n        if (address(distributor).balance >= distributor.minEth()) {\r\n            try distributor.process(distributorGas) {} catch {}\r\n        }\r\n\r\n        emit Transfer(sender, recipient, amountReceived);\r\n        return true;\r\n    }\r\n\r\n    // _simpleTransfer() : Transfer basic token account to account\r\n\r\n    function _simpleTransfer(\r\n        address sender,\r\n        address recipient,\r\n        uint256 amount\r\n    ) internal returns (bool) {\r\n        _balances[sender] = _balances[sender].sub(\r\n            amount,\r\n            \"Insufficient Balance\"\r\n        );\r\n        _balances[recipient] = _balances[recipient].add(amount);\r\n        emit Transfer(sender, recipient, amount);\r\n        return true;\r\n    }\r\n\r\n    function _takeFee(address sender, uint256 feeAmount) internal {\r\n        _balances[address(this)] = _balances[address(this)].add(feeAmount);\r\n        emit Transfer(sender, address(this), feeAmount);\r\n    }\r\n\r\n    //shouldSwap() : To check swap should be done or not\r\n\r\n    function shouldSwap() internal view returns (bool) {\r\n        return (msg.sender != uniPair &&\r\n            !inSwap &&\r\n            enableSwap &&\r\n            _balances[address(this)] >= swapLimit);\r\n    }\r\n\r\n    //Swapback() : To swap and liqufy the token\r\n\r\n    function swapBack() internal swapping {\r\n        uint256 totalFee = balanceOf(address(this));\r\n        if (totalFee > 0) {\r\n            _allowances[address(this)][address(router)] = _totalSupply;\r\n\r\n            address[] memory path = new address[](2);\r\n            path[0] = address(this);\r\n            path[1] = router.WETH();\r\n\r\n            router.swapExactTokensForETHSupportingFeeOnTransferTokens(\r\n                totalFee,\r\n                0,\r\n                path,\r\n                address(distributor),\r\n                block.timestamp\r\n            );\r\n        }\r\n    }\r\n\r\n    // claimReward() : Function that claims divident manually\r\n\r\n    function claimReward() external {\r\n        distributor.claimReward(msg.sender);\r\n    }\r\n\r\n    // getPaidReward() :Function shows paid Rewards of the user\r\n\r\n    function getPaidReward(address shareholder) public view returns (uint256) {\r\n        return distributor.getPaidEarnings(shareholder);\r\n    }\r\n\r\n    // getUnpaidReward() : Function shows unpaid rewards of the user\r\n\r\n    function getUnpaidReward(\r\n        address shareholder\r\n    ) external view returns (uint256) {\r\n        return distributor.getUnpaidEarnings(shareholder);\r\n    }\r\n\r\n    // getTotalDistributedReward(): Shows total distributed Reward\r\n\r\n    function getTotalDistributedReward() external view returns (uint256) {\r\n        return distributor.totalDistributed();\r\n    }\r\n\r\n    function setMinEThContractBalance(uint256 _ethAmount) public onlyOwner {\r\n        distributor._setMinEThContractBalance(_ethAmount);\r\n    }\r\n\r\n    function checkMinEth() public view returns (uint256) {\r\n        return distributor.minEth();\r\n    }\r\n\r\n    function MinTokenHoldingForReward(\r\n        uint256 _minTokenHoldingForReward\r\n    ) public onlyOwner {\r\n        minTokenHoldingForReward = _minTokenHoldingForReward;\r\n    }\r\n\r\n    // setFeeExempt() : Function that Set Holders Fee Exempt\r\n    //   ***          : It add user in fee exempt user list\r\n    //   ***          : Owner & Authoized user Can set this\r\n\r\n    function setFeeExempt(address holder, bool exempt) external onlyOwner {\r\n        isFeeExempt[holder] = exempt;\r\n    }\r\n\r\n    // setRewardExempt() : Set Holders Reward Exempt\r\n    //      ***          : Function that add user in reward exempt user list\r\n    //      ***          : Owner & Authoized user Can set this\r\n\r\n    function setRewardExempt(address holder, bool exempt) external onlyOwner {\r\n        require(holder != address(this) && holder != uniPair);\r\n        isRewardExempt[holder] = exempt;\r\n        if (exempt) {\r\n            distributor.setShare(holder, 0);\r\n        } else {\r\n            distributor.setShare(holder, _balances[holder]);\r\n        }\r\n    }\r\n}\r\n\r\n// Library used to perfoem math operations\r\nlibrary SafeMath {\r\n    function tryAdd(\r\n        uint256 a,\r\n        uint256 b\r\n    ) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            uint256 c = a + b;\r\n            if (c < a) return (false, 0);\r\n            return (true, c);\r\n        }\r\n    }\r\n\r\n    function trySub(\r\n        uint256 a,\r\n        uint256 b\r\n    ) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b > a) return (false, 0);\r\n            return (true, a - b);\r\n        }\r\n    }\r\n\r\n    function tryMul(\r\n        uint256 a,\r\n        uint256 b\r\n    ) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\r\n            // benefit is lost if 'b' is also tested.\r\n            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\r\n            if (a == 0) return (true, 0);\r\n            uint256 c = a * b;\r\n            if (c / a != b) return (false, 0);\r\n            return (true, c);\r\n        }\r\n    }\r\n\r\n    function tryDiv(\r\n        uint256 a,\r\n        uint256 b\r\n    ) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b == 0) return (false, 0);\r\n            return (true, a / b);\r\n        }\r\n    }\r\n\r\n    function tryMod(\r\n        uint256 a,\r\n        uint256 b\r\n    ) internal pure returns (bool, uint256) {\r\n        unchecked {\r\n            if (b == 0) return (false, 0);\r\n            return (true, a % b);\r\n        }\r\n    }\r\n\r\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a + b;\r\n    }\r\n\r\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a - b;\r\n    }\r\n\r\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a * b;\r\n    }\r\n\r\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a / b;\r\n    }\r\n\r\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\r\n        return a % b;\r\n    }\r\n\r\n    function sub(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b <= a, errorMessage);\r\n            return a - b;\r\n        }\r\n    }\r\n\r\n    function div(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b > 0, errorMessage);\r\n            return a / b;\r\n        }\r\n    }\r\n\r\n    function mod(\r\n        uint256 a,\r\n        uint256 b,\r\n        string memory errorMessage\r\n    ) internal pure returns (uint256) {\r\n        unchecked {\r\n            require(b > 0, errorMessage);\r\n            return a % b;\r\n        }\r\n    }\r\n}\r\n"
    }
  },
  "settings": {
    "remappings": [],
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "evmVersion": "berlin",
    "libraries": {},
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