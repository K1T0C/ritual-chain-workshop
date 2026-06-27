import { expect } from "chai";
import hre from "hardhat";

describe("AIJudge", function () {
  it("Should allow commit and reveal", async function () {
    const ethers = hre.ethers;
    const [addr1] = await ethers.getSigners();
    
    const AIJudge = await ethers.getContractFactory("AIJudge");
    const aiJudge = await AIJudge.deploy();
    await aiJudge.waitForDeployment();

    const bountyId = 1;
    const answer = "My secret AI solution";
    const salt = ethers.encodeBytes32String("my-secret-salt");
    
    const commitment = ethers.solidityPackedKeccak256(
      ["string", "bytes32", "address", "uint256"],
      [answer, salt, addr1.address, bountyId]
    );

    await aiJudge.connect(addr1).submitCommitment(bountyId, commitment);
    await aiJudge.revealAnswer(bountyId, answer, salt);
    
    const submission = await aiJudge.submissions(bountyId, addr1.address);
    expect(submission.isRevealed).to.equal(true);
    expect(submission.answer).to.equal(answer);
  });
});