import {
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("Core", function () {

  async function deployCorePartsFixture() {
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const Token = await hre.ethers.getContractFactory("Token20");
    const NFT = await hre.ethers.getContractFactory("Token721");
    const Shares = await hre.ethers.getContractFactory("Shares");
    const Core = await hre.ethers.getContractFactory("Core");

    const token1 = await Token.deploy("TOKEN1", "TKN1", [owner, otherAccount]);
    const token2 = await Token.deploy("TOKEN2", "TKN2", [owner, otherAccount]);

    const NFT1 = await NFT.deploy("NFT1", "NFT1");
    const NFT2 = await NFT.deploy("NFT1", "NFT1");
    

    const shares = await Shares.deploy();

    const core = await Core.deploy(shares);

    return { token1, token2, NFT1, NFT2, shares, core, owner, otherAccount };
  }

  async function creationGroupsFixture() {
    const { token1, token2, NFT1, NFT2, shares, core, owner, otherAccount } = await loadFixture(deployCorePartsFixture);

    const token1Num = 100n;
    const token2Num = 1000n;
    const nft1Num = 1n;
    const nft2Num = 2n;
    const sharesNum = 0n;

    await core.connect(otherAccount).createGroup(token1.getAddress(), token1Num, 
                      await NFT1.getAddress(), nft1Num, 
                      await token2.getAddress(), sharesNum, otherAccount);

    return { token1, token2, NFT1, NFT2, shares, core, owner, otherAccount, token1Num, token2Num, nft1Num, nft2Num, sharesNum };
    
  }

  describe("Deployment", function () {
    it("Should set the right Shares owner", async function () {
      const { shares, owner } = await loadFixture(deployCorePartsFixture);

      expect(await shares.owner()).to.equal(owner);
    });

    it("Should created right group", async function () {
      const { core, otherAccount, token1Num, token2Num, nft1Num, nft2Num, sharesNum } = await loadFixture(creationGroupsFixture);

      const group1 = await core.getGroup(0);

      expect(group1.rule.tokenNum).to.equal(token1Num);
      expect(group1.rule.nftNum).to.equal(nft1Num);
      expect(group1.rule.sharesNum).to.equal(sharesNum);
      expect(group1.owner).to.equal(otherAccount);
    })

    it("Should check rights", async function () {
      const { core, owner, otherAccount, token1Num, token2Num, nft1Num, nft2Num, sharesNum } = await loadFixture(creationGroupsFixture);

      const ownerCheckGroup1 = await core.checkLimits(0, owner);
      const eoaCheckGroup1 = await core.checkLimits(0, otherAccount);



      expect(ownerCheckGroup1).to.equal(true);
      expect(eoaCheckGroup1).to.equal(false);

    })

  });
});
