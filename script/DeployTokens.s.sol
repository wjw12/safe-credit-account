pragma solidity ^0.8.13;

import "./BaseScript.sol";
import "../src/MockToken.sol";

contract DeployTokens is BaseScript {
    constructor() BaseScript() {}

    function run() external {
        deploy(_chainId());
    }

    function deploy(uint256 chainId) public {
        string memory chain = loadChainName(chainId);
        if (tryLoadDeployment(chain, "MockDAI") == address(0) && tryLoadDeployment(chain, "MockSDAI") == address(0)) {
            vm.startBroadcast(broadcasterPK);
            MockToken token1 = new MockToken("MockDAI", "DAI");
            MockToken token2 = new MockToken("MockSDAI", "sDAI");
            vm.stopBroadcast();
            saveDeployment(chain, "MockToken", "MockDAI", address(token1));
            saveDeployment(chain, "MockToken", "MockSDAI", address(token2));
        }
    }

}
