// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//C:\Users\HP\Desktop\day2\node_modules\@chainlink\contracts\src\v0.8\vrf\VRFConsumerBase.sol

//import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
//import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/VRFConsumerBaseV2.sol";
//import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";


contract PrizeDistribution is VRFConsumerBase {
    // Chainlink VRF variables
    bytes32 internal keyHash;
    uint256 internal fee;

    // ERC20 token contract
    IERC20 public token;

    // Participant structure
    struct Participant {
        bool registered;
        uint256 entries;
    }

    // Mapping of participant addresses to Participant struct
    mapping(address => Participant) public participants;
    uint256 public participantCount; // Track the number of participants

    // Parameters for prize distribution
    uint256 public totalEntries;
    uint256 public totalPrizePool;
    uint256 public distributionTime;
    uint256 public numberOfWinners;
    uint256 public randomResult;

    // Event for prize distribution
    event PrizeDistributionEvent(address[] winners, uint256[] amounts);

    // Constructor
    constructor(
        address _vrfCoordinator,
        address _link,
        address _token
    ) VRFConsumerBase(_vrfCoordinator, _link) {
        keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c; // Set the actual key hash
        fee = 0.1 * 10**18; // 0.1 LINK
        token = IERC20(_token); // Initialize the ERC20 token contract
    }

    modifier onlyOwner(address owner) {
       require(owner == msg.sender);
        _;
    }


    // Function to register participants
    function registerParticipant() external {
        require(!participants[msg.sender].registered, "Already registered");
        participants[msg.sender].registered = true;
        participantCount++; // Increment participant count
    }

    // Function to record participant entries
    function recordEntries(uint256 _entries) external {
        require(participants[msg.sender].registered, "Not registered");
        participants[msg.sender].entries += _entries;
        totalEntries += _entries;
    }

    // Function to trigger prize distribution
    function triggerPrizeDistribution(uint256 _numberOfWinners) external  {
        require(totalEntries > 0, "No participants");
        require(_numberOfWinners > 0 && _numberOfWinners <= totalEntries, "Invalid number of winners");
        
        numberOfWinners = _numberOfWinners;
        distributionTime = block.timestamp;
        
        bytes32 requestId = requestRandomness(keyHash, fee);
        // Use requestId to track Chainlink VRF callback
        // Chainlink VRF will call fulfillRandomness function
    }

    // Callback function for Chainlink VRF
    function fulfillRandomness(bytes32 _requestId, uint256 _randomness) internal override {
        randomResult = _randomness;
        address[] memory winners = new address[](numberOfWinners);
        uint256[] memory amounts = new uint256[](numberOfWinners);
        
        uint256 totalEntriesSnapshot = totalEntries;
        for (uint256 i = 0; i < numberOfWinners; i++) {
            // Randomly select winners based on random number
            uint256 index = (_randomness + i) % totalEntriesSnapshot;
            address winner = selectWinner(index);
            winners[i] = winner;

            // Distribute prize pool evenly among winners
            uint256 prizeAmount = totalPrizePool / numberOfWinners;
            amounts[i] = prizeAmount;
            
            // Update total entries to prevent duplicate winners
            totalEntriesSnapshot--;
        }
        
        // Emit event for prize distribution
        emit PrizeDistributionEvent(winners, amounts);
    }

    // Function to select winner based on index
    function selectWinner(uint256 _index) internal view returns (address) {
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < participantCount; i++) {
            if (participants[msg.sender].entries > 0) {
                if (currentIndex + participants[msg.sender].entries > _index) {
                    return msg.sender;
                }
                currentIndex += participants[msg.sender].entries;
            }
        }
        revert("No winner found");
    }
}


