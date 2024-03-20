import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { ethers } from "hardhat";


const DeploymentModule = buildModule("DeploymentModule", (m) => {

  const shares = m.contract("Shares", []);
  // const shares = await ethers.deployContract
  
  const implementation = m.contract("Core", [shares]);

  // add proxy deploy

  return { implementation };
});

export default DeploymentModule;
