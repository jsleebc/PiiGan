# @version 0.3.7

"""
@title Vyper Burn
@license GNU AGPLv3
@author vyperburnteam
"""

interface IERC20:
    def totalSupply() -> uint256: view
    def decimals() -> uint256: view
    def symbol() -> String[20]: view
    def name() -> String[100]: view
    def getOwner() -> address: view
    def balanceOf(account: address) -> uint256: view
    def transfer(recipient: address, amount: uint256) -> bool: nonpayable
    def allowance(_owner: address, spender: address) -> uint256: view
    def approve(spender: address, amount: uint256) -> bool: nonpayable
    def transferFrom(sender: address, recipient: address, amount: uint256) -> bool: nonpayable

event Transfer:
    sender: indexed(address)
    recipient: indexed(address)
    value: uint256

event Approval:
    owner: indexed(address)
    spender: indexed(address)
    value: uint256

event TransferOwnership:
    previousOwner: indexed(address)
    newOwner: indexed(address)

event StuckETHWithdrawn:
    recipient: indexed(address)
    amount: uint256

event StuckTokensWithdrawn:
    tokenAddress: indexed(address)
    recipient: indexed(address)
    amount: uint256

event PairCreated:
    pair: address

interface IDexFactory:
    def createPair(tokenA: address, tokenB: address) -> address: nonpayable

interface IDexRouter:
    def factory() -> address: view
    def WETH() -> address: view
    def addLiquidityETH(token: address, amountTokenDesired: uint256, amountTokenMin: uint256, amountETHMin: uint256, to: address, deadline: uint256) -> (uint256, uint256, uint256): payable
    def swapExactTokensForETHSupportingFeeOnTransferTokens(amountIn: uint256, amountOutMin: uint256, path: address[2], to: address, deadline: uint256): nonpayable

implements: IERC20

name: constant(String[100]) = "Vyper Burn"
symbol: constant(String[20]) = "vb"
decimals: constant(uint256) = 9
balances: (HashMap[address, uint256])
allowances: (HashMap[address, HashMap[address, uint256]])
InitialSupply: constant(uint256) = 1_000_000_000 * 10**9
LaunchTimestamp: uint256
deadWallet: constant(address) = 0x000000000000000000000000000000000000dEaD  
owner: address
burnRate: uint256
devTaxRate: uint256
burnRateBuy: uint256
burnRateSell: uint256
devTaxRateBuy: uint256
devTaxRateSell: uint256
devWallet: address
liquidityPoolPair: address
dexFactory: IDexFactory
dexRouter: IDexRouter
factoryAddress: address
routerAddress: address
maxTransactionAmount: uint256
maxWalletAmount: uint256
isTradingEnabled: bool
inExecution: bool
swapEnabled: bool
_swapTokensAtAmount: uint256

@external
def __init__():
    self.isTradingEnabled = False
    self.swapEnabled = True
    self.inExecution = False
    deployerBalance: uint256 = InitialSupply
    factoryAddress: address = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
    routerAddress: address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    self.factoryAddress = factoryAddress
    self.routerAddress = routerAddress 
    self.dexFactory = IDexFactory(factoryAddress)
    self.dexRouter = IDexRouter(routerAddress)
    weth_address: address = self.dexRouter.WETH()
    liquidityPoolPair: address = self.dexFactory.createPair(self, weth_address)
    self.liquidityPoolPair = liquidityPoolPair
    log PairCreated(liquidityPoolPair)
    self.maxTransactionAmount = 10_000_000 * 10**9
    self.maxWalletAmount = 10_000_000 * 10**9
    self._swapTokensAtAmount = 10_000_000 * 10**9
    sender: address = msg.sender
    self.balances[sender] = deployerBalance
    self.owner = sender
    self.devWallet = 0x0f868135056690109ad9C792BDe4374cFe755b00
    self.burnRateBuy = 500 
    self.devTaxRateBuy = 500
    self.burnRateSell = 500
    self.devTaxRateSell = 500
    log Transfer(empty(address), sender, deployerBalance)

@view
@external
def getMaxTransactions() -> uint256[2]:
    return [
        self.maxTransactionAmount,
        self.maxWalletAmount,
        ]

@external
def setMaxTransactionAndWalletLimits(newTransactionPercentage: uint256, newWalletPercentage: uint256) -> bool:
    assert msg.sender == self.owner, "Only owner can call this function"
    assert newTransactionPercentage > 0 and newTransactionPercentage <= 100, "New transaction percentage should be between 1 and 100"
    assert newWalletPercentage > 0 and newWalletPercentage <= 100, "New wallet percentage should be between 1 and 100"
    self.maxTransactionAmount = (InitialSupply * newTransactionPercentage) / 100
    self.maxWalletAmount = (InitialSupply * newWalletPercentage) / 100
    return True

@external
def removeLimits() -> bool:
    assert msg.sender == self.owner, "Only owner can call this function"
    self.maxWalletAmount = InitialSupply
    self.maxTransactionAmount = InitialSupply
    return True

