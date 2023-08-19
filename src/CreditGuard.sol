pragma solidity ^0.8.0;

import "./Oracle.sol";
import "./Farming.sol";
import "./TokenPool.sol";
import "./BaseGuard.sol";
import "safe-contracts/contracts/common/Enum.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CreditGuard is BaseGuard {
    Farming public farming;
    Oracle public oracle;
    TokenPool public pool;
    IERC20 public stakingToken;
    IERC20 public receiptToken;

    uint public minHealthFactorBps = 11000;

    uint constant public BPS_BASE = 10000;

    constructor(address _farming, address _tokenPool, address _oracle) {
        pool = TokenPool(_tokenPool);
        farming = Farming(_farming);
        oracle = Oracle(_oracle);
        stakingToken = farming.stakingToken();
        receiptToken = farming.receiptToken();
    }

    /// @dev Module transactions only use the first four parameters: to, value, data, and operation.
    /// Module.sol hardcodes the remaining parameters as 0 since they are not used for module transactions.
    /// @notice This interface is used to maintain compatibilty with Gnosis Safe transaction guards.
    function checkTransaction(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation,
        uint256 safeTxGas,
        uint256 baseGas,
        uint256 gasPrice,
        address gasToken,
        address payable refundReceiver,
        bytes memory signatures,
        address msgSender
    ) external override {

    }

    // TODO: access control
    function setMinHealthFactorBps(uint _minHealthFactorBps) external {
        require(_minHealthFactorBps > BPS_BASE, "CreditGuard: invalid minHealthFactorBps");
        minHealthFactorBps = _minHealthFactorBps;
    }

    function getTokenValue(address user) public view returns (uint256) {
        uint256 stakeTokenValue = stakingToken.balanceOf(user) * oracle.getPrice(address(stakingToken));
        uint256 receiptTokenValue = receiptToken.balanceOf(user) * oracle.getPrice(address(receiptToken));
        return stakeTokenValue + receiptTokenValue;
    }

    function getDebtValue(address user) public view returns (uint256) {
        uint256 debtBalance = pool.debtBalanceOf(address(stakingToken), user);
        uint256 debtValue = oracle.getPrice(address(stakingToken)) * debtBalance;
        return debtValue;
    }

    function isHealthy(address user) public view returns (bool) {
        uint256 tokenValue = getTokenValue(user);
        uint256 debtValue = getDebtValue(user);
        return tokenValue * BPS_BASE >= debtValue * minHealthFactorBps;
    }

    function checkAfterExecution(bytes32 txHash, bool success) external override {
        require(isHealthy(msg.sender), "CreditGuard: unhealthy");
    }
}