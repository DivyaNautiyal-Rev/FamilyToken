/**
 *Submitted for verification at BscScan.com on 2023-04-25
*/

/**
 *Submitted for verification at BscScan.com on 2023-02-04
*/
 
pragma solidity 0.6.12;
// SPDX-License-Identifier: Unlicensed
 
/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;
 
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }
 
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }
 
    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
 
    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
 
    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
 
    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.
 
        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}
 
/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.
 
    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
 
    uint256 private _status;
 
    constructor () internal {
        _status = _NOT_ENTERED;
    }
 
    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
 
        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
 
        _;
 
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
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
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
 
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }
 
    function _msgData() internal view virtual returns (bytes memory) {
        this;
        // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}
 
/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {codehash := extcodehash(account)}
        return (codehash != accountHash && codehash != 0x0);
    }
 
    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success,) = recipient.call{value : amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
 
    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }
 
    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }
 
    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
 
    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }
 
    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly
                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
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
    address private _previousOwner;
    uint256 private _lockTime;
 
    enum FuncId { 
        excludeFromReward, 
        includeInReward, 
        excludeFromFee, 
        includeInFee, 
        transferAnyERC20Token, 
        setBlacklistAddress, 
        setCharityWallet, 
        setMarketingWallet, 
        setArbitrageWallet, 
        setPenaltyMaxSellBalanceWithoutPenalty, 
        setPenaltyFeeLiquidity, 
        setPenaltyFeeBurn, 
        setPenaltyFeeCharity, 
        setPenaltyFeeMarketing, 
        setPenaltyFeeArbitrage, 
        setPenaltyDuration, 
        setRouterAddress, 
        setSwapAndLiquifyEnabled, 
        setIsBlacklistedEnabled,
        renounceOwnership,
        transferOwnership,
        lock
    }
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
 
    mapping(FuncId => uint256) public _schedules;
 
 
 
    modifier delayPassed(FuncId id) {
        require(_schedules[id] <= block.timestamp, "Too early to execute operation");
        require(_schedules[id] != 0, "Schedule not called yet for the gived function");
        _;
    }
 
    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = 0xF422911F0D330dc89e053C617526aCd4eD2F3Bf3;
        emit OwnershipTransferred(address(0), msgSender);
    }
 
    function scheduleCall(FuncId id) external onlyOwner {
        _schedules[id] = block.timestamp + 2 days;
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
    function renounceOwnership() public virtual delayPassed(FuncId.renounceOwnership) onlyOwner {
        _schedules[FuncId.renounceOwnership] = 0;
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
 
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual delayPassed(FuncId.transferOwnership) onlyOwner {
        _schedules[FuncId.transferOwnership] = 0;
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
 
    function getUnlockTime() public view returns (uint256) {
        return _lockTime;
    }
 
    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual delayPassed(FuncId.lock) onlyOwner {
        _schedules[FuncId.lock] = 0;
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = now + time;
        emit OwnershipTransferred(_previousOwner, address(0));
    }
 
    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(now > _lockTime, "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
        _previousOwner = address(0);
    }
}
 
// pragma solidity >=0.5.0;
interface IUniswapV2Factory {
    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
 
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
}
 
 
// pragma solidity >=0.5.0;
interface IUniswapV2Pair {
    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
 
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(address indexed sender, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out, address indexed to);
    event Sync(uint112 reserve0, uint112 reserve1);
}
 
// pragma solidity >=0.6.2;
interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
 
// pragma solidity >=0.6.2;
interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amountETH);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
}
 
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
 
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
 
contract BUSDManager is ReentrancyGuard {
 
    using SafeERC20 for IERC20;
 
    address immutable owner;
    IERC20 immutable BUSD;
 
    constructor(IERC20 _busd) public {
        owner = msg.sender;
        BUSD = _busd;
    }
 
    function transfer(address to, uint256 tokens) public nonReentrant {
        require(msg.sender == owner);
        BUSD.safeTransfer(to, tokens);
    }
 
    function transferAll(address to) public nonReentrant {
        require(msg.sender == owner);
        BUSD.safeTransfer(to, BUSD.balanceOf(address(this)));
    }
}
 
