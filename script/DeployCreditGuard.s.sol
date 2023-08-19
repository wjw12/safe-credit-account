pragma solidity ^0.8.13;

import "./BaseScript.sol";
import "../src/CreditGuard.sol";

contract DeployCreditGuard is BaseScript {
    constructor() BaseScript() {}

    function run() external {
        deploy(_chainId());
    }

    function deploy(uint256 chainId) public {
        string memory chain = loadChainName(chainId);
        //address stakingToken = loadDeployment(chain, "MockDAI");
        //address receiptToken = loadDeployment(chain, "MockSDAI");
        address oracle = loadDeployment(chain, "Oracle");
        address tokenPool = loadDeployment(chain, "TokenPool");
        address farming = loadDeployment(chain, "FarmingMockDAI");
        if (tryLoadDeployment(chain, "CreditGuard") == address(0)) {
            vm.startBroadcast(broadcasterPK);
            CreditGuard guard = new CreditGuard(farming, tokenPool, oracle);
            vm.stopBroadcast();
            saveDeployment(chain, "CreditGuard", "CreditGuard", address(guard));
        }
    }

}
