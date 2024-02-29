import { ethers } from 'hardhat';

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log('Deploying contracts with the account:', deployer.address);

    // Retrieve the contract factory
    const MyToken = await ethers.getContractFactory('MyToken');

    // Deploy the contract
    const initialSupply = 1000000; // Set the initial supply here
    const myToken = await MyToken.deploy(initialSupply);

    console.log('MyToken deployed to:', myToken.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
