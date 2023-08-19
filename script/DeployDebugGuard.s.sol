pragma solidity ^0.8.13;

import "safe-contracts/contracts/examples/guards/DebugTransactionGuard.sol";
import "./BaseScript.sol";

contract DeployDebugGuard is BaseScript {
    constructor() BaseScript() {}

    function run() external {
        deploy(_chainId());
    }

    function deploy(uint256 chainId) public {
        string memory chain = loadChainName(chainId);
        if (tryLoadDeployment(chain, "DebugTransactionGuard") == address(0)) {
            vm.startBroadcast(broadcasterPK);
            DebugTransactionGuard guard = new DebugTransactionGuard();
            vm.stopBroadcast();
            saveDeployment(chain, "DebugTransactionGuard", "DebugTransactionGuard", address(guard));
        }
    }

}