contract FamilyTokenV2 is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;
    using SafeERC20 for IERC20;
 
    uint256 private constant _MAX = ~uint256(0);
    uint256 private _tTotal = 15853763753386939794276662748;
    uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
    uint256 private _tFeeTotal;
 
    string private constant _name = "FamilyToken V2";
    string private constant _symbol = "FT-2";
    uint8 private constant _decimals = 18;
 
    address private constant _router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address private constant _busd = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address private _sender;
    address private _recipient;
    bool private _takeFee = true;
    bool private _isPenalty = false;
    bool private _lock = false;
 
    address public charityWallet = 0xA74887Af8340508e26Aa52EE5c6A878a19faeCDF;
    address public marketingWallet = 0x2e49CAc28E737cfB9e51Ad2258Bb571F61aD01F6;
    address public arbitrageWallet = 0xd982F7aE55EEB6a2b8F3F1174254f47721b33668;
 
    uint256 public constant taxFee = 0;
    uint256 public constant buyFeeLiquidity = 200; // 2%
    uint256 public constant buyFeeBurn = 0; // 0%
    uint256 public constant buyFeeCharity = 50; // 0.5%
    uint256 public constant buyFeeMarketing = 50;  // 0.5%
 
    uint256 public constant sellFeeLiquidity = 100; // 1%
    uint256 public constant sellFeeBurn = 150; // 1.5%
    uint256 public constant sellFeeCharity = 25; // 0.25%
    uint256 public constant sellFeeMarketing = 125; // 1.25%
    uint256 public constant sellFeeArbitrage = 200; // 2%
 
    uint256 public penaltyMaxSellBalanceWithoutPenalty = 1000;  // < 10%
    uint256 public penaltyFeeLiquidity = 1000;  // 10%
    uint256 public penaltyFeeBurn = 700;  // 7%
    uint256 public penaltyFeeCharity = 100;  // 1%
    uint256 public penaltyFeeMarketing = 200;  // 2%
    uint256 public penaltyFeeArbitrage = 1000;  // 10%
    uint256 public penaltyDuration = 86400;  // 24h
 
    IERC20 public BUSD;
    BUSDManager public busdManager;
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    bool public inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    bool public isBlacklistedEnabled = true;
 
    struct TransferOut {
        uint256 amount;
        uint256 timestamp;
    }
 
    struct Account {
        uint256 sellTimestamp;
        uint256 sellBalance;
        TransferOut[] sell;
    }
 
    struct AccountFee {
        uint256 totalAmount;
        uint256 liquidityAmount;
        uint256 charityAmount;
        uint256 marketingAmount;
        uint256 arbitrageAmount;
    }
 
    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _isExcluded;
    mapping(address => Account) public accounts;
    mapping(address => bool) public isBlacklisted;
    address[] private _excluded;
    AccountFee private _accountFee;
 
    event SwapAndLiquifyEnabledUpdated(bool enabled);
 
    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }
 
 
    constructor () public {
        _rOwned[0xF422911F0D330dc89e053C617526aCd4eD2F3Bf3] = _rTotal;
        BUSD = IERC20(_busd);
        busdManager = new BUSDManager(BUSD);
        uniswapV2Router = IUniswapV2Router02(_router);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), _busd);
 
        address uniswapV2PairBNB = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        isBlacklisted[uniswapV2PairBNB] = true;
 
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[charityWallet] = true;
        _isExcludedFromFee[marketingWallet] = true;
        _isExcludedFromFee[arbitrageWallet] = true;
        _isExcludedFromFee[address(busdManager)] = true;
        emit Transfer(address(0), 0xF422911F0D330dc89e053C617526aCd4eD2F3Bf3, _tTotal);
    }
 
    function name() public view returns (string memory) {
        return _name;
    }
 
    function symbol() public view returns (string memory) {
        return _symbol;
    }
 
    function decimals() public view returns (uint8) {
        return _decimals;
    }
 
    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }
 
    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }
 
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
 
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
 
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
 
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
 
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
 
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
 
    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }
 
    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }
 
    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }
 
    function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }
 
    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        if (isBlacklistedEnabled) require(!isBlacklisted[from] && !isBlacklisted[to], "Blacklisted address");
        if (!inSwapAndLiquify && swapAndLiquifyEnabled && from != owner() && to == uniswapV2Pair && msg.sender == tx.origin) _swapAndLiquify();
        _tokenDistribution(from, to, amount);
    }
 
    function _swapAndLiquify() private lockTheSwap {
        _lock = true;
        uint256 half = _accountFee.liquidityAmount.div(2);
        uint256 otherHalf = _accountFee.liquidityAmount.sub(half);
        uint256 tokensForSwapAmount = _accountFee.charityAmount.add(_accountFee.marketingAmount).add(_accountFee.arbitrageAmount).add(half);
        uint256 busdAmount = _swapTokensForBUSD(tokensForSwapAmount);
        _addLiquidity(otherHalf, busdAmount.mul(half).div(tokensForSwapAmount));
        _transferFeesToWallets(IERC20(BUSD).balanceOf(address(this)), tokensForSwapAmount);
        _lock = false;
    }
 
    function _swapTokensForBUSD(uint256 amount) private returns (uint256) {
        uint256 initialBalance = BUSD.balanceOf(address(this));
        approve(address(uniswapV2Router), amount);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = address(BUSD);
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(amount, 0, path, address(busdManager), block.timestamp);
        busdManager.transferAll(address(this));
 
        return BUSD.balanceOf(address(this)).sub(initialBalance);
    }
 
    function _addLiquidity(uint256 tokenAmount, uint256 busdAmount) private {
        uint256 _toApprove = uint256(2 ** 256 - 1);
        _approve(address(this), address(uniswapV2Router), _toApprove);
        BUSD.safeApprove(address(uniswapV2Router), _toApprove);
        uniswapV2Router.addLiquidity(address(BUSD), address(this), busdAmount, tokenAmount, 0, 0, address(this), block.timestamp);
    }
 
    function _transferFeesToWallets(uint busdAmount, uint256 tokensForSwapAmount) private {
        uint256 charityAmount = busdAmount.mul(_accountFee.charityAmount).div(tokensForSwapAmount);
        uint256 marketingAmount = busdAmount.mul(_accountFee.marketingAmount).div(tokensForSwapAmount);
        uint256 arbitrageAmount = busdAmount.mul(_accountFee.arbitrageAmount).div(tokensForSwapAmount);
        BUSD.safeTransfer(charityWallet, charityAmount);
        BUSD.safeTransfer(marketingWallet, marketingAmount);
        if (arbitrageAmount > 0) {
            BUSD.safeTransfer(arbitrageWallet, arbitrageAmount);
        }
        _resetAccountFee();
    }
 
    function _tokenDistribution(address sender, address recipient, uint256 amount) private {
        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) _takeFee = false;
        _sender = sender;
        _recipient = recipient;
        if (_isBuy()) _buyToken(amount);
        else _sellToken(amount);
        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) _takeFee = true;
    }
 
    function _buyToken(uint256 amount) private {
        _accountFee.totalAmount = _accountFee.totalAmount.add(amount.mul(_getBuyFee()).div(10 ** 4));
        _accountFee.liquidityAmount = _accountFee.liquidityAmount.add(amount.mul(buyFeeLiquidity).div(10 ** 4));
        _accountFee.charityAmount = _accountFee.charityAmount.add(amount.mul(buyFeeCharity).div(10 ** 4));
        _accountFee.marketingAmount = _accountFee.marketingAmount.add(amount.mul(buyFeeMarketing).div(10 ** 4));
        _transferToken(_sender, _recipient, amount);
    }
 
    function _sellToken(uint256 amount) private {
 
        if (_sender != owner() && !_lock) {
            uint256 minTime = block.timestamp.sub(penaltyDuration);
            accounts[_sender].sellBalance = balanceOf(_sender);
            if (accounts[_sender].sellTimestamp > minTime) {
                require(accounts[_sender].sell.length <= 100, "Maximum number of transfers in penaltyDuration reached");
                accounts[_sender].sellTimestamp = block.timestamp;
                accounts[_sender].sell.push(TransferOut({amount: amount, timestamp: accounts[_sender].sellTimestamp}));
                uint256 sumAmount;
                for (uint256 i = accounts[_sender].sell.length; i > 0; i--) {
                    if (accounts[_sender].sell[i - 1].timestamp > minTime) {
                        sumAmount = sumAmount.add(accounts[_sender].sell[i - 1].amount);
                        if (sumAmount >= accounts[_sender].sellBalance.mul(penaltyMaxSellBalanceWithoutPenalty).div(10 ** 4)) {
                            _isPenalty = true;
                            break;
                        }
                    }
                }
            } else {
                accounts[_sender].sellTimestamp = block.timestamp;
                delete accounts[_sender].sell;
                accounts[_sender].sell.push(TransferOut({amount: amount, timestamp: accounts[_sender].sellTimestamp}));
                if (amount >= accounts[_sender].sellBalance.mul(penaltyMaxSellBalanceWithoutPenalty).div(10 ** 4)) _isPenalty = true;
            }
            _accountFee.totalAmount = _accountFee.totalAmount.add(amount.mul(_getSellFee()).div(10 ** 4));
            _accountFee.liquidityAmount = _accountFee.liquidityAmount.add(amount.mul(_isPenalty ? penaltyFeeLiquidity : sellFeeLiquidity).div(10 ** 4));
            _accountFee.charityAmount = _accountFee.charityAmount.add(amount.mul(_isPenalty ? penaltyFeeCharity : sellFeeCharity).div(10 ** 4));
            _accountFee.marketingAmount = _accountFee.marketingAmount.add(amount.mul(_isPenalty ? penaltyFeeMarketing : sellFeeMarketing).div(10 ** 4));
            _accountFee.arbitrageAmount = _accountFee.arbitrageAmount.add(amount.mul(_isPenalty ? penaltyFeeArbitrage : sellFeeArbitrage).div(10 ** 4));
        }
        _transferToken(_sender, _recipient, amount);
        _isPenalty = false;
    }
 
    function _isBuy() private view returns (bool) {
        return _sender == uniswapV2Pair;
    }
 
    function _transferToken(address sender, address recipient, uint256 amount) private {
        if (_isExcluded[sender] && !_isExcluded[recipient]) _transferFromExcluded(sender, recipient, amount);
        else if (!_isExcluded[sender] && _isExcluded[recipient]) _transferToExcluded(sender, recipient, amount);
        else if (!_isExcluded[sender] && !_isExcluded[recipient]) _transferStandard(sender, recipient, amount);
        else if (_isExcluded[sender] && _isExcluded[recipient]) _transferBothExcluded(sender, recipient, amount);
        else _transferStandard(sender, recipient, amount);
    }
 
    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        (uint256 rBurn, uint256 tBurn) = _getBurnValues(tAmount);
        tTransferAmount = tTransferAmount.sub(tBurn);
        rTransferAmount = rTransferAmount.sub(rBurn);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        if (tBurn > 0) _burnTokens(rBurn, tBurn);
        emit Transfer(sender, recipient, tTransferAmount);
    }
 
    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        (uint256 rBurn, uint256 tBurn) = _getBurnValues(tAmount);
        tTransferAmount = tTransferAmount.sub(tBurn);
        rTransferAmount = rTransferAmount.sub(rBurn);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        if (tBurn > 0) _burnTokens(rBurn, tBurn);
        emit Transfer(sender, recipient, tTransferAmount);
    }
 
    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        (uint256 rBurn, uint256 tBurn) = _getBurnValues(tAmount);
        tTransferAmount = tTransferAmount.sub(tBurn);
        rTransferAmount = rTransferAmount.sub(rBurn);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        if (tBurn > 0) _burnTokens(rBurn, tBurn);
        emit Transfer(sender, recipient, tTransferAmount);
    }
 
    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        (uint256 rBurn, uint256 tBurn) = _getBurnValues(tAmount);
        tTransferAmount = tTransferAmount.sub(tBurn);
        rTransferAmount = rTransferAmount.sub(rBurn);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        if (tBurn > 0) _burnTokens(rBurn, tBurn);
        emit Transfer(sender, recipient, tTransferAmount);
    }
 
    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
    }
 
    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
        uint256 tFee = _calculateTaxFee(tAmount);
        uint256 tLiquidity = _calculateLiquidityFee(tAmount);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
        return (tTransferAmount, tFee, tLiquidity);
    }
 
    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
        return (rAmount, rTransferAmount, rFee);
    }
 
    function _getBurnValues(uint256 tAmount) private view returns (uint256, uint256) {
        uint256 tBurn = _calculateBurnFee(tAmount);
        uint256 rBurn = tBurn.mul(_getRate());
        return (rBurn, tBurn);
    }
 
    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }
 
    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }
 
    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }
 
    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 currentRate = _getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
        if (_isExcluded[address(this)]) _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
    }
 
    function _burnTokens(uint256 rBurn, uint256 tBurn) private {
        _rTotal = _rTotal.sub(rBurn);
        _tTotal = _tTotal.sub(tBurn);
    }
 
    function _calculateTaxFee(uint256 amount) private view returns (uint256) {
        if (!_takeFee) return 0;
        return amount.mul(taxFee).div(10 ** 4);
    }
 
    function _calculateLiquidityFee(uint256 amount) private view returns (uint256) {
        if (!_takeFee) return 0;
        return amount.mul(_isBuy() ? _getBuyFee() : _getSellFee()).div(10 ** 4);
    }
 
    function _calculateBurnFee(uint256 amount) private view returns (uint256) {
        if (!_takeFee) return 0;
        return amount.mul(_isBuy() ? buyFeeBurn : (_isPenalty ? penaltyFeeBurn : sellFeeBurn)).div(10 ** 4);
    }
 
    function _getBuyFee() private view returns (uint256) {
        return buyFeeLiquidity.add(buyFeeCharity).add(buyFeeMarketing);
    }
 
    function _getSellFee() private view returns (uint256) {
        return _isPenalty ? penaltyFeeLiquidity.add(penaltyFeeCharity).add(penaltyFeeMarketing).add(penaltyFeeArbitrage) : sellFeeLiquidity.add(sellFeeCharity).add(sellFeeMarketing).add(sellFeeArbitrage);
    }
 
    function _resetAccountFee() private {
        _accountFee.totalAmount = 0;
        _accountFee.liquidityAmount = 0;
        _accountFee.charityAmount = 0;
        _accountFee.marketingAmount = 0;
        _accountFee.arbitrageAmount = 0;
    }
 
    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
 
    function excludeFromReward(address account) public onlyOwner() delayPassed(FuncId.excludeFromReward) {
        _schedules[FuncId.excludeFromReward] = 0;
        require(!_isExcluded[account], "Account is already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }
 
    function includeInReward(address account) external onlyOwner() delayPassed(FuncId.includeInReward) {
        _schedules[FuncId.includeInReward] = 0;
        require(_isExcluded[account], "Account is already included");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                uint256 currentRate = _getRate();
                _rTotal = _rTotal.sub(_rOwned[account]);
                _rOwned[account] = _tOwned[account].mul(currentRate);
                _tOwned[account] = 0;
                _rTotal = _rTotal.add(_rOwned[account]);          
                _isExcluded[account] = false;
                _excluded[i] = _excluded[_excluded.length - 1];
                _excluded.pop();
                break;
            }
        }
    }
 
    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }
 
    function excludeFromFee(address account) public onlyOwner delayPassed(FuncId.excludeFromFee) {
        _schedules[FuncId.excludeFromFee] = 0;
        _isExcludedFromFee[account] = true;
    }
 
    function includeInFee(address account) public onlyOwner delayPassed(FuncId.includeInFee) {
        _schedules[FuncId.includeInFee] = 0;
        _isExcludedFromFee[account] = false;
    }
 
    function transferAnyERC20Token(address token, uint256 tokens) external onlyOwner delayPassed(FuncId.transferAnyERC20Token) returns (bool) {
        require(token != address(this) && token != _busd, "Invalid token extraction");
        _schedules[FuncId.transferAnyERC20Token] = 0;
        IERC20(token).safeTransfer(owner(), tokens);
        return true;
    }
 
    function setBlacklistAddress(address account, bool value) external delayPassed(FuncId.setBlacklistAddress) onlyOwner {
        _schedules[FuncId.setBlacklistAddress] = 0;
        isBlacklisted[account] = value;
    }
 
    function setCharityWallet(address newWallet) external delayPassed(FuncId.setCharityWallet) onlyOwner() {
        _schedules[FuncId.setCharityWallet] = 0;
        require(newWallet != address(0), "Charity wallet can not equal zero address");
        charityWallet = newWallet;
    }
 
    function setMarketingWallet(address newWallet) external delayPassed(FuncId.setMarketingWallet) onlyOwner() {
        _schedules[FuncId.setMarketingWallet] = 0;
        require(newWallet != address(0), "Marketing wallet can not equal zero address");
        marketingWallet = newWallet;
    }
 
    function setArbitrageWallet(address newWallet) external delayPassed(FuncId.setArbitrageWallet) onlyOwner() {
        _schedules[FuncId.setArbitrageWallet] = 0;
        require(newWallet != address(0), "Arbitrage wallet can not equal zero address");
        arbitrageWallet = newWallet;
    }
 
    function setPenaltyMaxSellBalanceWithoutPenalty(uint256 newFee) external delayPassed(FuncId.setPenaltyMaxSellBalanceWithoutPenalty) onlyOwner() {
        _schedules[FuncId.setPenaltyMaxSellBalanceWithoutPenalty] = 0;
        require(newFee >= 100, "Fee can not be set lower than 1%");
        require(newFee <= 10_000, "Fee can not be set higher than 100%");
        penaltyMaxSellBalanceWithoutPenalty = newFee;
    }
 
    function setPenaltyFeeLiquidity(uint256 newFee) external delayPassed(FuncId.setPenaltyFeeLiquidity) onlyOwner() {
        _schedules[FuncId.setPenaltyFeeLiquidity] = 0;
        require(newFee.add(penaltyFeeBurn).add(penaltyFeeCharity).add(penaltyFeeMarketing).add(penaltyFeeArbitrage) <= 100, "Total fees cannot exceed 100%");
        penaltyFeeLiquidity = newFee;
    }
 
    function setPenaltyFeeBurn(uint256 newFee) external delayPassed(FuncId.setPenaltyFeeBurn) onlyOwner() {
        _schedules[FuncId.setPenaltyFeeBurn] = 0;
        require(penaltyFeeLiquidity.add(newFee).add(penaltyFeeCharity).add(penaltyFeeMarketing).add(penaltyFeeArbitrage) <= 100, "Total fees cannot exceed 100%");
        penaltyFeeBurn = newFee;
    }
 
    function setPenaltyFeeCharity(uint256 newFee) external delayPassed(FuncId.setPenaltyFeeCharity) onlyOwner() {
        _schedules[FuncId.setPenaltyFeeCharity] = 0;
        require(penaltyFeeLiquidity.add(penaltyFeeBurn).add(newFee).add(penaltyFeeMarketing).add(penaltyFeeArbitrage) <= 100, "Total fees cannot exceed 100%");
        penaltyFeeCharity = newFee;
    }
 
    function setPenaltyFeeMarketing(uint256 newFee) external delayPassed(FuncId.setPenaltyFeeMarketing) onlyOwner() {
        _schedules[FuncId.setPenaltyFeeMarketing] = 0;
        require(penaltyFeeLiquidity.add(penaltyFeeBurn).add(penaltyFeeCharity).add(newFee).add(penaltyFeeArbitrage) <= 100, "Total fees cannot exceed 100%");
        penaltyFeeMarketing = newFee;
    }
 
    function setPenaltyFeeArbitrage(uint256 newFee) external delayPassed(FuncId.setPenaltyFeeArbitrage) onlyOwner() {
        _schedules[FuncId.setPenaltyFeeArbitrage] = 0;
        require(penaltyFeeLiquidity.add(penaltyFeeBurn).add(penaltyFeeCharity).add(penaltyFeeMarketing).add(newFee) <= 100, "Total fees cannot exceed 100%");
        penaltyFeeArbitrage = newFee;
    }
 
    function setPenaltyDuration(uint256 durationInSeconds) external delayPassed(FuncId.setPenaltyDuration) onlyOwner() {
        _schedules[FuncId.setPenaltyDuration] = 0;
        penaltyDuration = durationInSeconds;
    }
 
    function setRouterAddress(address newRouter) external delayPassed(FuncId.setRouterAddress) onlyOwner() {
        _schedules[FuncId.setRouterAddress] = 0;
 
        IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
 
        uniswapV2Pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _busd);
        if (uniswapV2Pair == address(0))
            uniswapV2Pair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _busd);
 
        address uniswapV2PairBNB = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), uniswapV2Router.WETH());
        if (uniswapV2PairBNB == address(0))
        uniswapV2PairBNB = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), uniswapV2Router.WETH());
    }
 
    function setSwapAndLiquifyEnabled(bool enabled) external delayPassed(FuncId.setSwapAndLiquifyEnabled) onlyOwner {
        _schedules[FuncId.setSwapAndLiquifyEnabled] = 0;
        swapAndLiquifyEnabled = enabled;
        emit SwapAndLiquifyEnabledUpdated(enabled);
    }
 
    function setIsBlacklistedEnabled(bool enabled) external delayPassed(FuncId.setIsBlacklistedEnabled) onlyOwner {
        _schedules[FuncId.setIsBlacklistedEnabled] = 0;
        isBlacklistedEnabled = enabled;
    }
}