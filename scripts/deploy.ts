import { ethers } from "hardhat";

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    // Example: Replace 'VRFConsumerBase' with the actual contract name you want to deploy
    const ContractFactory = await ethers.getContractFactory("ChainlinkVRFConsumer");

    // Deploy your contract here
    const contract = await ContractFactory.deploy();

    console.log("Contract deployed to:", contract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
