import { ethers } from "hardhat";
import { ChainlinkVRFConsumer__factory } from "../typechain";

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    // Replace these with actual addresses
    const vrfCoordinatorAddress = ""; // Address of the Chainlink VRF Coordinator
    const linkTokenAddress = ""; // Address of the Chainlink LINK Token

    const chainlinkVRFConsumerFactory = (await ethers.getContractFactory(
        "ChainlinkVRFConsumer"
    )) as ChainlinkVRFConsumer__factory;

    const chainlinkVRFConsumer = await chainlinkVRFConsumerFactory.deploy(
        vrfCoordinatorAddress,
        linkTokenAddress
    );

    await chainlinkVRFConsumer.deployed();

    console.log("ChainlinkVRFConsumer deployed to:", chainlinkVRFConsumer.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
