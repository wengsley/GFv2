/**
 *Submitted for verification at BscScan.com on 2022-08-28
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

interface BEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
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
     *
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
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
     *
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

interface IFactoryV2 {
    event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
    function getPair(address tokenA, address tokenB) external view returns (address lpPair);
    function createPair(address tokenA, address tokenB) external returns (address lpPair);
}

interface IV2Pair {
    function factory() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function sync() external;
}

interface IRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function swapExactETHForTokens(
        uint amountOutMin, 
        address[] calldata path, 
        address to, uint deadline
    ) external payable returns (uint[] memory amounts);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IRouter02 is IRouter01 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
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
    ) external returns (uint[] memory amounts);
}

interface AntiSnipe {
    function checkUser(address from, address to, uint256 amt) external returns (bool);
    function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
    function setLpPair(address pair, bool enabled) external;
    function setProtections(bool _as, bool _ab) external;
    function removeSniper(address account) external;
}

contract GF is BEP20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _tOwned;
    mapping (address => bool) lpPairs;
    uint256 private timeSinceLastPair = 0;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _liquidityHolders;
    mapping (address => bool) private _isExcludedFromProtection;
    mapping (address => bool) private _isExcludedFromFees;
    mapping (address => bool) private presaleAddresses;
    bool private allowedPresaleExclusion = true;
   
    uint256 constant private startingSupply = 1000000;

    string constant private _name = "Girlsfren";
    string constant private _symbol = "GF";
    uint8 constant private _decimals = 6;

    uint256 constant private _tTotal = startingSupply * 10**_decimals;
    uint256 constant private _tLiquid = (_tTotal * 90) /100; // 90% remaining
    uint256 constant private _tBurn = (_tTotal * 10) /100; // 10% remaining

    struct Fees {
        uint256 buyFee;
        uint256 sellFee;
        uint256 transferFee;
        uint256 buyMarketingFee;
        uint256 sellMarketingFee;
        uint256 sellLiquidityFee;
        uint256 buyLiquidityFee;
        uint256 totalBuyFee;
        uint256 totalSellFee;
    }

    Fees public _taxRates = Fees({
        buyFee: 0,
        sellFee: 0,
        transferFee: 0,
        buyMarketingFee: 3,
        sellMarketingFee: 2,
        buyLiquidityFee: 0,
        sellLiquidityFee: 1,
        totalBuyFee: 3,
        totalSellFee: 3
    });

    uint256 private _aveLiquidityFee = 1;
    uint256 private _aveMarketingFee = 3;
    uint256 private _aveNFTFee = 2;
    uint256 private _aveTotalFee = 6;

    uint256 constant public maxBuyTaxes = 0;
    uint256 constant public maxSellTaxes = 0;
    uint256 constant public maxTransferTaxes = 0;
    uint256 constant public maxRoundtripTax = 0;
    // uint256 constant masterTaxDivisor = 10000;

    bool public taxesAreLocked;
    IRouter02 public dexRouter;
    address public lpPair;
    address public bnbPair;
    // address public USDT = 0x337610d27c682E347C9cD60BD4b3b107C9d34dDd;
    // address public USDT = 0x55d398326f99059fF775485246999027B3197955;
    address constant private WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c; // WBNB contract address 
    //address public WBNB = 0x095418A82BC2439703b69fbE1210824F2247D77c //testnet
    address constant public DEAD = 0x000000000000000000000000000000000000dEaD;

    struct TaxWallets {
        address marketing;
        address buyandsell;
    }

    TaxWallets public _taxWallets = TaxWallets({
        marketing: 0x71c8819988FFD77e5983854fc1B1F94596Ec4872,
        buyandsell: 0x72067C1c4608ae8765a9Fb0E24947dC5159310b5
    });

    bool public tradingEnabled = false;
    bool public _hasLiqBeenAdded = false;
    AntiSnipe antiSnipe;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(_owner == msg.sender, "Caller =/= owner.");
        _;
    }

    constructor () payable {
        _tOwned[msg.sender] = _tTotal;
        _tOwned[DEAD] = _tBurn;
        emit Transfer(address(0), msg.sender, _tLiquid);
        emit Transfer(address(0), DEAD, _tBurn);

        // Set the owner.
        _owner = msg.sender;
        originalDeployer = msg.sender;

         //Mainnet: 0x10ED43C718714eb63d5aA57B78B54704E256024E
        //Testnet BSC: 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3
        //Testnet ETH: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
         // Mainnet BSC :0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c 
        dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

        bnbPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
        lpPair = IFactoryV2(dexRouter.factory()).createPair(WBNB, address(this));
        lpPairs[lpPair] = true;
        lpPairs[bnbPair] = true;

        _approve(_owner, address(dexRouter), type(uint256).max);
        _approve(address(this), address(dexRouter), type(uint256).max);

        _isExcludedFromFees[_owner] = true;
        _isExcludedFromFees[address(this)] = true;
        _isExcludedFromFees[DEAD] = true;
        _liquidityHolders[_owner] = true;
    }

    receive() external payable {}

//===============================================================================================================
//===============================================================================================================
//===============================================================================================================
    // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
    // This allows for removal of ownership privileges from the owner once renounced or transferred.

    address private _owner;
    address public originalDeployer;
    address public operator;

    function transferOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
        require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
        setExcludedFromFees(_owner, false);
        setExcludedFromFees(newOwner, true);
        
        if (balanceOf(_owner) > 0) {
            finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
        }
        
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
        
    }

    function renounceOwnership() external onlyOwner {
        setExcludedFromFees(_owner, false);
        address oldOwner = _owner;
        _owner = address(0);
        emit OwnershipTransferred(oldOwner, address(0));
    }

//===============================================================================================================
//===============================================================================================================
//===============================================================================================================

    function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
    function decimals() external pure override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) { return _owner; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _approve(address sender, address spender, uint256 amount) internal {
        require(sender != address(0), "ERC20: Zero Address");
        require(spender != address(0), "ERC20: Zero Address");

        _allowances[sender][spender] = amount;
        emit Approval(sender, spender, amount);
    }

    function approveContractContingency() external onlyOwner returns (bool) {
        _approve(address(this), address(dexRouter), type(uint256).max);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            _allowances[sender][msg.sender] -= amount;
        }

        return _transfer(sender, recipient, amount);
    }

    function setNewRouter(address newRouter) external onlyOwner {
        require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
        IRouter02 _newRouter = IRouter02(newRouter);
        address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
        if (get_pair == address(0)) {
            lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
        }
        else {
            lpPair = get_pair;
        }
        dexRouter = _newRouter;
        _approve(address(this), address(dexRouter), type(uint256).max);
    }

    function setLpPair(address pair, bool enabled) external onlyOwner {
        if (!enabled) {
            lpPairs[pair] = false;
            antiSnipe.setLpPair(pair, false);
        } else {
            if (timeSinceLastPair != 0) {
                require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
            }
            lpPairs[pair] = true;
            timeSinceLastPair = block.timestamp;
            antiSnipe.setLpPair(pair, true);
        }
    }

    function setInitializer(address initializer) external onlyOwner {
        require(!tradingEnabled);
        require(initializer != address(this), "Can't be self.");
        antiSnipe = AntiSnipe(initializer);
    }

    function isExcludedFromFees(address account) external view returns(bool) {
        return _isExcludedFromFees[account];
    }

    function isExcludedFromProtection(address account) external view returns (bool) {
        return _isExcludedFromProtection[account];
    }

    function setExcludedFromFees(address account, bool enabled) public onlyOwner {
        _isExcludedFromFees[account] = enabled;
    }

    function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
        _isExcludedFromProtection[account] = enabled;
    }

    function removeSniper(address account) external onlyOwner {
        antiSnipe.removeSniper(account);
    }

    function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
        antiSnipe.setProtections(_antiSnipe, _antiBlock);
    }

    function setMarketingWallet(address wallet) external onlyOwner {
        _taxWallets.marketing = wallet;
    }

    function setBuySellWallet(address wallet) external onlyOwner {
        _taxWallets.buyandsell = wallet;
    }

    function lockTaxes() external onlyOwner {
        // This will lock taxes at their current value forever, do not call this unless you're sure.
        taxesAreLocked = true;
    }

    function setBuyTaxes( uint16 buyMarketingFee, uint16 buyLiquidityFee) external onlyOwner {
        require(!taxesAreLocked, "Taxes are locked.");

        require((buyMarketingFee + buyLiquidityFee + _taxRates.buyFee) <= 5 , "Must keep fees at 5% or less");

        _taxRates.buyMarketingFee = buyMarketingFee;
        _taxRates.buyLiquidityFee = buyLiquidityFee;
    }

    function setSellTaxes(uint16 sellMarketingFee, uint16 sellLiquidityFee) external onlyOwner {
        require(!taxesAreLocked, "Taxes are locked.");

        require((_taxRates.sellFee + sellMarketingFee + sellLiquidityFee) <= 5 , "Must keep fees at 5% or less");

        _taxRates.sellMarketingFee = sellMarketingFee;
        _taxRates.sellLiquidityFee = sellLiquidityFee;
    }

    function _hasLimits(address from, address to) internal view returns (bool) {
        return from != _owner
            && to != _owner
            && tx.origin != _owner
            && !_liquidityHolders[to]
            && !_liquidityHolders[from]
            && to != DEAD
            && to != address(0)
            && from != address(this)
            && from != address(antiSnipe)
            && to != address(antiSnipe);
    }

    function _transfer(address from, address to, uint256 amount) internal returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        bool buy = false;
        bool sell = false;
        bool other = false;
        if (lpPairs[from]) {
            buy = true;
        } else if (lpPairs[to]) {
            sell = true;
        } else {
            other = true;
        }
        if (_hasLimits(from, to)) {
            if(!tradingEnabled) {
                revert("Trading not yet enabled!");
            }
        }

        return finalizeTransfer(from, to, amount, buy, sell, other);
    }

    function _checkLiquidityAdd(address from, address to) internal {
        require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
        if (!_hasLimits(from, to) && to == lpPair) {
            _liquidityHolders[from] = true;
            _isExcludedFromFees[from] = true;
            _hasLiqBeenAdded = true;
            if (address(antiSnipe) == address(0)){
                antiSnipe = AntiSnipe(address(this));
            }
        }
    }

    function enableTrading() public onlyOwner {
        require(!tradingEnabled, "Trading already enabled!");
        require(_hasLiqBeenAdded, "Liquidity must be added.");
        if (address(antiSnipe) == address(0)){
            antiSnipe = AntiSnipe(address(this));
        }
        try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
        tradingEnabled = true;
        allowedPresaleExclusion = false;
    }

    function sweepContingency() external onlyOwner {
        require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
        payable(_owner).transfer(address(this).balance);
    }

    function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
        require(accounts.length == amounts.length, "Lengths do not match.");
        for (uint8 i = 0; i < accounts.length; i++) {
            require(balanceOf(msg.sender) >= amounts[i]);
            finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
        }
    }

    function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
        if (!_hasLiqBeenAdded) {
            _checkLiquidityAdd(from, to);
            if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
                revert("Pre-liquidity transfer protection.");
            }
        }

        if (_hasLimits(from, to)) { bool checked;
            try antiSnipe.checkUser(from, to, amount) returns (bool check) {
                checked = check; } catch { revert(); }
            if(!checked) { revert(); }
        }

        //
        swapAndLiquify(); 

        bool takeFee = true;
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
            takeFee = false;
        }

        _tOwned[from] -= amount;
        uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;
        _tOwned[to] += amountReceived;

        emit Transfer(from, to, amountReceived);
        return true;
    }

    function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {
        uint256 currentFee;
        if (buy) {
            currentFee = (amount * _taxRates.buyFee) /100 ;
        } else if (sell) {
            currentFee =  (amount * _taxRates.sellFee) /100;
        } else {
            currentFee = (amount * _taxRates.transferFee) /100;
        }

        if (currentFee > 0) {
            _tOwned[_taxWallets.buyandsell] += currentFee;
            emit Transfer(from, _taxWallets.buyandsell, currentFee);
        }

        return amount - currentFee;
    }

    function getAverageSwapFees() internal 
    {
        _aveLiquidityFee = _taxRates.buyLiquidityFee.add(_taxRates.sellLiquidityFee).div(2); // (1+0)/2 = 0.5
        _aveMarketingFee = _taxRates.buyMarketingFee.add(_taxRates.sellMarketingFee).div(2);
        _aveNFTFee = _taxRates.buyFee.add(_taxRates.sellFee).div(2); // (1+1)/2 = 1
        _aveTotalFee = _taxRates.totalBuyFee.add(_taxRates.totalSellFee).div(2); // (3+3)/2 = 3
    }

    function swapAndLiquify() internal {
        getAverageSwapFees();
        // split the contract balance into thirds
        uint256 _balanceContract = balanceOf(address(this));
        uint256 _amtLiq = _balanceContract.mul(_aveLiquidityFee).div(_aveTotalFee.sub(_aveNFTFee)).div(2);
        uint256 _amtSwap = _balanceContract.sub(_amtLiq);
        
        uint256 initialBalance = address(this).balance;

        // swap tokens for ETH
        swapTokensForEth(_amtSwap); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered

        // add liquidity to pancakeswap
        addLiquidity(_amtLiq, initialBalance);        
    }

    function swapTokensForEth(uint256 _amtSwap) internal 
    {
       
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;

        // make the swap
        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            _amtSwap,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 _amtLiq, uint256 initialAmount) internal 
    {
        uint256 amountBNB = address(this).balance.sub(initialAmount); //balance before swap
        uint256 totalBNBFee = _aveTotalFee.sub(_aveNFTFee).sub(_aveLiquidityFee).div(2);
        uint256 amountBNBLiquidity = amountBNB.mul(_aveLiquidityFee).div(totalBNBFee).div(2);
        uint256 amountBNBMarketing = amountBNB.mul(_aveMarketingFee).div(totalBNBFee);
        
        uint256 _gas = 3000;

        (bool MarketingSuccess, /* bytes memory data */) = payable(_taxWallets.marketing).call{value: amountBNBMarketing, gas: _gas}("");
        require(MarketingSuccess,"receiver rejected GF transfer");

        // add the liquidity
        dexRouter.addLiquidityETH{value: amountBNBLiquidity}(
            address(this),
            _amtLiq,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            _taxWallets.marketing,
            block.timestamp
        );
    }
}