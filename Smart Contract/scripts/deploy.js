const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const RentableNFT = await ethers.getContractFactory("RentableNFT");
  const rentableNFT = await RentableNFT.deploy("RentableNFT", "RNFT");
  await rentableNFT.deployed();
  console.log("RentableNFT deployed to:", rentableNFT.address);

  console.log("Sleeping.....");
  // Wait for etherscan to notice that the contract has been deployed
  await sleep(20000);

  // Verify the contract after deploying
  await hre.run("verify:verify", {
    address: rentableNFT.address,
    constructorArguments: ["RentableNFT", "RNFT"],
  });
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