/*
contract PrizeDistribution is VRFConsumerBase, Ownable {
    // Chainlink VRF variables
    bytes32 internal keyHash;
    uint256 internal fee;

    // ERC20 token contract
    IERC20 public token;

    // Event for prize distribution
    event PrizeDistributionEvent(address[] winners, uint256[] amounts);

    // Participant structure
    struct Participant {
        bool registered;
        uint256 entries;
    }

    // Mapping of participant addresses to Participant struct
    mapping(address => Participant) public participants;

    // Parameters for prize distribution
    uint256 public totalEntries;
    uint256 public totalPrizePool;
    uint256 public distributionTime;
    uint256 public numberOfWinners;
    uint256 public randomResult;

    // Constructor
    constructor(address _vrfCoordinator, address _link, address _token)
        VRFConsumerBase(_vrfCoordinator, _link)
    {
       //  keyHash = 0xd6b0a9bdf66bff6b9f61da427af3731c94d7896d9ffe3de59ac1687be646a18a;
        fee = 0.1 * 10**18; // 0.1 LINK
        token = IERC20(_token);
    }

    // Function to register participants
    function registerParticipant() external {
        require(!participants[msg.sender].registered, "Already registered");
        participants[msg.sender].registered = true;
    }

    // Function to record participant entries
    function recordEntries(uint256 _entries) external {
        require(participants[msg.sender].registered, "Not registered");
        participants[msg.sender].entries += _entries;
        totalEntries += _entries;
    }

    // Function to trigger prize distribution
    function triggerPrizeDistribution(uint256 _numberOfWinners) external onlyOwner {
        require(totalEntries > 0, "No participants");
        require(_numberOfWinners > 0 && _numberOfWinners <= totalEntries, "Invalid number of winners");
        
        numberOfWinners = _numberOfWinners;
        distributionTime = block.timestamp;
        
        bytes32 requestId = requestRandomness(keyHash, fee);
        // Use requestId to track Chainlink VRF callback
        // Chainlink VRF will call fulfillRandomness function
    }

    // Callback function for Chainlink VRF
    function fulfillRandomness(bytes32 _requestId, uint256 _randomness) internal override {
        randomResult = _randomness;
        address[] memory winners = new address[](numberOfWinners);
        uint256[] memory amounts = new uint256[](numberOfWinners);
        
        uint256 totalEntriesSnapshot = totalEntries;
        for (uint256 i = 0; i < numberOfWinners; i++) {
            // Randomly select winners based on random number
            uint256 index = (_randomness + i) % totalEntriesSnapshot;
            address winner = selectWinner(index);
            winners[i] = winner;

            // Distribute prize pool evenly among winners
            uint256 prizeAmount = totalPrizePool / numberOfWinners;
            amounts[i] = prizeAmount;
            
            // Update total entries to prevent duplicate winners
            totalEntriesSnapshot--;
        }
        
        // Emit event for prize distribution
        emit PrizeDistributionEvent(winners, amounts);
    }

    // Function to select winner based on index
    function selectWinner(uint256 _index) internal view returns (address) {
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < participants.length; i++) {
            if (participants[i].entries > 0) {
                if (currentIndex + participants[i].entries > _index) {
                    return participants[i].address;
                }
                currentIndex += participants[i].entries;
            }
        }
        revert("No winner found");
    }

    // Function to distribute tokens to winners
    function distributeTokens(address[] calldata _winners, uint256[] calldata _amounts) external onlyOwner {
        require(_winners.length == numberOfWinners && _amounts.length == numberOfWinners, "Invalid input");
        
        for (uint256 i = 0; i < numberOfWinners; i++) {
            token.transfer(_winners[i], _amounts[i]);
        }
    }

    // Withdraw LINK from the contract (in case of accidental deposits)
    function withdrawLink() external onlyOwner {
        require(LINK.transfer(owner(), LINK.balanceOf(address(this))), "Unable to transfer");
    }

    // Withdraw ERC20 tokens from the contract (in case of accidental deposits)
    function withdrawTokens(address _token, uint256 _amount) external onlyOwner {
        require(_token != address(token), "Cannot withdraw prize token");
        IERC20(_token).transfer(owner(), _amount);
    }
}
*/