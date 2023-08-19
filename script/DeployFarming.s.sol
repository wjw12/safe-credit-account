pragma solidity ^0.8.13;

import "./BaseScript.sol";
import "../src/MockToken.sol";
import "../src/Farming.sol";

contract DeployFarming is BaseScript {
    constructor() BaseScript() {}

    function run() external {
        deploy(_chainId());
    }

    function deploy(uint256 chainId) public {
        string memory chain = loadChainName(chainId);
        address stakingToken = loadDeployment(chain, "MockDAI");
        address receiptToken = loadDeployment(chain, "MockSDAI");
        vm.startBroadcast(broadcasterPK);
        Farming farming = new Farming(stakingToken, receiptToken);
        MockToken(receiptToken).mint(address(farming), 100 ether);
        vm.stopBroadcast();
        saveDeployment(chain, "Farming", "FarmingMockDAI", address(farming));
    }
}
