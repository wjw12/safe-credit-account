pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenPool {
    // token address => (user address => debt balance)
    mapping(address => mapping(address => uint256)) public debts;

    // we need enough token balance before calling
    // TODO: only authorized credit accounts can call this function
    function borrow(address token, uint256 amount) external {
        require(IERC20(token).balanceOf(address(this)) >= amount, "Insufficient balance");
        IERC20(token).transfer(msg.sender, amount);
        debts[token][msg.sender] += amount;
    }

    function repay(address token, uint256 amount) external {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        debts[token][msg.sender] -= amount;
    }

    function debtBalanceOf(address token, address user) external view returns (uint256) {
        return debts[token][user];
    }
}