@view
@external
def getBurnedTokens() -> uint256:
    return self.balances[deadWallet] 

@view
@external
def getCirculatingSupply() -> uint256:
    return InitialSupply - self.balances[deadWallet]

@external
def SetupEnableTrading(burnRate: uint256, devTaxRate: uint256) -> bool:
    assert msg.sender == self.owner, "Ownable: caller is not the owner"
    assert not self.isTradingEnabled, "Trading is already enabled"
    self.burnRateBuy = burnRate
    self.devTaxRateBuy = devTaxRate 
    self.LaunchTimestamp = block.timestamp
    self.isTradingEnabled = True
    return True

@view
@external
def getOwner() -> address:
    return self.owner

@view
@external
def name() -> String[100]:
    return name

@view
@external
def symbol() -> String[20]:
    return symbol

@view
@external
def decimals() -> uint256:
    return decimals

@view
@external
def totalSupply() -> uint256:
    return InitialSupply 

@view
@external
def balanceOf(account: address) -> uint256:
    return self.balances[account]

@nonpayable
@external
def transfer(recipient: address,amount: uint256) -> bool:
    self._transfer(msg.sender, recipient, amount)
    return True

@view
@external
def allowance(_owner: address, spender: address) -> uint256:
    return self.allowances[_owner][spender]

@external
@nonpayable
def approve(spender: address, amount: uint256) -> bool:
    owner: address = msg.sender
    self._approve(owner, spender, amount)
    return True

@external
def transferFrom(sender: address, recipient: address, amount: uint256) -> bool:
    self._transfer(sender, recipient, amount)
    currentAllowance: uint256 = self.allowances[sender][msg.sender]
    assert currentAllowance >= amount, "Transfer > allowance"
    self._approve(sender, msg.sender, currentAllowance - amount)
    return True

@external
def increaseAllowance(spender: address, addedValue: uint256) -> bool:
    self._approve(msg.sender, spender, self.allowances[msg.sender][spender] + addedValue)
    return True

@external
def decreaseAllowance(spender: address, subtractedValue: uint256) -> bool:
    currentAllowance: uint256 = self.allowances[msg.sender][spender]
    assert currentAllowance >= subtractedValue, "<0 allowance"
    self._approve(msg.sender, spender, currentAllowance - subtractedValue)
    return True

@external
def setTaxRates(_burnRateBuy: uint256, _devTaxRateBuy: uint256, _burnRateSell: uint256, _devTaxRateSell: uint256) -> bool:
    sender: address = msg.sender
    assert sender == self.owner, "Only the owner can set the tax rates"
    assert _burnRateBuy >= 0 and _burnRateBuy <= 10000, "Burn rate buy must be between 1 to 100"
    assert _devTaxRateBuy >= 0 and _devTaxRateBuy <= 10000, "Dev tax rate buy must be between 1 to 100"
    assert _burnRateSell >= 0 and _burnRateSell <= 10000, "Burn rate sell must be between 1 to 100"
    assert _devTaxRateSell >= 0 and _devTaxRateSell <= 10000, "Dev tax rate sell must be between 1 to 100"
    self.burnRateBuy = _burnRateBuy
    self.devTaxRateBuy = _devTaxRateBuy 
    self.burnRateSell = _burnRateSell
    self.devTaxRateSell = _devTaxRateSell 
    return True

@external
def removeFee():
    sender: address = msg.sender
    assert sender == self.owner, "Ownable: caller is not the owner"
    self.burnRateBuy = 0
    self.burnRateSell = 0
    self.devTaxRateBuy = 0
    self.devTaxRateSell = 0

@view
@external
def getTaxRates() -> uint256[6]:
    totalBuyTaxes: uint256 = self.burnRateBuy + self.devTaxRateBuy
    totalSellTaxes: uint256 = self.burnRateSell + self.devTaxRateSell

    return [
        self.burnRateBuy,
        self.devTaxRateBuy,
        totalBuyTaxes,
        self.burnRateSell,
        self.devTaxRateSell,
        totalSellTaxes
    ]

@external
@payable
def __default__(): pass

@internal
def _transfer(sender: address, recipient: address, amount: uint256):
    assert sender != empty(address), "Transfer from zero"
    assert recipient != empty(address), "Transfer to zero"
    assert amount > 0, "Amount should be greater than zero"
    assert self.isTradingEnabled or sender == self.owner or recipient == self.owner, "Trading not enabled"
    applyTax: bool = sender not in [self.owner, self] and recipient not in [self.owner, self] and self.isTradingEnabled

    if recipient not in [self.owner, self, self.routerAddress, self.liquidityPoolPair, deadWallet]:
        assert self.balances[recipient] + amount <= self.maxWalletAmount, "Recipient wallet balance exceeds max wallet limit"

    if sender not in [self.owner, self.liquidityPoolPair, self.routerAddress]:
        assert amount <= self.maxTransactionAmount, "Transaction amount exceeds max transaction limit"

    if applyTax:
        if recipient == self.liquidityPoolPair:
            self.burnRate = self.burnRateSell
            self.devTaxRate = self.devTaxRateSell
        else:
            self.burnRate = self.burnRateBuy
            self.devTaxRate = self.devTaxRateBuy
    else:
        self._normalTransfer(sender, recipient, amount)
        return

    contractTokenBalance: uint256 = self.balances[self]
    canSwap: bool = contractTokenBalance >= self._swapTokensAtAmount

    if contractTokenBalance >= self._swapTokensAtAmount:
        contractTokenBalance = self._swapTokensAtAmount
    if canSwap and not self.inExecution and recipient == self.liquidityPoolPair and self.swapEnabled and applyTax:
        self._swapTokens(min(amount, contractTokenBalance))
        contractETHBalance: uint256 = self.balances[self.dexRouter.WETH()]
        if contractETHBalance > 0:
            self._sendETHToFee(contractETHBalance)
    
    self._transferStandard(sender, recipient, amount)

