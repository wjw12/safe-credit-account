pragma solidity ^0.8.0;

import "./Oracle.sol";
import "./TokenPool.sol";
import "openzeppelin/token/ERC20/IERC20.sol";

contract Farming {
    Oracle public oracle;
    TokenPool public pool;
    IERC20 public stakingToken;
    IERC20 public receiptToken;

    mapping(address => uint256) public balances;

    constructor(address _oracle, address _pool, address _stakingToken, address _receiptToken) {
        oracle = Oracle(_oracle);
        pool = TokenPool(_pool);
        stakingToken = IERC20(_stakingToken);
        receiptToken = IERC20(_receiptToken);
    }

    function deposit(uint256 amount) external {
        stakingToken.transferFrom(msg.sender, address(this), amount);

        // 1 receiptToken = 1 stakingToken
        // and we need enough receiptToken balance for testing
        receiptToken.transfer(msg.sender, amount);

        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        receiptToken.transferFrom(msg.sender, address(this), amount);
        stakingToken.transfer(msg.sender, amount);
        balances[msg.sender] -= amount;
    }

    function stakeBalanceOf(address user) external view returns (uint256) {
        return balances[user];
    }
}
