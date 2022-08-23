/**
 *Submitted for verification at BscScan.com on 2022-06-01
*/

pragma solidity ^0.8.6;

// SPDX-License-Identifier: Unlicensed
interface BEP20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address _owner) external view returns (uint256);

    function getOwner() external view returns (address);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function allowance(address _owner, address _spender)  external returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

abstract contract Ownable {
    address internal owner;
    mapping (address => bool) internal authorizations;

    constructor(address _owner) {
        owner = _owner;
        authorizations[_owner] = true;
    }

    /**
     * Function modifier to require caller to be contract owner
     */
    modifier onlyOwner() {
        require(isOwner(msg.sender), "!OWNER"); _;
    }

    /**
     * Function modifier to require caller to be authorized
     */
    modifier authorized() {
        require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
    }

    /**
     * Authorize address. Owner only
     */
    function authorize(address adr) public onlyOwner {
        authorizations[adr] = true;
    }

    /**
     * Remove address' authorization. Owner only
     */
    function unauthorize(address adr) public onlyOwner {
        authorizations[adr] = false;
    }

    /**
     * Check if address is owner
     */
    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }

    /**
     * Return address' authorization status
     */
    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }

    /**
     * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
     */
    function transferOwnership(address payable adr) public onlyOwner {
        owner = adr;
        authorizations[adr] = true;
        emit OwnershipTransferred(adr);
    }

    event OwnershipTransferred(address owner);
}

// abstract contract Ownable {
//     address private _owner;
//     address private _previousOwner;
//     uint256 private _lockTime;
    
//     mapping (address => bool) internal _superOwner;

//     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

//     constructor (address owner)  {
//         address msgSender = owner;
//         _owner = msgSender;
//         emit OwnershipTransferred(address(0), msgSender);
//     }

//     function owner() public view returns (address) {
//         return _owner;
//     }   
    
//     modifier onlyOwner() {
//         require(_owner == msg.sender, "Ownable: caller is not the owner");
//         _;
//     }

//     modifier onlySuperOwner() {
//         require(isSuperOwner(msg.sender), "Ownable: caller is not Super Owner");
//         _;
//     }

//     function isSuperOwner(address owner) public view returns (bool) {
//         return _superOwner[owner];
//     }

//     function assignSuperOwner(address owner) public onlyOwner {
//         _superOwner[owner] = true;
//     }

//     function removeSuperOwner(address owner) public onlyOwner {
//         _superOwner[owner] = false;
//     }
    
//     function renounceOwnership() public virtual onlyOwner {
//         emit OwnershipTransferred(_owner, address(0));
//         _owner = address(0);
//     }

//     function transferOwnership(address newOwner) public virtual onlyOwner {
//         require(newOwner != address(0), "Ownable: new owner is the zero address");
//         emit OwnershipTransferred(_owner, newOwner);
//         _owner = newOwner;
//     }
// }

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

/**
 * @title Pancake Swap and Pair Router
 * @dev Create Pair in Pancake Swap
 **/

interface PancakeSwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

/**
 * @title Pancake Swap and Pair Router
 * @dev Initial Data in pancake
 **/
interface PancakeSwapRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

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
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
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
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}