@internal
def _transferStandard(sender: address, recipient: address, amount: uint256):
    burnAmount: uint256 = convert(floor(convert(amount, decimal) * convert(self.burnRate, decimal) / convert(10000, decimal)), uint256)
    devTaxAmount: uint256 = convert(floor(convert(amount, decimal) * convert(self.devTaxRate, decimal) / convert(10000, decimal)), uint256)
    transferAmount: uint256 = amount - burnAmount - devTaxAmount
    totalAmount: uint256 = transferAmount + burnAmount + devTaxAmount

    if recipient == self.liquidityPoolPair and sender != self.routerAddress:
        assert self.balances[sender] >= totalAmount, "Insufficient Balance"

    self.balances[sender] -= totalAmount
    self.balances[deadWallet] += burnAmount
    if devTaxAmount > 0:
        self.balances[self] += devTaxAmount
        log Transfer(sender, self, devTaxAmount)
    self.balances[recipient] += transferAmount
    log Transfer(sender, recipient, transferAmount)

@internal
def _normalTransfer(
    sender: address,
    recipient: address,
    amount: uint256
):
    senderBalance: uint256 = self.balances[sender]
    assert senderBalance >= amount, "Transfer exceeds balance"
    self.balances[sender] -= amount
    self.balances[recipient] += amount
    log Transfer(sender, recipient, amount)

@internal
def _swapTokens(amount: uint256):
    assert not self.inExecution, "Reentrancy protection"
    self.inExecution = True
    path: address[2] = [self, self.dexRouter.WETH()]
    self._approve(self, self.routerAddress, self.balances[self])
    self.dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
        amount,
        0,
        path,
        self,
        block.timestamp
    )
    self.inExecution = False

@internal
def _sendETHToFee(amount: uint256):
    send(self.devWallet, amount)

@external
def transferOwnership(newOwner: address):
    sender: address = msg.sender
    assert sender == self.owner, "Ownable: caller is not the owner"
    assert newOwner != empty(address), "Ownable: new owner is the zero address"
    log TransferOwnership(self.owner, newOwner)
    self.owner = newOwner

@external
def renounceOwnership():
    sender: address = msg.sender
    assert sender == self.owner, "Ownable: caller is not the owner"
    log TransferOwnership(self.owner, empty(address))
    self.owner = empty(address)

@external
def setFactoryAndRouter(factoryAddress: address, routerAddress: address) -> bool:
    assert msg.sender == self.owner, "Only the core can call this function."
    self.factoryAddress = factoryAddress
    self.routerAddress = routerAddress
    return True

@external
@view
def getLiquidityPoolPairAddress() -> address:
    return self.liquidityPoolPair

@view
@internal
def _contractBalance() -> uint256:
    return self.balances[self]

@internal
def _approve(owner: address, spender: address, amount: uint256) -> bool:
    assert owner != empty(address), "Approve from zero"
    assert spender != empty(address), "Approve from zero"
    self.allowances[owner][spender] = amount
    log Approval(owner, spender, amount)
    return True

@external
def withdrawStuckETH(amount: uint256) -> bool:
    send(self.devWallet, amount)
    log StuckETHWithdrawn(self.devWallet, amount)
    return True

@external
def withdrawStuckTokens(tokenAddress: address, amount: uint256) -> bool:
    token: IERC20 = IERC20(tokenAddress)
    token.transfer(self.devWallet, amount) 
    log StuckTokensWithdrawn(tokenAddress, self.devWallet, amount)
    return True

@external
@view
def getTradingStatus() -> bool:
    return self.isTradingEnabled

@external
def toggleSwapEnabled():
    assert msg.sender == self.owner, "Only the owner can call this function."
    self.swapEnabled = not self.swapEnabled

@external
def manualSwap():
    sender: address = msg.sender
    assert sender == self.owner or sender == self.devWallet, "Only the owner or dev can call this function."
    contractTokenBalance: uint256 = self.balances[self]
    
    if contractTokenBalance >= self._swapTokensAtAmount:
        contractTokenBalance = self._swapTokensAtAmount
    self._swapTokens(contractTokenBalance)