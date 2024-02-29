import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";

const ALCHEMY_API_KEY = "XpWuAVYcHj7J0KOpMrd-c8Zr1Tdd0YJ5";

const SEPOLIA_PRIVATE_KEY = "8b2e54997c83fe1a298fc5b2978448a6f2b4b03ef30942279af3333e137b421c";



const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    hardhat: {
      // For local testing
      chainId: 1337,
    },
    alchemy: {
      url: `https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_API_KEY}`, // Adjust for Alchemy mainnet or other network
      accounts: [sepoliaPrivateKey], // Private key for deploying to Alchemy network
    },
    sepolia: {
      url: "YOUR_SEPOLIA_RPC_URL",
      accounts: ["8b2e54997c83fe1a298fc5b2978448a6f2b4b03ef30942279af3333e137b421c"], // Private key for deploying to Sepolia network
    },
  },
};

export default config;
