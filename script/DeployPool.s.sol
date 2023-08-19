pragma solidity ^0.8.13;

import "./BaseScript.sol";
import "../src/TokenPool.sol";
import "../src/MockToken.sol";

contract DeployPool is BaseScript {
    constructor() BaseScript() {}

    function run() external {
        deploy(_chainId());
    }

    // deploy pool, mint enough tokens to pool
    function deploy(uint256 chainId) public {
        string memory chain = loadChainName(chainId);
        address stakingToken = loadDeployment(chain, "MockDAI");
        vm.startBroadcast(broadcasterPK);
        TokenPool pool = new TokenPool();
        MockToken(stakingToken).mint(address(pool), 100 ether);
        vm.stopBroadcast();
        saveDeployment(chain, "TokenPool", "TokenPool", address(pool));
    }
}
