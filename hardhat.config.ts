import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  defaultNetwork: "Cyber",
  networks: {
    Cyber: {
      url: 'https://cyber-testnet.alt.technology/',
      chainId: 111557560,
      accounts: [process.env.METAMASK_PRIVATE_KEY as string],
    }
  }
};

export default config;
