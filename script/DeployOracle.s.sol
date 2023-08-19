pragma solidity ^0.8.13;

import "./BaseScript.sol";
import "../src/Oracle.sol";

contract DeployOracle is BaseScript {
    constructor() BaseScript() {}

    function run() external {
        deploy(_chainId());
    }

    // set two tokens to the same price
    function deploy(uint256 chainId) public {
        string memory chain = loadChainName(chainId);
        address stakingToken = loadDeployment(chain, "MockDAI");
        address receiptToken = loadDeployment(chain, "MockSDAI");
        vm.startBroadcast(broadcasterPK);
        Oracle oracle = new Oracle();
        oracle.setPrice(stakingToken, 1 ether);
        oracle.setPrice(receiptToken, 1 ether);
        vm.stopBroadcast();
        saveDeployment(chain, "Oracle", "Oracle", address(oracle));
    }
}
