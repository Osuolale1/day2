// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBase.sol";

contract ChainlinkVRFConsumer is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;

    constructor(address _vrfCoordinator, address _link) VRFConsumerBase(_vrfCoordinator, _link) {
        keyHash =  0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c; // Set the actual key hash
        fee = 0.1 * 10**18; // 0.1 LINK
    }

    function requestRandomness() internal {
        bytes32 requestId = requestRandomness(keyHash, fee);
        // Use requestId to track Chainlink VRF callback
        // Chainlink VRF will call fulfillRandomness function
    }

    function fulfillRandomness(bytes32 _requestId, uint256 _randomness) internal override {
        // Process the randomness
    }
}