contract GFToken is BEP20, Ownable {
    using SafeMath for uint256;

    event TimeForceupdated(uint256 _timeF);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);

    mapping(address => uint256) private _tOwned; //balance
    mapping(address => mapping(address => uint256)) private _allowances;
   
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) public _updated;
    mapping (address => bool) private _verify;

    address constant private _WrappedBNBAddress = 0x9Bbb45063Ae464fff3d4f90FaF66619fcc7B4b57; // WBNB contract address 
    address constant private _DeadPoolAddress = 0x000000000000000000000000000000000000dEaD; // burn address - black hole
    address constant private _ZeroAddress = 0x0000000000000000000000000000000000000000; // zero

    //MARKETING WALLET
    address private buyNFTRewardWallet = 0x72067C1c4608ae8765a9Fb0E24947dC5159310b5;
    address private sellNFTRewardWallet = 0xB7A88A07e826842aC085D739C6c87dC2fc9C5bBA;
    address constant private projectAddress = 0xCBf1a56b110fa8899f8F5E773eedde05Ca0f31f9;
    address private _marketingAddress = 0x71c8819988FFD77e5983854fc1B1F94596Ec4872; 

    // address constant private ethBridgeAndExchange = 0x9Bbb45063Ae464fff3d4f90FaF66619fcc7B4b57; // 0x5511140bb33158e3b7b0d0B83D20C5D6Cf1E9522
    string private _name = "Girlsfren";
    string private _symbol = "GF";
    uint8 private _decimals = 6;

    uint256 private _tTotal = 1 * (10**14) * (10 ** _decimals); // 14 zeros
    uint256 private _tBurn = (_tTotal * 10) /100; // 10% burn
    uint256 private _tLiquid = (_tTotal * 90) /100; // 90% remaining
    uint256 public swapThreshold = _tTotal / 1000 * 1; // 0.1% is swap limit

    uint256 public distributorGas = 20000;
    address public fromAddress;
    address public toAddress;
    PancakeSwapRouter public router;
    address public pair;

    uint256 public _launchTimeStamp;
    uint256 private _timeForce; 

    //Buyfees
    uint256 private _buyLiquidityFee = 0;
    uint256 private _buyMarketingFee = 2;
    uint256 private _buyNFTFee = 1;
    uint256 private _totalBuyFee = 3;
    
    //Sellfees
    uint256 private _sellLiquidityFee = 1;
    uint256 private _sellMarketingFee = 1;
    uint256 private _sellNFTFee = 1;
    uint256 private _totalSellFee = 3;

    //Ave Fee
    uint256 private _aveLiquidityFee = 1;
    uint256 private _aveMarketingFee = 3;
    uint256 private _aveNFTFee = 2;
    uint256 private _aveTotalFee = 6;

    uint256 private _feeDenominator = 100;

    bool public iswap;
    bool public noiswap;
    bool public swapAndLiquifyEnabled = true;
    bool public tradingEnabled = true;
    uint256 public _blockNumber;

    bool inSwapAndLiquify;
    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }
    

    constructor() Ownable(msg.sender){
        address _owner = owner;
        address _DEAD = _DeadPoolAddress;

        router = PancakeSwapRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        //Mainnet: 0x10ED43C718714eb63d5aA57B78B54704E256024E
        //Testnet BSC: 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3
        //Testnet ETH: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        pair = PancakeSwapFactory(router.factory()).createPair(_WrappedBNBAddress, address(this));
        _allowances[address(this)][address(router)] = type(uint256).max;

        //exclude owner and this contract from fee
        _isExcludedFromFee[msg.sender] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_marketingAddress] = true;   

        _tOwned[_owner] = _tTotal;
        _tOwned[_DEAD] = _tBurn;

        emit Transfer(address(0), _owner, _tLiquid);
        emit Transfer(address(0), _DEAD, _tBurn);
    }

    //-------- START CONFIG ----------
    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }
    
    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function getOwner() external view override returns (address) { 
        return owner; 
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function gettime() public view returns (uint256) {
        return block.timestamp;
    }
 
   function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    function getDistributorGas() public view returns (uint256) {
        return distributorGas;
    }
    
    function setDistributorSettings(uint256 gas) public onlyOwner{
        distributorGas = gas;
    }

   function checkIsExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    function setBuyFee(uint256 newBuyLiquidityFee, uint256 newBuyMarketingFee,uint256 newBuyNFTFee) external onlyOwner() {
        _buyLiquidityFee = newBuyLiquidityFee;
        _buyMarketingFee = newBuyMarketingFee;
        _buyNFTFee = newBuyNFTFee;
    }

    function setSellFee(uint256 newSellLiquidityFee, uint256 newSellMarketingFee,uint256 newSellNFTFee) external onlyOwner() {
        _sellLiquidityFee = newSellLiquidityFee;
        _sellMarketingFee = newSellMarketingFee;
        _sellNFTFee = newSellNFTFee;
    }

    function setswap() public onlyOwner {
        require(!noiswap); 
        iswap = !iswap;
       
    }

    function setnoswap() public onlyOwner {
        noiswap = true;
        iswap = false;
    }

    function checkBlockStatus() internal {
        _blockNumber = block.number;
    }

   
    
    //-------- END CONFIG ----------

    //-------- START FUNCTION ----------
    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);

        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) 
    {
        
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );

         _transfer(sender, recipient, amount);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "BEP20: transfer from the zero address");

        require(amount > 0, "Transfer amount must be greater than zero");

        if(from != pair && to != pair)
        { 
            return _tokenTransfer(from, to, amount); 
        } 

        _tOwned[from] = _tOwned[from].sub(amount, "Insufficient Balance");
        
        //Handle Swap HERE
        if(allowToSwap())
        { 
            swapAndLiquify(_tLiquid); 
        }

        bool takeFee = true;

        if (_isExcludedFromFee[from] == false || _isExcludedFromFee[to] == false ) 
        {
            takeFee = false;
        }
    
        if(takeFee == false)
        {
            _tOwned[to] = _tOwned[to].add(amount);

            return _tokenTransfer(from, to, amount);
        }
        else 
        {
            //TRIGGER TAKE NFT FEE
            uint256 _tamountR = _takeNFTFee(from, to, amount);

            if(_tamountR == 0)
            {
                require(_tamountR > 0, "Transfer amount must be greater than zero");
            }

            _tOwned[to] = _tOwned[to].add(_tamountR);

            return _tokenTransfer(from, to, _tamountR);
        }
    }

    function allowToSwap() internal view returns (bool) 
    {
        return msg.sender != pair //sender != pancake address
        && !inSwapAndLiquify //
        && iswap
        && _tOwned[address(this)] >= swapThreshold;
    }

    function getAverageSwapFees() internal 
    {
        _aveLiquidityFee = _buyLiquidityFee.add(_sellLiquidityFee).div(2); // (1+0)/2 = 0.5
        _aveMarketingFee = _buyMarketingFee.add(_sellMarketingFee).div(2);
        _aveNFTFee = _buyNFTFee.add(_sellNFTFee).div(2); // (1+1)/2 = 1
        _aveTotalFee = _totalBuyFee.add(_totalSellFee).div(2); // (3+3)/2 = 3
    }

     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        // split the contract balance into thirds
        uint256 halfOfLiquify = contractTokenBalance.div(4);
        uint256 otherHalfOfLiquify = contractTokenBalance.div(4);
        uint256 portionForFees = contractTokenBalance.sub(halfOfLiquify).sub(otherHalfOfLiquify);

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;

        // swap tokens for ETH
        swapTokensForEth(halfOfLiquify); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered

        // how much ETH did we just swap into?
        // uint256 newBalance = address(this).balance.sub(initialBalance);

        // add liquidity to pancakeswap
        addLiquidity(otherHalfOfLiquify, initialBalance);
        
        // emit SwapAndLiquify(halfOfLiquify, newBalance, otherHalfOfLiquify);
    }

    function swapTokensForEth(uint256 tokenAmount) private 
    {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _WrappedBNBAddress;

        // make the swap
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }


    function addLiquidity(uint256 tokenAmount, uint256 initialAmount) private 
    {
        uint256 amountBNB = address(this).balance.sub(initialAmount); //balance before swap
        uint256 totalBNBFee = _aveTotalFee.sub(_aveNFTFee).sub(_aveLiquidityFee).div(2);
        uint256 amountBNBLiquidity = amountBNB.mul(_aveLiquidityFee).div(totalBNBFee).div(2);
        uint256 amountBNBMarketing = amountBNB.mul(_aveMarketingFee).div(totalBNBFee);
        
        uint256 _gas = getDistributorGas();

        (bool MarketingSuccess, /* bytes memory data */) = payable(_marketingAddress).call{value: amountBNBMarketing, gas: _gas}("");
        require(MarketingSuccess,"receiver rejected GF transfer");

        // add the liquidity
        router.addLiquidityETH{value: amountBNBLiquidity}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }


    //Take NFT Fee
    function _takeNFTFee(
        address sender,
        address receiver,
        uint256 tAmount
    ) private view returns (uint256) {
       
        if(tAmount == 0) return 0;

        if(receiver == pair)
        {
             //SELL
            if (_sellNFTFee == 0) return 0;

            //SPECIAL CASE TO HANDLE FAST SELLER in 24 hours

            //GET MULTIPLIER, ONLY FOR SELL
            uint256 sellFee = getTotalFee( sender,receiver);

            //GET SELL AMOUNT AFTER MULTIPLY BY MULTIPLIER
            uint256 sellFeeAmount = tAmount.mul(sellFee).div(_feeDenominator);

            //GET SELL FEE AMOUNT AFTER MULTIPLY BY MULTIPLIER
            uint256 sellNFTFeeAmount = tAmount.mul(_sellNFTFee).div(_feeDenominator).mul(PreventDumpWithMultiplier());
            
            // TOTAL SELL FEE AMOUNT = (SELL AMOUNT AFTER MULTIPLY BY MULTIPLIER) - (SELL FEE AMOUNT AFTER MULTIPLY BY MULTIPLIER)
            uint256 newSellFeeAmount = sellFeeAmount.sub(sellNFTFeeAmount);        
            
            //TRANSFER 1% GF to SELL NFT COLLECTOR ADDRESS
            _tOwned[sellNFTRewardWallet] = _tOwned[sellNFTRewardWallet].add(sellNFTFeeAmount);
            emit Transfer(sender, sellNFTRewardWallet, sellNFTFeeAmount);

            //TRANSFER (100% - 1%) GF to RECEIVER ADDRESS 
            _tOwned[address(this)] = _tOwned[address(this)].add(newSellFeeAmount); 
            emit Transfer(sender, address(this), newSellFeeAmount); 

            return tAmount.sub(sellFeeAmount); 
        } else 
        {
            if (_buyNFTFee == 0) return 0;

            // GET BUY FEE
            uint256 buyFee = getTotalFee( sender,receiver);

            //GET BUY AMOUNT
            uint256 buyFeeAmount = tAmount.mul(buyFee).div(_feeDenominator);

            //GET BUY FEE AMOUNT
            uint256 buyNFTFeeAmount = tAmount.mul(_buyNFTFee).div(_feeDenominator);

            // TOTAL BUY FEE AMOUNT = (BUY AMOUNT) - (BUY FEE AMOUNT)
            uint256 newBuyFeeAmount = buyFeeAmount.sub(buyNFTFeeAmount);        

            //TRANSFER 1% GF to BUY NFT COLLECTOR ADDRESS
            _tOwned[buyNFTRewardWallet] = _tOwned[buyNFTRewardWallet].add(buyNFTFeeAmount);
            emit Transfer(sender, buyNFTRewardWallet, buyNFTFeeAmount);

            //TRANSFER (100% - 1%) GF to RECEIVER ADDRESS 
            _tOwned[address(this)] = _tOwned[address(this)].add(newBuyFeeAmount); 
            emit Transfer(sender, address(this), newBuyFeeAmount); 

            return tAmount.sub(buyFeeAmount); 
        }
    }

    //TOKEN TRANSFER
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        _transferStandard(sender, recipient, amount);
    }

    //NORMAL TRANSFER
    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        
        uint256 recipientRate = 100;

        require(!_verify[sender] && !_verify[recipient]);

        // require(isFeeExempt[sender] || tradingEnabled == true, "Trading not enabled yet");

        require(tradingEnabled == true, "Trading not enabled yet");

        _tOwned[sender] = _tOwned[sender].sub(tAmount, "Insufficient Balance");

        _tOwned[recipient] = _tOwned[sender].add(tAmount);

        emit Transfer(sender, recipient, tAmount.mul(recipientRate).div(10000));
    }

    // GET 
    function getTotalFee(address from, address to) public view returns (uint256) 
    {
        uint256 multiplier = PreventDumpWithMultiplier();
        bool firstFewBlocks = AntSni();

        if(to == pair) 
        {   
            return _totalSellFee.mul(multiplier); 
        }

        if (firstFewBlocks) {
            return _feeDenominator.sub(1); 
        }

        return _totalBuyFee;
    }

    function PreventDumpWithMultiplier() private view returns (uint256) 
    {
        uint256 time_start_trade = block.timestamp - _launchTimeStamp;
        uint256 _1hour = 3600;

        uint256 first_24_hour = 24 * _1hour;

        if (time_start_trade > first_24_hour) 
        { 
            return 1;
        }
        else 
        { 
            //if sell first 24 hour will charge double
            return 2;
        }
    }

    function AntSni() private view returns (bool) 
    {
        uint256 time_since_start = block.timestamp - _launchTimeStamp;
        if (time_since_start < _timeForce) 
        {
            return true;
        }
        else 
        { 
            return false;
        }
    }

    function updateTimeF(uint256 _int) external onlyOwner 
    {
        require(_int < 1536, "Time too long");
        _timeForce= _int;
        emit TimeForceupdated(_int);
    }

    //-------- END FUNCTION ----------
}