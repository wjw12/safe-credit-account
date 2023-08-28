pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CreditManagerModule {
    struct BorrowRequest {
        address safe;
        address token;
        uint256 collateralAmount;
        uint256 requestedAmount;
        bool completed;
    }

    mapping(uint256 => BorrowRequest) public borrowRequests;
    uint256 public borrowRequestNonce;

    mapping(address => uint256) public borrowRatioBps;

    // nonReentrant
    // only relayer can call it
    function completeBorrow(uint256 nonce) external {
        BorrowRequest storage request = borrowRequests[nonce];
        require(!request.completed, "already completed");
        address token = request.token;
        uint256 balanceBefore = IERC20(token).balanceOf(address(this));

        // Bridge specific logic to receive tokens...

        uint256 balanceAfter = IERC20(token).balanceOf(address(this));
        require(balanceAfter - balanceBefore >= request.requestedAmount, "insufficient bridged amount");

        borrowRequests[nonce].completed = true;

        // execute farming strategy from Safe using execTransactionFromModule
        // source: https://github.com/safe-global/safe-contracts/blob/main/contracts/base/ModuleManager.sol#L82
    }
    
    function requestBorrow(address token, uint256 collateralAmount, uint256 requestedAmount) external {
        IERC20(token).transferFrom(msg.sender, address(this), collateralAmount);
        require(borrowRatioBps[token] * collateralAmount / 10000 >= requestedAmount, "insufficient collateral");

        // Bridge specific logic to request cross-chain transfer of requestedAmount

        borrowRequests[borrowRequestNonce] = BorrowRequest({
            safe: msg.sender,
            token: token,
            collateralAmount: collateralAmount,
            requestedAmount: requestedAmount,
            completed: false
        });
    }
}